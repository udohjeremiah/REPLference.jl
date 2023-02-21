"""
# KEYWORDS
In programming, a *keyword* is a reserved word that is used by a program to perform a
specific function or has a special meaning. Keywords can be commands or parameters, and they
are sometimes referred to as "reserved names".

# Reserved Keywords
| Keyword                         | Allowed to be used as a variable name?            |
|--------------------------------:|--------------------------------------------------:|
| `baremodule`                    |                                                   |
| `begin`                         |                                                   |
| `break`                         |                                                   |
| `catch`                         |                                                   |
| `const`                         |                                                   |
| `continue`                      |                                                   |
| `do`                            |                                                   |
| `else`                          |                                                   |
| `elseif`                        |                                                   |
| `end`                           |                                                   |
| `export`                        |                                                   |
| `false`                         |                                                   |
| `finally`                       |                                                   |
| `for`                           | All keywords in this category are not             |
| `function`                      | allowed to be used as variable names              |
| `global`                        |                                                   |
| `if`                            |                                                   |
| `import`                        |                                                   |
| `let`                           |                                                   |
| `local`                         |                                                   |
| `macro`                         |                                                   |
| `module`                        |                                                   |
| `quote`                         |                                                   |
| `return`                        |                                                   |
| `struct`                        |                                                   |
| `true`                          |                                                   |
| `try`                           |                                                   |
| `using`                         |                                                   |
| `while`                         |                                                   |

# Conjugated Keywords
| Keyword                         | Allowed to be used as a variable name?            |
|:--------------------------------|--------------------------------------------------:|
| `abstract type`                 | variables with names such as                      |
|                                 | `abstract` or `type` are allowed.                 |
|                                 |                                                   |
| `mutable struct`                | variables with names such as                      |
|                                 | `mutable` or `type` are allowed.                  |
|                                 |                                                   |
| `primitive type`                | variables with names such as                      |
|                                 | `primitive` or `type` are allowed.                |

# Infix Operators / Iteration Keywords
You can create variables with names that are the same as these operators, but they become
keywords and operators when used in special operations.

| Operator                        | Special Operation                                 |
|:--------------------------------|:--------------------------------------------------|
| `as`                            | infix operator between a package being loaded     |
|                                 | and an idenitifer name.                           |
|                                 |                                                   |
| `in`                            | infix operator between an item and a collection.  |
|                                 |                                                   |
| `isa`                           | infix operator between an object and a type.      |
|                                 |                                                   |
| `outer`                         | infix operator between a `for` loop and a         |
|                                 | variable being scoped.                            |
|                                 |                                                   |
| `where`                         | infix operator between a parametric method        |
|                                 | and a type definition.                            |

In a situation where `as`, `in`, `isa`, `outer` or `where` is used as a variable name:

- `in` and `isa` will throw an error when used as operators or functions in that same
  namespace where they've been used as variable names:

```julia
julia> in = 5;

julia> 2 in [2, 3, 5]
ERROR: MethodError: objects of type Int64 are not callable

julia> in(2, [2, 3, 5])
ERROR: MethodError: objects of type Int64 are not callable

julia> isa = "Logan";

julia> Int64 isa Integer
ERROR: MethodError: objects of type String are not callable

julia> isa(Int64, Integer)
ERROR: MethodError: objects of type String are not callable
```

- `as`, `outer` and `where` would always work as keywords and operators in their special
  operations, regardless of the fact that they may have been used as names of variables in
  that same namespace:

```julia
julia> as = 10
10

julia> import Test as T

julia> where = "JuliaLang";

julia> function add(x::T, y::T) where T <: Integer
            x + y
        end
add (generic function with 1 method)

julia> add(10, 12)
22

julia> function xs()
            outer = 10; x = 24
            for outer x in 2:3
                x == 3 ? println("Yes") : println("No")
            end
            x
        end
xs (generic function with 1 method)

julia> xs()
No
Yes
3
```
"""
function keywords end