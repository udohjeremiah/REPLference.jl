include("utility_script.jl")

@doc raw"""
A variable, in Julia, is a name associated (or bound) with a value. The value a variable was
previously bound to can be changed (except if stated as constant using `const`). They
provide temporary storage for information that will be needed during the lifespan of a
computer program.

In a program, every variable has a name (identifier), data type, size, and value to which
it is bound. One can obtain a list of all variable names in the current module along with
their size and data type using the function `varinfo()`. Alternatively, to obtain the names
of all variables defined in a call site, one can use the macro `Base.@locals()`.

# Naming Conventions For Variables
Julia provides an extremely flexible system for naming variables.

1. **Variable names are case-sensitive.**
This means, for example, "`version`" is different from "`Version`" as variable names
respectively:

```julia
julia> version = "1.7";

julia> Version    # throws an error because of 'V' used, instead of 'v'
ERROR: UndefVarError: Version not defined
```

2. **Variable names have no semantic meaning.**
This means the language will not treat variables differently based on their names:

```julia
julia> ™ = 2.90;    #'™' is a valid variable name just as `x` is too

julia> ™ + 1.10
4.0
```

3. **Variable names can be in Unicode names (in UTF-8) encodings.**

```julia
julia> δ = 120;     # the unicode symbol is a valid variable name

julia> α = 120;     # all unicode symbols and names are allowed

julia> δ + α
240
```

4. **Variable names must begin with a letter (A-Z or a-z), underscore, or a subset of
   Unicode code points greater than 00A0.**

This means variable names cannot start with numbers:

```julia
julia> new_var = 123
123

julia> 1new_var = 23
ERROR: syntax: "1" is not a valid function argument name around REPL[5]:1
```

Unicode character categories Lu/LI/Lt/Lm/Lo/NI (letters), Sc/So (currency and other
symbols), and a few other letter-like characters (e.g., a subset of the Sm math symbols) are
allowed:

```julia
julia> Dç = 10       # Lu/Ll/Lt/Lm/Lo/NI (letters) allowed
10

julia> £ = 23        # Sc/So (currency and other symbols) allowed
23

julia> ≥ = 12        # Sm math symbols allowed
12

julia> Dç + £ + ≥
45
```

5. **Subsequent characters of variable names may include any symbol.**

This means characters after the first character of a variable name may include "!" and
digits (0-9 and other characters in categories Mn/Mc/Me/Sk); some punctuation connectors
(category Pc), prime, and a few other characters:

```julia
julia> x!y = 20
20

julia> ! = 10
10

julia> x!y + !
30
```

See https://en.m.wikipedia.org/wiki/Unicode_character_property for a broad overview of
the Unicode symbols allowed.

6. **Variable names can be same as built-in constants and functions.**

Although this is allowed, it is not recommended to avoid potential confusion. As an example,
`pi` is a built-in mathematical constant, and `sum` is a built-in generic function; however,
they can be assigned to despite being "built-ins":

```julia
julia> pi = 4; pi * 2
8

julia> sum = 13; sum * 2
26
```

Note that redefining a built-in constant or function already in use throws an error:

```julia
julia> pi                 # pi is now in use
π = 3.1415926535897...

julia> sum                # sum is now in use
sum (generic function with 14 methods)

julia> pi = 4
ERROR: cannot assign a value to variable MathConstants.pi from module Main

julia> sum = 13
ERROR: cannot assign a value to variable Base.sum from module Main
```

7. **Operators are also valid identifiers, but are parsed specially.**

In some contexts, operators can be used just like variables. For example `+` refers to the
addition function and `+ = 2` will reassign it to the value `2`:

```julia
julia> +
+ (generic function with 208 methods)

julia> ^
^ (generic function with 68 methods)

julia> + = 34
34

julia> ^ = 23
23

julia> (+) - (^)
11
```

Most of the Unicode infix operators (in category Sm), such as `⊗`, are parsed as infix
operators and are available for user-defined methods. For example, you can use
`const ⊗ = kron` to define `⊗` as an infix Kronecker product.

Please note that operators can also be suffixed with modifying marks, primes, and
sub/superscripts. For example, `+̂ₐ` is parsed as an infix operator with the same precedence
as `+`. A space is required between an operator that ends with a subscript/superscript
letter and a subsequent variable name. For example, if `+ᵃ` is an operator, then `+ᵃx` must
be written as `+ᵃ x` to distinguish it from `+ ᵃx`, where `ᵃx` might be a variable name:

```julia
julia> +ᵃ(x, y) = "$(x+y)ᵃ"
+ᵃ (generic function with 1 method)

julia> x = 10; y = 20; ᵃy = 30;

julia> x +ᵃ y
"30ᵃ"

julia> x + ᵃy
40
```

8. **Variable names can be superscript and/or subscript.**

This can be useful and informative when combined with regular letters. For example:

```julia
julia> x = [10, 19, 2, 90, -1];

julia> xᵐᵃˣ = maximum(x);        # xᵐᵃˣ is gotten by typing x\^max<tab>

julia> xₘᵢₙ = minimum(x);        # xₘᵢₙ is gotten by typing x\_max<tab>

julia> xᵐᵃˣ, xₘᵢₙ
(90, -1)
```

Variable names can also consist solely of superscript or subscript characters, or they can
include both at the same time:

```julia
julia> ₐₛ = 10; ᵇᵗ = 20;

julia> ₐₛᵇᵗ = ₐₛ + ᵇᵗ;

julia> ₐₛᵇᵗ
30
```

9. **Variables can be unpacked from different data types, including vectors, matrices,
   tuples, and more.**

Similar to other programming languages like Python, variables can be assigned to multiple
values using unpacking:

```julia
julia> x, y = 1, 2;

julia> x
1

julia> y
2

julia> a, b, c = [1, 2, 3, 4, 5, 6];

julia> a
1

julia> b
2

julia> c
3
```

Note that in Julia versions prior to 1.9, the splat operator `...` can only be used on the
final element:

```julia
julia> a, b, c... = [1, 2, 3, 4, 5, 6];

julia> a
1

julia> b
2

julia> c
4-element Vector{Int64}:
 3
 4
 5
 6
```

10. **A particular class of variable names, i.e., underscore-only variables, is allowed.**

These identifiers can only be assigned values but cannot be used to assign values to other
variables. More technically, they can only be used as an L-value, but not as a non-L-value
or R-value. A non-L-value is colloquially known as an R-value.

Note that, while an R-value is any expression, a non-L-value is any expression that is not
an L-value; one example is an "immediate value" and consequently not addressable:

```julia
julia> x, _ = size([2 2; 1 1])    # size(A) returns the dimension of A
(2, 2)

julia> x
2

julia> _          # used as a non-l-value
ERROR: all-underscore identifier used as rvalue

julia> y = _      # used as an r-value
ERROR: syntax: all-underscore identifier used as rvalue      
```

This all-underscore identifier is very useful in Julia. In other languages like Python, it
can be used both as a non-L-value and R-value if one chooses to, but in Julia, it cannot be
under any circumstances. So, we can use this when we want only part of something, and be
rest assured the other part has been "discarded" and cannot be accidentally or intentionally
called or referenced.

```julia
julia> user_info = [
           :user => "John Pavard",
           :pswd => "1234",
           :auth_keys => "123csdx12",
           :log_keys => "xzzxwe2s434",
           :ref_keys => "12idme"
       ];

julia> x, y, _... = user_info;

julia> x
:user => "John Pavard"

julia> y
:pswd => "1234"

julia> _
ERROR: all-underscore identifier used as rvalue
```

The splat operator, `...`, can be omitted, and it means the same thing, but it helps to let
the user know that more than one value was truncated:

```julia
julia> x, y, _ = user_info;

julia> x
:user => "John Pavard"

julia> y
:pswd => "1234"

julia> _
ERROR: all-underscore identifier used as rvalue
```

The all-underscore variable, `_`, and splat operator, `...`, can both be omitted, and it
means the same thing as the ones above, but for code maintenance, it helps to let the user
know that other values were present but they were discarded. In languages like Python, this
would raise an error:

```julia
julia> x, y = user_info;

julia> x
:user => "John Pavard"

julia> y
:pswd => "1234"
```

From the above, we can conclude that all three ways are different syntactic sugar (and each
provides meaningful analyses of the code), but the result returned by each style is
equivalent to each other:

```julia
julia> array = [1, 2, 3, 4, 5];

julia> S1 = x, y, z = array;

julia> S2 = x, y, z, _ = array;

julia> S3 = x, y, z, _... = array;

julia> S1 == S2 == S3
true
```

11. **Some variable names are disallowed.**

The only explicitly disallowed names for variables are the names of the
[built-in reversed keywords](https://docs.julialang.org/en/v1/base/base/#Keywords):

```julia
julia> else = 12                    # else is a keyword
ERROR: syntax: unexpected "else"

julia> try = "No"                   # try is a keyword
ERROR: syntax: unexpected "="
```

# Style Guide On Variable Namings
While Julia imposes few restrictions on valid names, it has become useful to adopt the
following stylistic conventions for naming variables in Julia:

- Names of variables should be in lowercase.
- Word separation can be indicated by underscores (_), but the use of underscores is
  discouraged unless the name would be hard to read otherwise.

For more on the style guide used in the Julia community, take a look
at the official style guide recommended by Julia:
https://docs.julialang.org/en/v1/manual/style-guide/.

# Variable Scoping
In computer programming, the scope of a name binding (an association of a name to an entity,
such as a variable) is the part of a program where the name binding is valid; that is, where
the name can be used to refer to the entity. In other parts of the program, the name may
refer to a different entity (it may have a different binding), or to nothing at all
(it may be unbound).

In short, the scope of a variable is the region of code within which a variable is
accessible.

Scope helps prevent name collisions by allowing the same name to refer to different
objects - as long as the names have separate scopes. The scope of a name binding is also
known as the **visibility** of an entity, particularly in older or more technical
literature — this is from the perspective of the referenced entity, not the referencing
name.

The rules for when the same variable name does or doesn't refer to the same thing are
called **scope rules**; this section spells them out in detail.

## Main Types Of Scopes
There are two main types of scopes in Julia: global scope and local scope. The latter can
be nested.

A scope nested inside another scope can "see" variables in all the outer scopes in which it
is contained. Outer scopes, on the other hand, cannot see variables in inner scopes:

```julia
julia> function outer_scope()
           function inner_scope()
               # inner scope uses outer scope variables: `x` and `y`
               a, b = x, y
               println(a * b)
           end
           x, y = 12, 4
           inner_scope()
           println(x + y)
           # outer scope cannot use inner scope variables: `a` and `b`
           println(a / b)
       end
outer_scope (generic function with 1 method)

julia> outer_scope()
48
16
ERROR: UndefVarError: `a` not defined
```

## Lexical or Dynamic Scoping?
Julia uses
[lexical scoping as opposed to dynamic scoping]
(https://en.wikipedia.org/wiki/Scope_%28computer_science%29#Lexical_scoping_vs._dynamic_scoping),
meaning that a function's scope does not inherit from its caller's scope, but from the scope
in which the function was defined.

For example, in the following code the `x` inside `foo` refers to the `x` in the global
scope of its module `Bar`:

```julia
julia> module Bar
           x = 1
           foo() = x
       end;
```

and not a `x` in the scope where `foo` is used:

```julia
julia> import .Bar

julia> x = -1;

julia> Bar.foo()
1
```

Thus, lexical scope means that what a variable in a particular piece of code refers to can
be deduced from the code in which it appears alone and does not depend on how the program
executes. That is, the region in which a variable exists is determined by where it was
defined or created.

## Scope Constructs
As said earlier, variable scoping helps avoid variable naming conflicts. The concept is
intuitive: two functions can both have arguments called `x` without the two `x`'s referring
to the same thing. Similarly, there are many other cases where different blocks of code can
use the same name without referring to the same thing.

Certain constructs in the language introduce scope blocks, which are regions of code that
are eligible to be the scope of some set of variables. The scope of a variable cannot be an
arbitrary set of source lines; instead, it will always line up with one of these blocks.

There is also a distinction in Julia between constructs which introduce a
"hard scope" and those which only introduce a "soft scope", which affects whether
[shadowing](https://en.wikipedia.org/wiki/Variable_shadowing) a global variable by the same
name is allowed or not.

The constructs introducing scope blocks are:

| Construct	                            | Scope type   | Allowed within what scope? |
|:--------------------------------------|:------------:|:--------------------------:|
| `module`, `baremodule`                | global       | global                     |
|                                       |              |                            |
| `struct`                              | local (soft) | global                     |
|                                       |              |                            |
| `for`, `while`, `try`/`catch` blocks  | local (soft) | global, local              |
|                                       |              |                            |
| `macro`                               | local (hard) | global                     |
|                                       |              |                            |
| functions, `do` blocks, `let` blocks, | local (hard) | global, local              |
| comprehensions, generators            |              |                            |

Notably missing from this table are `begin` blocks and `if` blocks which do not introduce
new scopes. The three types of scopes i.e. global, local (soft) and local (hard), follow
somewhat different rules which will be explained below.

## Global Scope
Each module introduces a new global scope, separate from the global scope of all other
modules — there is no all - encompassing global scope.

Modules can introduce variables of other modules into their scope through the `using` or
`import` statements, or through qualified access using dot notation. That is, each module is
a so-called namespace, as well as a first-class data structure associating names with
values.

```julia
julia> module A
           a = 1        # a global in A's scope
       end;

julia> module B
           module C
               c = 2
           end
           b = C.c      # can access the namespace of a nested global scope
                        # through a qualified access using dot-notation

           import ..A   # makes module A available
           d = A.a
       end;

julia> module D
           b = a        # errors as D's global scope is separate from A's
       end;
ERROR: UndefVarError: `a` not defined
```

Variable bindings can be read and modified externally, i.e., outside the module to which
they belong. To accomplish this, the `setproperty!(::Module, ::Symbol, x)` function can be
used, which is invoked by the syntax `M.x = y`. Here, `M` refers to the module, `x`
represents the binding in `M` that needs to be assigned, and `y` is the value being assigned
to `x`:

```julia
julia> A.a
1

julia> module E
           import ..A   # make module A available
           A.a = 2      # modifies `a` in module `A`
       end;

julia> A.a
2
```

If a top-level expression contains a variable declaration with the keyword `local`, then
that variable is not accessible outside that expression. The variable inside the expression
does not affect global variables of the same name. An example is to declare `local x` in a
`begin` or `if` block at the top-level:

```julia
julia> x = 1
       begin
           local x = 0
           @show x
       end
       @show x;
x = 0
x = 1
```

Note that the interactive prompt (aka REPL) is in the global scope of the module `Main`.

## Local Scope
Most code blocks introduce a new local scope. If a block is syntactically nested inside of
another local scope, the scope it creates is nested inside of all the local scopes that it
appears within, which are all ultimately nested inside of the global scope of the module in
which the code is evaluated.

Variables in outer scopes are visible from any scope they contain — meaning that they can be
read and written in inner scopes — unless there is a local variable with the same name that
"shadows" the outer variable of the same name. This is true even if the outer local is
declared after an inner block, as shown below:

```julia
julia> function outer_scope()
           function inner_scope()  # inner block defined first
               2x
           end
           x = 10                  # outer local declared after inner block
           inner_scope()           # nevertheless, x is still known
       end
outer_scope (generic function with 1 methods)

julia> outer_scope()
20
```

When we say that a variable "exists" in a given scope, this means that a variable by that
name exists in any of the scopes that the current scope is nested inside of, including the
current one.

Some programming languages require explicitly declaring new variables before using them.
Explicit declaration works in Julia too: in any local scope, writing `local x` declares a
new local variable `x` in that scope, regardless of whether there is already a variable
named `x` in an outer scope or not.

Declaring each new variable like this is somewhat verbose and tedious, however, so Julia,
like many other languages, considers assignment to a variable name that doesn't already
exist to implicitly declare that variable. If the current scope is global, the new variable
is global; if the current scope is local, the new variable is local to the innermost local
scope and will be visible inside of that scope but not outside of it.

**If you assign to an existing local, it always updates that existing local: you can only
"shadow" a local by explicitly declaring a new local in a nested scope with the `local`
keyword***. In particular, this applies to variables assigned in inner functions, which may
surprise users coming from Python where assignment in an inner function creates a new local
unless the variable is explicitly declared to be non-local.

Mostly, this is pretty intuitive, but as with many things that behave intuitively, the
details are more subtle than one might naively imagine.

When `x = <value>` occurs in a local scope, Julia applies the following rules to decide what
the expression means based on where the assignment expression occurs and what `x` already
refers to at that location:

1. **Existing local:** If `x` is already a local variable, then the existing local `x` is
    assigned.

2. **Hard scope:** If `x` is not already a local variable and the assignment occurs inside
   of any hard scope construct (i.e. within a let block, function or macro body,
   comprehension, or generator), a new local named `x` is created in the scope of the
   assignment.

3. **Soft scope:** If `x` is not already a local variable and all of the scope constructs
   containing the assignment are soft scopes (loops, try/catch blocks, or struct blocks),
   the behavior depends on whether:

| global `x` is undefined          | global `x` is defined                      |
|:---------------------------------|:-------------------------------------------|
| Then, a new local named `x` is   | Then the assignment is considered          |
| created in the scope of the      | ambiguous, and carried out depending on if |
| assignment.                      | the environment is:                        |
|                                  |                                            |
|                                  | in non-interactive contexts (files, eval), |
|                                  | where an ambiguity warning is printed and  |
|                                  | a new local is created;                    |
|                                  |                                            |
|                                  | in interactive contexts (REPL, notebooks), |
|                                  | where the global variable `x` is assigned. |

You may note that in non-interactive contexts, the hard and soft scope behaviors are
identical, except that a warning is printed when an implicitly local variable (i.e., not
declared with `local x`) shadows a global. In interactive contexts, the rules follow a more
complex heuristic for the sake of convenience. This is covered in-depth in the examples that
follow.

### Example 1 - local (hard) scope
We'll begin with a nice and clear-cut situation: an assignment inside a hard scope, in this
case, a function body, where no local variable by that name exists:

```julia
julia> function greet()
           x = "hello" # new local
           println(x)
       end
greet (generic function with 1 method)

julia> greet()
hello

julia> x # global
ERROR: UndefVarError: `x` not defined
```

Inside the greet function, the assignment `x = "hello"` creates a new local variable in the
function's scope. Two relevant facts are:

- The assignment occurs in local scope and there is no existing local `x` variable.
- Since `x` is local, it doesn't matter if there is a global named `x` or not.

Here's an example where we define `x = 123` (which is a global variable) before defining
and calling `greet`:

```julia
julia> x = 123 # global
123

julia> function greet()
           x = "hello" # new local
           println(x)
       end
greet (generic function with 1 method)

julia> greet()
hello

julia> x # global
123
```

Since the `x` in `greet` is local, the value (or lack thereof) of the global `x` is
unaffected by calling `greet`.

***The hard scope rule doesn't care whether a global named `x` exists or not: assignment to
`x` in a hard scope is local (unless `x` is declared global)***.

### Example 2 - local (hard) scope
The next clear cut situation we'll consider is when there is already a local variable named
`x`, in which case `x = <value>` always assigns to this existing local `x`. This is true
whether the assignment occurs in the same local scope, an inner local scope in the same
function body, or in the body of a function nested inside of another function, also known
as a [closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)).

We'll use the `sum_to function`, which computes the sum of integers from `1` up to `n`, as
an example:

```julia
function sum_to(n)
  s = 0         # new local
  for i = 1:n
      s = s + i # assign existing local
  end
  return s      # same local
end
```

As in **Example 1**, the first assignment to `s` at the top of `sum_to` causes `s` to be a
new local variable in the body of the function. The `for` loop has its own inner local scope
within the function scope. At the point where `s = s + i` occurs, `s` is already a local
variable, so the assignment updates the existing `s` instead of creating a new local.

We can test this out by calling sum_to in the REPL:

```julia
julia> function sum_to(n)
           s = 0         # new local
           for i = 1:n
               s = s + i # assign existing local
           end
           return s      # same local
       end
sum_to (generic function with 1 method)

julia> sum_to(10)
55

julia> s # global
ERROR: UndefVarError: `s` not defined
```

Since `s` is local to the function `sum_to`, calling the function has no effect on the
global variable `s`. We can also see that the update `s = s + i` in the `for` loop must have
updated the same `s` created by the initialization `s = 0` since we get the correct sum of
`55` for the integers `1` through `10`.

### Example 3 - local (soft) scope
Let's take a moment to consider that the `for` loop body has its own scope by writing a
slightly more verbose variation which we'll call `sum_to_def`. In this version, we save the
sum `s + i` in a variable `t` before updating `s`:

```julia
julia> function sum_to_def(n)
           s = 0         # new local
           for i = 1:n
               t = s + i # new local `t`
               s = t     # assign existing local `s`
           end
           return s, @isdefined(t)
       end
sum_to_def (generic function with 1 method)

julia> sum_to_def(10)
(55, false)
```

This version returns `s` as before but it also uses the `@isdefined` macro to return a
boolean indicating whether there is a local variable named `t` defined in the function's
outermost local scope. As you can see, there is no `t` defined outside of the `for` loop
body. This is because of the hard scope rule again: since the assignment to `t` occurs
inside of a function, which introduces a hard scope, the assignment causes `t` to become a
new local variable in the local scope where it appears, i.e., inside the loop body. Even if
there were a global named `t`, it would make no difference — **the hard scope rule isn't
affected by anything in global scope**.

Note that the local scope of a `for` loop body is no different from the local scope of an
inner function. This means that we could rewrite this example so that the loop body is
implemented as a call to an inner helper function, and it behaves the same way:

```julia
julia> function sum_to_def_closure(n)
           function loop_body(i)
               t = s + i # new local `t`
               s = t     # assign same local `s` as below
           end
           s = 0         # new local
           for i = 1:n
               loop_body(i)
           end
           return s, @isdefined(t)
       end
sum_to_def_closure (generic function with 1 method)

julia> sum_to_def_closure(10)
(55, false)
```

This example illustrates a couple of key points:

- Inner function scopes are just like any other nested local scope. In particular, if a
  variable is already a local outside of an inner function and you assign to it in the inner
  function, the outer local variable is updated.

- It doesn't matter if the definition of an outer local happens below where it is updated;
  the rule remains the same. The entire enclosing local scope is parsed, and its locals are
  determined before inner local meanings are resolved.

This design means that you can generally move code in or out of an inner function without
changing its meaning, which facilitates a number of common idioms in the language using
closures (see `do` blocks).

### Example 4 - local (soft) scope
Let's move onto some more ambiguous cases covered by the soft scope rule. We'll explore this
by extracting the bodies of the `greet` and `sum_to_def` functions into soft scope contexts.

First, let's put the body of `greet` in a `for` loop—which is soft, rather than hard—and
evaluate it in the REPL:

```julia
julia> for i = 1:3
           x = "hello" # new local
           println(x)
       end
hello
hello
hello

julia> x
ERROR: UndefVarError: `x` not defined
```

Since the global `x` is not defined when the `for` loop is evaluated, the first clause of
the soft scope rule applies and `x` is created as local to the `for` loop and therefore
global `x` remains undefined after the loop executes.

### Example 5 - local (soft) scope
Next, let's consider the body of `sum_to_def` extracted into the global scope, fixing its
argument to `n = 10`:

```julia
s = 0
for i = 1:10
    t = s + i
    s = t
end
s
@isdefined(t)
```

What does this code do? Hint: it's a trick question. The answer is "it depends." If this
code is entered interactively, it behaves the same way it does in a function body. But if
the code appears in a file, it prints an ambiguity warning and throws an undefined variable
error.

Let's see it working in the REPL first:

```julia
julia> s = 0          # global
0

julia> for i = 1:10
           t = s + i  # new local `t`
           s = t      # assign global `s`
       end

julia> s              # global
55

julia> @isdefined(t)  # global
false
```

The REPL approximates being in the body of a function by deciding whether the assignment
inside the loop assigns to a global or creates a new local based on whether a global
variable by that name is defined or not. If a global by the name exists, then the assignment
updates it. If no global exists, then the assignment creates a new local variable. In this
example, we see both cases in action:

- There is no global named `t`, so `t = s + i` creates a new `t` that is local to the `for`
  loop.
- There is a global named `s`, so `s = t` assigns to it.

The second fact is why the execution of the loop changes the global value of `s`, and the
first fact is why `t` is still undefined after the loop executes.

Now, let's try evaluating this same code as though it were in a file:

```julia
julia> code = \"\"\"
       s = 0         # global
       for i = 1:10
           t = s + i # new local `t`
           s = t     # new local `s` with warning
       end
       s,            # global
       @isdefined(t) # global
       \"\"\";

julia> include_string(Main, code)
┌ Warning: Assignment to `s` in soft scope is ambiguous because a global variable by the same name exists: `s` will be treated as a new local. Disambiguate by using `local s` to suppress this warning or `global s` to assign to the existing global variable.
└ @ string:4
ERROR: LoadError: UndefVarError: `s` not defined
```

Here, we use `include_string` to evaluate the code as though it were the contents of a file.
We could also save the code to a file and then call `include` on that file, and the result
would be the same. Alternatively, we could have placed the code inside a module, and the
results would have been the same, without the warning message.

As you can see, this behaves quite differently from evaluating the same code in the REPL.
Let's break down what's happening here:

- The global variable `s` is defined with the value `0` before the loop is evaluated.

- The assignment `s = t occurs` in a soft scope - a `for` loop outside of any function body
  or other hard scope construct.

- Therefore, the second clause of the soft scope rule applies, and the assignment is
  ambiguous, so a warning is emitted.

- Execution continues, making `s` local to the `for` loop body.

- Since `s` is local to the `for` loop, it is undefined when `t = s + i` is evaluated,
  causing an error.

- Evaluation stops there, but if it got to `s` and `@isdefined(t)`, it would return `0` and
  `false`.

This demonstrates some important aspects of scope: in a scope, each variable can only have
one meaning, and that meaning is determined regardless of the order of expressions.

The presence of the expression `s = t` in the loop causes `s` to be local to the loop, which
means that it is also local when it appears on the right-hand side of `t = s + i`, even
though that expression appears first and is evaluated first.

One might imagine that the `s` on the first line of the loop could be global while the `s`
on the second line of the loop is local, but that's not possible since the two lines are in
the same scope block and ***each variable can only mean one thing in a given scope***.

For a complete explanation of why the ambiguous soft scope case is handled differently in
interactive and non-interactive contexts, head over to
https://docs.julialang.org/en/v1/manual/variables-and-scoping/#on-soft-scope.
"""
function variables(; extmod=false)
    macros = [
        "Macros" => [
            "@gensym", "@isdefined"
        ]
    ]
    methods = [
        "Methods" => [
            "True/False" => [
                "isconst", "isdefined", "isidentifierˣ"
            ],
            "Others"     => [
                "gensym"
            ]
        ]
    ]
    _print_names(macros, methods)
end