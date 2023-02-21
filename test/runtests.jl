using REPLference
using Markdown
using Test

@testset "REPLference.jl" begin
    @test man(:variables)   |> typeof === Markdown.MD
    @test man(:keywords)    |> typeof === Markdown.MD
    @test man(:operators)   |> typeof === Markdown.MD
    @test man(:integers)    |> typeof === Markdown.MD
    @test man(:floating)    |> typeof === Markdown.MD
    @test man(:complex)     |> typeof === Markdown.MD
    @test man(:rationals)   |> typeof === Markdown.MD
    @test man(:irrationals) |> typeof === Markdown.MD
    @test man(:characters)  |> typeof === Markdown.MD
    @test man(:strings)     |> typeof === Markdown.MD
    @test man(:ranges)      |> typeof === Markdown.MD
    @test man(:types)       |> typeof === Markdown.MD
    @test man(:functions)   |> typeof === Markdown.MD
    @test man(:tuples)      |> typeof === Markdown.MD
    @test man(:sets)        |> typeof === Markdown.MD
    @test man(:dicts)       |> typeof === Markdown.MD
    @test man(:array)       |> typeof === Markdown.MD
    @test man(:random)      |> typeof === Markdown.MD
    @test man(:time)        |> typeof === Markdown.MD
    @test man(:files)       |> typeof === Markdown.MD
    @test man(:modules)     |> typeof === Markdown.MD
    @test man(:regex)       |> typeof === Markdown.MD

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
end
