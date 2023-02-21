@doc raw"""
# FLOATING-POINTS
Floating-point values are a fundamental component of arithmetic and computation. Built-in
representations of these values are referred to as numeric primitives, while representations
of floating-point numbers as immediate values in code are known as numeric literals. For
example, `1.0` is a floating-point literal and its binary in-memory representation as an
object is a numeric primitive.

## Type Hierarchy Tree
!!! note
    The tree below is only for the `AbstractFloat` type, and is not the complete type
    hierarchy tree of `Number`.

```julia
Any
└─ Number
   └─ Real
      └─ AbstractFloat
         ├─ BigFloat
         ├─ Float16
         ├─ Float32
         └─ Float64
```

| Type       | Precision | Number of bits |
|:----------:|:---------:|:--------------:|
| `Float16`  | half      |     16         |
|            |           |                |
| `Float32`  | single    |     32         |
|            |           |                |
| `Float64`  | double    |     64         |
|            |           |                |
| `BigFloat` | Arbitrary |    Arbitrary   |

To get the lowest and highest value representable by a given floating-point type, use
`typemin` and `typemax`.

To get the smallest positive normal number and largest finite number representable in a
given floating-point type, use `floatmin` and `floatmax`.

To get the largest consecutive integer-valued floating-point number that is exactly
representable in a given floating-point type, use `maxintfloat`.

# Numeric Literals
Literal floating-point numbers are represented in standard formats, using E-notation if
necessary, such as `.5`, `4.`, `4.59`, `6.022e23`, and `6.7E-3`.

Underscores, `_`, can be used as digit seperators when necessary, for example, `0.000_005`,
`1_234_567e-5`. Hexadecimal floating-point literals are also valid, but only as `Float64`
values. The base-2 exponent is preceded by `p` e.g. `0x1p0` which means `1.0 * 2^0`, `0x3p2`
which means `3.0 * 2^2`, `0x4p-1` which means `4 * 2^-1`, and `0x.4p-1` which means
`4/16 * 2^-1`.

Literal `Float32` values can be entered by replacing `e` with `f`
(capital letter `F` is not allowed) e.g. `.5f0`, `4.f-0`, `4.59f-4`, `6.022f23`.

# Special Floating-Point Values
There are three specified standard floating-point values that do not correspond to any point
on the real number line:

| Float16  | Float32  | Float64 | Name              | Description             |
|:--------:|:--------:|:-------:|:-----------------:|:------------------------| 
| `Inf16`  | `Inf32`  | `Inf`   | Positive infinity | A value greater than    |
|          |          |         |                   | all finite floating     |
|          |          |         |                   | point.                  |
|          |          |         |                   |                         |
| `-Inf16` | `-Inf32` | `-Inf`  | Negative infinity | A value less than all   |
|          |          |         |                   | finite floating-point.  |
|          |          |         |                   |                         |
| `NaN16`  | `NaN32`  | `NaN`   | Not a number      | A value not `==` to any |
|          |          |         |                   | floating-point value    |
|          |          |         |                   | (including itself).     |

According to the [IEEE 754-2008 standard](https://en.wikipedia.org/wiki/IEEE_754-2008),
these floating-point values are the results of certain arithmetic operations:

| Arithmetic Operation | Result |
|:--------------------:|:------:|
| `-5/0`               | `-Inf` |
|                      |        |
| `0/0`                | `NaN`  |
|                      |        |
| `1/0`                | `Inf`  |
|                      |        |
| `0 + Inf`            | `Inf`  |
|                      |        |
| `0 - Inf`            | `-Inf` |
|                      |        |
| `0 * Inf`            | `NaN`  |
|                      |        |
| `0 / Inf`            | `0.0`  |
|                      |        |
| `1 + Inf`            | `Inf`  |
|                      |        |
| `1 - Inf`            | `-Inf` |
|                      |        |
| `1 * Inf`            | `Inf`  |
|                      |        |
| `1 / Inf`            | `0.0`  |
|                      |        |
| `Inf / 0`            | `Inf`  |
|                      |        |
| `Inf / 1`            | `Inf`  |
|                      |        |
| `Inf + Inf`          | `Inf`  |
|                      |        |
| `Inf - Inf`          | `NaN`  |
|                      |        |
| `Inf * Inf`          | `Inf`  |
|                      |        |
| `Inf / Inf`          | `NaN`  |

Any arithmetic operation, such as `+`, `-`, `*` or `\`, with `NaN` will result in `NaN`.

# Arbitrary Precision Arithmetic
To allow computations with arbitrary-precision floating-point numbers, Julia wraps the GNU
MPFR Library. The `BigFloat` type is available in Julia for arbitrary precision
floating-point numbers. Use `BigFloat` or `big` to construct this type from primitive
numerical types. Use `@big_str` or `parse` to construct this type from strings.

Decimal literals are converted to `Float64` when parsed, so `BigFloat(x)` may not yield what
you expect; in such cases use `BigFloat("x")`, which is identical to `parse`.

Once created, `BigFloat` values participate in arithmetic with all other numeric types,
thanks to Julia's type promotion and conversion mechanism. Although `BigFloat` a subtype of
`AbstractFloat`, the `BigFloat` type is not an `isbitstype`.

# Floating-Point Zero
Floating-point numbers have two zeros: positive zero (`0.0`) and negative zero (`-0.0`).
These zeros are equal to each other but have different binary representations. You can use
the `bitstring` function to see their literal bit representation.

# Floating-Point Comparison
Floating-point numbers are compared according to the IEEE 754-2008 standard. Finite numbers
are ordered in the usual manner. For example, the expressions `1.5 > 1.49` and `1.5 == 1.50`
both return `true`.

Positive zero is equal but not greater than negative zero, i.e., `0.0 == -0.0` returns
`true`. However, `0.0 === -0.0` returns `false` because `0.0 and -0.0` have different binary
representations.

`Inf` is equal to itself and greater than everything else, except for `NaN`, i.e.,
`Inf == Inf` returns `true`, but `Inf > NaN` and `Inf < NaN` both return `false`. `-Inf` is
equal to itself and less than everything else except for `NaN`. For example, `-Inf == -Inf`
returns `true`, but `-Inf > NaN` and `-Inf < NaN` both return `false`.

`NaN` is not equal to, less than, or greater than anything, including itself. i.e.,
`NaN != NaN` returns `true`, but `NaN > NaN` and `NaN < NaN` both return `false`. However,
`NaN === NaN` returns true.

To test for special values, you can use `isequal`, `isfinite`, `isinf`, and `isnan`
functions.

# Machine Epsilon
Most *real* numbers cannot be represented exactly as floating-point numbers. For many
purposes, it is important to know the distance between two adjacent representable floating
point numbers, which is often referred to as *machine epsilon*.

Julia provides `eps` for this, which gives the distance between `1.0` and the next larger
representable floating-point value. These values are `2.0^-23` and `2.0^-52` as `Float32`
and Float64` values, respectively.

The `eps` function can also take a floating-point value as an argument and gives the
absolute difference between that value and the next representable floating-point value. By
definition, `eps(1.0)` is the same as `eps(Float64)` since `1.0` is a 64-bit floating-point
value.

Julia also provides the `nextfloat` and `prevfloat` functions, which return the next largest
or smallest representable floating-point number to the argument respectively.

Every adjacent representable floating-point numbers also has adjacent binary integer
representations. You can use `bitstring(prevfloat(x)`, `bitstring(x)`,
`bitstring(nextfloat(x))` to see this.

# Rounding & Rounding Mode
If a number doesn't have an exact floating-point representation, it must be rounded to an
appropriate representable value. However, the manner in which this rounding is done can be
changed if required, according to the rounding modes presented in the IEEE 754-2008
standard. `Base.Rounding` is the module containing the rounding modes and other `round`
related  operations in Julia.

`round` is the function used to perform the rounding operations, alongside with the rounding
modes provided.  `RoundingMode` is the type used for controlling the rouding mode of
floating-point operations (via the `rounding` or `setrouding` functions) or as an optional
argument for rounding to the nearest integer (via the `round` function). The default
rounding mode used is always `RoundNearest` which rounds to the nearest integer
representable value, with ties rounded towards the nearest value with an even least
significant bit.

`rounding` gets the current floating-point rounding mode for a given type of floating-point,
controlling the rounding type of basic arithmetic functions (`+`, `-`, `*`, `/` and `sqrt`)
and type conversion. `precision` gets the precision of a floating-point number or type. The
default `precision` (in the number of bits of the significand) and `rounding` mode of
`BigFloat` operations can be changed globally by calling `setprecision` and `setrounding`,
and all further calculations will take these changes in account.

Alternatively, the `precision` or the `rounding` can be changed only within the execution of
a particular block of code by using the functions stated above with a `do` block:

```julia
setprecision(precision) do
    # do what you want here
end

setrounding(T, mode) do
    # do what you want here
end
```
"""
function floats()
    header1 = "Union Types"
    printstyled(header1, '\n', '≡'^(length(header1) + 2), '\n'; bold=true);
    println("""
    F_or_FF    HWNumber    HWReal    IEEEFloat\n""")

    header2 = "Macros"
    printstyled(header2, '\n', '≡'^(length(header2) + 2), '\n'; bold=true);
    println("""
    @big_str     @evalpoly    @fastmath      @isdefined    @show\n""")

    header3 = "General Functions"
    printstyled(header3, '\n', '≡'^(length(header3) + 2), '\n'; bold=true)
    println("""
    TwicePrecision    methodswith            setprecision      typeassert
    bitsunionsize     nameof                 sizeof            typeintersect
    bitstring         nextfloat              splitprec         typejoin
    bswap             one                    summary           typemax
    canonicalize2     oneunit                summarysize       typemin
    eps               precision              subtypes          typeof
    floatmax          prevfloat              supertype         zero
    floatmin          randn                  supertypes
    maxintfloat       set_zero_subnormals    twiceprecision\n""")

    header4 = "True/False Functions"
    printstyled(header4, '\n', '≡'^(length(header4) + 2), '\n'; bold=true)
    println("""
    get_zero_subnormals    isconcretetype    isinf            isone
    hastypemax             isconst           isinteger        isprimitivetype
    isa                    isdefined         isless           isreal
    isabstracttype         isequal           ismutable        isstructtype
    isbits                 iseven            ismutabletype    issubnormal
    isbitstype             isfinite          isnan            isunordered
    isbitsunion            isgreater         isodd            iszero\n""")
  
    header5 = "Type-Conversion Functions"
    printstyled(header5, '\n', '≡'^(length(header5) + 2), '\n'; bold=true)
    println("""
    Char        big        complex    oftype    promote        string      widen
    Rational    convert    float      parse     rationalize    tryparse\n""")

    header6 = "Mathematical Functions"
    printstyled(header6, '\n', '≡'^(length(header6) + 2), '\n'; bold=true)
    printstyled("Absolute Value, Min/Max & Sign", '\n'; bold=true)
    println("""
    abs     cmp         flipsign    min       sign       signequal   
    abs2    copysign    max         minmax    signbit    signless\n""")

    printstyled("Addition, Division & Multiplication", '\n'; bold=true)
    println("""
    add12    div12    fldmod     inv     mod2pi    muladd      rem2pi
    cld      fld      fldmod1    mod     modf      nextprod    widemul
    div      fld1     fma        mod1    mul12     rem\n""")

    printstyled("Logs, Powers & Roots", '\n'; bold=true)
    println("""
    cbrt     exp      expm1       frexp     ldexp    log1p      prevpow
    cis      exp2     exponent    hypot     log      log2       significand
    cispi    exp10    evalpoly    ispow2    log10    nextpow    sqrt\n""")

    printstyled("Rounding", '\n'; bold=true)
    println("""
    ceil    clamp    floor    round    trunc\n""")

    printstyled("Trigonometric & Hyperbolic", '\n'; bold=true)
    println("""
    acos     acscd    asind    cosc     coth       sec       sincosd     tand
    acosd    acsch    asinh    cosd     csc        secd      sincospi    tanh
    acosh    asec     atan     cosh     cscd       sech      sind
    acot     asecd    atand    cospi    csch       sin       sinh
    acoth    asech    atanh    cot      deg2rad    sinc      sinpi
    acsc     asin     cos      cotd     rad2deg    sincos    tan\n""") 
end