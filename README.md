<table>
    <!-- Info -->
    <tr>
        <td>Repo Info</td>
        <td>
            <a href="https://github.com/udohjeremiah/REPLference.jl/blob/master/LICENSE.md"><img src="https://img.shields.io/badge/License-MIT-blue"/></a>
            <a href="https://github.com/udohjeremiah/REPLference.jl/blob/master/CITATION.bib"><img src="https://img.shields.io/badge/Citation-Cite%20this%20repository-blue"/></a>
            <a href="https://img.shields.io/badge/Development%3F-Active-success"><img src="https://img.shields.io/badge/Development%3F-Active-success"/></a>
            <a href="https://img.shields.io/badge/Maintained%3F-Yes-success" style="pointer-events: none;"><img src="https://img.shields.io/badge/Maintained%3F-Yes-success"/></a>
        </td>
    </tr>
    <!-- Stats -->
    <tr>
        <td>Repo Stats</td>
        <td>
            <a href="https://img.shields.io/github/repo-size/udohjeremiah/REPLference.jl"><img src="https://img.shields.io/github/repo-size/udohjeremiah/REPLference.jl"/></a>
            <a href="https://github.com/udohjeremiah/REPLference.jl/actions/workflows/CI.yml"><img src="https://github.com/udohjeremiah/REPLference.jl/actions/workflows/CI.yml/badge.svg?branch=master"/></a>
            <a href="https://codecov.io/gh/udohjeremiah/REPLference.jl/branch/master"><img src="https://codecov.io/gh/udohjeremiah/REPLference.jl/branch/master/graph/badge.svg"/></a>
        </td>
    </tr>
    <!-- Contributions -->
    <tr>
        <td>Contributing</td>
        <td>
            <a href="https://github.com/udohjeremiah/Continuous-Release-Workflow"><img src="https://img.shields.io/badge/Git%20Workflow-Continuous--Release-F05032?logo=git&logoColor=red"/></a>
            <a href="https://github.com/SciML/ColPrac"><img src="https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet"/></a>
            <a href="https://github.com/invenia/BlueStyle"><img src="https://img.shields.io/badge/Code%20Style-blue-4495d1.svg"/></a>
            <a href="https://github.com/udohjeremiah/REPLference.jl/blob/master/TODO.md"><img src="https://img.shields.io/badge/Tasks-TODO.md-E44332?logo=todoist&logoColor=white"/></a>
        </td>
    </tr>
</table>

# REPLference.jl

`REPLference.jl` is a package that addresses two challenges:

First, it provides materials for beginners to learn basic programming in Julia within
Julia's versatile REPL. Instead of searching online or asking basic Julia questions
elsewhere, beginners can use the rich-feature REPL to learn.

Second, it aims to solve the problem of accessing methods in Julia using the "dot" syntax,
which can be frustrating for new users. In many [OOP languages](https://en.wikipedia.org/wiki/Object-oriented_programming),
users can easily see and learn new methods to call on an object by using the "dot" syntax in
their editor, as shown in this example below:

![Python example](https://github.com/udohjeremiah/REPLference.jl/blob/master/assets/python_example.png)

However, in Julia, this isn't possible because `a.x` refers to the property `x` bundled with
`a`, not the method `x` bundled with `a` (methods are not bundled with objects in Julia). So
when users type `a.<tab>` in the REPL, it will return the properties defined in `a`, as
shown in this example below:

![Julia example](https://github.com/udohjeremiah/REPLference.jl/blob/master/assets/julia_example.png)

This limitation often leads to "reinventing the wheel" for those who can write the methods
they're looking for and a "break in workflow" for those who cannot, as they have to go
online to ask, "Is there a method X to do Y?" There is an
[ongoing discussion in Julia's discourse forum about this](https://discourse.julialang.org/t/allowing-the-object-method-args-syntax-as-an-alias-for-method-object-args/62051).

> NOTE: Julia provides functions like `methods`, `methodswith`, and `which` to help users
with this challenge, but new users may still struggle because these functions don't return
an exhaustive list of methods.

Finally, for convenience, this package uses [AbstractTrees.jl](https://github.com/JuliaCollections/AbstractTrees.jl)
as a dependency to print the sub- and super-types of a type in a tree-like format.

## Installing
To install and use, follow these steps:

```julia
julia> ] # enters the package mode
pkg> add REPLference

julia> using REPLference
```

If you enjoy using `REPLference.jl`, you can ensure that the package is automatically loaded
in every Julia session without having to explicitly call `using REPLference` each time in
the REPL. To do this, simply add the following line to your `~/.julia/config/startup.jl`
file (if the file does not exist, create it):

```julia
@eval using REPLference
```

## Usage
This package provides three functions, and their usage is explained below.

> NOTE: The examples below will be truncated to keep this README file concise.

### `man`
You can think of `man` as a function that returns the manual for a topic or object in Julia.

To see the manual for an object, pass the object to `man`:

```julia
julia> a = 'J'
'J': ASCII/Unicode U+004A (category Lu: Letter, uppercase)

julia> man(a)
  CHARACTERS
  ≡≡≡≡≡≡≡≡≡≡≡≡

  When we refer to "characters" in computer programming, we are not necessarily limiting our view
  to the characters that most English speakers are familiar with. Some examples of these familiar
  characters include letters like A, B, C, etc., numbers 1, 2, 3, etc., and common punctuation
  ⋮

  julia> isvalid('\UD7FF')
  true
  
  julia> '\UD7FF'
  '\ud7ff': Unicode U+D7FF (category Cn: Other, not assigned)
```

If you're interested in seeing the manual for a topic, simply pass the topic as a
`Symbol`, e.g., `man(:characters)`. If an invalid topic is entered, nothing is printed to
the screen.

### `fun`
You can think of `fun` as a function that returns the names related to a topic or that can
be called on a Julia object.

To see the names that can be called on an object, pass the object to `fun`:

```julia
julia> fun(a)
Macros
≡≡≡≡≡≡≡≡
@assert    @doc    @show    @showtime

Methods
≡≡≡≡≡≡≡≡≡
⋮
AbstractChar    Cchar    Char    Cuchar    Cwchar_t    DataType    Ref    Pair

Operators
≡≡≡≡≡≡≡≡≡≡≡
!     !==    +    <     ==    >     ^    ∉    ∌    ∪    ≡    ≤    ⊆    ⊈    ⊊    ===
!=    *      -    <=    =>    >=    ∈    ∋    ∩    ≠    ≢    ≥    ⊇    ⊉    ⊋ 
```

You can pass a keyword argument named `extmod::Bool` to the function. The default value for
`extmod` is `false`. If `extmod` is `true`, `fun` prints methods that can be called on the
object, as well as methods from modules in the standard library that can be loaded with
`using` or `import`:

```julia
julia> fun(a, extmod=true)
Macros
≡≡≡≡≡≡≡≡
@assert    @doc    @show    @showtime

Methods
≡≡≡≡≡≡≡≡≡
⋮

Stdlib
≡≡≡≡≡≡≡≡
Printf.@printf     Printf.Pointerˣ            Printf.formatˣ
Printf.@sprintf    Printf.PositionCounterˣ    Unicode.isassignedˣ
Printf.Formatˣ     Printf.Specˣ               Unicode.julia_chartransformˣ
```

If you're interested in seeing the functions for a topic, simply pass the topic as a
`Symbol`, e.g., `fun(:characters)`. If an invalid topic is entered, nothing is printed to
the screen.

Names suffixed with `ˣ` are unexported. In cases where they are not qualified with a module,
they need to be qualified with either `Base`, `Core`, or `InteractiveUtils` for the name to
be available.

### `subtree`
This function prints the subtypes of an object `T` in a tree format. `T` must be a `Type`;
otherwise, an error is thrown.

```julia
julia> subtree(Integer)
Integer
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
