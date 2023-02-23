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

### Installing
To install and use, follow these steps:

```
julia> ] # enters the package mode
pkg> add REPLference

julia> using REPLference
```

If you enjoy using `REPLference.jl`, you can ensure that every Julia session automatically
loads the package without having to explicitly call `using REPLference` each time in the
REPL. To do this, simply add the following line to your `~/.julia/config/startup.jl` file:

```
# In your ~/.julia/config/startup.jl file
@eval using REPLference
```

### `man` (short for the word "manual")
To learn about a specific topic in Julia, you can pass a `Symbol` to the `man` function by
appending a colon (`:`) before the name of the topic. If the entered `Symbol` is valid or
closely matches any of the valid `Symbol`s, `man` will return a docstring explaining the
topic you searched for. Here is an example:

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

If you have an object but don't know "what" it is in Computer Science in general or "how" to
use it in Julia, you can simply pass it as an argument to `man` to learn more about it. Here
is an example:

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

### `fun` (short for the word "function")
As explained previously for `man`, the same applies to `fun`, except that it doesn't print a
docstring. Instead, it displays the available methods that can be called on the object or
objects falling under the specified topic (if a `Symbol` was passed as the argument). Here
are a few examples:

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

## Contributing
Some files in the `src/` folder, which contain the source code for `REPLference.jl`, have a
comment section marked as:

```
#=
TO DO
⋮
=#
```

If you are very proficient in the relevant topic(s), please create a new file for a new
topic or continue from where it was stopped for an existing topic and create a `man`ual. The
general format for a manual should be as follows:

- Explain the topic generally as it is used in computer science.
- Show how it is used or applied in the [Julia programming language](http://julialang.org).

If you come across a new function (or an old one that has not been added yet) that can be
applied to an object but is not printed by `fun` for that object, please open a pull request
(PR) for it.

Also, if you have a new topic entirely that is not in the comment section marked as
`# = TODO ... = #`, but you would like to add it, please create a new file for it and follow
the format used in the package: `man` should return the docstring of `fun` (which is the
text you will be creating as a manual for the object), and `fun` will print the methods that
can be called on the object if any exist.

## Citing
If you use this for your work, please cite us.

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).