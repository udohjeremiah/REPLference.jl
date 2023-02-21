"""
# TUPLES
In computer programming, a *tuple* (pronounced **TUH-pul**) is a data structure with the
following characteristics:

- *It can contain a finite sequence of elements*: the elements can be of any type supported
  by the language.

- *Its elements are immutable*: once created, its elements cannot be deleted or modified to
  point to different objects.

- *Its elements are ordered*: since they cannot be changed, each element has a position that
  can be identified and accessed with (either by index or name).

- *its elements can be of duplicate values*: since elements are ordered, we can have the
  same elements in a tuple, but refer to different ones of them using their position in the
  tuple.

To indicate how many elements a tuple contains, it's a convention in the programming space
to say an *"n-tuple"*, where "n" is the number of elements.

Though similar in nature, tuples are generally used as a collection for heterogeneous
(different) data types, while arrays are used for homogeneous (similar) data types. This
means tuples are the "ideal" data structure to use for storing a list of heterogeneous items
whose values will not change (during the execution of your program).

Some noteworty advantages of using a tuple over other data structures like arrays are:

- Since tuples are immutable, their data may be accessed faster than a standard array.

- If you have a data that doesn't change, implementing it as tuple will guarantee that it
  remains write-protected.

- Tuples that contain immutable elements can be used as a key for a dictionary. With arrays,
  this is not "possible" (or guaranteed to remain stable), because elements in arrays can be
  modified/changed.

The built-in data structures for tuples in Julia are `Tuple` and `NamedTuple`; both are the
same, with the **ONLY** difference being the style in which their elements are accessed:
`Tuple`s have their elements accessed only by index, while `NamedTuple`s have theirs
accessed either by index or name.

## Type Hierarchy Tree
```julia
Any
├─ Tuple
└─ NamedTuple
```

## Tuples
#### How To Create A `Tuple`?
1. Using the traditional `()` and `,` literals found in many programming languages:

```julia
julia> ()      # empty tuple
()

julia> (1,)    # 1-tuple
(1,)

julia> (1, 2, π)
(1, 2, π)

julia> ((1, 2, π), ["hello", "world"])
((1, 2, π), ["hello", "world"])
```


2. Using the `tuple` function: This is equivalent to using the literal (shown above), except
   for the added benefit of being able to create a tuple from a collection
   (which can be multiple), as we can simply *splat* the arguments with `...`, something not
   possible with the literal:

```julia
julia> tuple()
()

julia> tuple(1)
(1,)

julia> tuple(1, 2, π)
(1, 2, π)

julia> tuple((1, 2, π), ["hello", "world"])
((1, 2, π), ["hello", "world"])
```

!!! tip
    To avoid promoting the elements of a collection to a common type when splatting, make
    the `eltype` of that collection a general abstract type for all its elements, as shown
    in the example below.

```
julia> tuple([1, 2, π]...)
(1.0, 2.0, 3.141592653589793)

julia> tuple(Real[1, 2, π]...)
(1, 2, π)
```

3. Using the `Tuple` constructor: The main use case for this is creating a tuple from a
   collection (must be one), without explicitly using the `...` operator to splat the
   collection:

```julia
julia> Tuple([1, 2, π])
(1.0, 2.0, 3.141592653589793)

julia> Tuple(Real[1, 2, π])
(1, 2, π)
```

4. Using the `ntuple` function: The use case for this is when you want a tuple from a
   specified index that will be applied to a function as a range to produce a tuple:

```julia
julia> ntuple(i -> 2*i, 4)
(2, 4, 6, 8)

julia> ntuple(i -> complex(i), 4)
(1 + 0im, 2 + 0im, 3 + 0im, 4 + 0im)
```

#### `typeof` Of A Tuple
The elements of a tuple are not promoted to a common type, as we see in Julia arrays:

```julia
julia> [1, 2.0, 3+3im]
3-element Vector{ComplexF64}:
 1.0 + 0.0im
 2.0 + 0.0im
 3.0 + 3.0im

julia> (1, 2.0, 3+3im)
(1, 2.0, 3 + 3im)
```

This is one reason why tuples are "ideal" for items with different types. The type of each
element in a tuple can be viewed with the `typeof` function:

```julia
julia> typeof((1, 2.0, 3+3im))
Tuple{Int64, Float64, Complex{Int64}}

julia> typeof((1, 2, 3))
Tuple{Int64, Int64, Int64}
```

As seen above, the types of the tuple remained the same; that is, they are not promoted. In
Julia, there is an even more compact way of representing the type for a tuple using `NTuple`
when all its elements are of the same type:

```julia
julia> T = NTuple{4, Float64} # 4-tuple, with all elements as Float64
NTuple{4, Float64}

julia> (1.0, 1.3, 4.5, 5.9) isa T
true

julia> (1.0, 1.3, 4.5) isa T
false

julia> (1, 1.3, 4.5, 5.9) isa T
false
```

See:

- https://docs.julialang.org/en/v1/manual/types/#Tuple-Types
- https://docs.julialang.org/en/v1/manual/types/#Vararg-Tuple-Types

for a complete overview of Tuple types, including a special type for tuples known as
Vararg Tuple types.

#### Accessing The Elements Of A Tuple
Elements of a `Tuple` can be accessed using the syntax `x[i]` or `x[i:j]`, where `x` is the
tuple, and `i` and `j` are index positions.

!!! note
    In Julia, range indexing (i.e., slicing) with `x[i:i]` (if `x` supports it) returns an
    object of the same type as `x`, composed of the element `x[i]`.

```julia
julia> a = (10, 20, 30);

julia> a[1]
10

julia> a[1:1]
(10,)

julia> a[1:2]
(10, 20)

julia> a = ((1, 2, 3), ["hello", "world"]);

julia> a[1]
(1, 2, 3)

julia> a[1][2]
2

julia> a[2][2]
"world"
```

## NamedTuples
#### How To Create A `NamedTuple`?
1. Using literals: In Julia, an assignment inside parentheses with a comma is the literal
   for constructing a `NamedTuple`:

```julia
julia> (;)      # empty namedtuple
NamedTuple()

julia> (a=1,)   # 1-namedtuple
(a = 1,)

julia> (a=1, b=2, c=π)
(a = 1, b = 2, c = π)

julia> (A = (a=1, b=2, c=π), B = ["helo", "world"])
(A = (a = 1, b = 2, c = π), B = ["helo", "world"])
```

2. Using the `;` operator inside a tuple of `x=>y` `Pair`s, where `x` is a `Symbol`:

```julia
julia> (; :a=>1)
(a = 1,)

julia> (; :a=>1, :b=>2, :c=>π)
(a = 1, b = 2, c = π)

julia> (; :A => (; :a=>1, :b=>2, :c=>π), :B => ["hello", "world"])
(A = (a = 1, b = 2, c = π), B = ["hello", "world"])
```

A case where this is most useful is when you want to create a `NamedTuple` from a
`Dictionary`, using the `;` and `...` operator:

```julia
julia> (; Dict(:one=>1, :two=>1, :three=>3)...)
(three = 3, two = 1, one = 1)
```

3. Using the `;` operator inside a tuple of `T.x`, where `T` is an instance of a concrete
   type and `x` is a field of `T`:

```julia
julia> a = 1//2
1//2

julia> (; a.num, a.den)
(num = 1, den = 2)
```

4. Using the `NamedTuple` constructor; this is equivalent to `(; itr...)`, where `itr` is
   a key-value pair (key must be `Symbol`s):

```julia
julia> NamedTuple(Dict(:one=>1, :two=>1, :three=>3))
(three = 3, two = 1, one = 1)

julia> keys = (:a, :b, :c); values = (1, 2, 3);

julia> NamedTuple(zip(keys, values))
(a = 1, b = 2, c = 3)
```

See `NamedTuple` in `help?>` mode for more information on other ways to use the constructor.

#### `typeof` Of A NamedTuple
The elements of a `NamedTuple` have their names mapped as a tuple of `Symbol`s, and their
values as a tuple of their types:

```julia
julia> typeof((;))
NamedTuple{(), Tuple{}}

julia> typeof((a=1,))
NamedTuple{(:a,), Tuple{Int64}}

julia> typeof((a=1, b=2, c=π))
NamedTuple{(:a, :b, :c), Tuple{Int64, Int64, Irrational{:π}}}

julia> typeof((a=1, b=2, c=3, d=4))
NamedTuple{(:a, :b, :c, :d), NTuple{4, Int64}}
```

See https://docs.julialang.org/en/v1/manual/types/#Named-Tuple-Types for a complete overview
of `NamedTuple` types.

#### Accessing The Elements Of A NamedTuple
The values of the elements of a `NamedTuple` are accessed with either of these styles:

- using the syntax `x[i]`, where `x` is the namedtuple and `i` is the index postion,
- using the syntax `x[:i]`, where `x` is the namedtuple and `i` is a valid name,
- using the syntax `x.i`, where `x` is the namedtuple and `i` is a valid name.
- using the `get` function; this is primarily used when one wants to return a default value
  when the requested key is not found.

```julia
julia> a = (x=10, y=20, z=30);

julia> a[1]
10

julia> a[:x]
10

julia> a.x
10

julia> get(a, :x, 0)
10

julia> get(a, :e, 0)    # default value returned
0

julia> a = (; :A => (; :a=>1, :b=>2, :c=>π), :B => ["hello", "world"]);

julia> a[:A][1]
1

julia> a[:A][:b]
2

julia> a[:B][1]
"hello"
```

While the syntax `x[:i]` can be used to retrieve the value associated with the name `i` in
the named tuple `x` (as shown above), we can also do `x[(:i,)]`, where the returned value
will be a `NamedTuple`:

```julia
julia> a[(:y,)]
(y = 20,)

julia> a[(:y, :x)]
(y = 20, x = 10)
```

Also, we can use the `keys` and `values` function to retrive the names and values of a
`NamedTuple` respectively:

```julia
julia> keys(a)
(:x, :y, :z)

julia> values(a)
(10, 20, 30)
```

It's important to note that iterating over a `NamedTuple` will only produce the values
(without the names); when desired, use the `pairs` function to get the keys and values:

```julia
julia> for i in a
           println(i)
       end
10
20
30

julia> for i in pairs(a)
           println(i)
       end
:x => 10
:y => 20
:z => 30
```

## Destructuring Assignment For Tuples and NamedTuples
In programming, it's a common feature found in many languages to unpack a sequence into
multiple variables using the `=` operator. The sequence to be unpacked is on the RHS, and
the multiple variables are on the LHS of the `=` operator. In Julia, this can also be done.

**Unpacking a tuple**: The syntax for this is to have the multiple variables on the LHS,
optionally enclosed in brackets, and the sequence on the RHS to have a length at least the
same as the multiple variables on the LHS. If the sequence is longer than the variables,
the remaining values are simply discarded. In Julia, this is known as "destructuring based
on iteration":

```julia
julia> c, a = (1, 2, 3, 4);

julia> c
1

julia> a
2
```

**Unpacking a namedtuple**: The syntax for this is to have the multiple variables on the LHS
enclosed in a bracket, with the `;` operator at the beginning of the closed bracket. The
sequence follows the same rule as stated in the tuple above. In Julia, this is known as
"destructuring based on property names":

```julia
julia> (; c, a) = (a=1, b=2, c=3, d=4);

julia> c
3

julia> a
1
```
"""
function tuples()
    header1 = "Tuple Constructors"
    printstyled(header1, '\n', '≡'^(length(header1) + 2), '\n'; bold=true)
    println("""
    NamedTuple    NTuple    Tuple    Vararg\n""")

    header2 = "Macros"
    printstyled(header2, '\n', '≡'^(length(header2) + 2), '\n'; bold=true)
    println("""
    @doc    @isdefined    @NamedTuple\n""")

    header3 = "Indices Functions"
    printstyled(header3, '\n', '≡'^(length(header3) + 2), '\n'; bold=true)
    println("""
    axes    eachindex    firstindex    getindex    indexin    lastindex\n""")

    header4 = "Loop Operations"
    printstyled(header4, '\n', '≡'^(length(header4) + 2), '\n'; bold=true)
    println("""
    enumerate    foreach    pairs    zip\n""")

    header5 = "Search & Find Functions"
    printstyled(header5, '\n', '≡'^(length(header5) + 2), '\n'; bold=true)
    println("""
    count     findall      findlast    findmin     findprev    last
    filter    findfirst    findmax     findnext    first\n""")

    header6 = "Reduce Functions"
    printstyled(header6, '\n', '≡'^(length(header6) + 2), '\n'; bold=true)
    println("""
    foldl    mapfoldl    mapreduce          mapreduce_first    reduce_empty    splat
    foldr    mapfoldr    mapreduce_empty    reduce             reduce_first\n""")

    header7 = "Missing & Nothing Operations"
    printstyled(header7, '\n', '≡'^(length(header7) + 2), '\n'; bold=true)
    println("""
    Some         @something    missing        nonmissingtype    something
    @coalesce    coalesce      skipmissing    notnothing\n""")

    header8 = "General Functions"
    printstyled(header8, '\n', '≡'^(length(header8) + 2), '\n'; bold=true)
    println("""
    Generator         eltype     map            reverse        supertypes
    IteratorEltype    empty      merge          setindex       tail
    IteratorSize      front      methodswith    sizeof         typeassert
    bitsunionsize     get        nameof         something      typeintersect
    broadcast         getkey     ntuple         structdiff     typejoin
    checked_length    iterate    only           summary        typeof
    coalesce          join       rand           summarysize    unique
    copymutable       keys       replace        subtypes       values
    dump              length     rest           supertype\n""")

    header9 = "True/False Functions"
    printstyled(header9, '\n', '≡'^(length(header9) + 2), '\n'; bold=true)
    println("""
    all          isbits            isdispatchtuple    ismutable
    allequal     isbitstype        isdone             ismutabletype
    allunique    isbitsunion       isempty            isnothing
    any          isconst           isequal            isperm
    hasfastin    isabstracttype    isgreater          isprimitivetype
    haskey       isconcretetype    isiterable         issorted
    in           isdefined         isless             isstructtype
    isa          isdisjoint        ismissing          issubset\n""")

    header10 = "Type-Conversion Functions"
    printstyled(header10, '\n', '≡'^(length(header10) + 2), '\n'; bold=true)
    println("""
    collect    convert    oftype    string\n""")

    header11 = "Mathematical Functions"
    printstyled(header11, '\n', '≡'^(length(header11) + 2), '\n'; bold=true)
    println("""
    accumulate    clamp      cumsum       maximum    setdiff    union
    argmax        cmp        extrema      minimum    sum
    argmin        cumprod    intersect    prod       symdiff\n""")

    header12 = "Non-Alphanumeric Operators"
    printstyled(header12, '\n', '≡'^(length(header12) + 2), '\n'; bold=true)
    println("""
    ∩    ∪    >    <    >=    <=    ∈    ∉    ∋    ∌    ⊆    ⊈    ⊊    ⊇    ⊉    ⊋\n""")
end