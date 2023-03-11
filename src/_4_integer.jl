include("utility_script.jl")

@doc raw"""
# INTEGERS
Integer values are one of the basic building blocks of arithmetic and computation. Built-in
representations of such values are called numeric primitives, while representations of
integer numbers as immediate values in code are known as numeric literals. For example, `1`
is an integer literal; its binary in-memory representation as an object is a numeric
primitive.

## Type Hierarchy Tree
!!! note
    The tree below is not the complete type hierarchy tree of `Number`. It's ONLY for the
    `Integer` type.

```julia
Any
└─ Number
   └─ Real
      └─ Integer
         ├─ Bool
         ├─ Signed
         │  ├─ BigInt
         │  ├─ Int128
         │  ├─ Int16
         │  ├─ Int32
         │  ├─ Int64
         │  └─ Int8
         └─ Unsigned
            ├─ UInt128
            ├─ UInt16
            ├─ UInt32
            ├─ UInt64
            └─ UInt8
```

| Type      | Number of bits | Smallest value | Largest value |
|:----------|:--------------:|:--------------:|:-------------:|
| `Int8`    | 8              | -2^7           | 2^7 - 1       |
|           |                |                |               |
| `UInt8`   | 8              | 0              | 2^8 - 1       |
|           |                |                |               |
| `Int16`   | 16             | -2^15          | 2^15 - 1      |
|           |                |                |               |
| `UInt16`  | 16             | 0              | 2^16 - 1      |
|           |                |                |               |
| `Int32`   | 32             | -2^31          | 2^31 - 1      |
|           |                |                |               |
| `UInt32`  | 32             | 0              | 2^32 - 1      |
|           |                |                |               |
| `Int64`   | 64             | -2^63          | 2^63 - 1      |
|           |                |                |               |
| `UInt64`  | 64             | 0              | 2^64 - 1      |
|           |                |                |               |
| `Int128`  | 128            | -2^127         | 2^127 - 1     |
|           |                |                |               |
| `UInt128` | 128            | 0              | 2^128 - 1     |
|           |                |                |               |
| `Bool`    | 8              | `false` (0)    | `true` (1)    |
|           |                |                |               |
| `BigInt`  | Arbitrary      | Arbitrary      | Arbitrary     |

To get the minimum or maximum values representable in these data types, use `typemin` and
`typemax`. The default machine values are `Int` and `UInt`. The constant `Sys.WORD_SIZE`
returns the machine's default size.

# Numeric Literals
Signed integers are inputted and outputted as literal integers in the standard manner, e.g.,
`1`, `2`, `14`. Underscores, `_`, can be used as digit separators when necessary, e.g.,
`10_000`, `123_456_789`.

Unsigned integers are inputted and outputted using the `0x` prefix and hexadecimal (base 16)
digits `0-9a-f` (the capitalized digits `A-F` also work for input), e.g., `0x12`, `0xaf`,
`0xCA`.

Regarding hexadecimal literals, binary and octal literals produce unsigned integer types,
e.g., `0b11`, `0b100101`, `0o1220`. The size of the binary data item is the minimal needed
size if the leading digit of the literal is not `0`. In the case of leading zeros, the size
is determined by the minimal needed size for a literal that has the same length but leading
digit `1`.

Even if there are leading zero digits that do not contribute to the value, they count for
determining the storage size of a literal. So `0x01` is a `UInt8`, while `0x0001` is a
`UInt16`. This allows the user to control the size. Unsigned literals starting with `0x`
that are too big to fit in a `UInt128` object are interpreted as `BigInt`.

Binary, octal, and hexadecimal literals may be signed by a "`-`" immediately preceding the
unsigned literal, e.g., `-0x2`, `-0xae`. This produces an unsigned integer of the same size
as the unsigned literal would do, with the two's complement of the value.

# Overflow Behaviour
In Julia, modular arithmetic is employed for integer operations. Modular arithmetic in
integer calculations means that when the result of an arithmetic operation exceeds the
maximum representable value for that type, the value will "wrap around" and become the
smallest representable value. This behavior can be problematic in some cases, such as when
the exact result of a calculation is needed and wraparound can cause inaccuracies.

To avoid such problems, one can use the `BigInt` type to represent integers with arbitrary
precision, which is not limited by the size of the underlying hardware. However, using
`BigInt` can come at the cost of slower performance, and it may not be necessary in many
cases.

Another option is to use the `big` function, which can convert an integer to a `BigInt` if
necessary. The `widen` function can also be used to convert an integer to a wider type that
can accommodate larger values. These options can provide a middle ground between accuracy
and performance.

The `Base.OverflowSafe` is a `Union` that contains types that are safe for integer
operations to be promoted to when there's a possibility for overflow, allowing for more
precise control over the behavior of integer calculations.

Finally, the `Base.Checked` module provides a set of functions that perform integer
arithmetic with overflow checking, indicating or throwing an exception if an overflow
occurs. This can be useful for detecting and handling overflow errors explicitly, rather
than relying on the default wraparound behavior.

# Arbitrary Precision Arithmetic
To allow for computations with arbitrary-precision integers, Julia utilizes the GNU Multiple
Precision Arithmetic Library (GMP). The `BigInt` type is available in Julia for representing
arbitrary precision integers. You can construct this type from primitive numerical types
using the `BigInt` or `big` function. You can also use the `@big_str` or `parse` function to
construct `BigInt` values from strings. `BigInt` values can also be inputted as integer
literals when they are too large for other built-in integer types.

Once created, `BigInt` values participate in arithmetic operations with all other numeric
types, thanks to Julia's type promotion and conversion mechanism. Although `BigInt` is a
subtype of `Integer`, it is not an `isbitstype`.

# Division Error
Using the `div` or `÷` function, dividing by `0`, or dividing the `typemin`, the lowest
negative number, by `-1`, throws a `DivideError`. The right division operator, `/`, returns
`Inf` when a number other than `0` is divided by `0`, and it returns NaN when `0` is
divided by `0``.

The remainder and modulus functions, `rem` and `mod`, throw a `DivideError` when their
second argument is `0``.
"""
function integers(; extmod=false)
    constants = [
        "Constants" => [
            "RoundDown", "RoundFromZero", "RoundNearest", "RoundNearestTiesAway",
            "RoundNearestTiesUp", "RoundToZero", "RoundUp"
        ]
    ]
    macros = [
        "Macros" => [
            "@assert", "@big_str", "@doc", "@enum", "@evalpoly", "@fastmath", "@int128_str",
            "@show", "@showtime", "@uint128_str"
        ]
    ]
    methods = [
        "Methods" => [
            "Addition, Division & Multiplication" => [
                "binomial", "canonicalize2ˣ", "cld", "div", "divrem", "evalpoly",
                "factorial", "fld", "fld1", "fldmod", "fldmod1", "fma", "gcd", "gcdx",
                "inv", "invmod", "kron", "lcm", "mod", "mod1", "mod2pi", "muladd",
                "nextprod", "rem", "rem2pi", "widemul"
            ],
            "Absolute Value, Min/Max & Sign"      => [
                "abs", "abs2", "cmp", "copysign", "flipsign", "max", "min", "minmax",
                "sign", "signbit", "uabsˣ"
            ],
            "Bitwise"                             => [
                "nand", "nor", "xor"
            ],
            "Logs, Powers & Roots"                => [
                "cbrt", "exp", "exp10", "exp2", "expm1", "exponent", "hypot", "isqrt",
                "ldexp", "log", "log10", "log1p", "log2", "powermod", "nextpow", "prevpow",
                "sqrt"
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
                "hastypemaxˣ", "ifelse", "isa", "isapprox", "isbits", "isequal", "iseven",
                "isfinite", "isgreaterˣ", "isinf", "isinteger", "isless", "ismutable",
                "isnan", "isodd", "isone", "ispow2", "isreal", "isunordered", "iszero",
            ],
            "Type-Conversion"                     => [
                "big", "cconvertˣ", "collect", "complex", "convert", "float", "oftype",
                "promote", "signed", "string", "unsafe_convertˣ", "unsigned", "widen"
            ],
            "Others"                              => [
                "bitreverse", "bitrotate", "bitstring", "bswap", "count_ones",
                "count_zeros", "digits", "display", "dump", "identity", "leading_ones",
                "leading_zeros", "maxintfloat", "ndigits", "ndigits0zˣ", "one", "oneunit",
                "print", "println", "printstyled", "redisplay", "repr", "show", "sizeof",
                "splitprecˣ", "summary", "summarysizeˣ", "trailing_ones", "trailing_zeros",
                "typeassert", "typeof", "typemax", "typemin", "zero"
            ]
        ]
    ]
    types = [
        "Types" => [
            "BigInt", "Bool", "Cint", "Cintmax_t", "Clong", "Clonglong", "Cmode_tˣ",
            "Cptrdiff_t", "Cshort", "Csize_t", "Cssize_t", "Cuint", "Cuintmax_t", "Culong",
            "Culonglong", "Cushort", "DataType", "Enum", "Int", "Int128", "Int16", "Int32",
            "Int64", "Int8", "Integer", "Number", "Pair", "Real", "Ref", "RoundingMode",
            "Signed", "UInt", "UInt128", "UInt16", "UInt32", "UInt64", "UInt8", "UUIDˣ",
            "Unsigned", "VIntˣ"
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "%", "&", "'", "*", "+", "-", "/", "//", "<", "<<", "<=",
            "==", "=>", ">", ">=", ">>", ">>>", "^", "~", "÷", "∈", "∉", "∋", "∌", "√",
            "∛", "∩", "∪", "≈", "≉", "≠", "≡", "≢", "≤", "≥", "⊆", "⊇", "⊈", "⊉", "⊊", "⊋",
            "⊻", "⊼", "⊽", "==="
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Printf.@printf", "Printf.@sprintf", "Printf.Formatˣ", "Printf.Pointerˣ",
            "Printf.PositionCounterˣ", "Printf.Specˣ", "Printf.formatˣ", "Printf.tofloatˣ",
            "Unicode.isassignedˣ", "Unicode.julia_chartransformˣ", "Statistics.clampcorˣ",
            "Statistics.middle"
        ]
    ]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end