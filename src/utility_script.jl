function _varinfo_to_string(m::Module)
    @eval using InteractiveUtils: varinfo
    # The negative lookahead in the regex below helps us avoid compiler-generated names
    # (e.g., `#any`) and internal names (e.g., `_kwdef!`).
    markdown = varinfo(m, r"^(?!#|_.*[^_]$).*", all=true)
    return string(markdown)
end

function _names_to_dict()
    @eval using Base64, Dates, InteractiveUtils
    @eval using Printf, Random, Statistics, Unicode
    # We only allow the core modules of Julia and those that are easily understandable to
    # both experts and beginners (i.e., not too technical) to be used here.
    all_modules = [
        Base, Base64,
        Core,
        InteractiveUtils,
        Dates,
        Printf,
        Random,
        Statistics,
        Unicode
    ]
    names_dict = Dict(
        :Constants => String[],
        :Macros    => String[],
        :Methods   => String[],
        :Modules   => String[],
        :Operators => String[],
        :Types     => String[]
    )
    forbidden_names = [
        [Core, "iterate"]
    ]
    for m in all_modules
        io = IOBuffer(_varinfo_to_string(m))
        for (line_no, line) in enumerate(eachline(io))
            if line_no > 2
                line_match = match(r"\| (?<name>\S*)(?: )+\|(?: )+(?<size>\S* \S*) \| (?<summary>.*?)(?=  | \|)+\K", line)
                if !in([m, line_match["name"]], forbidden_names)
                    docstring = Docs.Binding(m, Symbol(line_match["name"])) |> Docs.doc |> string
                else
                    docstring = ""
                end
                if !isempty(docstring) && !contains(docstring, r"^No documentation found")
                    if Base.isexported(m, Symbol(line_match["name"]))
                        name = line_match["name"]
                    else
                        name = line_match["name"] * 'ˣ'
                    end
                    n = match(r"(?n)(\(.*?function|\(macro)|Module|DataType|Union(All)?", line_match["summary"])
                    if typeof(n) !== Nothing
                        if occursin("function", n.match)
                            if Meta.isoperator(m.Symbol(line_match["name"]))
                                push!(names_dict[:Operators], string(m, '.', name))
                            else
                                push!(names_dict[:Methods], string(m, '.', name))
                            end
                        elseif occursin("macro", n.match)
                            push!(names_dict[:Macros], string(m, '.', name))
                        elseif n.match == "Module"
                            push!(names_dict[:Modules], string(m, '.', name))
                        elseif (n.match == "DataType") ||
                            (n.match == "Union") ||
                            (n.match == "UnionAll")
                            if Meta.isoperator(m.Symbol(line_match["name"]))
                                push!(names_dict[:Operators], string(m, '.', name))
                            else
                                push!(names_dict[:Types], string(m, '.', name))
                            end
                        end
                    else
                        doc1 = Docs.Binding(m, Symbol(line_match["name"])) |> Docs.doc |> string
                        doc2 = Docs.Binding(m, Symbol(line_match["summary"])) |> Docs.doc |> string
                        if doc1 != doc2
                            push!(names_dict[:Constants], string(m, '.', name))
                        end
                    end
                end
            end
        end
    end
    return names_dict
end

function _print_dict_to_dest(dict, dest)
    open(dest, "w") do io
        str = """To generate this file run the `_print_dict_to_dest` method in the\
        `utility_script.jl` file"""
        println(io, "#$('='^length(str))", '\n', str, '\n', "$('='^length(str))#", '\n')
        for (key, value) in dict
            sort!(dict[key])
            println(io, "# $key")
            for v in value
                println(io, v)
            end
            print(io, '\n')
        end
    end
    return nothing
end

function _display_vector_as_matrix_in_column_major_order(n::AbstractVector)
    columns = displaysize(stdout)[2]
    cnt = 1
    total_characters_on_a_line = columns + cnt
    _2d_array = Vector{eltype(n)}[]
    while total_characters_on_a_line > columns
        n_arr = Vector{eltype(n)}[]
        quotient, remainder = divrem(length(n), cnt)
        start, stop = 1, cnt
        for _ in 1:quotient
            arr = eltype(n)[]
            for j in start:stop
                push!(arr, n[j])
            end
            append!(n_arr, [arr])
            if stop+cnt <= length(n)
                start += cnt
                stop += cnt
            else
                arr = String[]
                for k in stop+1:stop+remainder
                    push!(arr, n[k])
                end
                if !isempty(arr)
                    append!(n_arr, [arr])
                end
            end
        end
        whitespaces = 4 * (length(n_arr) - 1)
        non_whitespaces = join(argmax.(length, n_arr))
        total_characters_on_a_line =  length(non_whitespaces) + whitespaces
        cnt += 1
        _2d_array = n_arr
    end
    if !allequal(length.(_2d_array))
        for i in 1:length(_2d_array[begin])-length(_2d_array[end])
            push!(_2d_array[end], "")
        end
    end
    for index in 1:length(_2d_array[begin])
        for vector in _2d_array
            if vector != _2d_array[end]
                print(rpad(vector[index], length(argmax(length, vector))), " "^4)
            else
                println(vector[index])
            end
        end
    end
    return nothing
end


function _print_names(names...)
    for n in names
        n = n[1]
        printstyled(n.first, '\n', '≡'^(length(n.first)+2), '\n'; bold=true, color=:yellow)
        if n.second isa Vector{String}
            _display_vector_as_matrix_in_column_major_order(n.second)
        else
            for i in n.second
                printstyled('\n', i.first, '\n'; underline=true, bold=true, color=:reverse)
                _display_vector_as_matrix_in_column_major_order(i.second)
            end
        end
        println()
    end
    return nothing
end
