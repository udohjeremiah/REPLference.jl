using InteractiveUtils
using REPLference
using Test

@testset "REPLference.jl" begin
    @test typeof(REPLference._varinfo_to_string(Core)) == String
    @test typeof(REPLference._varinfo_to_string(Base)) == String
    @test typeof(REPLference._names_to_dict()) == Dict{Symbol, Vector{String}}
    @test typeof(REPLference._print_dict_to_dest(REPLference._names_to_dict(), tempname())) == Nothing
    @test typeof(REPLference._display_vector_as_matrix_in_column_major_order([1, 2, 3, 4])) == Nothing
    @test typeof(REPLference._print_names()) == Nothing
end
