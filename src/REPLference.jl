module REPLference

include("_arrays.jl")
include("_characters.jl")
include("_complexs.jl")
include("_datetimes.jl")
include("_dicts.jl")
include("_files.jl")
include("_floats.jl")
include("_functions.jl")
include("_integers.jl")
include("_irrationals.jl")
include("_keywords.jl")
include("_modules.jl")
include("_operators.jl")
include("_randoms.jl")
include("_ranges.jl")
include("_rationals.jl")
include("_regexes.jl")
include("_sets.jl")
include("_strings.jl")
include("_tuples.jl")
include("_types.jl")
include("_variables.jl")

import Dates: AbstractTime
import .Docs: doc

export man, fun

"""
    man(obj::T)
    man(obj::Symbol)

Prints a long text that explains what `obj` generally is in computer programming and how it
is implemented in the Julia programming language. Note that `T` can only be a Julia stdlib
type or a composite type that is a subtype of a Julia stdlib type. If a type that does not
meet these requirements is used, an error will be thrown.

Examples of using `man` can be found in the docstrings of `REPLference`, using the `help?>`
mode.
"""
function man end

"""
    fun(obj::T)
    fun(obj::Symbol)

Prints a comprehensive list of functions that can be called on `obj`, both `exported` and
`unexported`. Note that `T` can only be a Julia stdlib type or a composite type that is a
subtype of a Julia stdlib type. If a type that does not meet these requirements is used, an
error will be thrown.

Only un`exported` functions with docstrings are included, as there is a chance they may be
added to the public API. To access these unexported functions, one would typically use the
qualified name, such as `Base.«function»`, or the package name in use in place of `Base`, to
access these un`exported` functions.

Examples of using `fun` can be found in the docstrings of `REPLference`, using the `help?>`
mode.
"""
function fun end

function man(symbol)
    str = string(symbol)
    # variables
    if match(r"^variable"i, str) != nothing
        doc(variables)
    # keywords
    elseif match(r"^(?:keyword|reserved)"i, str) != nothing
        doc(keywords)
    # operators
    elseif match(r"^operat(?:or|ion)"i, str) != nothing
        doc(operators)
    # integers
    elseif match(r"^integer"i, str) != nothing
        doc(integers)
    # floating points
    elseif match(r"^float"i, str) != nothing
        doc(floats)
    # complex numbers
    elseif match(r"^complex"i, str) != nothing
        doc(complexs)
    # rational numbers
    elseif match(r"^rational"i, str) != nothing
        doc(rationals)
    # irrationals
    elseif match(r"^irrational"i, str) != nothing
        doc(irrationals)
    # characters
    elseif match(r"^character"i, str) != nothing
        doc(characters)
    # strings
    elseif match(r"^string"i, str) != nothing
        doc(strings)
    # ranges
    elseif match(r"^range"i, str) != nothing
        doc(ranges)
    # types
    elseif match(r"^(?:type|datatype)"i, str) != nothing
        doc(types)
    # function
    elseif match(r"^(?:function|method|procedure)"i, str) != nothing
        doc(functions)
    # tuples
    elseif match(r"^(?:tuple|named(.)?tuple)"i, str) != nothing
        doc(tuples)
    # sets
    elseif match(r"^set"i, str) != nothing
        doc(sets)
    # dictionaries
    elseif match(r"^dict"i, str) != nothing
        doc(dicts)
    # arrays
    elseif match(r"^array"i, str) != nothing
        doc(arrays)
    # random numbers
    elseif match(r"^rand"i, str) != nothing
        doc(randoms)
    # time and date
    elseif match(r"^(?:time|date)"i, str) != nothing
        doc(datetime)
    # files
    elseif match(r"^(?:file|io|stream)"i, str) != nothing
        doc(files)
    # modules
    elseif match(r"^(?:module|package)"i, str) != nothing
        doc(modules)
    # regexes
    elseif match(r"^reg(?:ex|ular)"i, str) != nothing
        doc(regexes)
    end
end

function fun(symbol)
    str = string(symbol)
    # operators
    if match(r"operat(?:or|ion)"i, str) != nothing
        operators()
    # integers
    elseif match(r"^integer"i, str) != nothing
        integers()
    # floating points
    elseif match(r"^float"i, str) != nothing
        floats()
    # complex numbers
    elseif match(r"^complex"i, str) != nothing
        complexs()
    # rational numbers
    elseif match(r"^rational"i, str) != nothing
        rationals()
    # irrationals
    elseif match(r"^irrational"i, str) != nothing
        irrationals()
    # characters
    elseif match(r"^character"i, str) != nothing
        characters()
    # strings
    elseif match(r"^string"i, str) != nothing
        strings()
    # ranges
    elseif match(r"^range"i, str) != nothing
        ranges()
    # types
    elseif match(r"^(?:type|datatype)"i, str) != nothing
        types()
    # function
    elseif match(r"^(?:function|method|procedure)"i, str) != nothing
        functions()
    # tuples
    elseif match(r"^(?:tuple|named(.)?tuple)"i, str) != nothing
        tuples()
    # sets
    elseif match(r"^set"i, str) != nothing
        sets()
    # dictionaries
    elseif match(r"^dict"i, str) != nothing
        dicts()
    # arrays
    elseif match(r"^array"i, str) != nothing
        arrays()
    # random numbers
    elseif match(r"^rand"i, str) != nothing
        randoms()
    # time and date
    elseif match(r"^(?:time|date)"i, str) != nothing
        datetime()
    # files
    elseif match(r"^(?:file|io|stream)"i, str) != nothing
        files()
    # modules
    elseif match(r"^(?:module|package)"i, str) != nothing
        modules()
    # regexes
    elseif match(r"^re(?:gex|gular)"i, str) != nothing
        regexes()
    end
end

man(::Integer)         = doc(integers)
man(::AbstractFloat)   = doc(floats)
man(::Complex)         = doc(complexs)
man(::Rational)        = doc(rationals)
man(::Irrational)      = doc(irrationals)
man(::AbstractChar)    = doc(characters)
man(::AbstractString)  = doc(strings)
man(::AbstractRange)   = doc(ranges)
man(::Type)            = doc(types)
man(::Function)        = doc(functions)
man(::Tuple)           = doc(tuples)
man(::NamedTuple)      = doc(tuples)
man(::AbstractSet)     = doc(sets)
man(::AbstractDict)    = doc(dicts)
man(::AbstractArray)   = doc(arrays)
man(::AbstractTime)    = doc(datetime)
man(::IO)              = doc(files)
man(::Module)          = doc(modules)
man(::AbstractPattern) = doc(regexes)

fun(::Integer)         = integers()
fun(::AbstractFloat)   = floats()
fun(::Complex)         = complexs()
fun(::Rational)        = rationals()
fun(::Irrational)      = irrationals()
fun(::AbstractChar)    = characters()
fun(::AbstractString)  = strings()
fun(::AbstractRange)   = ranges()
fun(::Type)            = types()
fun(::Function)        = functions()
fun(::Tuple)           = tuples()
fun(::NamedTuple)      = tuples()
fun(::AbstractSet)     = sets()
fun(::AbstractDict)    = dicts()
fun(::AbstractArray)   = arrays()
fun(::AbstractTime)    = datetime()
fun(::IO)              = files()
fun(::Module)          = modules()
fun(::AbstractPattern) = regexes()

end

#=
TO DO
# Symbols
# Enumerations
# Macros
# Metaprogramming
=#