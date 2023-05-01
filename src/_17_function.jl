@doc raw"""
# FUNCTIONS
A function in computer programming is simply a block of organized, reusable code that is
used to perform a single, related action, which might return a value or not.

A typical function usually takes in data (called arguments), processes it
(called the function body), and then returns a result (called the returned value). During
the function definition, its arguments are called "formal parameters," while during the
function call, its arguments are called "actual parameters."

In different programming languages, a function may be called a routine, subprogram,
subroutine, method, or procedure. Technically, these terms all have different definitions,
and the nomenclature varies from language to language. The generic umbrella
term *callable unit* is sometimes used.

In Julia, the convention is that:

- a function is an object that maps a tuple of argument values to a return value.
- a method is a definition of one (i.e., specific) behavior for a function for certain
  combinations of argument types and counts.
**Thus, we can say "methods" are different versions of a "function"**.

Julia functions:

- are first-class objects i.e. they support all the operations generally available to other
  entities, such as:
  - can appear in an expression,
  - can be assigned to a variable,
  - can be used as an argument to a function,
  - can be returned by a function call.
- are generics; a generic function is a function defined for polymorphism i.e. their
  behaviour depends on the types of the arguments supplied to it.
- are dispatched on *argument types* and *argument counts*.
- are not pure mathematical functions, because they can alter and be affected by the global
  state of the program.

## Defining A Function
Functions in Julia are defined in two ways:

- using the `function` keyword:

```julia
julia> function add(a, b)
           return a + b
       end
add (generic function with 1 method)
```

- using the short form notation, which can be either a single or compound expression. A
  compund expression is constructed with a `begin` block or `;` operator enclosed in 
  brackets, `()`):

```julia
julia> add(a, b) = a + b
add (generic function with 1 method)
```

Note that functions with no arguments can be created and they are known as
*empty generic functions*:
```
julia> function f end
f (generic function with 0 methods)
```

This is useful because it introduces a generic function without yet adding methods, which
can then be used:

- To separate interface definitions from implementations.
- For the purpose of documentation or code readability.

## Calling A Function
A function is called using the traditional parenthesis syntax:

```julia
julia> f(x, y) = x + y
f (generic function with 1 method)

julia> f(2, 3)
5
```

Without parentheses, the expression `f` refers to the function object, and can be passed
around like any other value:

```julia
julia> g = f;

julia> g(2, 3)
5
```

## Argument Passing Behaviour
Julia function arguments are "passed-by-sharing", which means that values are not copied
when they are passed to functions; function arguments themselves act as new locations that
can refer to values, but the values they refer to are identical to the passed values:

```julia
julia> modify(x) = (x[3] = 30)
modify (generic function with 1 method)

julia> a = [10, 20, 20]; println(a)
[10, 20, 20]

julia> modify(a); println(a)
[10, 20, 30]
```

## Argument-Type declarations
You can declare the types of function arguments by appending `::TypeName` to the argument
name, as usual for type declarations in Julia, e.g., `f(x::Integer) = x + 1`, declares a
function `f` whose argument `x` must be a subtype of `Integer`.

Argument-type declarations normally have no impact on performance in Julia. The language
compiles a specialized version of a function based on the actual argument types passed by
the caller, regardless of the types appended to the arguments (if any). So, if `f(1)` is
called, Julia will compile a version of `f` optimized specifically for `Int` arguments,
which can then be re-used if `f(1)` or `f(21)` is called again.

However, there are rare exceptions when an argument-type declaration can trigger additional
compiler specializations. For more information, see:
https://docs.julialang.org/en/v1/manual/performance-tips/#Be-aware-of-when-Julia-avoids-specializing.

## The `return` Keyword
The value returned by a function is the value of the last expression evaluated, which, by
default, is the last expression in the body of the function definition:

```julia
julia> function f(x, y)
           x*y
           x+y
       end
f (generic function with 1 method)

julia> f(10, 20)    # last expression `x+y` is returned
30
```

As an alternative, as in many other languages, the `return` keyword causes a function to
return immediately, providing an expression whose value is returned:

```julia
julia> function f(x, y)
           return x*y
           x+y
       end
f (generic function with 1 method)

julia> f(10, 20)    # last expression `x+y` is never executed
200
```

To learn more about how the `return` keyword works, you can see its usage in `help?>` mode.

## How do I Return Nothing?
For functions that do not need to return a value (functions used only for some side
effects), the Julia convention is to return the value `nothing`. There are 3 ways to do
this, depending on programmer style:

- Explicitly return the value `nothing` i.e. `return nothing`.
- The `return` keyword implicitly returns `nothing`, so it can be used alone.
- Since functions implicitly return their last expression evaluated, `nothing` can be used
  alone when it's the last expression.

## The Return Type
A return type can be specified in the function declaration using the `::` operator. This
converts the return value to the specified type:

```julia
julia> g(x, y)::Int8 = x*y
g (generic function with 1 method)

julia> typeof(g(2, 4))
Int8
```

Return type declarations are **rarely used** in Julia: in general, you should instead focus
on writing **type-stable functions** in which Julia's compiler can automatically infer the
return type. For more information, see
https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-tips.

## Naming  A Function
- As with variables, Unicode can also be used for function names:

```julia
julia> ∑(x,y) = x+y
∑ (generic function with 1 method)

julia> ∑(2, 3)
5
```

- Julia recommends, as a style guide, appending `!` to function names that mutate their
  arguments:

```julia
julia> sqr_elem!(x) = (x .= x .^ 2)

julia> a = [1, 2, 3]; println(a)
[1, 2, 3]

julia> sqr_elem!(a); println(a)
[1, 4, 9]
```

## Anonymous Functions
In Julia, functions can also be created anonymously, without being given a name, using
either of these syntaxes:

```julia
julia> x -> x^2 + 2x - 1
#1 (generic function with 1 method)

julia> function (x)
           x^2 + 2x - 1
       end
#3 (generic function with 1 method)
```

This creates a function taking one argument `x` and returning the value of the polynomial
`x^2 + 2x - 1` at that value. Notice that the result is a generic function, but with a
compiler-generated name based on consecutive numbering.

And because they're first class objects, we can assign them to a variable and then call
them using the variable as a function:

```julia
julia> A = x -> x^2 + 2x - 1
#5 (generic function with 1 method)

julia> A(10)
119
```

However, the primary use for anonymous functions is passing them to functions which take
other functions as arguments, e.g:

```julia
julia> map(x -> x^2 + 2x - 1, [1, 3, -1])
3-element Vector{Int64}:
  2
 14
 -2
```

Note that:

- An anonymous function accepting multiple arguments should have its arguments wrapped in
  closed brackets, e.g., `(x, y, z) -> 2x+y-z`.
- An anonymous function accepting zero-argument is written like this `() -> ...`.
  The idea of a function with no arguments may seem strange, but is useful for "delaying" a
  computation (which might be called or not).

## Defining A Method
The choice of which method to execute when a function is applied is called *dispatch*. Julia
allows the dispatch process to choose which of a function's methods to call based on the
number of arguments given, and on the types of all of the function's arguments. Using all of
a function's arguments to choose which method should be invoked, rather than just the first,
is known as **multiple dispatch**.

To define a function with multiple methods, one simply defines the function multiple times
with different number and/or types of arguments as desired:

```julia
julia> f(x) = 1
f (generic function with 1 method)

julia> f(x, y) = 2
f (generic function with 2 methods)

julia> g(x) = 1
g (generic function with 1 method)

julia> g(x::Integer) = 1
g (generic function with 2 methods)
```

The first method definition for a function creates the function object, and subsequent
method definitions add new methods to the existing function object. The most specific method
definition matching the number and types of the arguments will be executed when the function
is applied.

## Iteration Destructuring
A comma-separated list of variables (optionally wrapped in parentheses) can appear on the
left side of an assignment: the value on the right side is destructured by iterating over
and assigning to each variable in turn. The value on the right can be any iterator and its
length should not be less than the number of variables on the left (any excess elements of
the iterator are ignored):

```julia
julia> (a, b, c) = 1:6    # same as: a, b, c = 1:6
1:3

julia> a
1

julia> b
2

julia> c
3
```

This can be used to return multiple values from functions by returning a tuple or other
iterable value:

```julia
julia> foo(a, b) = a+b, a*b
foo (generic function with 1 method)

julia> foo(2, 3)
(5, 6)
```

Destructuring assignment on multiple return values from a function, extracts each value into
a variable:

```julia
julia> x = zeros(2); println(x)
[0.0, 0.0]

julia> x[1], y = foo(2, 3);

julia> println(x)
[5.0, 0.0]

julia> println(y)
6
```

## Property Destructuring
Instead of destructuring based on iteration i.e., index position, the right side of
assignments can also be destructured using property names. This follows the syntax for
`NamedTuple`s, and works by assigning to each variable on the left a property of the right
side of the assignment with the same name using `getproperty`.

Just as iteration destructing works for any iterable object, property destructing also
works for any object that has fields:

```julia
julia> (; b, a) = (a=1, b=2, c=3)
(a = 1, b = 2, c = 3)

julia> a
1

julia> b
2

julia> (; num, den) = 1//2
1//2

julia> num
1

julia> den
2
```

Without the `;` in the left hand side, this would have been equivalent to destructuring
based on iteration i.e index position:

```julia
julia> (b, a) = (a=1, b=2, c=3);

julia> a
2

julia> b
1
```

## Argument Destructuring Using Iteration & Property Destructuring
The destructuring feature can also be used within a function argument.

- If a function argument name is written as a tuple (e.g. `f((x, y))`) instead of just a
  symbol (e.g. `f(x, y)`), then an assignment `(x, y) = argument` will be inserted for you
  i.e iteration destructuring. As an example:

```julia
julia> minmax(x, y) = y < x ? (y, x) : (x, y);

julia> gap((min, max)) = max - min;

julia> gap(minmax(10, 2))
8
```

- If a function argument name is written as a tuple with `;` inside (e.g. `f((; x, y))`)
  instead of just a tuple (e.g. `f((x, y))`), then an assignment `(; x, y) = argument` will
  be inserted for you i.e property destructuring. As an example:

```julia
julia> foo((; x, y)) = x + y;

julia> foo((y=1, x=2))
3

julia> struct A
           x
           y
       end

julia> foo(A(3, 4))
7
```

For anonymous functions, destructuring a single argument requires an extra comma:

```julia
julia> map(((x,y),) -> x + y, [(1,2), (3,4)])
2-element Array{Int64,1}:
 3
 7

julia> map(((; x, y),) -> x + y, [(x=1, y=2), (x=3, y=4)])
2-element Vector{Int64}:
 3
 7
```

## Optional Arguments
Optional arguments are created by giving default values to arguments during the function
definition:

```julia
julia> function greet(greeting, person="Sir")
           println(greeting, ' ', person)
       end;

julia> greet("Good Morning")
Good Morning Sir

julia> greet("Hello")
Hello Sir

julia> greet("Hello", "Logan")
Hello Logan
```

Optional arguments are actually just a convenient syntax for writing multiple method
definitions with different numbers of arguments; Julia provides a `methods` function for
checking this:

```julia
julia> methods(greet)
# 2 methods for generic function "greet":
[1] greet(exclamation) in Main at REPL[2]:1
[2] greet(exclamation, person) in Main at REPL[2]:1
```

In Julia, default expressions may refer to prior arguments (i.e. left-to-right order); this
gives the ability to have optional arguments whose default values refer to prior arguments:

```julia
julia> f(x, y, z=y) = x+y+z
f (generic function with 1 methods)

julia> f(2, 3)
8
```

## Keyword Arguments
Keyword arguments serve two purposes:

- The call is easier to read since we can label an argument with its meaning.
- It also becomes possible to pass any subset of a large number of arguments in any order.

!!! note
    Keyword arguments behave quite differently from ordinary positional arguments. In
    particular, they do not participate in method dispatch. Methods are dispatched based
    only on positional arguments, with keyword arguments processed after the matching method
    is identified.

Functions with keyword arguments are defined using a semicolon, `;`, in the signature:

```julia
function plot(x, y; style="solid", width, color="black")
    # do something
end
```

In function calls, the semicolon is optional: one can either call `plot(x, y, width=2)` or
`plot(x, y; width=2)`, but the former style is more common (since `width=2` already tells
us that this a keyword argument). An explicit semicolon is required only for passing varargs
or computed keywords.

If a keyword argument is not assigned a default value in the method definition, then it is
required. Calling `plot(x, y)` throws an `UndefKeywordError` exception, because no default
value is assigned to `width`.

In Julia, default expressions may refer to prior arguments (i.e. left-to-right order). So
the default values of keyword arguments are evaluated only when a corresponding keyword
argument is not passed.

```julia
julia> f(x; y, z=x) = x+y+z
f (generic function with 1 method)

julia> f(2, y=3)
7

julia> f(x; y, z=y) = x+y+z
f (generic function with 1 method)

julia> f(2, y=3)
8

julia> f(x; y=z, z) = x+y+z
f (generic function with 1 method)

julia> f(2, z=3)    # `y=z` throws an error
ERROR: UndefVarError: `z` not defined
```

Extra keyword arguments can be collected using `...`, as in varargs functions, e.g., in the
function below, `kwargs...` will be an immutable key-value iterator over a named tuple:

```julia
function f(x; y=0, kwargs...)
    ###
end
```

Named tuples (as well as dictionaries with keys of `Symbol`) can be passed as keyword
arguments using a semicolon in a call, e.g:

```julia
julia> foo(; kwargs...) = kwargs
foo (generic function with 1 method)

julia> foo(; (a=1, b=2)...)
pairs(::NamedTuple) with 2 entries:
  :a => 1
  :b => 2

julia> foo(; Dict(:a=>1, :b=>2)...)
pairs(::NamedTuple) with 2 entries:
  :a => 1
  :b => 2
```

One can also pass `key => value` expressions after a semicolon. For example,
`plot(x, y; :width => 2)` is equivalent to `plot(x, y, width=2)`. This is useful in
situations where the keyword name is computed at runtime.

Note that:

- When a bare identifier or dot expression occurs after a semicolon, the keyword argument
  name is implied by the identifier or field name. For example:
  - `plot(x, y; width)` is equivalent to `plot(x, y; width=width)` i.e. identifier,
  - `plot(x, y; options.width)` is equivalent to `plot(x, y; width=options.width)` i.e.
    field name.

- Keyword arguments with the same name can be *implicitly* specified more than once. For
  example, in the call `plot(x, y; options..., width=2)` it is possible that the `options`
  structure also contains a value for `width`. In such a case the rightmost occurrence takes
  precedence; which in this example, means `width` is certain to have the value `2`.

- However, *explicitly* specifying the same keyword argument multiple times, for example
  `plot(x, y, width=2, width=3)`, is not allowed and results in a syntax error.

## Vararg Functions
Functions that take an arbitrary number of arguments are traditionally known as "varargs"
functions, which is short for "variable number of arguments".

You can define a varargs function by following the last positional argument with an
ellipsis:

```julia
julia> bar(a, b, x...) = (a, b, x)
bar (generic function with 1 method)
```

The variables `a` and `b` are bound to the first two argument values as usual, and the
variable `x` is bound to an iterable collection of zero or more values passed to `bar`
after its first two arguments:

```julia
julia> bar(1, 2)
(1, 2, ())

julia> bar(1, 2, 3)
(1, 2, (3,))

julia> bar(1, 2, 3, 4)
(1, 2, (3, 4))
```

On the flip side, it is often handy to "splat" the values contained in an iterable
collection into a function call as individual arguments. To do this, one also uses `...`
but in the function call instead:

```julia
julia> x = (3, 4);

julia> bar(1, 2, x...)
(1, 2, (3, 4))
```

In this case, a tuple of values is spliced into a varargs call precisely where the variable
number of arguments go. This need not be the case, however:

```julia
julia> x = (2, 3); bar(x...)
(2, 3, ())

julia> x = (2, 3, 4); bar(1, x...)
(1, 2, (3, 4))

julia> x = (1, 2, 3, 4); bar(x...)
(1, 2, (3, 4))
```

Keyword arguments can also be used in varargs functions:

```julia
function plot(x...; style="solid")
    ###
end
```

It is possible to constrain the number of values passed as a variable argument; this is done
by parametrically constraining the number of arguments that may be supplied to the "varargs"
function. The notation `Vararg{T, N}` is used to indicate such a constraint, e.g:

```julia
julia> bar(a, b, x::Vararg{Any, 2}) = (a, b, x)
bar (generic function with 1 method)

julia> bar(1, 2, 3, 4)
(1, 2, (3, 4))

julia> bar(1, 2, 3)
ERROR: MethodError: no method matching bar(::Int64, ::Int64, ::Int64)

julia> bar(1, 2, 3, 4, 5)
ERROR: MethodError: no method matching bar(::Int64, ::Int64, ::Int64, ::Int64, ::Int64)
```

When only the type of supplied arguments needs to be constrained, `Vararg{T}` can be
equivalently written as `T...`, i.e., `f(x::Int...) = x` is a shorthand for
`f(x::Vararg{Int}) = x`.

More usefully, it is possible to constrain varargs methods by a parameter. For example, the
following would only be callable when the number of `indices` matches the dimensionality of
the array:

```julia
getindex(A::AbstractArray{T, N}, indices::Vararg{Number, N}) where {T, N}
```

## Do-Block Syntax For Function Arguments
Julia provides a reserved `do` keyword for clearly and concisely writing functions that are
to be passed to other functions, but spans multiple lines.

`do` blocks also help in managing system state; just like the `with` keyword in python helps
to ensure that all files are closed, the same can be achieved with the `do` block, e.g:

```julia
open("outfile", "w") do io
    write(io, data)
end
```

Note that:

- a plain `do` (i.e one with no arguments) would delcare that what follows is an anonymous
  function of the form `() -> ...`
- Unlike the anonymous function `(x, y) -> ...`, `do (a, b)` would create a one-argument
  anonymous function, whose argument is a tuple to be deconstructed. Use `do a, b` to create
  a two-argument anonymous function.

A `do` block, like any other inner function, can "capture" variables from its enclosing
scope. For example, the variable data in the above example of `open...do` is captured from
the outer scope. Captured variables can create performance challenges as discussed in
performance tips
https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-captured.

See `do` in `help?>` mode, as well as `return` and `open`, to learn how they can be used in
relation to `do` blocks.

## Function Composition & Piping
Functions in Julia can be combined by composing with `∘` or by piping (chaining) them
together with `|>`.

See `∘` and `|>` in `help?>` mode for more information on this.

## Dot For Vectorizing Functions
In Julia, vectorized functions are not required for performance, and indeed it is
often beneficial to write your own loops, but they can still be convenient. Therefore, any
Julia function `f` can be applied elementwise to any array (or other collection) with the
syntax `f.(A)`, where "`.`" is known as the "vectorized dot".

See `broadcast` and `@.` in `help?>` mode and for more info on vectorizing.

## Redefining Methods
When redefining a method or adding new methods, it is important to realize that these
changes don't take effect immediately in the current runtime environment. This is key to
Julia's ability to statically infer and compile code to run fast, without the usual JIT
tricks and overhead.

Indeed, any new method definition won't be visible to the current runtime environment,
including Tasks and Threads (and any previously defined `@generated` functions). However,
the `Base.invokelatest` function is provided to get around this. See:
https://docs.julialang.org/en/v1/manual/methods/#Redefining-Methods for a detailed
explanation on this.

## Method Ambiguities
It is possible to define a set of function methods such that there is no unique most
specific method applicable to some combinations of arguments:

```julia
julia> g(x::Float64, y) = 2x + y
g (generic function with 1 method)

julia> g(x, y::Float64) = x + 2y
g (generic function with 2 methods)

julia> g(2.0, 3)
7.0

julia> g(2, 3.0)
8.0

julia> g(2.0, 3.0)
ERROR: MethodError: g(::Float64, ::Float64) is ambiguous.

Candidates:
  g(x::Float64, y)
  g(x, y::Float64)

Possible fix, define
  g(::Float64, ::Float64)
```

Here the call `g(2.0, 3.0)` could be handled by either the `g(Float64, Any)` or the
`g(Any, Float64)` method, and neither is more specific than the other. In such cases, Julia
raises a `MethodError` rather than arbitrarily picking a method.

While it is common to think that we will be smart enough to not fall into such subtle
circumstances, it would be best to learn more about how to design methods to avoid such
cases in a better Julia style. See
https://docs.julialang.org/en/v1/manual/methods/#man-method-design-ambiguities for more
information.

## Parametric Methods
Method definitions can optionally have type parameters qualifying the signature. Such
definitions correspond to methods whose type signatures are `UnionAll` types:

```julia
julia> same_type(x::T, y::T) where {T} = true
same_type (generic function with 1 method)

julia> same_type(x, y) = false
same_type (generic function with 2 methods)
```

The first method above applies whenever both arguments are of the same concrete type,
regardless of what type that is, while the second method acts as a catch-all, covering all
other cases. Thus, overall, this defines a boolean function that checks whether its two
arguments are of the same type:

```julia
julia> same_type(1, 2)
true

julia> same_type(1, 2.0)
false

julia> same_type(1.0, 2.0)
true

julia> same_type("foo", 2.0)
false

julia> same_type("foo", "bar")
true
```

This kind of definition of function behavior by dispatch is quite common - even idiomatic -
in Julia. Method type parameters are not restricted to being used as the types of arguments;
they can be used anywhere a value would appear in the signature of the function or body of
the function:

```julia
julia> myappend(v::Vector{T}, x::T) where {T} = [v..., x]
myappend (generic function with 1 method)

julia> myappend([1,2], 3)
4-element Vector{Int64}:
 1
 2
 3

julia> myappend([1, 2], 2.5)
ERROR: MethodError: no method matching myappend(::Vector{Int64}, ::Float64)

julia> myappend([1.0, 2.0], 3.0)
4-element Vector{Float64}:
 1.0
 2.0
 3.0

julia> myappend([1.0, 2.0], 3)
ERROR: MethodError: no method matching myappend(::Vector{Float64}, ::Int64)
```

As you can see, the type of the appended element must match the element type of the vector
it is appended to, or else a `MethodError` is raised. In the following example, the method
type parameter `T` is used as the return value:

```julia
julia> mytypeof(x::T) where {T} = T
mytypeof (generic function with 1 method)

julia> mytypeof(1)
Int64

julia> mytypeof(1.0)
Float64
```

You can place subtype constraints on type parameters in type declarations, and the same is
true for method type parameters:

```julia
julia> same_type_numeric(x::T, y::T) where {T<:Number} = true
same_type_numeric (generic function with 1 method)

julia> same_type_numeric(x::Number, y::Number) = false
same_type_numeric (generic function with 2 methods)

julia> same_type_numeric(1, 2)
true

julia> same_type_numeric(1, 2.0)
false

julia> same_type_numeric(1.0, 2.0)
true

julia> same_type_numeric("foo", 2.0)
ERROR: MethodError: no method matching same_type_numeric(::String, ::Float64)

Closest candidates are:
  same_type_numeric(::T, ::T) where T<:Number
  same_type_numeric(::Number, ::Number)

julia> same_type_numeric("foo", "bar")
ERROR: MethodError: no method matching same_type_numeric(::String, ::String)

julia> same_type_numeric(Int32(1), Int64(2))
false
```

The `same_type_numeric` function behaves much like the `same_type` function defined above
but is only defined for pairs of numbers.

## Design Patterns with Parametric Methods
While complex dispatch logic is not required for performance or usability, sometimes it can
be the best way to express some algorithms. See
https://docs.julialang.org/en/v1/manual/methods/#Design-Patterns-with-Parametric-Methods for
a few common design patterns that come up when using dispatch in this way.

Parametric methods allow the same syntax as `where` expressions used to write types. If
there is only a single parameter, the enclosing curly braces (in `where {T}`) can be
omitted, but they are often preferred for clarity. Multiple parameters can be separated with
commas, e.g. `where {T, S<:Real}`, or written using nested `where`, e.g.
`where S<:Real` where `T`.

## Function-Like Objects
Note that, methods are associated with types, so we can:

- make constructors of specific types using this style (this is commonly seen in Julia's
  base module):

```julia
julia> abstract type Point end

julia> struct Coordinates <: Point
           x
           y
       end

julia> (T::Type{<:Point})(x::AbstractFloat) = T(reverse(modf(x))...)

julia> Coordinates(3.5)
Coordinates(3.0, 0.5)
```

- make any arbitrary Julia object "callable" by adding methods to its type; such "callable"
  objects are sometimes called "functors":

```julia
julia> (::Point)(c::Char) = println("code point of \$c is \$(Int(c)).")

julia> a = Coordinates(1, 2)
Coordinates(1, 2)

julia> a('x')
code point of x is 120.
```
"""
function functions(; extmod=false)
    constants = ["Constants" => ["EDITOR_CALLBACKSˣ"]]
    macros = [
        "Macros" => [
            "@__doc__ˣ",
            "@cfunction",
            "@code_llvm",
            "@code_lowered",
            "@code_native",
            "@code_typed",
            "@code_warntype",
            "@functionloc",
            "@__dot__",
            "@_inline_metaˣ",
            "@_noinline_metaˣ",
            "@allocated",
            "@allocations",
            "@assert",
            "@assume_effectsˣ",
            "@atomic",
            "@atomicreplace",
            "@atomicswap",
            "@ccall",
            "@ccallableˣ",
            "@constpropˣ",
            "@debug",
            "@deprecate",
            "@doc",
            "@edit",
            "@elapsed",
            "@enum",
            "@eval",
            "@fastmath",
            "@generated",
            "@goto",
            "@inline",
            "@invoke",
            "@invokelatest",
            "@label",
            "@less",
            "@localsˣ",
            "@lock",
            "@lock_nofailˣ",
            "@macroexpand",
            "@macroexpand1",
            "@noinline",
            "@nospecialize",
            "@polly",
            "@propagate_inboundsˣ",
            "@pureˣ",
            "@show",
            "@showtime",
            "@specialize",
            "@static",
            "@task",
            "@time",
            "@timed",
            "@timev",
            "@which",
        ],
    ]
    methods = [
        "Methods" => [
            "Introspection" => [
                "code_ircodeˣ",
                "code_lowered",
                "code_llvm",
                "code_native",
                "code_typed",
                "code_warntype",
                "which",
            ],
            "True/False" => ["applicable", "ifelse", "isa", "isambiguousˣ", "isbits"],
            "Others" => [
                "accumulate",
                "all",
                "any",
                "argmax",
                "argmin",
                "asyncmap",
                "atexit",
                "atreplinit",
                "backtrace",
                "broadcast",
                "ccall_macro_parseˣ",
                "cd",
                "cmp",
                "count",
                "delete_methodˣ",
                "donotdeleteˣ",
                "disable_sigint",
                "display",
                "dump",
                "edit",
                "filter",
                "finalizer",
                "findall",
                "findfirst",
                "findlast",
                "gen_call_with_extracted_types_and_kwargsˣ",
                "findmax",
                "findmin",
                "findnext",
                "findprev",
                "foreach",
                "functionloc",
                "get",
                "identity",
                "include_string",
                "includeˣ",
                "invoke",
                "invoke_in_worldˣ",
                "invokelatest",
                "less",
                "lock",
                "lstrip",
                "macroexpand",
                "map",
                "mapfoldl",
                "mapfoldr",
                "mapreduce",
                "mapreduce_emptyˣ",
                "mapreduce_firstˣ",
                "mapslices",
                "maximum",
                "may_invoke_generatorˣ",
                "mergewith",
                "methods",
                "methodswith",
                "minimum",
                "mktemp",
                "mktempdir",
                "nameof",
                "ntuple",
                "objectid",
                "open",
                "precompile",
                "print",
                "print_statement_costsˣ",
                "println",
                "printstyled",
                "prod",
                "promote_opˣ",
                "redirect_stderr",
                "redirect_stdin",
                "redirect_stdio",
                "redirect_stdout",
                "redisplay",
                "reduce",
                "reenable_sigint",
                "replace",
                "repr",
                "retry",
                "setprecision",
                "setrounding",
                "show",
                "showargˣ",
                "skipchars",
                "splat",
                "sprint",
                "string",
                "sum",
                "summary",
                "typeassert",
                "typeof",
                "unique",
                "withenv",
            ],
        ],
    ]
    types = [
        "Types" => [
            "BottomRFˣ",
            "CFunctionˣ",
            "ComposedFunction",
            "DataType",
            "FilteringRFˣ",
            "Fix1ˣ",
            "Fix2ˣ",
            "FlatteningRFˣ",
            "Function",
            "Generatorˣ",
            "MappingRFˣ",
            "Returns",
            "Splatˣ",
            "Timer",
        ],
    ]
    operators = [
        "Operators" => [
            "!",
            "!=",
            "!==",
            "<",
            "<:",
            "==",
            "=>",
            ">",
            ">=",
            "∈",
            "∉",
            "∋",
            "∌",
            "∘",
            "≈",
            "≠",
            "≡",
            "≢",
            "≤",
            "≥",
            "===",
        ],
    ]
    stdlib = ["Stdlib" => ["Statistics.mean"]]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end
