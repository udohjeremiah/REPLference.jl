include("utility_script.jl")

@doc raw"""
# RATIONAL NUMBERS

## What Are Rational Numbers
In mathematics, a rational number is a number that can be expressed as a fraction where both
the numerator and the denominator in the fraction are integers.  Rational numbers include
fractions and any number that can be expressed as fractions. 

They are in the form of `p/q`, where `p` and `q` can be any integer and `q ≠ 0`.
This means that rational numbers include natural numbers, whole numbers, integers, fractions
of integers, and decimals (terminating decimals and recurring decimals).

To summarize, a number that can be expressed as an integer or the quotient of an integer
divided by a nonzero integer, will be considered a rational number.

The different types of rational numbers are:

- Integers like `-2`, `0`, `3`, etc.
- Fractions whose numerators and denominators are integers like `3/7`, `-6/5`, etc.
- Terminating decimals like `0.35`, `0.7116`, `0.9768`, etc..
- Non-terminating decimals with some repeating patterns (after the decimal point) such as
  `0.333...`, `0.141414...`, etc. These are popularly known as non-terminating repeating
  decimals.

## DIFFERENCES BETWEEN RATIONAL AND IRRATIONAL NUMBERS
| Rational Numbers                        | Irrational Numbers                      |
|:----------------------------------------|:----------------------------------------|
| These are numbers that can be           | These are numbers that cannot be        |
| expressed as fractions of integers.     | expressed as fractions of integers.     |
| Examples: `1/2`, `0.75`, `-31/5`, etc.  | Examples: `√5`, `π`, etc.               |
|                                         |                                         |
| They are terminating decimals.          | They are NEVER terminating decimals     |
|                                         | that do not have an accurate value.     |
|                                         |                                         |
| They can be non-terminating decimals    | They are non-terminating decimals with  |
| but with repetitive patterns of         | NO repetitive patterns of decimals.     |
| decimals or recurring decimals.         | Example:                                |
| Example: `1.414414414...` has           | `√5 = 2.236067977499789696409173....`   |
| repeating patterns of decimals          | has no repeating patterns of decimals.  |
| where `414` is repeating.               |                                         |
|                                         |                                         |
| The set of rational numbers contains    | The set of irrational numbers is a      |
| all-natural numbers, all whole,         | separate set and it does NOT contain    |
| numbers and all integers.               | any of the other sets of numbers.       |

In Julia, rational numbers are defined on top of integers, one of the primitive numeric
types. Support for all standard mathematical operations and elementary functions is
available for them.

Conversion and promotion are also defined so that operations on any combination of
predefined numeric types, whether primitive or composite, behave as expected.

## Type Hierarchy Tree
!!! note
    The tree below is not the complete type hierarchy tree of `Number`. It's ONLY for the
    `Rational` type.

```julia
Any
└─ Number
   └─ Real
      └─ Rational
```

## How To Create A Rational Number
`Rational`s in Julia can be constructed in several ways depending on the primitive or
composite numeric types being used.

- For integers and `Rational`s, they are constructed straightforwardly using the `//`
  operator to represent the exact ratios of the integers:

```julia
julia> 2//3
2//3

julia> 0x3//0x5
0x03//0x05

julia> (3 // 5) // (2 // 1)
3//10

julia> 3 // 5 // 6    # same as (3//5) // 6
1//10

julia> 3 // -5        # denominator is always positive
-3//5
```

- For floating-points, they are constructed by calling the `rationalize` function to get
  the inexact conversion of a floating number OR by calling the `Rational` constructor
  or `convert` function to get the exact representation of a floating-point number that is
  representable by the floating-point type in use.

```julia
julia> rationalize(1.2)
6//5

julia> Rational(1.2)
5404319552844595//4503599627370496

julia> convert(Rational, 1.2)
5404319552844595//4503599627370496
```

As seen above, different results are returned because of the exact and inexact conversion
returned:

```julia
julia> 1.2 == rationalize(1.2)        # inexact conversion
false

julia> 1.2 == Rational(1.2)           # exact conversion
true

julia> 1.2 == convert(Rational, 1.2)  # exact conversion
true

julia> rationalize(1.2) == Rational(1.2)
false
```

The `Rational` and `convert` conversion is exact: `Rational(1.2)` is a rational
representation of the same value as `1.2` (which is a floating-point approximation of the
decimal value `1.2`), whereas `rationalize(1.2)` is not exactly equal to `1.2` but is
exactly equal to the decimal value `1.2`.

Note that the `//` operator does not necessarily always result in the creation of a
`Rational` number of two integers, i.e., a numerator and a denominator. This behavior only
happens when it is used with two integers. Using the `//` operator with types other than an
integer will return a different type that is composed of a `Rational` number:

```julia
julia> 5//3+2im
5//3 + 2//1*im

julia> 5//(3+2im)
15//13 - 10//13*im

julia> 3im//3
0//1 + 1//1*im

julia> 4.0//2im
0.0 - 2.0im
```

## Rational Number Types
```julia
struct Rational{T<:Integer} <: Real
   num::T
   den::T

   # Unexported inner constructor of Rational that bypasses all checks
   global unsafe_rational(::Type{T}, num, den) where {T} = new{T}(num, den)
end
```

From the actual definition of `Rational` in [Julia's Base module]
(https://github.com/JuliaLang/julia/blob/master/base/rational.jl) as shown above, rational
numbers can ONLY be made up of integers: `Rational{T<:Integer}`, which means they are
subtypes of 'Integer'.

So, what is the concrete type of a rational number since it cannot be `Rational`? It will be
a concrete type of `Rational` composed of integers (i.e. subtypes of `Integer`), and these
concrete types are `DataType`s and not `UnionAll`.

An example is shown below:

```julia
julia> x = 1//2; typeof(x)
Rational{Int64}

julia> isconcretetype(Rational{Int64})
true

julia> typeof(Rational{Int64})
DataType

julia> Base.show_supertypes(Rational{Int64})
Rational{Int64} <: Real <: Number <: Any
```

## Numerator And Denominator Of A Rational Number
The standardized numerator and denominator of a rational value can be extracted using the
`numerator` and `denominator` functions or calling on the `num` and `den` field of the
rational number:

```julia
julia> x = 2//3
2//3

julia> x.num
2

julia> x.den
3

julia> numerator(x)
2

julia> denominator(x)
3
```

If the numerator and denominator of a rational have common factors, they are reduced to
lowest terms such that the denominator is non-negative:

```julia
julia> 6//9
2//3

julia> -4//8
-1//2

julia> 5//-15
-1//3

julia> -4//-12
1//3
```

## Standard Arithmetic Operations With Rational Numbers
As stated earlier, all the standard [mathematical operations and elementary functions]
(https://docs.julialang.org/en/v1/manual/mathematical-operations/#Elementary-Functions) are
supported for rational values.

This normalized form (i.e. the reducing of a rational number to its lowest term when the
numerator and denominator have common terms) for a ratio of integers is unique, so equality
of rational values can be tested by checking for equality of the numerator and denominator:

```julia
julia> x = 1//11; y = 5//55;

julia> x.num == y.num
true

julia> x.den == y.den
true

julia> x == y
true
```

Anyway, direct comparison of the numerator and denominator is generally not necessary,
since the standard arithmetic and comparison operations are defined for rational values:

```julia
julia> 2//3 == 6//9
true

julia> 3//7 < 1//2
true

julia> 2//4 + 1//6
2//3

julia> 3//4 > 2//3
true

julia> 6//5 / 10//7
21//25
```

As usual, the promotion system makes interactions with other numeric types effortless:

```julia
julia> 3//5 + 1
8//5

julia> 2//7 * (1.5 + 2im)
0.42857142857142855 + 0.5714285714285714im

julia> 0.5 == 1//2
true
```

Rationals are checked for overflow:

```julia
julia> x = typemax(Int64); y = typemax(Int64);

julia> x + y
-2

julia> x = typemax(Int64)//1; y = typemax(Int64)//1;

julia> x + y
ERROR: OverflowError: 9223372036854775807 + 9223372036854775807 overflowed for type Int64
```

## Conversion Of Rational Numbers
Rationals can easily be converted to floating-point numbers:

```julia
julia> float(9//14)
0.6428571428571429

julia> Float16(9//14, RoundUp)
Float16(0.643)
```

Conversion from rational to floating-point respects the following identity for any integral
values of `a` and `b`, with the exception of the case `a == 0` and `b == 0`:

```julia
julia> a = 1; b = 2; float(a//b) == a/b
true

julia> a = 0; b = 2; float(a//b) == a/b
true

julia> a = 1; b = 0;  float(a//b) == a/b
true

julia> a = 0; b = 0; float(a//b) == a/b
ERROR: ArgumentError: invalid rational: zero(Int64)//zero(Int64)
```

The expression `float(a//b) == a/b` when `a = 0; b = 0;` in the above code block threw an
error because trying to construct a `NaN` rational value is invalid:

```julia
julia> 0/0
NaN

julia> 0//0
ERROR: ArgumentError: invalid rational: zero(Int64)//zero(Int64)

julia> Rational(NaN)
ERROR: InexactError: Int64(NaN)
```

However, constructing an `Inf` rational value is valid. Any rational number with the
denominator as `0` produces an infinity that is represented as `1//0`:

```julia
julia> 2/0
Inf

julia> 2//0
1//0

julia> Rational(Inf)
1//0
```

Note that `1//0` does not equal `0//1`. `1//0` is a Julia's way of saying `Inf` in rational
value, whereas `0//1` is Julia's representation of `0` in rational value:

```julia
julia> 1//0 == 0//1
false

julia> 0//1 == 0
true

julia> 1//0 == Inf
true
```

## Minimum And Maximum Values For Rational Types
The minimum and maximum representable values of rational values built on top of the
primitive type `Integer` are given by the `typemin` and `typemax` functions.

The values returned by `typemin` and `typemax` for `Rational` values are equivalent to
`typemin(T<:AbstractFloat)` and `typemax(T<:AbstractFloat)` respectively:

```julia
julia> typemin(Rational{Int})
-1//0

julia> typemax(Rational{Int})
1//0
```
"""
function rationals(;extmod=false)
    constants = [
        "Constants" => [
            "RoundDown", "RoundFromZero", "RoundNearest", "RoundNearestTiesAway",
            "RoundNearestTiesUp", "RoundToZero", "RoundUp"
        ]
    ]
    macros = [
        "Macros" => [
            "@assert", "@doc", "@evalpoly", "@fastmath", "@show", "@showtime"
        ]
    ]
    methods = [
        "Methods" => [
            "Addition, Division & Multiplication" => [
                "canonicalize2ˣ", "cld", "div", "divrem", "evalpoly", "fld", "fld1",
                "fldmod", "fldmod1", "fma", "gcd", "gcdx", "inv", "kron", "lcm", "mod",
                "mod1", "muladd", "nextprod", "rem", "widemul"
            ],
            "Absolute Value, Min/Max & Sign"      => [
                "abs", "abs2", "cmp", "copysign", "flipsign", "max", "min", "minmax",
                "sign", "signbit"
            ],
            "Logs, Powers & Roots"                => [
                "cbrt", "exp", "exp10", "exp2", "expm1", "exponent", "hypot", "log",
                "log10", "log1p", "log2", "nextpow", "prevpow", "sqrt"
            ],
            "Rouding"                             => [
                "ceil", "clamp", "floor", "round", "trunc", "unsafe_trunc"
            ],
            "Trigonometric & Hyperbolic"          => [
                "acos", "acot", "acotd", "acoth", "acsc", "acscd", "acsch", "asec", "asecd",
                "asech", "asin", "asind", "asinh", "atan", "atand", "atanh", "cis", "cispi",
                "cos", "cosc", "cosd", "cosh", "cospi", "cot", "cotd", "coth", "csc",
                "cscd", "csch", "deg2rad", "rad2deg", "sec", "secd", "sech", "sin", "sinc",
                "sincos", "sincosd", "sincospi", "sind", "sinh", "sinpi", "tan", "tand",
                "tanh"
            ],
            "True/False"                          => [
                "hasproperty", "ifelse", "isa", "isapprox", "isbits", "isdefined",
                "isequal", "iseven", "isfinite", "isgreaterˣ", "isinf", "isinteger",
                "isless", "ismutable", "isnan", "isodd", "isone", "ispow2", "isreal",
                "isunordered", "iszero"
            ],
            "Type-Conversion"                     => [
                "big", "cconvertˣ", "collect", "complex", "convert", "float", "oftype",
                "promote", "string", "unsafe_convertˣ", "widen"
            ],
            "Others"                              => [
                "denominator", "display", "dump", "getfield", "getproperty", "identity",
                "modf", "nfields", "numerator", "one", "oneunit", "print", "println",
                "printstyled", "propertynames", "redisplay", "repr", "show", "sizeof",
                "summary", "summarysizeˣ", "typeassert", "typeof", "typemax", "typemin",
                "zero"
            ]
        ]
    ]
    types = [
        "Types" => [
            "DataType", "Number", "Pair", "Rational", "Real", "Ref", "RoundingMode"  
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "%", "*", "+", "-", "/", "<", "<<", "<=", "==", "=>", ">",
            ">=", ">=", "\\", "^", "÷", "∈", "∉", "∋", "∌", "√", "∛", "∩", "∪", "≈", "≉",
            "≠", "≡", "≢", "≤", "≥", "⊆", "⊇", "⊈", "⊉", "⊊", "⊋", "==="
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Printf.@printf", "Printf.@sprintf", "Printf.Formatˣ", "Printf.Pointerˣ",
            "Printf.PositionCounterˣ", "Printf.Specˣ", "Printf.formatˣ", "Printf.tofloatˣ",
            "Statistics.clampcorˣ", "Statistics.middle",
        ]
    ]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end