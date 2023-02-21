# REPLference
`REPLference.jl` is a package that provides a solution for two problems. First, it provides
materials for beginners to learn basic programming in Julia within the Julia REPL. Second,
it tries to solve the "dot.syntax" problem that new users face in accessing methods in
Julia. In Julia, `A.x` means call the property `x` that is bundled with `A`, not the method
`x` that is bundled with `A`. This can be challenging for new users as they might not know
what method to call on an object, which leads to reinventing the wheel. Julia provides
functions like `methodswith`, `methods`, `which`, etc., to solve this challenge; but the
methods they return are not exhaustive. This package provides two functions, `man` and
`fun`, to help users learn and access methods more efficiently.

### Installation
Install with:

```
julia> ] # enters the pkg mode
pkg> add REPLference
```

If you like `REPLference`, you can ensure that every Julia session uses it by adding the
following to your `~/.julia/config/startup.jl` file:

```
# In your ~/.julia/config/startup.jl file
@eval using REPLference
```

### `man`
If you know exactly what you want to learn in Julia, simply pass it as a `Symbol` to man by
appending a colon (`:`) after the name of the object:

```
julia> man(:irrationals)
  IRRATIONAL NUMBERS
  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

  What Are Irrational Numbers
  =============================

  In mathematics, irrational numbers are all the real numbers that are not

  ...

  julia> typeof(-negsqrt2)
  Float64
```

If you are unsure about an object or don't know what to do with it, you can use `man` to
learn more about it.

```
julia> man(ℯ)
  IRRATIONAL NUMBERS
  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

  What Are Irrational Numbers
  =============================

  In mathematics, irrational numbers are all the real numbers that are not

  ...

  julia> typeof(-negsqrt2)
  Float64
```

### `fun`
The same applies to `fun`. If you know exactly what you want, then append a colon (`:`) to
it and pass it to fun. Otherwise, just pass the object in question.

```
julia> fun(:irrationals)
Macros
≡≡≡≡≡≡≡≡
@evalpoly    @fastmath    @isdefined    @show

General Functions
≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
TwicePrecision    nameof      summarysize    typeassert       zero

....

Trigonometric & Hyperbolic Operations
acos     acsc     asin     cos      cotd       rad2deg    sind        tan
acosd    acscd    asind    cosc     coth       sec        sincos      tand
acosh    acsch    asinh    cosd     csc        secd       sincosd     tanh
acot     asec     atan     cosh     cscd       sech       sincospi
acotd    asecd    atand    cospi    csch       sin        sinh
acoth    asech    atanh    cot      deg2rad    sinc       sinpis

julia> fun(ℯ)
Macros
≡≡≡≡≡≡≡≡
@evalpoly    @fastmath    @isdefined    @show

General Functions
≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
TwicePrecision    nameof      summarysize    typeassert       zero

....

Trigonometric & Hyperbolic Operations
acos     acsc     asin     cos      cotd       rad2deg    sind        tan
acosd    acscd    asind    cosc     coth       sec        sincos      tand
acosh    acsch    asinh    cosd     csc        secd       sincosd     tanh
acot     asec     atan     cosh     cscd       sech       sincospi
acotd    asecd    atand    cospi    csch       sin        sinh
acoth    asech    atanh    cot      deg2rad    sinc       sinpis
```

## Citing
If you use this for your work, please cite us.

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).