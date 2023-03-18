module REPLference

include("utility_script.jl")
include("_1_keyword.jl")
include("_2_variable.jl")
include("_3_operator.jl")
include("_4_integer.jl")
include("_5_float.jl")
include("_6_complex.jl")
include("_7_rational.jl")
include("_8_irrational.jl")
include("_9_character.jl")
include("_10_string.jl")
include("_11_range.jl")
include("_12_array.jl")
include("_13_tuple.jl")
include("_14_dict.jl")
include("_15_set.jl")
include("_16_type.jl")
include("_17_function.jl")
include("_18_file.jl")
include("_19_module.jl")
include("_20_regex.jl")
include("_21_date.jl")
include("_22_random.jl")

import Dates: AbstractTime
import .Docs: doc

export man, fun, subtree

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

"""
    subtree(T::Type)

Prints a list of immediate subtypes of type `T` in a tree-like format. Note that all
currently loaded subtypes are included, including those not visible in the current module.

Examples of using `subtree` can be found in the docstrings of `REPLference`, using the
`help?>` mode.
"""
function subtree end

function man(obj::Symbol)
    str = string(obj)
    # keywords
    if match(r"^(?:keyword|reserved)"i, str) != nothing
        doc(keywords)
        # variables
    elseif match(r"^variable"i, str) != nothing
        doc(variables)
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
        # arrays
    elseif match(r"^array"i, str) != nothing
        doc(arrays)
        # tuples
    elseif match(r"^(?:tuple|named(.)?tuple)"i, str) != nothing
        doc(tuples)
        # dictionaries
    elseif match(r"^dict"i, str) != nothing
        doc(dicts)
        # sets
    elseif match(r"^set"i, str) != nothing
        doc(sets)
        # types
    elseif match(r"^(?:type|datatype)"i, str) != nothing
        doc(types)
        # function
    elseif match(r"^(?:function|method|procedure)"i, str) != nothing
        doc(functions)
        # files
    elseif match(r"^(?:file|io|stream)"i, str) != nothing
        doc(files)
        # modules
    elseif match(r"^(?:module|package)"i, str) != nothing
        doc(modules)
        # regexes
    elseif match(r"^reg(?:ex|ular)"i, str) != nothing
        doc(regexes)
        # time and date
    elseif match(r"^(?:time|date)"i, str) != nothing
        doc(datetime)
        # random numbers
    elseif match(r"^rand"i, str) != nothing
        doc(randoms)
    end
end

function fun(obj::Symbol; extmod=false)
    str = string(obj)
    # operators
    if match(r"operat(?:or|ion)"i, str) != nothing
        operators(; extmod=extmod)
        # integers
    elseif match(r"^integer"i, str) != nothing
        integers(; extmod=extmod)
        # floating points
    elseif match(r"^float"i, str) != nothing
        floats(; extmod=extmod)
        # complex numbers
    elseif match(r"^complex"i, str) != nothing
        complexs(; extmod=extmod)
        # rational numbers
    elseif match(r"^rational"i, str) != nothing
        rationals(; extmod=extmod)
        # irrationals
    elseif match(r"^irrational"i, str) != nothing
        irrationals(; extmod=extmod)
        # characters
    elseif match(r"^character"i, str) != nothing
        characters(; extmod=extmod)
        # strings
    elseif match(r"^string"i, str) != nothing
        strings(; extmod=extmod)
        # ranges
    elseif match(r"^range"i, str) != nothing
        ranges(; extmod=extmod)
        # arrays
    elseif match(r"^array"i, str) != nothing
        arrays(; extmod=extmod)
        # tuples
    elseif match(r"^(?:tuple|named(.)?tuple)"i, str) != nothing
        tuples(; extmod=extmod)
        # dictionaries
    elseif match(r"^dict"i, str) != nothing
        dicts(; extmod=extmod)
        # sets
    elseif match(r"^set"i, str) != nothing
        sets(; extmod=extmod)
        # types
    elseif match(r"^(?:type|datatype)"i, str) != nothing
        types()
        # function
    elseif match(r"^(?:function|method|procedure)"i, str) != nothing
        functions(; extmod=extmod)
        # files
    elseif match(r"^(?:file|io|stream)"i, str) != nothing
        files(; extmod=extmod)
        # modules
    elseif match(r"^(?:module|package)"i, str) != nothing
        modules(; extmod=extmod)
        # regexes
    elseif match(r"^re(?:gex|gular)"i, str) != nothing
        regexes(; extmod=extmod)
        # time and date
    elseif match(r"^(?:time|date)"i, str) != nothing
        datetime(; extmod=extmod)
        # random numbers
    elseif match(r"^rand"i, str) != nothing
        randoms(; extmod=extmod)
    end
end

man(::Integer) = doc(integers)
man(::AbstractFloat) = doc(floats)
man(::Complex) = doc(complexs)
man(::Rational) = doc(rationals)
man(::Irrational) = doc(irrationals)
man(::AbstractChar) = doc(characters)
man(::AbstractString) = doc(strings)
man(::AbstractRange) = doc(ranges)
man(::AbstractArray) = doc(arrays)
man(::Tuple) = doc(tuples)
man(::NamedTuple) = doc(tuples)
man(::AbstractDict) = doc(dicts)
man(::AbstractSet) = doc(sets)
man(::Type) = doc(types)
man(::Function) = doc(functions)
man(::IO) = doc(files)
man(::Module) = doc(modules)
man(::AbstractPattern) = doc(regexes)
man(::AbstractTime) = doc(datetime)

fun(::Integer; extmod=false) = integers(; extmod=extmod)
fun(::AbstractFloat; extmod=false) = floats(; extmod=extmod)
fun(::Complex; extmod=false) = complexs(; extmod=extmod)
fun(::Rational; extmod=false) = rationals(; extmod=extmod)
fun(::Irrational; extmod=false) = irrationals(; extmod=extmod)
fun(::AbstractChar; extmod=false) = characters(; extmod=extmod)
fun(::AbstractString; extmod=false) = strings(; extmod=extmod)
fun(::AbstractRange; extmod=false) = ranges(; extmod=extmod)
fun(::AbstractArray; extmod=false) = arrays(; extmod=extmod)
fun(::Tuple; extmod=false) = tuples(; extmod=extmod)
fun(::NamedTuple; extmod=false) = tuples(; extmod=extmod)
fun(::AbstractDict; extmod=false) = dicts(; extmod=extmod)
fun(::AbstractSet; extmod=false) = sets(; extmod=extmod)
fun(::Type; extmod=false) = types(; extmod=extmod)
fun(::Function; extmod=false) = functions(; extmod=extmod)
fun(::IO; extmod=false) = files(; extmod=extmod)
fun(::Module; extmod=false) = modules(; extmod=extmod)
fun(::AbstractPattern; extmod=false) = regexes(; extmod=extmod)
fun(::AbstractTime; extmod=false) = datetime(; extmod=extmod)

subtree(T::Type) = _subtype_tree(T)

end
