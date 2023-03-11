@doc raw"""
# IRRATIONAL NUMBERS

## What Are Irrational Numbers
In mathematics, irrational numbers are all the real numbers that are not rational numbers.
That is, irrational numbers cannot be expressed as the ratio of two integers.

They are the set of real numbers that cannot be expressed in the form of a fraction `p/q`,
where `p` and `q` are integers and `q ≠ 0`.

In irrational numbers, the decimal expansion does not terminate, nor end with a repeating
sequence. For example, the decimal representation of `π` starts with `3.14159`, but no
finite number of digits can represent `π` exactly, nor does it repeat.

Other examples of irrational numbers are euler's number `ℯ`, the golden ratio `φ`, and the
square root of two `√2`. In fact, all square roots of natural numbers, other than of
perfect squares, are irrational.

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

In Julia, irrational numbers are an "extension" of floating-point numbers, defined for the
purpose of representing exact irrational values. They are singletons used to represent some
irrational numbers of *special significance or classical value*, that delay or elide the
actual computation.

- By *"special significance or classical value"*, it implies that only few of the numerous
  mathematically valid irrational numbers are supported. Nevertheless you can define yours
  in cases where you want to.

- By *"delay or elide the actual computation"*, it implies that they are correctly
  represented on any type only when requested by the user by means of using them in
  calculations or type conversions.

Irrational numbers in Julia are of a special number type. They're mostly used in cases where
one wants to avoid losing precision in a floating-point number. Because of how they're
constructed, they're represented exactly and can be converted to any floating-point type
with the correct precision.

## Type Hierarchy Tree
!!! note
    The tree below is not the complete type hierarchy tree of `Number`. It's ONLY for the
    **`AbstractIrrational`** type.

```julia
Any
└─ Number
   └─ Real
      └─ AbstractIrrational
         └─ Irrational
```

Below is the actual definition of `Irrational` from [Julia's `Base` module]
(https://github.com/JuliaLang/julia/edit/master/base/irrationals.jl), showing `Irrational`
is a parametric type i.e. a `UnionAll`:

```julia
struct Irrational{sym} <: AbstractIrrational end
```

## How To Create An Irrational Number
Irrationals in Julia are constructed using the `Base.@irrational` macro:

```julia
  @irrational sym val def
  @irrational(sym, val, def)
```

An example of an irrational number is `2π`, and we can create it as shown below:

```julia
julia> Base.@irrational twoπ   6.2831853071795864769  2*big(π)

julia> twoπ
twoπ = 6.2831853071795...
```

When using the macro, an error is thrown when:

- `big(def) isa BigFloat` returns `false`:

```julia
julia> Base.@irrational twoπ   6.2831853071795864769  2*π
ERROR: AssertionError: big(\$(Expr(:escape, :twoπ))) isa BigFloat
```

- `Float64(val) == Float64(def)` returns `false`:

```julia
julia> Base.@irrational twoπ   6.2831853071795864769f0  2*big(π)
ERROR: AssertionError: Float64(\$(Expr(:escape, :twoπ))) == Float64(big(\$(Expr(:escape, :twoπ))))
```

This means that we can **ONLY** have irrational numbers that are pre-computed with `Float64`
values, with their expression being types of `BigFloat`.

When defining the arbitrary-precision in terms of `BigFloat`s given by the expression `def`
in `Base.@irrational(sym, val, def)`, always convert the intended number to arbitrary
precision before any operation is carried out to get the exact result. For example:

```julia
julia> √big(2)
1.414213562373095048801688724209698078569671875376948073176679737990732478462102

julia> big(√2)
1.4142135623730951454746218587388284504413604736328125

julia> √big(2) == big(√2)
false
```

In the above, `√big(2)` computes the square root of the arbitrary precision number `2`,
whereas `big(√2)` converts to the closest arbitrary precision number, the approximate value
of the square root of the `Float64` number `2`. In other words, you get "garbage" after the
16th decimal place because only from the 1st to the 16th decimal place is representable by a
`Float64` value, as seen from the `floatmax()` function below:

```julia
julia> floatmax(Float64)
1.7976931348623157e308
```

To add to all that has been said, the actual definitions of the mathematical constants from
[Julia's Base module](https://github.com/JuliaLang/julia/blob/master/base/mathconstants.jl))
is a great example of creating irrational values:

```julia
Base.@irrational π        3.14159265358979323846  pi
Base.@irrational ℯ        2.71828182845904523536  exp(big(1))
Base.@irrational γ        0.57721566490153286061  euler
Base.@irrational φ        1.61803398874989484820  (1+sqrt(big(5)))/2
Base.@irrational catalan  0.91596559417721901505  catalan
```

Not all of the above irrationals are exported. You might need to use
`Base.MathConstants.«name»` to view and use the above irrationals in the REPL mode.

## Irrational Number Types
```julia
abstract type AbstractIrrational <: Real end

struct Irrational{sym} <: AbstractIrrational end
```

From the actual definition of `AbstractIrrational` and `Irrational` in [Julia's Base module]
(https://github.com/JuliaLang/julia/blob/master/base/irrationals.jl) as shown above, an
irrational number in Julia can ONLY be composed of a `Symbol` represented by `sym`, which
denotes an `AbstractIrrational` value. An `AbstractIrrational` value can only be a real
number because `AbstractIrrational <: Real`.

So what will be the concrete type of an irrational number, since it can't be `Irrational`?
It will be a concrete type of `Irrational` composed of the symbol `:sym`, where `sym` is a
`Real` number of type `AbstractIrrational`. These concrete types are `DataType`s and not
`UnionAll`.

An example is shown below:

```julia
julia> Base.@irrational invπ 0.31830988618379067154 inv(big(π))

julia> typeof(invπ)
Irrational{:invπ}

julia> isconcretetype(Irrational{:invπ})
true

julia> typeof(Irrational{:invπ})
DataType

julia> Base.show_supertypes(Irrational{:invπ})
Irrational{:invπ} <: AbstractIrrational <: Real <: Number <: Any
```


## Mathematical Operations
Irrational numbers in Julia can perform all mathematical operations that any floating-point
type can perform. This is because they are automatically rounded to the correct precision
during type conversions, arithmetic operations, and other numeric quantities.

For instance:

```julia
julia> π + Float16(0.3f2)
Float16(33.12)

julia> π + 0.3f2
33.141594f0

julia> π + 0.3e2
33.1415926535898

julia> π - 3im
3.141592653589793 - 3.0im

julia> ℯ * 2
5.43656365691809

julia> ℯ / 2
1.3591409142295225

julia> ℯ ÷ 2
1.0

julia> Float32(π)
3.1415927f0

julia> Float64(π)
3.141592653589793
```

However, one subtle behavior to note is that of the unary minus, `-`, operator with
irrational values. While one might think that it does not change the variable type, in
irrational numbers it does:

```julia
julia> -π
-3.141592653589793

julia> typeof(-π)
Float64

julia> Base.@irrational negsqrt2 -1.4142135623730951 -√(big(2))

julia> negsqrt2
negsqrt2 = -1.414213562373...

julia> -negsqrt2
1.4142135623730951

julia> typeof(-negsqrt2)
Float64
```
"""
function irrationals(;extmod=false)
    constants = [
        "Constants" => [
            "RoundDown", "RoundFromZero", "RoundNearest", "RoundNearestTiesAway",
            "RoundNearestTiesUp", "RoundToZero", "RoundUp", "pi", "π", "ℯ"
        ]
    ]
    macros = [
        "Macros" => [
            "@assert", "@doc", "@evalpoly", "@fastmath", "@irrationalˣ", "@show",
            "@showtime",
        ]
    ]
    methods = [
        "Methods" => [
            "Addition, Division & Multiplication" => [
                "add12ˣ", "canonicalize2ˣ", "cld", "div", "divrem", "evalpoly", "fld",
                "fld1", "fldmod", "fldmod1", "fma", "inv", "kron", "mod", "mod1", "muladd",
                "nextprod", "rem", "widemul"
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
                "ceil", "clamp", "floor", "round",
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
                "ifelse", "isapprox", "isa", "isbits", "isequal", "iseven", "isfinite",
                "isgreaterˣ", "isinf", "isinteger", "isless", "ismutable", "isnan", "isodd",
                "isone", "isreal", "isunordered", "iszero"
            ],
            "Type-Conversion"                     => [
                "big", "cconvertˣ", "collect", "complex", "convert", "float", "oftype",
                "promote", "rationalize", "string", "unsafe_convertˣ", "widen"
            ],
            "Others"                              => [
                "display", "dump", "identity", "modf", "one", "print", "println",
                "printstyled", "redisplay", "repr", "show", "sizeof", "summary",
                "summarysizeˣ", "typeassert", "typeof", "zero"
            ]
        ]
    ]
    types = [
        "Types" => [
            "AbstractIrrational", "DataType", "Irrational", "Number", "Real", "Ref", "Pair",
            "RoundingMode",
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "%", "'", "*", "+", "-", "/", "<", "<=", "==", "=>", ">",
            ">=", "\\", "^", "÷", "∈", "∉", "∋", "∌", "√", "∛", "∩", "∪", "≈", "≉", "≠",
            "≡", "≢", "≤", "≥", "⊆", "⊇", "⊈", "⊉", "⊊", "⊋", "==="
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