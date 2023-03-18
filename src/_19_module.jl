@doc raw"""
# MODULES

### What Is A Module?
A module is a single file that contains related objects, intended to provide specific
functionalities within a program. These individual files (i.e. modules) work perfectly at
an individual level, but can also be easily integrated with other modules to create a larger
program, where each module serves a unique and separate functionality within the entire
program.

Generally, modules are not "functional" on their own. That is, loading a module into your
program will not perform any operation. Instead, it makes the module contents available to
you, which you can then call in your program to perform operations.

The concept or design technique of separating a software application into different
interchangeable modules, where each module seeks to solve one aspect of the entire problem
the application is trying to solve, is known as *modular programming*.

# Modular Programming
The central problem of computer programming is complexity. The actual line-by-line business
of programming is easy i.e., any simple program that does one or two operations will
probably be easy to understand. But real-world applications aren't always small. Oftentimes,
they span a thousand lines of code. So, the bigger the program gets, the more complexity
builds up. This is where modular programming comes in. It seeks to make the bigger program
understandable just as a smaller program would have been, by dividing bigger programs into
smaller programs.

As a software design technique, it emphasizes separating the functionality of a program into
independent, interchangeable modules, such that each module contains everything necessary to
execute only one aspect of the desired functionality. When bundled together with other
modules, they create the larger program.

Since modules are usually independent, they can be reusable in other programs, for which
they were not originally written. Thus, the introduction of modularity allowed programmers
to reuse prewritten code with new applications. In Julia, functions, modules, files, and
packages are all constructs that promote code modularization, as explained below:

- function: a procedure or algorithm that maps a tuple of argument values to a return
  value, to solve a specific task.

- module: a collection of related objects, e.g. global variables, constants, functions,
  user-defined types, and/or other modules, into coherent units.

- file: in this context, is the source code of the module saved into digital format and
  stored in a directory.

- package: like a module, is also a collection of functions, user-defined types, and
  module file paths. However, it goes further to contain tests (to make sure the entirety of
  the program works as desired) and documentation (so users can easily know how to use it).
  While modules are created to build coherent units, packages are developed with the main
  aim of sharing code with the public.

# Obvious Benefits Of Modular Programming
- Simplicity: Modular programming usually makes your code easier to read because it
  means separating it into modules, each dealing with only one aspect of the overall
  functionality. It can make your files a lot smaller and easier to understand compared to
  monolithic code.

- Maintainability: With each module providing a single source code for your specific
  functions, it minimizes the number of places where bugs can occur and makes it easier and
  faster to fix when you do get bugs. This reduces the risk of problems caused by two pieces
  of code relying on slightly different implementations of the same functionality. And if
  there's a bug in the code or you need to update the specific function, you only have to
  fix it in the one module, and everything that uses it will get updated right away.
  Whereas, if you copied and pasted the code into different places, you could easily miss
  updating one or two instances.

- Reusability: A lot of the time, you'll need to use the same code or function in
  multiple places. Instead of copying and pasting the code, modularity allows you to pull it
  from a single source by calling it from whatever module it's in. This eliminates the need
  to duplicate code.

- Easier lower risk updates: WWith modular programming, every module has a defined API
  layer, which protects users from changes inside the module. As long as you don't change
  the API (in a way that breaks things), there's a much lower risk of unintentionally
  breaking code somewhere that relies on whatever you changed. For example, if you didn't
  have explicit APIs and someone changed a function they thought was only used within that
  same module (but it was actually used elsewhere), they could accidentally break something.

- Easier collaboration: Modular programming is essential when multiple teams need to
  work on different components of a program. When you have multiple developers working on
  the same piece of code, it usually results in Git conflicts and various other issues,
  which can be annoying and can slow down the team. If the code is split between modules,
  you can decrease the chances of this happening, as development and ownership of specific
  modules are assigned to teams, enabling them to break the work down into smaller tasks,
  which ensures everything fits together at deployment.

# Possible Downsides To Modular Programming
The alternative to modular programming is usually to create a monolithic application of
code, where all your code is (more or less) dumped into a single source code. This can
result in what is usually known as "spaghetti code". However, there are actually a few
valid reasons why some people still write "spaghetti code":

- Code size: If you're working on a personal or small project, modularity can increase code
  size and impact performance if you can't tree shake your dependencies.

- Complexity: If you're working on a personal or small project, complex file systems may not
  be necessary and can add unnecessary overhead.

- Security: Monolithic code can make it harder for people to mess with the code that the
  original developer doesn't want changed, hacked, or pirated.

However, if you expect your personal or small project to have a long life or to grow a lot,
it might be good to consider modularity from the start.

# Standard Modules In Julia
Julia has 3 essential standard modules that are vital for performing basic functionality in
the language:

1. `Core`: This module contains all functionality that is built into the language.
2. `Base`: This module contains basic functionality that is useful in almost all cases.
3. `Main`: This is the top-level module and the current module when Julia is started.

In addition to these three modules, there is the `InteractiveUtils` module, which is loaded
by default when you start the Julia REPL or any other Julia environment. There are also
other standard library modules that are shipped with Julia by default, which behave like
regular Julia packages, but they do not require explicit installation. For example, if you
wanted to perform unit testing, you can simply load the `Test` standard library using either
`using Test` or `import Test`.

# How To Create A Module In Julia
In Julia, there are 3 ways to create a module, depending on your needs:

## 1. using the `module` keyword

```julia
module ModuleName

# your module definitions here

end
```

This declares a `Module` and automatically contains `using Core`, `using Base`, and
definitions of the `eval` and `include` functions, which evaluate expressions/files within
the global scope of that module:

```julia
julia> module Mod1 end
Main.Mod1

julia> typeof(Mod1)
Module

julia> Mod1.Core
Core

julia> Mod1.Base
Base
```

This means all modules declared with `module` implicitly import `Core` and `Base`, making
names *exported* by `Core` and `Base` available to the module, and those not exported can be
accessed with their qualified name.

## 2. using the `baremodule` keyword

```julia
baremodule ModuleName

# your module definitions here

end
```

This declares a `Module` and automatically contains `using Core`. Unlike modules declared
with `module`, it does not contain `using Base` and definitions of the `eval` and `include`
functions, which evaluate expressions/files within the global scope of that module:

```julia
julia> baremodule Mod2 end
Main.Mod2

julia> typeof(Mod2)
Module

julia> Mod2.Core
Core

julia> Mod2.Base
ERROR: UndefVarError: Base not defined
```

## 3. using the `Module` constructor

`Module` (a `DataType`) can be used as a constructor to create modules. Though this can be
used to create modules equivalent to the ones declared with `module` and `baremodule`, it is
commonly used when one wants to declare a `Module` that does not contain `using Core`,
`using Base`, definitions of the `eval` and `include` functions, which evaluate
expressions/files within the global scope of that module, and a reference to itself:

```julia
julia> Mod3 = Module(:Mod3, false, false)
Main.Mod3

julia> Mod3.Core
ERROR: UndefVarError: Core not defined

julia> Mod3.Base
ERROR: UndefVarError: Base not defined

julia> Mod3.Mod3
ERROR: UndefVarError: Mod3 not defined
```

Code can be evaluated into such modules with `@eval` or `Core.eval`. For example:

```julia
julia> @eval Mod3 add(x, y) = $(+)(x, y)
add (generic function with 1 method)

julia> Mod3.add(1, 2)
3
```

# A Simple Module
Let's create a simple module to use as an example to show the different aspects of a module
in Julia. As a style guide, do not indent the body of a module since that would typically
lead to whole files being indented.

```julia
julia> module Shapes

       global °

       abstract type Shape end
       abstract type Polygon <: Shape end
       abstract type Triangle <: Polygon end

       struct RightTriangle <: Triangle
           base        ::Float64
           height      ::Float64
           hypotenuse  ::Float64
           degrees     ::Int64
           RightTriangle(a, b, c) = a^2+b^2==c^2 ? new(a, b, c, 90) : error()
       end

       function Base.show(io::IO, rt::RightTriangle)
           print(io,
                 "right-△(",
                          "degrees = ",    rt.degrees, "°, ",
                          "base = ",       rt.base, ", ",
                          "height = ",     rt.height, ", ",
                          "hypotenuse = ", rt.hypotenuse, ")"
           )
       end

       area(s::RightTriangle)      = 0.5*s.base*s.height
       perimeter(s::RightTriangle) = s.base+s.height+√(s.base^2 + s.height^2)

       end;
```

# Namespace Management
Namespace management refers to the facilities the language offers for making names in a
module available in other modules.

## Qualified Names
Names for functions, variables, and types in the global scope, like `sin`, `ARGS`, and
`UnitRange`, always belong to a module, called the parent module, which can be found
interactively with `parentmodule`, for example:

```julia
julia> parentmodule(UnitRange)
Base
```

One can also refer to these names outside of their parent module by prefixing them with
their module, for example, `Base.UnitRange`. This is called a **qualified name**. The parent
module may be accessible using a chain of submodules like `Base.Math.sin`, where `Base.Math`
is called the module path. The `Shapes` module, as seen above, is defined in the top-level
`Main` module, so we do not need to install it as a package.

```julia
julia> parentmodule(Shapes)
Main
```

To call any operation from the `Shapes` module, we simply use the qualified name:

```julia
julia> a = Shapes.RightTriangle(3, 4, 5)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)

julia> Shapes.area(a)
6.0

julia> Shapes.perimeter(a)
12.0
```

If a name is qualified, then it is always accessible, and in the case of a function, methods
can also be added to it by using the qualified name as the function name. For example, we
can add an outer constructor method for the `RightTriangle` outside the `Shapes` module:

```julia
julia> function Shapes.RightTriangle(base, height)
           hypotenuse = √(base^2 + height^2)
           Shapes.RightTriangle(base, height, hypotenuse)
       end

julia> a = Shapes.RightTriangle(3, 4)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)
```

Note that variable names within a module cannot be reserved, i.e., they can always be
modified externally. The syntax `M.x = y` in a namespace outside `M`, where `M` is a
`Module` and `x` is a global in `M`, calls `setproperty!(M, :x, y)`, which assigns `y` to
the binding `x` in the module `M`. As an example

```julia
julia> Shapes.°
ERROR: UndefVarError: `°` not defined

julia> Shapes.° = 90;

julia> Shapes.°
90
```

Due to syntactic ambiguities, qualifying a name that contains only symbols, such as an
operator, requires inserting a colon, e.g. `Base.:+`. A small number of operators
additionally require parentheses, e.g., `Base.:(==)`.

## Module APIs & Export Lists
An **API** (an acronym for *"application programming interface"*) is the part of an
application exposed to external sources, thereby enabling two different applications to
communicate with each other. The *exposed part* (i.e. the *interface*) of an application can
be thought of as a *contract of service* laid for any external source that chooses to
communicate with it. This contract defines "how" the two should communicate and the
"boundary" within which the communication should be done.

An API can be considered stable or unstable, depending on the level of guarantee from the
application that its API will only change in defined ways in the future or will not change
at all. A program that uses any part of an API is said to *call* that portion of the API.


One purpose of APIs is to hide the internal details of **"how a system works"**, exposing
only the details of **"what a system does"** to a programmer, and keeping them consistent
even if the internal details later change. The goal when designing a module API is to expose
a correct, secure, standard, consistent, and possibly unchanging programming interface as
the public API of the module that you want other developers to work with.

In Julia, module APIs are created with the `export` keyword, where names (referring to
global variables, constants, functions, and types) are added to the public API via the
`export` keyword. Such names are said to be in an *export list*. Typically, export lists are
at or near the top of the module definition so that readers of the source code can find them
easily. However, this is just a style suggestion, and a module can have multiple export
statements in arbitrary locations.

We can modify our `Shapes` module to make `RightTriangle`, `area`, and `perimeter` a part of
the public API of `Shapes`, as follows:

```julia
module Shapes

export RightTriangle
export area, perimeter

# remaining part of the module stays the same

end
```

Note that, since qualified names always make identifiers accessible, `Shapes.Polygon`, for
example, would still make `Polygon` accessible. Unlike other programming languages, Julia
has no facilities for truly hiding module "internals". `export` is just a mechanism for
organizing APIs.

However, the Julia community has adopted some common practices to indicate that a name is
intended to be a module "internal". They are:

- Names are not `export`ed if they are considered "internal".

- Names are given a prefix and/or suffix e.g. `_polygon`, `polygon_`, `_polygon_`, to
  further suggest that a name is "internal".

It's important to point out that some modules may not `export` names at all. This doesn't
mean such modules have no public API; usually, this is done if they use common names, e.g.,
`derivative`, which could easily clash with the export lists of other modules.

The public API (i.e., export lists) of a `Module` can be seen using `names(m::Module)`,
which will return an array of `Symbol` elements representing the exported bindings:

```julia
julia> names(Shapes)
4-element Vector{Symbol}:
 :RightTriangle
 :Shapes
 :area
 :perimeter
```

`names(m::Module, all = true)` returns symbols for all bindings in `m`, regardless of export
status:

```julia
julia> names(Shapes, all=true)
14-element Vector{Symbol}:
 Symbol("#area")
 Symbol("#eval")
 Symbol("#include")
 Symbol("#perimeter")
 :Polygon
 :RightTriangle
 :Shape
 :Shapes
 :Triangle
 :area
 :eval
 :include
 :perimeter
 :°
```

## Loading A Module
To *load* a module simply means to evaluate it and make its contents available in the
current namespace. This makes the contents of the loaded module act as if they were
initially defined in the current namespace.

Julia has two mechanisms for loading a module:

- **code inclusion** with `include`, which is used if the module is defined in a source
  file. For example: `include("filepathname")`.

- **package loading** with `import` and `using`, which is used if the module is defined in a
  top-level module or it's available in one of the project environment paths listed in
  `LOAD_PATH`. For example: `import ModuleName` or `using ModuleName`.

### Code Inclusion
Code inclusion is straightforward and simple: it evaluates the given source file in the
context of the caller. For example, let's create a file named `Shapes.jl` in our home
directory:

```julia
julia> pwd()
"/Users/JuliaUser"

julia> touch("Shapes.jl")
"Shapes.jl"
```

Then, copy and save the contents of the Shapes module into the `Shapes.jl` file. We can load
the `Shapes.jl` file as follows:

```julia
julia> include("Shapes.jl")
Main.Shapes
```

As seen above, the `Shapes` module is now loaded, and we can use the qualified name to
access the module contents:

```julia
julia> a = Shapes.RightTriangle(3, 4, 5)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)

julia> Shapes.area(a)
6.0
```

Inclusion allows you to split a single program across multiple source files; thus, `include`
is mostly used to include modules into other modules. The statement `include("Shapes.jl")`
causes the contents of the file `Shapes.jl` to be evaluated in the global scope of the
module where the include call occurs. If `include("Shapes.jl")` is called multiple times,
`Shapes.jl` is evaluated multiple times.

The included path, `Shapes.jl`, is interpreted relative to the file where the `include` call
occurs. This makes it simple to relocate a subtree of source files. In the REPL, included
paths are interpreted relative to the current working directory, `pwd()`. Thus, if we change
the current working directory to a different one other than `/Users/JuliaUser`, the program
will throw an error:

```julia
julia> cd("/Users/JuliaUser/Documents")

julia> include("Shapes.jl")
ERROR: SystemError: opening file "/Users/JuliaUser/Documents/Shapes.jl": No such file or directory

julia> rm("/Users/JuliaUser/Shapes.jl")
```

### Package Loading
`using` and `import` are the two ways of loading a module if its defined in a top-level
module like `Main` or available in one of the project environment paths listed in
`LOAD_PATH`.

To load a module from a locally defined module (i.e., a module within a top-level module,
e.g., `Main`), a dot needs to be added before the module name, e.g., `using .ModuleName` and
`import .ModuleName`.

To load a module from a package (i.e., a module available in one of the project environment
paths listed in `LOAD_PATH`), only the module name is needed, e.g., `using ModuleName` and
`import ModuleName`.

With `using` and `import`, if the same module is imported multiple times in the same Julia
session, it's only loaded the first time — on subsequent imports, the importing module gets
a reference to the same module. Note, though, that `import X` can load different packages in
different contexts: `X` can refer to one package named `X` in the main project but
potentially to different packages also named `X` in each dependency.

#### `using`
`using` is used to load a module or package, and it brings the module name and its public
API (i.e. export list) into the surrounding global namespace. This makes the public API of
the module available for direct use. By "direct use", it means there is no need to specify
qualified names before names can be used from a module. When a global variable is
encountered that has no definition in the current module, the system will search for it
among the public API of the loaded module and use it if it is found there.

For example, loading our `Shapes` module defined in the top-level `Main` module would make
`RightTriangle`, `perimeter`, and `area` available for direct use:

```julia
julia> using .Shapes

julia> a = RightTriangle(3, 4, 5)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)

julia> area(a)
6.0

julia> perimeter(a)
12.0
```

Names in the public API and "internals" can also be used via dot syntax (e.g., `Shapes.area`
to access the name `area`), even when the module is loaded with using:

```julia
julia> Shapes.area(a)
6.0

julia> Shapes.perimeter(a)
12.0
```

#### `import`
`import` is used to load a module or package, and it brings only the module name into the
surrounding global namespace. This means that the public API and "internals" will have to be
accessed with dot syntax (e.g., `Foo.foo` to access the name `foo`). Usually, `import` is
used in contexts when the user wants to keep the namespace clean, as this is guaranteed to
always use the name `foo` if called with `Foo.foo`. Unlike `using`, where if the top-level
module has a name `foo` before `using Foo` is called, then `foo` will call the top-level's
`foo`, leading to name conflicts.

For example, loading our `Shapes` module defined in the top-level `Main` module would only
make the module name `Shapes` available. The others would have to be accessed with the dot
syntax:

```julia
julia> import .Shapes
Main.Shapes

julia> a = RightTriangle(3, 4, 5)
ERROR: UndefVarError: RightTriangle not defined

julia> a = Shapes.RightTriangle(3, 4, 5)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)
```

You can also combine multiple `using` and `import` statements of the same kind in a
comma-separated expression, e.g.:

```julia
using LinearAlgebra, Statistics

import Pkg, Test
```

#### `using` And `import` With Specific Identifiers, And Adding Methods
When a module is loaded with a colon (`:`) added to the module name, followed by a list of
comma-separated names, only those specific names are brought into the namespace. For
example, `using ModuleName: name` or `import ModuleName: name1, name2`.

Using our `Shapes` module, we can choose to bring only `RightTriangle` into the current
global namespace:

```julia
julia> using .Shapes: RightTriangle

julia> a = RightTriangle(3, 4, 5)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)

julia> area(a)
ERROR: UndefVarError: area not defined

julia> perimeter(a)
ERROR: UndefVarError: perimeter not defined
```

Note that when a module that is not defined in a top-level module is loaded using this
format in that top-level module, the name of the module will not be in the namespace. For
example, the `Test` package is not defined in the top-level `Main` module; hence, `Test`,
which is the module name, will not be available if loaded in this format:

```julia
julia> using Test: detect_ambiguities

julia> Test
ERROR: UndefVarError: Test not defined

julia> detect_ambiguities
detect_ambiguities (generic function with 1 method)
```

If you want to make it accessible, you have to list it explicitly as part of the imported
names:

```julia
julia> using Test: Test, detect_ambiguities

julia> Test
Test
```

However, the `Shapes` module is defined in the top-level `Main` module; hence, `Shapes` will
always be in the `Main` namespace, even when loaded using this format:

```julia
julia> using .Shapes: RightTriangle

julia> Shapes
Main.Shapes

julia> RightTriangle
RightTriangle
```

Julia has two forms for adding methods to functions already defined in a module, depending
on how the module was loaded:

1. If a module is loaded with `using`, then you need to say `function Foo.bar(...` to extend
   module `Foo`'s function `bar` with a new method.

2. If a module is loaded with `import`, then you only need to say `function bar(...` to
   extend module `Foo`'s function `bar`.

The reason this is important enough to have separate syntax is that you don't want to
accidentally extend a function that you didn't know existed because that could easily cause
a bug. This is most likely to happen with a method that takes a common type like a string or
integer because both you and the other module could define a method to handle such a common
type. If you use `import`, then you'll replace the other module's implementation of
`bar(s::AbstractString)` with your new implementation, which could easily do something
completely different (and break all/many future usages of the other functions in module
`Foo` that depend on calling `bar`). Which one you choose is a matter of style.

As an example, to add an outer constructor to the `RightTriangle` in the `Shapes` module, we
can use either of these syntaxes:

```julia
julia> using .Shapes

julia> function Shapes.RightTriangle(base, height)
           hypotenuse = √(base^2 + height^2)
           Shapes.RightTriangle(base, height, hypotenuse)
       end

julia> RightTriangle(3, 4)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)
```

or

```julia
julia> import .Shapes

julia> function RightTriangle(base, height)
           hypotenuse = √(base^2 + height^2)
           Shapes.RightTriangle(base, height, hypotenuse)
       end
RightTriangle (generic function with 1 method)

julia> RightTriangle(3, 4)
right-△(degrees = 90°, base = 3.0, height = 4.0, hypotenuse = 5.0)
```

Once a variable becomes visible via `using` or `import`, a module cannot create its variable
with the same name. Imported variables are read-only, and assigning to a global variable
always affects the variable owned by the current module, or else raises an error.

### Renaming Identifiers With `as`
An identifier brought into scope by `import` or `using` can be renamed with the keyword
`as`. This is useful for working around name conflicts, as well as for shortening names. For
example, `Base` exports the function name `read`, but the `CSV.jl` package also provides
`CSV.read`. If we are going to invoke `CSV` reading many times, it would be convenient to
drop the `CSV.` qualifier. However, then it becomes ambiguous whether we are referring to
`Base.read` or `CSV.read`:

```julia
julia> read;

julia> import CSV: read
WARNING: ignoring conflicting import of CSV.read into Main
```

Renaming provides a solution:

```julia
julia> read;

julia> import CSV: read as rd;
```

Imported packages themselves can also be renamed. For example:

```julia
import BenchmarkTools as BT
```

brings the imported `BenchMarkTools` package into scope as `BT`.

`as` works with `using` only when individual identifiers are brought into scope. For
example, `using CSV: read as rd` or `using CSV: read as rd, write as wd` works, but
`using CSV as C` does not work since it operates on all the exported names in `CSV`.

### Mixing Multiple `using` and `import` Statements
If `using` and `import` statements, of any of the forms discussed above, are mixed together
in the same module, their effects are combined in the order they appear. For example:

```julia
julia> using .Shapes         # exported names and the module name

julia> import .Shapes: area  # allows adding methods to unqualified functions
```

This would bring in all the exported names of `Shapes` and the module name itself into
scope, and also allow adding methods to `area` without prefixing it with a module name.

### Handling Name Conflicts
Consider the situation where two (or more) packages export the same name, as in:

```julia
julia> module A
       export f
       f() = 1
       end
Main.A

julia> module B
       export f
       f() = 2
       end
Main.B
```

The statement `using .A, .B` works, but when you try to call `f`, you get a warning:

```julia
julia> using .A, .B

julia> f
WARNING: both B and A export "f"; uses of it in module Main must be qualified
ERROR: UndefVarError: `f` not defined
```

Here, Julia cannot decide which `f` you are referring to, so you have to make a choice. The
following solutions are commonly used:

1. Simply proceed with qualified names like `A.f` and `B.f`. This makes the context clear to
   the reader of your code, especially if `f` just happens to coincide but has different
   meaning in various packages. For example, "degree" has various uses in mathematics, the
   natural sciences, and in everyday life, and these meanings should be kept separate.

```julia
julia> A.f
f (generic function with 1 method)

julia> B.f
f (generic function with 1 method)
```

2. Use the `as` keyword to rename one or both identifiers, assuming that you did not use
   `using A` before, which would have brought `f` into the namesapce e.g

```julia
julia> using .A: f as f

julia> using .B: f as g

julia> f
f (generic function with 1 method)

julia> g
f (generic function with 1 method)
```

3. When the names in question do share a meaning, it is common for one module to import it
   from another or have a lightweight "base" package with the sole function of defining an
   interface like this, which can be used by other packages. It is conventional to have such
   package names end in `...Base` (which has nothing to do with Julia's `Base` module).

### Submodules And Relative Paths
Modules are separate namespaces, each introducing a new global scope. This is useful,
because it allows the same name to be used for different functions or global variables
without conflict, as long as they are in separate modules.

Modules can contain submodules, nesting the same syntax `module ... end`. They can be used
to introduce separate namespaces, which can be helpful for organizing complex codebases.

Since each module introduces its own global scope, as explained above, submodules do not
automatically "inherit" names from their parent.

It is recommended that submodules refer to other modules within the enclosing parent module
(including the latter) using **relative module qualifiers** in `using` and `import`
statements.

A *relative module qualifier* starts with a period (`.`), which corresponds to the current
module, and each successive period (`.`) leads to the parent of the current module. This
should be followed by modules if necessary, and eventually the actual name to access, all
separated by periods (`.`).

Consider the following example, where the submodule `SubA` defines a function, which is then
extended in its "sibling" module:

```julia
julia> module ParentModule

       module SubA
       export add_D             # exported interface
       const D = 3
       add_D(x) = x + D
       end

       using .SubA              # brings add_D into the namespace
       export add_D             # export it from ParentModule too

       module SubB
       import ..SubA: add_D     # relative path for a “sibling” module
       struct Infinity end
       add_D(x::Infinity) = x
       end

       end;
```

You may see code in packages that, in a similar situation, use:

```julia
julia> import .ParentModule.SubA: add_D
```

However, this operates through code loading, and thus only works if `ParentModule` is in a
package. It is better to use relative paths.

Note that the order of definitions also matters if you are evaluating values. Consider:

```julia
module TestPackage

export x, y

x = 0

module Sub
using ..TestPackage
z = y # ERROR: UndefVarError: y not defined
end

y = 1

end
```

where `Sub` is trying to use `TestPackage.y` before it was defined, so it does not have a
value.

For similar reasons, you cannot use a cyclic ordering:

```julia
module A

module B
using ..C   # ERROR: UndefVarError: C not defined
end

module C
using ..B
end

end
```

# Module Initialization And Precompilation
Large modules can take several seconds to load because executing all of the statements in a
module often involves compiling a large amount of code. To reduce this time, Julia creates
precompiled caches of the module, and `Base.require`, the implementation of the `import`
statement, is responsible for loading modules and managing the precompilation cache.

Incremental precompiled module files are created and used automatically when using `import`
or `using` to load a module. This causes the module to be automatically compiled the first
time it is imported. Alternatively, you can manually call `Base.compilecache(modulename)`.
The resulting cache files will be stored in `DEPOT_PATH[1]/compiled/`. Subsequently, the
module is automatically recompiled upon `using` or `import` whenever any of its
*dependencies* change. Dependencies are modules it imports, the Julia build, files it
includes, or explicit dependencies declared by `include_dependency(path)` in the module
file(s).

For file dependencies, a change is determined by examining whether the modification time
(`mtime`) of each file loaded by `include` or added explicitly by `include_dependency` is
unchanged or equal to the modification time truncated to the nearest second (to accommodate
systems that can't copy `mtime` with sub-second accuracy). It also takes into account
whether the path to the file chosen by the search logic in `Base.require` matches the path
that had created the precompiled file. Additionally, it takes into account the set of
dependencies already loaded into the current process and won't recompile those modules, even
if their files change or disappear, to avoid creating incompatibilities between the running
system and the precompiled cache.

If you know that a module is not safe to precompile (for example, for one of the reasons
described below), you should put `__precompile__(false)` in the module file (typically
placed at the top). This will cause `Base.compilecache` to throw an error, and
`using`/`import` to load it directly into the current process, skipping the precompilation
and caching. This also prevents the module from being imported by any other precompiled
module.

You may need to be aware of certain behaviors inherent in the creation of incremental shared
libraries, which may require care when writing your module. For example, external state is
not preserved. To accommodate this, explicitly separate any initialization steps that must
occur at runtime from steps that can occur at compile time. For this purpose, Julia allows
you to define an `__init__()` function in your module that executes any initialization steps
that must occur at runtime. This function will not be called during compilation
(`--output-*`). Effectively, you can assume it will be run exactly once in the lifetime of
the code. You may, of course, call it manually if necessary, but the default is to assume
that this function deals with computing state for the local machine, which does not need to
be - or even should not be - captured in the compiled image. It will be called after the
module is loaded into a process, including if it is being loaded into an incremental compile
(`--output-incremental=yes`), but not if it is being loaded into a full-compilation process.

In particular, if you define an `__init__()` function in a module, then Julia will call it
immediately after the module is loaded (e.g., by `import`, `using`, or `Base.require`) at
runtime for the first time (i.e., `__init__` is only called once, and only after all
statements in the module have been executed). Because it is called after the module is fully
imported, any submodules or other imported modules have their `__init__` functions called
before the `__init__` of the enclosing module:

```julia
julia> module Mod1
       function __init__()
           println("Thank you for using ", @__MODULE__)
       end

       module Mod2
       function __init__()
           println("Thank you for using ", @__MODULE__)
       end
       end

       module Mod3
       function __init__()
           println("Thank you for using ", @__MODULE__)
       end
       end

       end;
Thank you for using Main.Mod1.Mod2
Thank you for using Main.Mod1.Mod3
Thank you for using Main.Mod1
```

Two typical uses of `__init__` are calling runtime initialization functions of external C
libraries and initializing global constants that involve pointers returned by external
libraries. For example, suppose that we are calling a C library `libfoo` that requires us
to call a `foo_init()` initialization function at runtime. Suppose that we also want to
define a global constant `foo_data_ptr` that holds the return value of a `void *foo_data()`
function defined by `libfoo` - this constant must be initialized at runtime (not at compile
time) because the pointer address will change from run to run. You could accomplish this by
defining the following `__init__` function in your module:

```julia
const foo_data_ptr = Ref{Ptr{Cvoid}}(0)
function __init__()
    ccall((:foo_init, :libfoo), Cvoid, ())
    foo_data_ptr[] = ccall((:foo_data, :libfoo), Ptr{Cvoid}, ())
    nothing
end
```

Notice that it is perfectly possible to define a global inside a function like `__init__`.
This is one of the advantages of using a dynamic language. But by making it a constant at
the global scope, we can ensure that the type is known to the compiler and allow it to
generate better optimized code. Obviously, any other globals in your module that depend on
`foo_data_ptr` would also have to be initialized in `__init__`.

Constants involving most Julia objects that are not produced by `ccall` do not need to be
placed in `__init__`. Their definitions can be precompiled and loaded from the cached module
image. This includes complicated heap-allocated objects like arrays. However, any routine
that returns a raw pointer value must be called at runtime for precompilation to work (`Ptr`
objects will turn into null pointers unless they are hidden inside an `isbits` object). This
includes the return values of the Julia functions `@cfunction` and `pointer`.

Dictionary and set types, or in general, anything that depends on the output of a
`hash(key)` method, are a trickier case. In the common case where the keys are numbers,
strings, symbols, ranges, `Expr`, or compositions of these types (via arrays, tuples, sets,
pairs, etc.), they are safe to precompile. However, for a few other key types, such as
`Function` or `DataType`, and generic user-defined types where you haven't defined a `hash`
method, the fallback `hash` method depends on the memory address of the object (via its
`objectid`), and hence may change from run to run. If you have one of these key types, or if
you aren't sure, to be safe, you can initialize this dictionary from within your `__init__`
function. Alternatively, you can use the `IdDict` dictionary type, which is specially
handled by precompilation so that it is safe to initialize at compile-time.

When using precompilation, it is important to keep a clear sense of the distinction between
the compilation phase and the execution phase. In this mode, it will often be much more
apparent that Julia is a compiler that allows execution of arbitrary Julia code, not a
standalone interpreter that also generates compiled code.

For more information, see
https://docs.julialang.org/en/v1/manual/modules/#Module-initialization-and-precompilation.

"""
function modules(; extmod=false)
    constants = ["Constants" => ["DEPOT_PATH", "LOAD_PATH", "VERSION"]]
    macros = ["Macros" => ["@__MODULE__", "@assert", "@doc", "@eval", "@time_imports"]]
    methods = [
        "Methods" => [
            "True/False" => ["__precompile__", "isa", "isconst", "isdefined"],
            "Others" => [
                "compilecacheˣ",
                "display",
                "dump",
                "edit",
                "eval",
                "fullname",
                "get_extensionˣ",
                "getglobal",
                "getproperty",
                "identify_package_envˣ",
                "identify_packageˣ",
                "identity",
                "include_string",
                "includeˣ",
                "load_pathˣ",
                "locate_packageˣ",
                "methods",
                "methodswith",
                "modulerootˣ",
                "nameof",
                "names",
                "objectid",
                "parentmodule",
                "pathof",
                "pkgdir",
                "pkgversion",
                "print",
                "println",
                "printstyled",
                "redisplay",
                "repr",
                "requireˣ",
                "setglobal!",
                "show",
                "string",
                "summary",
                "typeassert",
                "typeof",
                "varinfo",
                "which",
            ],
        ],
    ]
    types = ["Types" => ["DataType", "Module"]]
    operators = ["Operators" => ["!", "!=", "!==", "==", "=>", "≠", "≡", "≢", "==="]]
    return _print_names(constants, macros, methods, types, operators)
end
