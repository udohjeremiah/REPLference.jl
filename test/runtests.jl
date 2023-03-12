using InteractiveUtils
using Markdown
using REPLference
using Test

@testset "REPLference.jl" begin
    @test typeof(REPLference._varinfo_to_string(Core)) == String
    @test typeof(REPLference._varinfo_to_string(Base)) == String
    @test typeof(REPLference._names_to_dict()) == Dict{Symbol, Vector{String}}
    @test typeof(REPLference._print_dict_to_dest(REPLference._names_to_dict(), tempname())) == Nothing
    @test typeof(REPLference._display_vector_as_matrix_in_column_major_order([1, 2, 3, 4])) == Nothing
    @test typeof(REPLference._print_names()) == Nothing
    @test typeof(REPLference._subtype_tree(AbstractArray)) == Nothing
    @test typeof(REPLference._subtype_tree(Integer)) == Nothing
    @test typeof(REPLference._subtype_tree(Int)) == Nothing

    @test man(:keywords)    |> typeof === Markdown.MD
    @test man(:variables)   |> typeof === Markdown.MD
    @test man(:operators)   |> typeof === Markdown.MD
    @test man(:integers)    |> typeof === Markdown.MD
    @test man(:floating)    |> typeof === Markdown.MD
    @test man(:complex)     |> typeof === Markdown.MD
    @test man(:rationals)   |> typeof === Markdown.MD
    @test man(:irrationals) |> typeof === Markdown.MD
    @test man(:characters)  |> typeof === Markdown.MD
    @test man(:strings)     |> typeof === Markdown.MD
    @test man(:ranges)      |> typeof === Markdown.MD
    @test man(:array)       |> typeof === Markdown.MD
    @test man(:tuples)      |> typeof === Markdown.MD
    @test man(:dicts)       |> typeof === Markdown.MD
    @test man(:sets)        |> typeof === Markdown.MD
    @test man(:types)       |> typeof === Markdown.MD
    @test man(:functions)   |> typeof === Markdown.MD
    @test man(:files)       |> typeof === Markdown.MD
    @test man(:modules)     |> typeof === Markdown.MD
    @test man(:regex)       |> typeof === Markdown.MD
    @test man(:time)        |> typeof === Markdown.MD
    @test man(:random)      |> typeof === Markdown.MD

    @test man(:keywords)    == man(:reserved)
    @test man(:operators)   == man(:operations)
    @test man(:types)       == man(:datatypes)
    @test man(:functions)   == man(:methods)
    @test man(:methods)     == man(:procedures)
    @test man(:time)        == man(:date)
    @test man(:files)       == man(:io)
    @test man(:io)          == man(:stream)
    @test man(:modules)     == man(:packages)
    @test man(:regex)       == man(:regular)

    @test fun(:operators)   === nothing
    @test fun(:integers)    === nothing
    @test fun(:floating)    === nothing
    @test fun(:complex)     === nothing
    @test fun(:rationals)   === nothing
    @test fun(:irrationals) === nothing
    @test fun(:characters)  === nothing
    @test fun(:strings)     === nothing
    @test fun(:ranges)      === nothing
    @test fun(:types)       === nothing
    @test fun(:functions)   === nothing
    @test fun(:tuples)      === nothing
    @test fun(:sets)        === nothing
    @test fun(:dicts)       === nothing
    @test fun(:arrays)      === nothing
    @test fun(:random)      === nothing
    @test fun(:time)        === nothing
    @test fun(:files)       === nothing
    @test fun(:modules)     === nothing
    @test fun(:regex)       === nothing

    @test fun(:keywords)    == fun(:reserved)
    @test fun(:operators)   == fun(:operations)
    @test fun(:types)       == fun(:datatypes)
    @test fun(:functions)   == fun(:methods)
    @test fun(:methods)     == fun(:procedures)
    @test fun(:time)        == fun(:date)
    @test fun(:files)       == fun(:io)
    @test fun(:io)          == fun(:stream)
    @test fun(:modules)     == fun(:packages)
    @test fun(:regex)       == fun(:regular)

    @test fun(:operators; extmod=true)   === nothing
    @test fun(:integers; extmod=true)    === nothing
    @test fun(:floating; extmod=true)    === nothing
    @test fun(:complex; extmod=true)     === nothing
    @test fun(:rationals; extmod=true)   === nothing
    @test fun(:irrationals; extmod=true) === nothing
    @test fun(:characters; extmod=true)  === nothing
    @test fun(:strings; extmod=true)     === nothing
    @test fun(:ranges; extmod=true)      === nothing
    @test fun(:types; extmod=true)       === nothing
    @test fun(:functions; extmod=true)   === nothing
    @test fun(:tuples; extmod=true)      === nothing
    @test fun(:sets; extmod=true)        === nothing
    @test fun(:dicts; extmod=true)       === nothing
    @test fun(:arrays; extmod=true)      === nothing
    @test fun(:random; extmod=true)      === nothing
    @test fun(:time; extmod=true)        === nothing
    @test fun(:files; extmod=true)       === nothing
    @test fun(:modules; extmod=true)     === nothing
    @test fun(:regex; extmod=true)       === nothing

    @test subtree(Number) === nothing
    @test subtree(Vector) === nothing
    @test subtree(Regex) === nothing
    @test subtree(Complex) === nothing
end
