@doc raw"""
# TYPES
When the word **"type"** is mentioned in computer programming, the possible meanings that
correspond to the everyday use of the word can be narrowed down into two main categories:
*TYPE SYSTEM* and *DATATYPES*.

## Type System
A *TYPE SYSTEM* is simply a set of rules specified as part of a programming language and
built into the language's compiler. It dictates the rules on how the language assigns a
property called a "type" to a "term," how operations on the "term" are carried out (because
of the "type" assigned to it), and the interface on how the language deals with this
property called "type".

Depending on the interface used by the language to deal with "types", it will generally fall
under these concepts or categories:

- *TYPE SAFETY* determines that no operation leads to undefined behavior:
  **weak (a.k.a loosely) vs strong**.

- *TYPE CHECKING* determines when the type-safety of a program is verified:
  **static vs dynamic**.

- *TYPE EXPRESSIONS* determines how types declarations are to be made:
  **explicit (a.k.a manifest) vs implicit (a.k.a type inference)**.

- *TYPE COMPATIBILITY & EQUIVALENCE* determines which types are considered the same and
  hence compatible with each other: **structural vs nominative**.

- *POLYMORPHISM* determines how variables, functions and objects can take up multiple forms:
  **ad hoc vs parametric**.

- *DYNAMIC DISPATCH* determines the process of selecting which implementation of a
  polymorphic operation to call at runtime: **single vs multiple**.

Describing Julia in the context of type systems as described above, it is:

- Strong (operations with no defined behaviour throws a type or method error).

- Dynamic (type checks are done during runtime).

- Implicit with optional explicit (variables are not required to be declared with types,
  but can be done if required).

- Nominative (types must have the same name in order to be equal).

- Parametric (a generic type can be defined with variables instead of actual types and then
  instantiated with specific types as needed).

- Multi-method a.k.a multiple-dispatch (methods are dynamically dispatched on all of its
  arguments)

High-level aspects of Julia's type system are:

- *There is no division between object and non-object values*: all values in Julia are true
  objects having a type that belongs to a single, fully connected type graph, all nodes of
  which are equally first-class as types.

- *There is no meaningful concept of a "compile-time type"*: the only type a value has is
  its actual type when the program is running. This is called a "run-time type" in
  object-oriented languages where the combination of static compilation with polymorphism
  makes this distinction significant.

- *Only values, not variables, have types*: variables are simply names bound to values,
  although we may say "type of a variable" as shorthand for "type of the value to which a
  variable refers" for simplicity.

- *Concrete types may not subtype each other*: all concrete types are final and may only
  have abstract types as their supertypes.

- *Abstract & concrete types can be parameterized by other types*: They can also be
  parameterized by symbols, by values of any type for which `isbits` returns true
  (essentially, things like numbers and bools that are stored like C types or structs with
  no pointers to other objects), and by tuples thereof.

- *Type parameters may be omitted*: Though abstract and concrete types can be parameterized
  by other types, the parameters may be omitted when they do not need to be referenced or
  restricted.

## How is Explicit Type Declaration Done?
Adding type annotations (i.e explicit declaration) serves 4 primary purposes in Julia:

- **clarity**: to improve human readability.
- **correctness**: to catch programmer errors.
- **dispatch**: to take advantage of Julia's powerful multiple-dispatch mechanism.
- **speed in some cases:** to provide extra type information to the compiler, which can then
  improve performance in some cases.

Type annotations are appended to expressions using the `::` operator; the `::` operator is
read as "is an instance of". See `::` in `help?>` mode for info on how type annotations
work.

## DataTypes
The word "DataType" is a combination of two words: "Data" and "Type". At the simplest level,
it simply refers to a "data" and the "type" that is assigned to it. For example, if X is a
"data" and its "type" is an INTEGER, we can say that INTEGER is a "datatype" because it is a
"type" that is assigned to the "data" X. We can also omit "data" from "datatype" and just
say INTEGER is a "type", which means the same thing.

However, the above description alone is not complete and can lead to confusion when we come
across types that are not assigned to any data, such as abstract types. Despite not having
any instances, abstract types are also considered DATATYPES in the programming world.
Therefore, a better and more general description of a DATATYPE is that it is simply a
classification of data or type.

This classification is used within type systems to tell the compiler how the programmer
intends to use the data or type. It defines the set of possible values that it can take and
store, as well as the operations that can be performed on it. All programs are composed of
two items: **Data** and **Operations** on that **Data**. Therefore, all complex information
must be built up from DataTypes.

In type theory, there is a "top" type, which is at the apex of the type graph, and a
"bottom" type, which is at the nadir of the type graph. In Julia:

- `Any` is the predefined abstract type that all objects are instances of, and all types are
  subtypes of, i.e. the "top".

- `Union{}` is the exact opposite of Any: no object is an instance of Union{}, and all types
  are supertypes of `Union{}`, i.e. the "bottom".

- `DataType` is the object that represents all types in Julia. That is, every concrete value
  in the system is an instance of some `DataType`.

### Classification Of DataTypes
The differrent datatypes implemented in the language are:

- Abstract Types
- Primitive Types
- Composite Types
- Parametric Types
- UnionAll Types
- Union Types
- Function Types
- Type{T} type selectors
- "Value Types"

## Abstract Types
In Julia, an abstract data type is a data type that provides the default implementation for
a concrete type, without specifying the concrete representation of the data.

These types cannot be instantiated, but they serve as nodes in a type graph. They describe a
set of related concrete types, which are their subtypes. This hierarchy of types provides a
context in which different concrete types can fit.

The general syntax for declaring an abstract type is:

```
abstract type «name» end
abstract type «name» <: «supertype» end
```

The `abstract type` keyword introduces a new abstract type named `«name»`. This name may
optionally be followed by `<:` and an already-existing type, indicating that the new
abstract type is a subtype of this "parent" type. When no `«supertype»` is given, the
default supertype is `Any`.

Using a function with abstract type arguments doesn't result in a loss of performance
because the function is recompiled for each tuple of concrete types with which it is
invoked. However, there may be a performance issue with function arguments that are
containers of abstract types.

## Primitive Types
A primitive type is a concrete type whose data consists of plain old bits. Classic examples
of primitive types are integers and floating-point values.

The general syntax for declaring a primitive type is:

```
primitive type «name» «bits» end
primitive type «name» <: «supertype» «bits» end
```

The number of `«bits»` indicates how much storage the type requires and the `«name»` gives
the new type a name. A primitive type can optionally be declared to be a subtype of some
`«supertype»`. If a `«supertype»` is omitted, then the type defaults to having `Any` as its
immediate supertype.

Unlike most languages, Julia lets you declare your own primitive types, rather than
providing only a fixed set of built-in ones. In fact, the standard primitive types are all
defined in the language itself. Currently, only sizes that are multiples of `8` bits are
supported and you are likely to experience LLVM bugs with sizes above `128`.

## Composite Types
In Julia, a composite type is a collection of named fields, an instance of which can be
treated as a single value. All values are objects in Julia, but functions are not bundled
with the objects they operate on, as we usually see in languages like C++ that use classes.

The general syntax for declaring a composite type is (for mutable types, use
`mutable struct` in place of `struct`):

```
struct «name»
    # fields here
end

struct «name» <: «supertype»
    # fields here
end
```

The `struct` or `mutable struct` keyword introduces a new composite type, whose name is
given by `«name»`. This name can be optionally followed by `<:` and an already-existing
type, indicating that the newly declared composite type is a subtype of this "parent" type.
When no `«supertype»` is given, the default supertype is `Any`. As said earlier, only
abstract types can be subtyped, so if provided, `«supertype»` must be an abstract type;
otherwise, an error is thrown.

Fields are optional (i.e., we can have composite types that have no fields; these are called
singleton types). However, when fields are provided, they can be optionally annotated with
types (and when no type annotations are added, they default to `Any`). A composite type
declared with `struct` cannot have the field values changed once instantiated; the opposite
is the case for composite types declared with `mutable struct`.

Instances of composite types are instantiated using the `«name»` of the composite type as a
function, with its field values as the arguments; when this happens, the type is said to be
used as a constructor.

#### Important Notes On Immutability & Mutability Of Composite Types
- An immutable object might contain mutable objects, such as arrays, as fields. Those
  contained objects will remain mutable; only the fields of the immutable object itself
  cannot be changed to point to different objects.

- In cases where one or more fields of an otherwise mutable struct is known to be immutable,
  one can declare these fields as such using `const`. This enables some, but not all of the
  optimizations of immutable structs, and can be used to enforce invariants on the
  particular fields marked as `const`.

- If all the fields of an immutable structure are indistinguishable (`===`), then two
  immutable values containing those fields are also indistinguishable.

- Immutable composite types with no fields are called singletons. Formally, if `T` is an
  immutable composite type defined with `struct`, such that `a isa T && b isa T` implies
  `a === b`, then `T` is a singleton type. `Base.issingletontype` can be used to check if a
  type is a singleton type. Abstract types cannot be singleton types by construction
  (although they contain no fields).

#### Accessing The Field Of A Composite Object
- You can access the field name(s) of a composite object using `fieldname` or `fieldnames`.
- You can access the field type(s) of a composite object using `fieldtype` or `fieldtypes`.
- You can access the field value of a composite object using the traditional dot notation,
  `«objectname».«fieldname»`.

#### Default Constructors For Composite Types
Two default constructors are generated automatically for every composite type:

- One accepts arguments that match the field types exactly.
- The other accepts any arguments and calls `convert` to convert them to the types of the
  fields.

For example:

```julia
julia> struct Foo
           a
           b::Int
           c::Float64
       end

julia> Foo("Hello, world.", 122, 1.5)
Foo("Hello, world.", 122, 1.5)

julia> Foo("Hello, world.", 'z', 1.5)  # `z` is converted to Int64
Foo("Hello, world.", 122, 1.5)
```

#### Outer Constructors For Composite Types
Outer constructors can be created if needed. This is done by creating a function with the
same name as the composite type and having it call the default constructors. It can also
call an outer constructor, provided the outer constructor inherently calls the default
constructor:

```julia
julia> struct Foo
           a
           b
       end

julia> Foo(2, 5)             # default constructor
Foo(2, 5)

julia> Foo(x) = Foo(x, x)    # Foo(x) becomes an outer constructor
Foo

julia> Foo(1)
Foo(1, 1)

julia> Foo() = Foo(0)        # Foo() becomes an outer constructor
Foo

julia> Foo()
Foo(0, 0)
```

Here the zero-argument constructor method, `Foo()`, calls the single-argument constructor
method, `Foo(x)`, which, in turn, calls the default constructors provided, `Foo(a, b)`.

#### Inner Constructors For Composite Types
An inner constructor method is like an outer constructor method, except for two differences:

- It is declared inside the block of a type declaration, rather than outside of it like
  normal methods.
- It has access to a special locally existent function called `new` that creates objects of
  the block's type.

Among other use cases, an inner constructor for composite types is mostly used to address
two case:

- To enforce invariants.
- To allow construction of self-referential objects.

A few notes about inner constructors:

- If any inner constructor method is defined, no default constructor method is provided; it
  is presumed that you have supplied yourself with all the inner constructors you need.

- Once a type is declared, there is no way to add more inner constructor methods. This gives
  some degree of enforcement of a type's invariants (if provided) because outer constructors
  can only create objects by calling inner constructors one way or the other. Thus we are
  guaranteed that our invariants in the inner constructor will always hold.

- We cannot have functions inside types. In Julia, `obj.x` means "take a property from obj
  named x"; it doesn't mean "take a function from obj named x". Providing a function with a
  different name from the composite type as an inner constructor ultimately means that the
  composite type cannot be instantiated.

##### Enforcing Invariants
For example, suppose we want to declare a type that holds a pair of real numbers, but then
we want to **enforce the invariant** that the first number must be less than or equal to the
second number, otherwise we won't allow creating this type. We could declare it like this:

```julia
julia> struct OrderedPair
           x::Real
           y::Real
           OrderedPair(x, y) = x > y ? error("out of order") : new(x, y)
       end
```

Now `OrderedPair` objects can only be constructed such that `x <= y`:

```julia
julia> OrderedPair(1, 2)
OrderedPair(1, 2)

julia> OrderedPair(2, 2)
OrderedPair(2, 2)

julia> OrderedPair(2, 1)
ERROR: out of order
```

##### Allowing Construction Of Self-Referential Objects
An example of a self-referential object is a recursive data structure. The fundamental
difficulty may not be immediately obvious. Let us briefly explain it. Consider the following
recursive type declaration:

```julia
julia> mutable struct SelfReferential
           obj::SelfReferential
       end
```

This type may appear to be harmless at first until one considers how to construct an
instance of it. If `a` is an instance of `SelfReferential`, then a second instance can be
created by the call: `b = SelfReferential(a)`.

But how does one construct the first instance when no instance exists to provide as a valid
value for its `obj` field? The only solution is to allow creating an incompletely
initialized instance of `SelfReferential` with an unassigned `obj` field and using that
incomplete instance as a valid value for the `obj` field of another instance, such as, for
example, itself.

To allow for the creation of incompletely initialized objects, Julia allows the `new`
function to be called with fewer than the number of fields that the type has, returning an
object with the unspecified fields uninitialized. The inner constructor method can then use
the incomplete object, finishing its initialization before returning it. Here, for example,
is another attempt at defining the `SelfReferential` type, this time using a zero-argument
inner constructor returning instances having `obj` fields pointing to themselves:

```julia
julia> mutable struct SelfReferential
           obj::SelfReferential
           SelfReferential() = (x = new(); x.obj = x)
       end
```

We can verify that this constructor works and constructs objects that are, in fact,
self-referential:

```julia
julia> x = SelfReferential();

julia> x === x
true

julia> x === x.obj
true

julia> x === x.obj.obj
true
```

Although it is generally a good idea to return a fully initialized object from an inner
constructor, it is possible to return incompletely initialized objects. While you are
allowed to create objects with uninitialized fields, any access to an uninitialized
reference is an immediate error:

```julia
julia> mutable struct Incomplete
           data
           Incomplete() = new()
       end

julia> z = Incomplete();

julia> typeof(z)
Incomplete

julia> z.data
ERROR: UndefRefError: access to undefined reference
```

This avoids the need to continually check for null values. However, not all object fields
are references. Julia considers some types to be "plain data", meaning all of their data is
self-contained and does not reference other objects. The plain data types consist of
primitive types (e.g., `Int`) and immutable structs of other plain data types. `Array`s of
plain data types exhibit the same behavior. The initial contents of a plain data type is
undefined:

```julia
julia> struct HasPlain
           n::Int
           HasPlain() = new()
       end

julia> HasPlain()
HasPlain(438103441441)
```

You can pass incomplete objects to other functions from inner constructors to delegate their
completion:

```julia
julia> mutable struct Lazy
           data
           Lazy(v) = complete_me(new(), v)
       end
```

As with incomplete objects returned from constructors, if `complete_me` or any of its
callees try to access the `data` field of the `Lazy` object before it has been initialized,
an error will be thrown immediately.

### Declared Types
The three kinds of types (abstract, primitive, composite) discussed above are actually all
closely related. They share the same key properties:

- They are explicitly declared.
- They have names.
- They have explicitly declared supertypes.
- They may have parameters.

Because of these shared properties, these types are internally represented as instances of
the same concept, `DataType`, which is the type of any of these types. Calling `typeof` on
any of these types would return `DataType`.

A `DataType` may be abstract or concrete. If it is concrete, it has a specified size,
storage layout, and (optionally) field names. Thus a primitive type is a `DataType` with
nonzero size, but no field names. A composite type is a `DataType` that has field names or
is empty (zero size). As earlier stated, every concrete value in the system is an instance
of some `DataType`.

## Parametric Types
All declared types (i.e., the `DataType` variety) can be parameterized.

## Parametric Composite Types
The general syntax for declaring a parametric composite type is (for mutable types, use
`mutable struct` in place of `struct`):

```
struct «name»{«type_parameter»}
    # fields here
end

struct «name»{«type_parameter»} <: «supertype»
    # fields here
end
```

The declaration is the same as for a composite type, with the exception of the
`«type_parameter»` and curly braces, `{}`, which are introduced. Type parameters are
introduced immediately after `«name»`, surrounded by curly braces, `{}`:

```julia
julia> struct Point{T}
           x::T
           y::T
       end
```

This declaration defines a new parametric composite type, `Point{T}`, holding two
"coordinates" of type `T`. `T` can be any type at all or a value of any bits type (here it's
clearly used as a type, since its type annotated to the fields of `Point`).

Using the parametric type defined above as an example to explain parametric composite types
in Julia:

- `Point{Float64}` is a concrete type equivalent to the type defined by replacing `T` in the
  definition of `Point` with `Float64`. Thus, `Point{Float64}`, `Point{AbstractString}`,
  `Point{Int64}`, etc., are all usable concrete types.

- Parametric composite types are valid type objects whose `typeof` are `UnionAll`, and they
  contain all of their instances as subtypes: `Point{Float64} <: Point` is true.

- Type parameters are invariant, so concrete parametric types with different values
  of "type parameters" are never subtypes of each other. So, even though `Float64 <: Real`
  returns `true`, `Point{Float64} <: Point{Real}` doesn't.

- Type parameters for parametric composite types can be restricted. For example,
  `Point{T<:Real}` restricts `T` to only be subtypes of `Real`; so `Point{Float64}` is
  valid, but `Point{String}` isn't. `Point{T<:Real}` can be shortened as `Point{<:Real}`.

- The notation `Point{<:Real}` can be used to express the Julia analogue of a covariant
  type, while `Point{>:Int}` is the analogue of a contravariant type, but technically these
  represent sets of types: `Point{Float64} <: Point{<:Real}` and
  `Point{Real} <: Point{>:Int}` are both true.

- Like composite types, immutable parametric composite types with no fields are called
  singletons. That is, for a parametric composite type without any field, say
  `NoFieldsParam{T}`, `NoFieldsParam{Int}` is a singleton; however, `NoFieldsParam` isn't a
  singleton because it has mutiple instances.

An important point to note is this: since Julia's type parameters are invariant as explained
above, the following method can't be applied to arguments of type `Point{Float64}`:

```julia
norm(p::Point{Real}) = sqrt(p.x^2 + p.y^2)
```

The correct way to define such a method is:
```julia
norm(p::Point{<:Real}) = sqrt(p.x^2 + p.y^2)
```

#### Default Constructor For Parametric Composite Types
Every parametric composite type comes with two default constructors:

- The first one accepts type parameters and arguments. The arguments are converted to the
  specified type parameter using `convert`.

- The second constructor deduces the type parameters from the arguments of the object
  constructor, i.e., all the arguments are of the same concrete type.

As an example:

```julia
julia> struct Point{T}
           x::T
           y::T
       end

julia> Point{Float32}(1, 2)
Point{Float32}(1.0, 2.0)

julia> Point(1, 2)
Point{Int64}(1, 2)
```

#### Outer Constructors For Parametric Composite Types
When using the default constructors provided for parametric composite types, we are faced
with an issue: if we choose not to explicitly call on the type parameter but imply them,
they have to be of the same type. For example, `Point(1, 2.0)`, `Point(2.0, 5)`, and
`Point(2, 3//5)` all fail.

The way to concisely and effectively solve this is to define an outer constructor and then
promote the different types to be the same type:

```julia
julia> struct Point{T<:Real}
           x::T
           y::T
       end

julia> Point(x::Real, y::Real) = Point(promote(x, y)...)
Point

julia> Point(1, 2.0)
Point{Float64}(1.0, 2.0)

julia> Point(2, 3//5)
Point{Rational{Int64}}(2//1, 3//5)

julia> Point(2.0, 3//5)
Point{Float64}(2.0, 0.6)
```

Note that outer constructors with arguments type annotated to become similar to the default
constructors provided for the parametric composite types would throw an error as it would
lead to calling the method twice. For example:

```julia
julia> struct Point{T}
           x::T
           y::T
       end

julia> Point(x::Real, y::Real) = Point(promote(x, y)...)
Point

julia> Point(1, 2.0)
ERROR: StackOverflowError:
Stacktrace:
 [1] Point(x::Float64, y::Float64) (repeats 2 times)
```

#### Inner Constructors For Parametric Composite Types
Outer constructors call inner constructors to actually make instances. However, in some
cases, one would rather not provide inner constructors so that specific type parameters
cannot be requested manually.

For example, let's say we define a `SummedArray` that stores a vector along with an accurate
representation of its sum, but we always want the type of the summed value to be larger than
the vector type, so there's no information loss. That is, we want to avoid an interface that
allows the user to construct instances of the type `SummedArray{Int8, Int8}`. One way to do
this is to provide a constructor only for `SummedArray`, but inside the struct definition
block, suppress generation of default constructors:

```julia
julia> struct SummedArray{T<:Number, S<:Number}
           data::Vector{T}
           sum::S
           function SummedArray(a::Vector{T}) where T
               S = widen(T)
               new{T, S}(a, sum(S, a))
           end
       end

julia> SummedArray(Int8[1; 2; 3], Int8(6))
ERROR: MethodError: no method matching SummedArray(::Vector{Int8}, ::Int8)

julia> SummedArray(Int8[1; 2; 3])
SummedArray{Int8, Int16}(Int8[1, 2, 3], 6)
```

The syntax `new{T, S}` allows specifying parameters for the type to be constructed, i.e.,
this call will return a `SummedArray{T, S}`. `new{T, S}` can be used in any constructor
definition, but for convenience, the parameters to `new{}` are automatically derived from
the type being constructed when possible. These constructors are
called *"outer-only constructors".*

## Parametric Abstract Types
The general syntax for declaring an abstract primitive type is:

```
abstract type «name»{«type parameter»} end
abstract type «name»{«type parameter»} <: «supertype» end
```

Parametric abstract type declarations declare a *collection* of abstract types:

```julia
julia> abstract type Pointy{T} end
```

With this declaration, `Pointy{T}` is a distinct abstract type for each type or value of
`T`. As with parametric composite types, each such instance will be a subtype of `Pointy`:

```julia
julia> Pointy{Int64} <: Pointy
true

julia> Pointy{1} <: Pointy
true
```

Constraining the range of `T` to not range freely over all types works as it does for
composite types, e.g., `Pointy{T<:Real}`, `Pointy{T:>Int}`. Parametric abstract types are
also invariant, just as parametric composite types are, e.g.,
`Pointy{Float64} <: Pointy{Real}` returns `false`.

Much like plain old abstract types serve to create a useful hierarchy of types over concrete
types, parametric abstract types serve the same purpose with respect to parametric composite
types (i.e., only parametric composite types can subtype parametric abstract types):

```julia
julia> struct Point{T} <: Pointy{T}
           x::T
           y::T
       end

julia> supertype(Point)
Pointy

julia> supertype(Point{T} where T)
Pointy

julia> supertype(Point{Float64})
Pointy{Float64}
```

What purpose do parametric abstract types like `Pointy` serve? Consider if we create a
point-like implementation that only requires a single coordinate because the point is on the
diagonal line `x = y`:

```julia
julia> struct DiagPoint{T} <: Pointy{T}
           x::T
       end
```

Now, both `Point{Float64}` and `DiagPoint{Float64}` are implementations of the
`Pointy{Float64}` abstraction, and similarly for every other possible choice of type `T`.
This allows programming to a common interface shared by all `Pointy` objects, implemented
for both `Point` and `DiagPoint`.

## Parametric Primitive Types
The general syntax for declaring a primitive parametric type is:

```
primitive type «name»{«type_parameter»} «bits» end
primitive type «name»{«type parameter»} <: «supertype» «bits» end
```

For example:

```julia
primitive type Ptr{T} 64 end
```

Unlike typical parametric composite types, the type parameter `T` is not used in the
definition of the type itself - it is just an abstract tag, essentially defining an entire
family of types with identical structure, differentiated only by their type parameter. Thus,
`Ptr{Float64}` and `Ptr{Int64}` are distinct types, even though they have identical
representations. And of course, all specific pointer types e.g. `Ptr{Float64}`,
`Ptr{Int64}`, etc., are subtypes of the umbrella `Ptr` type.

## UnionAll
All parametric types in Julia are `UnionAll` types. Such a type expresses the iterated union
of types for all values of some parameter.

`UnionAll` types are written using the keyword `where`, e.g. `Ptr{T} where T`, meaning all
values whose type is `Ptr{T}` for some value of `T`. Here, the parameter `T` is also called
a "type variable" since it is like a variable that ranges over types. Each `where`
introduces a single type variable, so these expressions are nested for types with multiple
parameters, for example `Array{T, N} where N where T`.

The type application syntax `A{B, C}` requires `A` to be a `UnionAll` type, and first
substitutes `B` for the outermost type variable in `A`; the result is expected to be another
`UnionAll` type, into which `C` is then substituted to produce a `DataType`. So `A{B, C}` is
equivalent to `A{B}{C}`:

```julia
julia> struct A{B, C}
           x::B
           y::C
       end

julia> typeof(A)
UnionAll

julia> typeof(A{Float64})
UnionAll

julia> typeof(A{Float64, Int64})  # same as A{Float64}{Int64}
DataType
```

This explains why it is possible to partially instantiate a type, as in `Array{Float64}`:
the first parameter value has been fixed, but the second still ranges over all possible
values. However, using an explicit `where` syntax, any subset of parameters can be fixed,
e.g. the type of all 1-dimensional arrays can be written as `Array{T, 1} where T`.

Using `where`:

- Type variables can be restricted with subtype relations, e.g. `Array{T} where T<:Integer`.

- Type variables can have both lower and upper bounds, e.g. `Array{T} where Int<:T<:Number`,
  `Array{>:Int}`.

- Type variable bounds can refer to outer type variables, e.g. in
  `Tuple{T, Array{S}} where S <: AbstractArray{T} where T<:Real`, `T` is some `Real`, and
  `S` is some Array whose elements contain `T`.

The `where` keyword itself can be nested inside a more complex declaration. For example:

```julia
const T1 = Array{Array{T, 1} where T, 1}

const T2 = Array{Array{T, 1}, 1} where T
```

where `T1` is a concrete type, and `T2` is an abstract type.

There's a convenient syntax for aliasing parametric types, e.g. `Vec{T} = Array{T, 1}`,
which is equivalent to `const Vec = Array{T, 1} where T`. Writing `Vec{Float64}` is
equivalent to writing `Array{Float64, 1}`, and the umbrella type `Vec` will have as
instances all `Array` objects where the second parameter - the number of array dimensions -
is `1`, regardless of what the element type is.

## Union Types
A union type is a special abstract type that includes all instances of any of its argument
types, constructed using the `Union` keyword:

```julia
julia> IntOrString = Union{Int, String}
Union{Int64, String}

julia> 1::IntOrString
1

julia> "Hello!"::IntOrString
"Hello!"

julia> 1.0::IntOrString
ERROR: TypeError: in typeassert, expected Union{Int64, String}, got a value of type Float64
```

A particularly useful case of a `Union` type is `Union{T, Nothing} where T`; here, `T` can
be any type, and `Nothing` is the singleton type whose only instance is the object
`nothing`. This pattern is the Julia equivalent of "Nullable", "Option," or "Maybe" types in
other languages. Declaring a function argument or a field as `Union{T, Nothing} where T`
allows setting it either to a value of type `T` or to `nothing` to indicate that there is no
value.

## Functions Types
Functional programming languages treat functions as a distinct datatype; that is, they are
first-class objects. In Julia, each function has its own type, which is a subtype of the
`Function` datatype:

```
julia> foo(x) = x + 1
foo (generic function with 1 method)

julia> typeof(foo)
typeof(foo) (singleton type of function foo41, subtype of Function)
```

Note how `typeof(foo)` prints itself. This is merely a convention for printing, as it
is a first-class object that can be used like any other value:

```julia
julia> T = typeof(foo)
typeof(foo) (singleton type of function foo, subtype of Function)

julia> T <: Function
true
```

Closures also have their own type, which is usually printed with names that end in
`#<number>`. Names and types for closure functions defined at different locations are
distinct, but not guaranteed to be printed the same way across sessions:

```julia
julia> typeof(x -> x + 1)
var"#1#2"

julia> typeof(x -> x + 1)
var"#3#4"
```

A type `T` is a singleton if `T` is an immutable composite type, i.e., defined with
`struct`, and `a isa T && b isa T` implies `a === b`. This then means:

- types of functions defined at top-level are singletons.
- types of closures are not necessarily singletons.

## Types{T} type selectors
For each type `T`, `Type{T}` is an abstract parametric type whose only instance is the
object `T`.

- `A isa Type{B}` is `true` if and only if `A` and `B` are the same object and that object
  is a type. For example, `Int64 isa Int64` is `false`, but `Int64 isa Type{Int64}` is
  `true`.

- Without the parameter, `Type` is simply an abstract type which has all type objects as its
  instances (but not subtypes). For example, `Float64 isa Type` is `true`, but
  `Float64 <: Type` is `false`.

- Any object that is not a type is not an instance of `Type`. For example,`` 1.5 isa Type`
  is false.

This allows one to specialize function behavior on specific types as values. Methods can be
written, especially parametric ones, such that their behavior depends on a type that is
given as an explicit argument rather than implied by the type of one of its arguments. For
example, `lastvalue(::Type{Int64}) = typemax(Int64)` would only work when `Int64` is
explicitly passed as the argument.

Another important use case for `Type` is sharpening field types which would otherwise be
captured less precisely and could lead to performance problems in code relying on the
precise wrapped type (similarly to containers of abstract type parameters):

```julia
julia> struct WrapType{T}
           value::T
       end
```

The default constructor:

```julia
julia> WrapType(Float64)        # note DataType
WrapType{DataType}(Float64)
```

The sharpened constructor:

```
julia> WrapType(::Type{T}) where {T} = WrapType{Type{T}}(T)
WrapType

julia> WrapType(Float64)        # note more precise Type{Float64}
WrapType{Type{Float64}}(Float64)
```

## "Values Types"
In Julia, you can't dispatch on a value such as `true` or `false`. However, you can
dispatch on parametric types, and Julia allows you to include "plain bits" values
(`Type`s, `Symbols`, `Integer`s, floating-point numbers, tuples, etc.) as type parameters.
A common example is the dimensionality parameter in `Array{T, N}`, where `T` is a type
(e.g., `Float64`) but `N` is just an `Int`.

You can create your own custom types that take values as parameters and use them to control
dispatch of custom types. To illustrate this idea, let's introduce a parametric type,
`Val{x}`, and a constructor `Val(x) = Val{x}()`, which serves as a customary way to exploit
this technique for cases where you don't need a more elaborate hierarchy:

```julia
julia> struct Val{x} end

julia> Val(x) = Val{x}()    # outer constructor
Val
```

There is no more to the implementation of `Val` than this. Some functions in Julia's
standard library accept `Val` instances as arguments, and you can also use it to write your
own functions. For example:

```julia
julia> firstlast(::Val{true}) = "First"
firstlast (generic function with 1 method)

julia> firstlast(::Val{false}) = "Last"
firstlast (generic function with 2 methods)

julia> firstlast(Val(true))
"First"

julia> firstlast(Val(false))
"Last"
```

It's important to note that you would never want to write actual code as illustrated above.
For more information about the proper (and improper) uses of `Val`, please read the more
extensive discussion in the performance tips of Julia's documentation.

## Type Aliasing
Sometimes it is convenient to introduce a new name for an already expressible type. This can
be done with a simple assignment statement, e.g. `const Vec = Array{T, 1} where T`.

`Int`, `UInt`, `ComplexF64`, `Vector`, etc., are some examples of built-in type aliases in
the langauge.

## Custom Pretty-Printing
Often, one wants to customize how instances of a type are displayed; this can be
accomplished by overloading the `show` function. To learn how this works, as well as how to
extend it to new types, see:
https://docs.julialang.org/en/v1/manual/types/#man-custom-pretty-printing.

## Conversion And Promotion Of Types
Julia has a system for promoting arguments of operators, functions, types, and methods to a
common type. In most programming languages, this is "hidden" from the programmer. However,
in Julia, this system is open for everyone to see. To learn how this promotion system works,
as well as how to extend it to new types and apply it to functions besides built-ins, see:
https://docs.julialang.org/en/v1/manual/conversion-and-promotion/.
"""
function types(;extmod=false)
    constants = [
        "Constants" => [
            "Bottomˣ", "Vararg"
        ]
    ]
    macros = [
        "Macros" => [
            "@MIME_str", "@assert", "@atomic", "@atomicreplace", "@atomicswap", "@doc",
            "@kwdef", "@show", "@showtime",
        ]
    ]
    methods = [
        "Methods" => [
            "In-Place"        => [
                "modifyfield!", "modifyproperty!", "replacefield!", "replaceproperty!",
                "setfield!", "setproperty!", "swapfield!", "swapproperty!"
            ],
            "Field"           => [
                "fieldcount", "fieldindexˣ", "fieldname", "fieldnames", "fieldoffset",
                "fieldtype", "fieldtypes"
            ],
            "True/False"      => [
                "datatype_haspaddingˣ", "datatype_pointerfreeˣ", "has_bottom_parameterˣ",
                "hasfastinˣ", "hasfield", "hasmethod", "hastypemaxˣ", "isa",
                "isabstracttype", "isbitstype", "isbitsunionˣ", "isconcretetype",
                "isdispatchtuple", "isiterableˣ", "ismutabletype", "isprimitivetype",
                "issingletontypeˣ", "isstructtype", "isvalid"
            ],
            "Type-Conversion" => [
                "big", "cconvertˣ", "ceil", "complex", "convert", "float", "trunc",
                "typeintersect", "typejoin", "unsafe_convertˣ", "unsafe_trunc", "widen"
            ],
            "Type-Promotion"  => [
                "promote_opˣ", "promote_rule", "promote_type", "promote_typejoinˣ"
            ],
            "Others"          => [
                "bitsunionsizeˣ", "bodyfunctionˣ", "clamp", "code_ircode_by_typeˣ",
                "code_ircodeˣ", "code_lowered", "code_typed", "code_typed_by_typeˣ",
                "collect", "complex", "convert", "datatype_alignmentˣ",
                "datatype_fielddesc_typeˣ", "datatype_nfieldsˣ", "display", "dump", "eps",
                "elsizeˣ", "eltype", "exponent_maxˣ", "exponent_raw_maxˣ", "floatmax",
                "floatmin", "floor", "getfield", "getindex", "getproperty", "identity",
                "instances", "keytype", "maxintfloat", "methods", "methodswith", "nameof",
                "nfields", "nonmissingtype", "objectid", "one", "ones", "oneunit",
                "paddingˣ", "parse", "precision", "print", "print_statement_costsˣ",
                "println", "printstyled", "real", "redisplay", "reinterpret", "rem", "repr",
                "round", "rounding", "setprecision", "show", "showable", "sizeof", "stack",
                "string", "subtypes", "supertype", "supertypes", "summary", "summarysizeˣ",
                "typeassert", "typeof", "typemax", "typemin", "which", "zero"
            ]
        ]
    ]
    types = [
        "Types" => [
            "AbstractArray", "AbstractChannel", "AbstractChar", "AbstractDict",
            "AbstractDisplay", "AbstractFloat", "AbstractIrrational", "AbstractLockˣ",
            "AbstractMatch", "AbstractPattern", "AbstractPipeˣ", "AbstractSet",
            "AbstractSlices", "AbstractString", "AbstractUnitRange", "AbstractVecOrMat",
            "AbstractVector", "AlwaysLockedSTˣ", "Any", "AnyDictˣ", "Array",
            "ArgumentError", "AssertionError", "AsyncCollectorˣ", "AsyncConditionˣ",
            "AsyncGeneratorˣ", "BigFloat", "BigInt", "BitArray", "BitMatrix", "BitSet",
            "BitVector", "Bitsˣ", "Bool", "BoundsError", "BottomRFˣ", "CFunctionˣ",
            "CartesianIndex", "CartesianIndices", "Cchar", "Char", "Cdouble", "Cfloat",
            "Channel", "Cint", "Cintmax_t", "Clong", "Clonglong", "Cmd", "Cmode_tˣ",
            "CodeUnitsˣ", "Colon", "ColumnSlices", "Complex", "ComplexF16", "ComplexF32",
            "ComplexF64", "ComposedFunction", "CompositeException", "Condition",
            "Cptrdiff_t", "Cshort", "Csize_t", "Cssize_t", "Cstring", "Cuchar", "Cuint",
            "Cuintmax_t", "Culong", "Culonglong", "Cushort", "Cvoid", "Cwchar_t",
            "Cwstring", "CyclePaddingˣ", "DenseMatrix", "DenseVecOrMat", "DataType",
            "DenseArray", "DenseVector", "Dict", "DimensionMismatch", "Dims", "DivideError",
            "DomainError", "EOFError", "Enum", "EnvDictˣ", "ErrorException", "Eventˣ",
            "ExponentialBackOff", "Expr", "FilteringRFˣ", "Fix1ˣ", "Fix2ˣ", "FlatteningRFˣ",
            "Float16", "Float32", "Float64", "Function", "Generatorˣ", "GenericConditionˣ",
            "HTML", "IOBuffer", "IOContext", "IOStream", "IdDict", "IdentityUnitRangeˣ",
            "ImmutableDictˣ", "IndexCartesian", "InexactError", "InitError", "Int",
            "Int128", "Int16", "Int32", "Int64", "Int8", "Integer", "IteratorEltypeˣ",
            "IteratorSizeˣ", "InterConditionalˣ", "InterruptException", "LLVMPtrˣ",
            "LibuvServerˣ", "LibuvStreamˣ", "LinRange", "LinearIndices", "LoadError",
            "LogicalIndexˣ", "MIME", "MappingRFˣ", "Matrix", "MethodError", "Missing",
            "MissingException", "Module", "NTuple", "NamedTuple", "Nothing", "Number",
            "OS_HANDLEˣ", "OneToˣ", "OrdinalRange", "OutOfMemoryError", "OverflowError",
            "Pair", "PartialQuickSort", "PermutedDimsArray", "Ptr", "QuoteNode",
            "RangeStepStyleˣ", "Rational", "RawFD", "ReadOnlyMemoryError", "Real",
            "ReentrantLock", "Ref","Regex", "RegexMatch", "Returns", "RoundingMode",
            "RowSlices", "ScalarIndexˣ", "SecretBufferˣ", "Semaphoreˣ", "Set", "Signed",
            "Slices", "Sliceˣ", "Some", "SpawnIOsˣ", "Splatˣ", "StackOverflowError",
            "StepRange", "StepRangeLen", "StridedArray", "StridedMatrix", "StridedVecOrMat",
            "StridedVector", "String", "StringIndexError", "SubArray", "SubString",
            "SubstitutionString", "Symbol", "SystemError", "TaskFailedException", "Task",
            "Text", "TextDisplay", "ThreadSynchronizerˣ", "Timer", "Tuple",
            "TwicePrecisionˣ", "Type", "TypeError", "TypeofBottomˣ", "UInt", "UInt128",
            "UInt16", "UInt32", "UInt64", "UInt8", "UUIDˣ", "UndefInitializer",
            "UndefKeywordError", "UndefRefError", "UndefVarError", "Union", "UnionAll",
            "UnitRange", "Unsigned", "Val", "VecElement", "VecOrMat", "Vector", "VerTupleˣ",
            "VersionNumber", "WeakKeyDict", "WrappedExceptionˣ", "text_colorsˣ"
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "<:", "==", "=>", ">:", "≠", "≡", "≢", "<:", "==="
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Base64.Base64DecodePipe", "Base64.Base64EncodePipe", "Printf.Formatˣ",
            "Printf.Pointerˣ", "Printf.PositionCounterˣ", "Printf.Specˣ"
        ]
    ]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end
