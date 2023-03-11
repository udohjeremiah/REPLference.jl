include("utility_script.jl")

@doc raw"""
# COMPLEX NUMBERS
Julia provides a wide range of primitive numeric types, with a full complement of arithmetic
and bitwise operators, as well as standard mathematical functions. These are directly mapped
to the numeric types and operations supported by modern computers, allowing Julia to fully
utilize computational resources. Furthermore, Julia supports Arbitrary Precision Arithmetic
for handling numeric values that cannot be effectively represented in native hardware,
albeit with slower performance.

Complex numbers in Julia are built on these primitive types and include predefined types for
complex numbers, with support for all standard mathematical operations and functions.

Conversion and promotion are also defined, so that operations with any combination of
predefined numeric types, whether primitive or composite, behave as expected.

## Imaginary Unit (or Number)
In mathematics, a complex number is a type of number that extends the real numbers with an
element denoted `i`, known as the "imaginary unit", which satisfies the equation `i² = -1`.
The term "imaginary" originated because there is no real number that has a negative square.
There are two complex square roots of `-1`, `i` and `-i`, just as there are two complex
square roots for any real number other than zero (which has one double square root).

By using `i`, the real numbers can be extended to "complex numbers" through addition and
multiplication, such as the complex number `a + bi`, where `a` is the real part and `b` is
the imaginary part. `i` is a solution to the equation `x² + 1 = 0`.

Contrary to its historical name, complex numbers are considered "real" in the mathematical
sciences, and they play a fundamental role in many aspects of the scientific description of
the natural world.

In Julia, the global constant `im` represents `i`, the principal square root of `-1`. The
use of mathematicians' `i` or engineers `j`, commonly used as index variables by
programmers, was avoided for `im`.

The actual definition of `im` in Julia's
[`Base` module](https://github.com/JuliaLang/julia/edit/master/base/complex.jl) is:

```julia
const im = Complex(false, true)
```

`im` is a global constant of type `Complex{Bool}`, and calling `im` directly returns the
constant.

!!! note
    The tree below represents only the hierarchy tree of the `Complex` type and is not a
    complete hierarchy tree of the `Number` type.

```julia
Any
└─ Number
   ├─ Complex
   └─ Real
```

## How To Create A Complex Number
Julia uses various methods and syntax for creating complex numbers, which are listed below:

- Since Julia permits numeric literals to be placed next to identifiers as coefficients,
  this binding offers a convenient syntax for complex numbers similar to traditional
  mathematical notation:

```julia
julia> 1 + 2im
1 + 2im

julia> 1//2 + 3im
1//2 + 3//1*im

julia> 0x10 + im
0x10 + 0x01im

julia> 0x10 + 0x2im         # throws an error
ERROR: syntax: invalid numeric constant "0x2i"

julia> 0x10 + 0x2*im        # this works now 
0x10 + 0x02im

julia> 0x10 + UInt8(0x2)im  # this works too as well 
0x10 + 0x02im

julia> 2e-2 + 2im
0.02 + 2.0im

julia> 2.3f0 + 1.2f3im
2.3f0 + 1200.0f0im
```

- Complex numbers can also be created from variables, but juxtaposition does not work when
  constructing a complex number from variables. Instead, the multiplication must be
  explicitly written out:

```julia
julia> a = 1; b = 2;

julia> a + bim
ERROR: UndefVarError: bim not defined

julia> a + b*im
1 + 2im
```

- Another way to create a complex number is to use the efficient `complex` function, which
  directly constructs a complex value from its real and imaginary parts. The syntax is
  `complex(r, [i])`, where `i` defaults to `0`. This method solves the problem of creating
  complex numbers from unsigned literals encountered with juxtaposition, and also eliminates
  the need for multiplication and addition operations when creating complex numbers from
  variables:

```julia
julia> a = 1; b = 2;

julia> complex(a, b)
1 + 2im

julia> complex(0x10, 0x2)
0x10 + 0x02im

julia> complex(5.0, -12.9)
5.0 - 12.9im

julia> complex(5)
5 + 0im

julia> complex(11//2)
11//2 + 0//1*im
```

## Subtle Bugs To Take Note Of When Juxtaposing Complex Numbers
In Juxtaposing identifiers to form complex numbers, leaving out the real part creates a
complex number with a real part of `0`, not the imaginary part as one might expect:

```julia
julia> 2im       # this is not same as 2 + 0im
0 + 2im

julia> 1//2im    # this is not same as 1//2 + 0im
0//1 - 1//2*im
```

Leaving out the imaginary part creates a complex number with an imaginary part of `1`, not
`0` as one might expect:

```julia
julia> 1 + im    # this is not same as 1 + 0im
1 + 1im

julia> 0 + im    # this is not same as 0 + 0im
0 + 1im
```

## Complex Number Types
```julia
struct Complex{T<:Real} <: Number
    re::T
    im::T
end
```

The definition of `Complex` in Julia's
[`Base` module](https://github.com/JuliaLang/julia/edit/master/base/complex.jl) is shown
above. Complex numbers can only be made up of real numbers, subtypes of `Real`. This means a
complex number can only be formed from an integer, floating-point, `Rational` number, or any
other subtype of `Real` defined by the user. The concrete type of a complex number will be a
concrete type of `Complex` composed of real numbers and these concrete types are
`DataType`s, not `UnionAll`. For example:

```julia
julia> x = 1 + 3im; typeof(x)
Complex{Int64}

julia> isconcretetype(Complex{Int64})
true

julia> typeof(Complex{Int64})
DataType

julia> Base.show_supertypes(Complex{Int64})
Complex{Int64} <: Number <: Any
```

`Inf` and `NaN` propagate through complex numbers in the real and imaginary parts as
described in the
[special floating-point values section](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Special-floating-point-values).
For example:

```julia
julia> 1 + Inf*im
1.0 + Inf*im

julia> 1 + NaN*im
1.0 + NaN*im

julia> NaN16 + -Inf16*im
NaN16 - Inf16*im

julia> Inf32 + 2im
Inf32 + 2.0f0im
```

## Type Alias For Complex Numbers
Julia provides type aliases, i.e. alternative names, for some complex numbers, and using the
aliases is the same as using the original names.:

```julia
julia> ComplexF16
ComplexF16 (alias for Complex{Float16})

julia> ComplexF32
ComplexF32 (alias for Complex{Float32})

julia> ComplexF64
ComplexF64 (alias for Complex{Float64})
```

## Real And Imaginary Part Of A Complex Number
The real and imaginary part of a complex value can be extracted using the `real` and `imag`
functions or accessing the `re` and `im` fields of the complex number:

```julia
julia> x = 1 + 3im
1 + 3im

julia> x.re
1

julia> x.im
3

julia> real(x)
1

julia> imag(x)
3
```

## Mathematical Operations & Standard Functions
As stated earlier, all the standard [mathematical operations and elementary functions]
(https://docs.julialang.org/en/v1/manual/mathematical-operations/#Elementary-Functions) are
supported for complex values.

Note that mathematical functions typically return real values when applied to real numbers,
and complex values when applied to complex numbers. For example, the `sqrt` function behaves
differently when applied to `-1` compared to `-1 + 0im` even though `-1` is equal to
`-1 + 0im`:

```julia
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).

julia> sqrt(-1 + 0im)
0.0 + 1.0im
```

Also, standard functions for manipulating complex values are provided. A few examples are:

| Function | Operation                                    |
|:--------:|:---------------------------------------------|
| `real`   | Returns the real part.                       |
|          |                                              |
| `imag`   | Returns the imaginary part.                  |
|          |                                              |
| `conj`   | Returns the complex conjugate.               |
|          |                                              |
| `abs`    | Returns its distance from zero.              |
|          |                                              |
| `abs2`   | Returns the square of the absolute value,    |
|          | and is of particular use for complex numbers |
|          | since it avoids taking a square root.        |
|          |                                              |
| `angle`  | Returns the phase angle in radians (also     |
|          | known as the argument or arg function).      |
"""
function complexs(;extmod=false)
    constants = [
        "Constants" => [
            "RoundDown", "RoundFromZero", "RoundNearest", "RoundNearestTiesAway",
            "RoundNearestTiesUp", "RoundToZero", "RoundUp", "im"
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
                "canonicalize2ˣ", "evalpoly", "inv", "kron", "muladd", "widemul"
            ],
            "Absolute Value, Min/Max & Sign"      => [
                "abs", "abs2", "adjoint", "conj", "sign"
            ],
            "Logs, Powers & Roots"                => [
                "exp", "exp10", "exp2", "expm1", "hypot", "log", "log10", "log1p", "log2",
                "sqrt"
            ],
            "Rouding"                             => [
                "clamp", "round"
            ],
            "Trigonometric & Hyperbolic"          => [
                "acos", "acot", "acotd", "acoth", "acsc", "acscd", "acsch", "angle", "asec",
                "asecd", "asech", "asin", "asind", "asinh", "atan", "atand", "atanh", "cis",
                "cispi", "cos", "cosc", "cosd", "cosh", "cospi", "cot", "cotd", "coth",
                "csc", "cscd", "csch", "deg2rad", "rad2deg", "sec", "secd", "sech", "sin",
                "sinc", "sincos", "sincosd", "sincospi", "sind", "sinh", "sinpi", "tan",
                "tand", "tanh"
            ],
            "True/False"                          => [
                "hasproperty", "ifelse", "isa", "isapprox", "isbits", "isdefined",
                "isequal", "iseven", "isfinite", "isgreaterˣ", "isinf", "isinteger",
                "isless", "ismutable", "isnan", "isodd", "isone", "ispow2", "isreal",
                "isunordered", "iszero",
            ],
            "Type-Conversion"                     => [
                "big", "cconvertˣ", "collect", "complex", "convert", "float", "oftype",
                "promote", "rationalize", "string", "unsafe_convertˣ", "widen"
            ],
            "Others"                              => [
                "bswap", "display", "dump", "getfield", "getproperty", "imag", "identity",
                "nfields", "one", "oneunit", "print", "println", "printstyled",
                "propertynames", "real", "redisplay", "reim", "repr", "show", "sizeof",
                "summary", "summarysizeˣ", "typeassert", "typeof", "zero"
            ]
        ]
    ]
    types = [
        "Types" => [
            "Complex", "ComplexF16", "ComplexF32", "ComplexF64", "DataType", "Number",
            "Pair", "Ref", "RoundingMode",
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "%", "'", "*", "+", "-", "/", "==", "=>", "\\", "^", "∈", "∉",
            "∋", "∌", "√", "∛", "∩", "∪", "≈", "≉", "≠", "≡", "≢", "≤", "≥", "⊆", "⊇",
            "⊈", "⊉", "⊊", "⊋", "==="
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Printf.@printf", "Printf.@sprintf", "Printf.Formatˣ", "Printf.Pointerˣ",
            "Printf.PositionCounterˣ", "Printf.Specˣ", "Printf.formatˣ", "Printf.tofloatˣ",
            "Statistics.middle"
        ]
    ]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end