@doc raw"""
# OPERATORS
Julia provides a myriad of operators for mathematical and non-mathematical operations alike
when compared to other programming languages. This is because it accepts all unicode math
symbols as valid mathematical operators (but only provides definitions for selected few),
which is a good thing for the scientific community, as it helps write more scientific code.
For example, `≤`, `≠`, and `√` are all valid operators in Julia.

# Operator Notation
All Julia operators support the prefix (the function application form) and/or infix notation
of operators; postfix notation is not allowed (except for select few like "`'`"):

```julia
julia> +(2, 3)      # prefix notation
5

julia> 2 + 3        # infix notation
5

julia> [3, 4im]'    # postfix notation
1×2 adjoint(::Vector{Complex{Int64}}) with eltype Complex{Int64}:
 3+0im  0-4im

julia> (2, 3)+
ERROR: syntax: incomplete: premature end of input
```

The exceptions, i.e. operators with no support for prefix (function application form)
notation, are updating operators (e.g. `+=`, `<<=`, etc.) and operators with special
evaluation semantics (e.g. `&&`, `||`, `&`). These operators cannot be functions since
short-circuit evaluation requires that their operands are not evaluated before evaluation
of the operator.

Short-circuit evaluation operators, `&&` and `||`, don't necessarily evaluate their second
argument under the circumstances described below:

- In the expression `a && b`, the subexpression `b` is only evaluated if `a` evaluates to
  `true`.

- In the expression `a || b`, the subexpression `b` is only evaluated if `a` evaluates to
  `false`.

Use `&` and `|` for boolean operations without short-circuit evaluation, i.e. they always
evaluate their arguments:

```julia
julia> t(x) = (println(x); true)
t (generic function with 1 method)

julia> f(x) = (println(x); false)
f (generic function with 1 method)

julia> f(1) && t(2)
1
false

julia> t(1) || t(2)
1
true

julia> f(1) & t(2)
1
2
false

julia> t(1) | t(2)
1
2
true
```

# Operators Are Functions
In Julia, most operators (with the exceptions of operators with special evaluation semantics
like `&&` and `||`) are just functions with support for special syntax. This is why they can
be used in prefix notation (i.e. function application form):

```julia
julia> 1 + 2 + 3
6

julia> +(1, 2, 3)
6

julia> (+)(1, 2, 3)
6
```

The infix form, `1 + 2`, is exactly equivalent to the function application form, `+(1, 2)`.
In fact, `1 + 2` is parsed to produce `+(1, 2)` internally.

This also means you can assign and pass around operators such as `+` and `*` just like you
would with other function values:

```julia
julia> raise_to_power = ^;

julia> raise_to_power(2, 4)
16
```

However, when operators are assigned, like `raise_to_power` in the above code block, the
name bound to the operator cannot be used as an infix operator:

```julia
julia> 2 raise_to_power 4
ERROR: syntax: extra token "raise_to_power" after end of expression
```

# Updating Operators
An updating operator rebinds (or "reassigns") the variable on the left-hand side. As a
result, the type of the variable may change after the operation on the right-hand side is
done. Julia's elegant conversion and promotion system takes care of this:

```julia
julia> x = 0x1; typeof(x)
UInt8

julia> x += 20; typeof(x)
Int64
```

Updating operators can be used with collections as well, provided the operation on the
right-hand side is defined or supported:

```julia
julia> a = [2, 3]
2-element Vector{Int64}:
 2
 3

julia> a += [10, 20]; a
2-element Vector{Int64}:
 12
 23

julia> a *= [10, 20]; a
ERROR: MethodError: no method matching *(::Vector{Int64}, ::Vector{Int64})
```

# Dot Operation
In Julia, for every binary operation, there is a corresponding "dot" operation. For example,
the exponential operator `^` has a vectorized dot exponential operation `.^`, which is
automatically defined to perform `^` element-by-element on arrays.

So, `[1,2,3] ^ 3` is not defined, since there is no standard mathematical meaning to
"cubing" a (non-square) array, but `[1,2,3] .^ 3` is defined as computing the elementwise
(or "vectorized") result `[1^3, 2^3, 3^3]`.

More specifically, `a .^ b` is parsed as the "dot" call `(^).(a,b)`, which performs a
broadcast operation. It can combine arrays and scalars, arrays of the same size (performing
the operation elementwise), and even arrays of different shapes (e.g., combining row and
column vectors to produce a matrix):

```julia
julia> [1, 2, 3] ^ 3
ERROR: MethodError: no method matching ^(::Vector{Int64}, ::Int64)

julia> [1, 2, 3] .^ 3              # arrays and scalars
3-element Vector{Int64}:
  1
  8
 27

julia> .^([1, 2, 3], [4, 5, 6])    # arrays of the same size
3-element Vector{Int64}:
   1
  32
 729

julia> (^).([1, 2], [3 4])        # arrays of different shapes
2×2 Matrix{Int64}:
 1   1
 8  16
```

Similarly for unary operators like `!` or `√`, there is a corresponding `.!` or `.√` that
applies the operator elementwise:

```julia
julia> .√[4 9 16; 25 49 64; 81 100 121] 
3×3 Matrix{Float64}:
 2.0   3.0   4.0
 5.0   7.0   8.0
 9.0  10.0  11.0
```

Furthermore, "dotted" updating operators like `a .+= b` (or `@. a += b`) are parsed as
`a .= a .+ b`, where `.=` is a fused in-place assignment operation (see the
[dot syntax documentation](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized)).

```julia
julia> A = zeros(4, 4); B = [1, 2, 3, 4];

julia> A .= B;

julia> A
4×4 Matrix{Float64}:
 1.0  1.0  1.0  1.0
 2.0  2.0  2.0  2.0
 3.0  3.0  3.0  3.0
 4.0  4.0  4.0  4.0

julia> A = [10, 20, 30]; B = [2, 4, 6];

julia> A .*= B;

julia> A
3-element Vector{Int64}:
  20
  80
 180
```

# Non-Alphanumeric Operators
|  Precedence  | Operators                            | Associativity                |
|:----|:--------------------------------------------- |:-----------------------------|
| 17  | `.`                                           | left                         |
|     |                                               |                              |
| 16  | `::`                                          | left                         |
|     |                                               |                              |
| 15  | `^`                                           | right                        |
|     |                                               |                              |
| 14  | `<<` `>>` `>>>`                               | left                         |
|     |                                               |                              |
| 13  | `//`                                          | left                         |
|     |                                               |                              |
| 12  | `*` `/` `÷` `%` `&` `∘` `\` `∩` `⊼`           | left; `*` is none            |
|     |                                               |                              |
| 11  | `$` `+` `-` `\|` `∪` `⊻` `⊽`                  | left; `+` is none            |
|     |                                               |                              |
| 10  | `:`                                           | left                         |
|     |                                               |                              |
| 9   | `\|>`                                         | left                         |
|     |                                               |                              |
| 7   | `>` `<` `>=` `≥` `<=` `≤` `==` `===` `≡`      |                              |
|     | `!=` `≠` `!==` `≢` `∈` `∉` `∋` `∌` `⊆` `⊈`    | none; `<:` and `>:` are right|
|     | `⊊` `≈` `≉` `⊇` `⊉` `⊋` `<:` `>:`             |                              |
|     |                                               |                              |
| 6   | `&&`                                          | right                        |
|     |                                               |                              |
| 5   | `\|\|`                                        | right                        |
|     |                                               |                              |
| 3   | `?`                                           | left                         |
|     |                                               |                              |
| 2   | `=>`                                          | right                        |
|     |                                               |                              |
| 1   | `=` `+=` `-=` `*=` `/=` `//=` `\=` `^=` `÷=`  | right                        |
|     | `%=` `<<=` `>>=` `>>>=` `\|=` `&=` `⊻=` `~`   |                              |
|     |                                               |                              |
| 0   | `'` `...`                                     | none                         |

# Alphanumeric Operators
| Operator            | Equivalent To     |
|:--------------------|:-----------------:|
| `ComposedFunction`  | `∘`               |
|                     |                   |
| `Pair`              | `=>`              |
|                     |                   |
| `adjoint`           | `'`               |
|                     |                   |
| `div`               | `÷`               |
|                     |                   |
| `ifelse`            | `?`               |
|                     |                   |
| `in`                | `∈`               |
|                     |                   |
| `intersect`         | `∩`               |
|                     |                   |
| `isapprox`          | `≈`               |
|                     |                   |
| `issetequal`        | `a ⊆ b && b ⊆ a`  |
|                     |                   |
| `issubset`          | `⊆`               |
|                     |                   |
| `mod`               | `%`               |
|                     |                   |
| `nand`              | `⊼`               |
|                     |                   |                   
| `union`             | `∪`               |
|                     |                   |
| `xor`               | `⊻`               |
|                     |                   |
| `nor`               | `⊽`               |
|                     |                   |
| `rem`               | `%`               |

# Special Syntax Operators
| Syntax            | Calls          |
|:------------------|:---------------|
| `[A B C ...]`     | `hcat`         |
|                   |                |
| `[A; B; C; ...]`  | `vcat`         |
|                   |                |
| `[A B; C D; ...]` | `hvcat`        |
|                   |                |
| `A[i]`            | `getindex`     |
|                   |                |
| `A[i] = x`        | `setindex!`    |
|                   |                |
| `A.n`             | `getproperty`  |
|                   |                |
| `A.n = x`         | `setproperty!` |
|                   |                |
| `M.n`             | `getglobal`    |
|                   |                |
| `M.n = x`         | `setglobal!`   |

A complete list providing a detailed overview of every Julia operator and its precedence can
be seen at the top of this file:
[src/julia-parser.scm](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm).

Note that some of the operators listed there are not defined in the `Core` and `Base`
modules of Julia, but they may be given definitions by standard libraries, packages, or user
code.
"""
function operators(; extmod=false)
    methods = [
        "Methods" => [
            "True/False" => [
                "isbinaryoperatorˣ", "isidentifierˣ", "isoperatorˣ", "ispostfixoperatorˣ",
                "isunaryoperatorˣ"
            ],
            "Others"     => [
                "accumulate", "cmp", "foldl", "foldr", "identity", "mapfoldl", "mapfoldr",
                "mapreduce", "mapreduce_emptyˣ", "mapreduce_firstˣ", "mergewith",
                "operator_associativityˣ", "operator_precedenceˣ", "reduce",
                "reduce_emptyˣ", "reduce_firstˣ", "splat"
            ]
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "%", "&", "'", "*", "+", "-", "/", "//", ":", "<", "<:", "<<",
            "<=", "==", "=>", ">", ">:", ">=", ">>", ">>>", "\\", "^", "~", "÷", "∈", "∉",
            "∋", "∌", "∘", "√", "∛", "∩", "∪", "≈", "≉", "≠", "≡", "≢", "≤", "≥", "⊆", "⊇",
            "⊈", "⊉", "⊊", "⊋", "⊻", "⊼", "⊽", "<:", "==="
        ]
    ]
    _print_names(methods, operators)
end
