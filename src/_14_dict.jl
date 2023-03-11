@doc raw"""
# DICTS
In computer science, a *dictionary* is simply a general-purpose data structure for storing a
collection of objects, each of which is a *key-value* pair. The dictionary data structure
can be compared to a real-world dictionary, where words (keys) are used to look up meanings
(values).

Different programming languages have different names for dictionaries, including hash, map,
table, hashmap, hashtable, symbol-table, associative-array, object, and others. There are
also different underlying implementations of dictionaries in different programming
languages, referred to as the *dictionary problem*. This involves designing efficient data
structures that implement dictionaries, such as hash tables, self-balancing binary search
trees, unbalanced binary search trees, sequential containers of key-value pairs, and others.

Regardless of their different names and implementations, all dictionaries are *key-value*
stores. This concept is widely used in high-performance systems such as caches and
databases.

## Characteristics Of A Dictionary
In dictionaries, the association between a key and a value is often referred to as a
"mapping," and the term "mapping" can also refer to the process of creating a new
association.

A dictionary as a data structure in programming typically has the following characteristics:

- Elements are key-value pairs: The elements in a dictionary consist of keys mapped to
  values. If a key has no value, it must be mapped to a null value, but a key or value
  cannot stand on its own and must be mapped to something.
- Keys are grouped into sets: The keys in a dictionary form a finite set, and the elements
  in the dictionary consist of this set of keys associated with a value.
- Elements are unordered: Since the keys form a set, dictionaries have no order as sets have
  no order.
- Keys are unique values: As the keys form a set, there can be no duplicate keys in a
  dictionary, and attempts to create duplicate keys typically overwrite the existing value
  for that key.
- Keys are immutable: Once a dictionary is created, its keys, like elements in a set, cannot
  be changed or modified. The keys can be deleted, causing the associated value to also be
  deleted, but a new key cannot be mapped to the deleted key's value in one operation. If
  desired, the old key-value must be deleted and the dictionary updated with the new key
  mapped to the new value (which is the same as the old value).
- Values are mutable: While keys are immutable, the values of a dictionary can be modified
  if they are mutable types.
- Type restrictions on keys and values are language dependent: The types allowed for keys
  are language-dependent, and the values of dictionary elements can generally be of any
  type. For example, Python only allows immutable objects to be keys, while Julia allows
  both mutable and immutable types.

Julia has built-in data structures for dictionaries, including `Dict`, `IdDict`, and
`WeakKeyDict`, among other non-exported types. `Dict` is the standard dictionary and the
others serve specific purposes. Julia uses a
[hash table](https://en.wikipedia.org/wiki/Hash_table) to implement dictionaries.

## Type Hierarchy Tree
```julia
Any
└─ AbstractDict
   ├─ Base.EnvDict
   ├─ Base.ImmutableDict
   ├─ Base.Pairs
   ├─ Dict
   ├─ IdDict
   ├─ Test.GenericDict
   └─ WeakKeyDict
```

## How To Create A Dictionary?
Like `Set`s, `Dict`ionaries and their counterparts (`IdDict` and `WeakKeyDict`) can only be
constructed from their constructors, meaning there is no syntax for creating dictionaries as
literals in Julia.

`Dict`ionaries, `IdDict`s, and `WeakKeyDict`s are different types of dictionaries in Julia,
all of which are constructed as hash tables. The difference lies in how Julia handles the
`key`s in the key-value pairs:

- `Dict`s use `isequal` for comparison and `hash` for hashing the keys.
- `IdDict`s use `===` for comparison and `objectid` for hashing the keys.
- `WeakKeyDict`s use weak references for the keys, meaning they may be garbage collected
  even when referenced in a hash table.

Instances of dictionaries, regardless of subtype (`Dict`, `IdDict`, `WeakKeyDict`), can be
constructed in the following ways:

- Using an iterator of 2-tuples, where each tuple holds a `(key, value)` pair, as in the
  following examples:

```julia
julia> Dict([("A", 1), ("B", 2)])
Dict{String, Int64} with 2 entries:
  "B" => 2
  "A" => 1

julia> IdDict([("A", 1), ("B", 2)])
IdDict{String, Int64} with 2 entries:
  "B" => 2
  "A" => 1

julia> WeakKeyDict([("A", 1), ("B", 2)])
WeakKeyDict{String, Int64}(...):
  "B" => 2
  "A" => 1
```

- Using an iterator/sequence of `Pair` arguments, where each argument holds a `key=>value`
  pair:

```julia
julia> Dict(true => "Bool", 1 => Int, 1.0 => :Float64)
Dict{Real, Any} with 1 entry:
  1.0 => :Float64

julia> IdDict(true => "Bool", 1 => Int, 1.0 => :Float64)
IdDict{Any, Any} with 3 entries:
  1.0  => :Float64
  1    => Int64
  true => "Bool"

julia> WeakKeyDict(:a => 1, "two" => 2, :c => 3)
WeakKeyDict{Any, Int64}(...):
  :a    => 1
  "two" => 2
  :c    => 3
```

The type information of a dictionary is inferred from the keys and values. For example,
`Dict("A"=>1, "B"=>2)` creates a `Dict{String, Int64})`. To specify the types explicitly,
use the syntax `Dict{KeyType, ValueType}(...)`, as in `Dict{String, Int32}("A"=>1, "B"=>2)`.

Finally, dictionaries can also be created using comprehensions or generators, such as
`Dict([i => f(i) for i in 1:5])` or `Dict(i => f(i) for i in 1:5)` (where `f` is callable).

## Standard Dictionary Operations
A dictionary, due to its design and use case, has specific operations
(which may also be applicable to other data structures) that are of great importance when
working with dictionaries. These operations are:

- Testing or verifying the existence of a key:
  - `haskey`
  - `getkey`
  - `key in keys(dict)`

- Retrieving the value associated with a key:
  - `getindex` i.e. `dict[key]`
  - `get`
  - `get!`

- Updating the value associated with a key:
  - `setindex!` i.e. `dict[key] = value`
  - `replace!`

- Inserting a new key-value pair into the collection:
  - `push!`
  - `get!`

- Removing a key-value pair from the collection:
  - `delete!`
  - `pop!`
  - `filter!`
  - `copy!`

- Merging a dictionary with another dictionary:
  - `merge`
  - `merge!`
  - `mergewith`
  - `mergewith!`

## Looping Through A Dictionary
Unlike `NamedTuple`s, where iterating over them will only produce values without names,
dictionaries produce their key-value pairs during iteration:

```julia
julia> d = Dict(:a=>1, :b=>2, :c=>[1, 2, 3]);

julia> for kv in d
           println(kv)
       end
Pair{Symbol, Any}(:a, 1)
Pair{Symbol, Any}(:b, 2)
Pair{Symbol, Any}(:c, [1, 2, 3])
```

During iteration, there are multiple ways to retrieve the key and value of an element:

1. Calling the `first` and `second` fields of the `Pair` object produced in each iteration:

```julia
julia> for kv in d
           println(kv.first, ", ", kv.second)
       end
a, 1
b, 2
c, [1, 2, 3]
```

Instead of calling the fields of the `Pair` object, you can use the `first` and `last`
functions:

```julia
julia> for kv in d
           println(first(kv), ", ", last(kv))
       end
a, 1
b, 2
c, [1, 2, 3]
```

2. Using a 2-tuple as the "item" in the for-loop construct:

```julia
julia> for (k, v) in d
           println(k, ", ", v)
       end
a, 1
b, 2
c, [1, 2, 3]
```

3. Using a 2-tuple as the "item", and passing the "collection" (i.e., dictionary) to the
   `pairs` function, in the for-loop construct:

```julia
julia> for (k, v) in pairs(d)
           println(k, ", ", v)
       end
a, 1
b, 2
c, [1, 2, 3]
```

To simplify the process, you can use `keys(d)`, `values(d)`, or `zip(keys(d), values(d))` to
iterate over the keys, values, or keys and values in the dictionary `d` respectively. Note
that elements in a dictionary are unordered, so loops over dictionaries will likely return
elements in a random order.

## Nested Dictionaries
While the values of a dictionary can be of any type, the syntax for creating a dictionary of
dictionaries (nested dictionaries) may not seem intuitive at first glance. Below is a simple
example of a nested dictionary where each key has a dictionary as its value:

```julia
julia> a = Dict(:s1 => Dict(:name     => "John Ayomide",
                            :age      => 35,
                            :sex      => 'M',
                            :phone_no => 2348000000090,
                            :address  => "Kingsway Street"
                       ),
                
                :s2 => Dict(:name     => "Anabel Okpa",
                            :age      => 28,
                            :sex      => 'F',
                            :phone_no => 2349100000007,
                            :address  => "MaryLand Avenue"
                       )
           );

julia> typeof(a)
Dict{Symbol, Dict{Symbol, Any}}

julia> a[:s1]
Dict{Symbol, Any} with 5 entries:
  :address  => "Kingsway Street"
  :age      => 35
  :sex      => 'M'
  :name     => "John Ayomide"
  :phone_no => 2348000000090

julia> a[:s1][:name]
"John Ayomide"

julia> a[:s1][:age]
35

julia> a[:s2]
Dict{Symbol, Any} with 5 entries:
  :address  => "MaryLand Avenue"
  :age      => 28
  :sex      => 'F'
  :name     => "Anabel Okpa"
  :phone_no => 2349100000007

julia> a[:s2][:name]
"Anabel Okpa"

julia> a[:s2][:age]
28
```
"""
function dicts(;extmod=false)
    constants = [
        "Constants" => [
            "missing", "nothing"
        ]
    ]
    macros = [
        "Macros" => [
            "@assert", "@boundscheck", "@coalesce", "@localsˣ", "@show", "@showtime",
            "@simd", "@something",
        ]
    ]
    methods = [
        "Methods" => [
            "In-Place"          => [
                "delete!", "empty!", "filter!", "get!", "map!", "merge!", "mergewith!",
                "pop!", "push!", "replace!", "sizehint!"
            ],
            "Indices"           => [
                "eachindex", "first", "get", "getindex", "getkey", "keys", "keytype"
            ],
            "Loop"              => [
                "enumerate", "foreach", "pairs", "zip"
            ],
            "Mathematical"      => [
                "argmax", "argmin", "extrema", "intersect", "maximum", "minimum", "prod",
                "setdiff", "sum", "symdiff", "union", "unique",
            ],
            "Missing & Nothing" => [
                "coalesce", "notnothingˣ", "something"
            ],
            "Reduce"            => [
                "foldl", "mapfoldl", "mapreduce", "mapreduce_emptyˣ", "mapreduce_firstˣ",
                "reduce", "reduce_emptyˣ", "reduce_firstˣ"
            ],
            "Search & Find"     => [
                "filter", "findall", "findfirst", "findmax", "findmin"
            ],
            "True/False"        => [
                "allequal", "allunique", "hasfastinˣ", "haskey", "hasproperty", "ifelse",
                "isa", "in", "isbits", "isdefined", "isdisjoint", "isdoneˣ", "isempty",
                "isequal", "isgreaterˣ", "ismissing", "ismutable", "isnothing",
                "issetequal", "issubset", "isunordered", "promote"
            ],
            "Type-Conversion"   => [
                "cconvertˣ", "collect", "convert", "oftype", "string"
            ],
            "Others"            => [
                "checked_lengthˣ", "copy", "copymutableˣ", "deepcopy", "display", "dump",
                "eltype", "empty", "getfield", "getproperty", "hash", "identity", "iterate",
                "join", "length", "merge", "mergewith", "nfields", "objectid", "only",
                "print", "println", "printstyled", "propertynames",
                "recursive_prefs_mergeˣ", "redisplay", "replace", "repr", "restˣ", "show",
                "sizeof", "split_restˣ", "stack", "summary", "summarysizeˣ", "typeassert",
                "typeof", "valtype", "values"
            ]
        ]
    ]
    types = [
        "Types" => [
            "AbstractDict", "AnyDictˣ", "Cvoid", "DataType", "Dict", "EnvDictˣ",
            "Generatorˣ", "IdDict", "ImmutableDictˣ", "IteratorEltypeˣ", "IteratorSizeˣ",
            "Missing", "Nothing", "Ref", "Pair", "Pairsˣ", "Some", "WeakKeyDict",
            "text_colorsˣ"
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "==", "=>", "∈", "∉", "∋", "∌", "∩", "∪", "≠", "≡", "≢", "⊆",
            "⊇", "⊈", "⊉", "⊊", "⊋", "==="
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Printf.@printf", "Printf.@sprintf", "Printf.Formatˣ", "Printf.Pointerˣ",
            "Printf.PositionCounterˣ", "Printf.Specˣ", "Printf.formatˣ"
        ]
    ]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end