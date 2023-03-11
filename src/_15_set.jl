@doc raw"""
# SETS
In mathematics, a *set* is the mathematical model for a "collection of different things".
First, we specify a common property among "things", and then we gather up all the "things"
that have this common property to form a "collection". For example, the items you
wear - hat, shirt, jacket, pants, etc. - are known as a set. Another example of a set is
types of fingers, including index, middle, ring, and pinky. So a set is simply things
grouped together with a certain property in common. Sets are usually written using curly
brackets, with their elements inside the curly brackets. For example, the set containing
only the numbers 1, 2, 3 is written as {1, 2, 3}. Each element in a set is also known as a
*"member"* of the set.

In [set theory](https://en.m.wikipedia.org/wiki/Set_theory):
- "Things" as described above are called the *universal set*. It's a set that contains
  everything - well, not exactly everything, but everything that is related to your
  question. For example, in **Number Theory**, the universal set is *all the integers*, as
  Number Theory is simply the study of integers. But in *Calculus* (also known as real
  analysis), the universal set is almost always the *real numbers*.

- A set with an infinite number of elements (which may be countable or uncountable) is
  called an infinite set. For example, the set of all integers is a countably infinite set,
  {..., -1, 0, 1, 2, ...}, and the set of all real numbers is an uncountably infinite set.

- A set with a finite number of elements is called a finite set. For example, {2, 4, 6} is a
  finite set of 3 elements.

Informally, a finite set is a set that one could in principle count and finish counting, as
shown in the example above. The number of elements of a finite set is a natural number
(possibly zero) and is called the *cardinality (or the cardinal number)* of the set. A set
with no elements is an empty (or null) set (represented as ∅), while a set with a single
element is a singleton.

In computer science, a *set* is a simply the computer implementation of the mathematical
model of a **finite set**. That is, the idea of a *set* in programming is that of a
*finite set*, which was translated directly over from mathematics.

Aside from the many characteristics and properties of a set in mathematics, the two basic
properties that make it a distinctive data structure in programming are:

- **Its elements are unique values**: no two identical values can exist in a set (or are
  repeated). Repeating one or many elements of a set does not change it; it remains the
  same. For example, {1, 1, 1, 1, 2} is the same as {1, 2}.

- **Its elements have no order**: It does not matter what order the elements are in, so
  {3, 1, 2} as a set is the same as {2, 1, 3}, {1, 3, 2} and so on. This means that changing
  the order in which elements are written does not change the set. For example, changing
  {1, 2, 3} to {3, 1, 2} will not create a different set.

The built-in data structures for sets in Julia are `Set` and `BitSet`, which are mutable
type collections. In addition to the above-described behaviors of sets generally in computer
science, below are some characteristics of how `Set`s differ as a data structure from their
counterparts in Julia.

# NOTEWORTHY DIFFERENCES OF `Set` FROM OTHER DATA STRUCTURES.
- Unlike most data structures in Julia, the values of a `Set` cannot be retrieved using
  indexing. That is, `getindex` is not defined for `Set`s. The reason for this is that
  "elements in a set are not ordered," which can lead to bugs. For example, the value
  returned from `s[2]` on the first call (if `s` is a `Set` object) will likely be different
  from the value returned when `s[2]` is called multiple times.

- Although `Set` is a mutable data type, `Set` objects cannot have their elements changed by
  assignment, i.e., `setindex!` is not defined for `Set`s. The possible reason for this has
  to do with order as well. For example, the variable changed and re-assigned to 10 in
  `s[2] = 10` (if `s` is a Set object) cannot be said to be exact because `s[2]` is not
  known in the first place due to the lack of order. Running that code multiple times will
  likely give a different outcome.

- Since `getindex` isn't defined for `Set`s, the elements of a `Set` cannot be actually
  modified once constructed. However, Julia provides in-place functions to modify the `Set`
  object itself, such as `pop!`, `push!`, `union!`, `delete!`, and so on, which can be used
  to add or delete elements from the `Set` object.

One may ask: with the above said, what then are the benefits of using a `Set` over other
data structures like arrays, dictionarys, or even tuples? A concise answer to this question
would make this material "too big for itself". To put it simply, sets have been found to be
a fundamental tool not just in mathematics, but in programming as well. Throughout your
programming career, you will likely encounter a wide variety of problems that can be more
easily solved with the use of sets. The best way to explore the efficient use-cases for
`Set`s is by searching and asking questions about them in the programming community.

However, the common reason for using sets in programming is that they are designed for fast
query operations on their elements, such as checking whether a given value is in the set
(i.e., membership test) or enumerating (looping) over the values in some arbitrary order.

## Type Hierarchy Tree
```julia
Any
└─ AbstractSet
   ├─ Base.IdSet
   ├─ Base.KeySet
   ├─ BitSet
   ├─ Set
   └─ Test.GenericSet
```

## How To Create A `Set`?
Unlike other languages like Python, the curly bracket literal, `{}`, for creating `Set`
objects does not exist in Julia. A possible reason for this is Julia's parametric types,
which are typically written in curly brackets (e.g., `Array{T, 1}`). To avoid ambiguity, the
curly bracket syntax was not adopted for `Set`s.

In Julia, `Set`s are constructed only from the `Set` or `BitSet` constructor with multiple
elements enclosed in square brackets, `[]`.

- Using the `Set` constructor: the main use case for this is for creating sets objects of
  sparse integers, or for sets of arbitrary objects (i.e. not related in a common type).

```julia
julia> Set()    # null set
Set{Any}()

julia> Set('a')
Set{Char} with 1 element:
  'a'

julia> Set("app")
Set{Char} with 2 elements:
  'a'
  'p'

julia> Set(["app"])
Set{String} with 1 element:
  "app"

julia> Set([1, 2, 3, 10^10])
Set{Int64} with 4 elements:
  2
  10000000000
  3
  1

julia> Set([1, "two", π])
Set{Any} with 3 elements:
  "two"
  π
  1
```

- Using the `BitSet` constructor: the main use case for this is for creating a *sorted* set
  of dense integers (i.e., all elements are subtypes of `Integer`s).
```julia
julia> BitSet()    # null bitset
BitSet([])

julia> BitSet(1)
BitSet with 1 element:
  1

julia> BitSet([4, 2, 3, 1])
BitSet with 4 elements:
  1
  2
  3
  4
```

Sparse integer sets are sets where their integer elements are very spread out between each
other, e.g., `{1, 2, 3, 4, 5^5}`. Dense integer sets are sets where their integer elements
are very close to each other, e.g., `{1, 2, 3, 4, 5}`. A simple heuristic for distinguishing
between them is using the formula:

```
D = number_of_unique_values / (max_value - min_value)
```

Where `D` would be higher for dense integer sets and lower for sparse integer sets.

The type information of a `Set` is inferred from its elements, e.g., `Set([1, 2, 3])`
creates a `Set{Int64}`. To explicitly specify types, use the syntax `Set{ElementType}(...)`;
for example, `Set{Int8}([1, 2, 3])`.

`Set` and `BitSet` objects can also be created with comprehensions or generators. For
example, `Set([i^2 for i in 1:5])`, `Set(i^2 for i in 1:5)`.

## Sets and BitSets Equality
It's important to point out that although `Set`s and `BitSet`s are different concrete types,
their objects are equal if they have the same elements:

```julia
julia> BitSet() == Set()
true

julia> BitSet(1) == Set(1)
true

julia> BitSet([1, 2, 4]) == Set([2, 4, 1])
true
```

This is because `Set`s and `BitSet`s have the same `hash` values (when their elements are
the same), hence `true` is returned when compared with `==`. However, because they're of
different concrete types, their `objectid`s are different, hence `false` is returned when
compared with `===`:

```julia
julia> a = BitSet(1); b = Set(1);

julia> hash(a), hash(b)
(0x146bcd8d339cbe14, 0x146bcd8d339cbe14)

julia> a == b
true

julia> objectid(a), objectid(b)
(0x735dc65ead84cd1f, 0x7d100bde60256d34)

julia> a === b
false
```
"""
function sets(;extmod=false)
    constants = [
        "Constants" => [
            "missing", "nothing"
        ]
    ]
    macros = [
        "Macros" => [
            "@assert", "@boundscheck", "@coalesce", "@show", "@showtime", "@simd",
            "@something"
        ]
    ]
    methods = [
        "Methods" => [
            "In-Place"          => [
                "copy!", "delete!", "empty!", "filter!", "intersect!", "pop!", "popfirst!",
                "push!", "replace!", "setdiff!", "sizehint!", "symdiff!", "union!"
            ],
            "Loop"              => [
                "enumerate", "foreach", "pairs", "zip"
            ],
            "Mathematical"      => [
                "accumulate", "cumprod", "cumsum", "extrema", "intersect", "maximum",
                "minimum", "prod", "setdiff", "sum", "symdiff", "union", "unique"
            ],
            "Missing & Nothing" => [
                "coalesce", "notnothingˣ", "skipmissing", "something"
            ],
            "Reduce"            => [
                "add_sumˣ", "foldl", "mapfoldl", "mapreduce", "mapreduce_emptyˣ",
                "mapreduce_firstˣ", "mul_prodˣ", "reduce", "reduce_emptyˣ", "reduce_firstˣ",
            ],
            "Search & Find"     => [
                "count", "filter"
            ],
            "True/False"        => [
                "all", "allequal", "allunique", "any", "hasfastinˣ", "hasproperty",
                "ifelse", "in", "isa", "isbits", "isdefined", "isdisjoint", "isdoneˣ",
                "isempty", "isequal", "isgreaterˣ", "ismissing", "ismutable", "isnothing",
                "issetequal", "issubset", "isunordered", "promote"
            ],
            "Type-Conversion"   => [
                "cconvertˣ", "collect", "convert", "oftype", "string"
            ],
            "Others"            => [
                "broadcast", "bytes2hex", "checked_lengthˣ", "copy", "copymutableˣ",
                "deepcopy", "display", "dump", "eltype", "empty", "first", "getfield",
                "getproperty", "hash", "identity", "iterate", "join", "length", "nfields",
                "objectid", "only", "print", "println", "printstyled", "propertynames",
                "redisplay", "replace", "repr", "restˣ", "show", "sizeof", "split_restˣ",
                "stack", "summary", "summarysizeˣ", "typeassert", "typeof", "values"
            ]
        ]
    ]
    types = [
        "Types" => [
            "AbstractSet", "BitSet", "Cvoid", "DataType", "Generatorˣ", "IteratorEltypeˣ",
            "IteratorSizeˣ", "Missing", "Nothing", "Ref", "Pair", "Set", "Some"
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "<", "<=", "==", "=>", ">", ">=", "∈", "∉", "∋", "∌", "∩",
            "∪", "≠", "≡", "≢", "≤", "≥", "⊆", "⊇", "⊈", "⊉", "⊊", "⊋", "==="
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Printf.@printf", "Printf.@sprintf", "Printf.Formatˣ", "Printf.Pointerˣ",
            "Printf.PositionCounterˣ", "Printf.Specˣ", "Printf.formatˣ", "Statistics.mean",
            "Statistics.median", "Statistics.quantile", "Statistics.std", "Statistics.stdm",
            "Statistics.var", "Statistics.varm"
        ]
    ]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end