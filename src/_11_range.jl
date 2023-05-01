@doc raw"""
# RANGES
In statistics, the "range" for a given data set is the difference between the highest and
lowest values (or observation). For example, if the given data set is `{5, 2, 3, 10, 8}`,
then the range will be `10 - 2 = 8`. Showing another example, on a typical exam where
students are scored from `0` to `100`, there is a range between `0` and `100`; the range of
possible exam values will be the largest value (`100`) minus the smallest value (`0`) i.e.
`100 - 0 = 100`.

However, in computer programming, the term "range" may refer to one of three things:

- The possible values that may be stored in a variable (depending on its type).
- The upper and lower bounds of an array.
- An alternative to an iterator.

## RANGE AS A VARIABLE
The range of a variable refers to the set of possible values that the variable can hold,
based on its type. For example, if a variable is a subtype of `Integer`, its definition is
restricted to whole numbers only, and its range will cover every integer within its limits
(including the maximum and minimum values).

In Julia, you can use the `typemin` and `typemax` functions to access the range of a
variable. Additionally, there's a non-exported function called `Base.hastypemax` that you
can use to check if a variable type has a range.

## RANGE AS AN ARRAY
When an array is numerically indexed, its range is defined by the upper and lower bounds of
the array. For example, the array `[12, 45, 67, 2, 20]` is a 5-element array, which means
its range will be from the lower bound of `1` to the upper bound of `5`, and all numbers
from `1` to `5` will be valid indices of the array. An error will be thrown if the program
attempts to access the array with an index that is outside of `1`, `2`, `3`, `4`, or `5`.

Julia provides the `firstindex` and `lastindex` functions for accessing the range of an
array. Additionally, the `axes` function can be used to return all valid indices of an array
within a given dimension.

## RANGE AS AN ALTERNATIVE TO AN ITERATOR
Another meaning of "range" in computer programming is as an alternative to an "iterator". In
fact, when the word "range" is used in programming, it often refers to this concept. The
remaining part of this discussion will explain what this means and how it is implemented in
Julia.

An iterable is an object that contains a countable number of values, meaning one can iterate
over its values. Common examples include arrays such as `[1, 2, 3, 4]`, `[10, 20, 15, 4]`,
and `['a', 'b', 'c', 'd']`. When iterated upon, each iteration produces a value of the array
from its first index to the last index, until the vector is exhausted.

An iterator is a computer language construct that allows a program to read through a group
of data values or pieces of information. An iterator is the object that actually performs
the iteration over an "iterable", allowing the iterable to be iterated upon, i.e., you can
go through all the values in the iterable.

In Julia, an iterable is any object that implements the iterator protocol, which consists of
the `iterate` method. Nearly all objects in Julia implement this method, and hence they're
considered as "iterables".

The general `for` loop in Julia:

```julia
for i in iterable
    # body
end
```

is translated into the following code:

```julia
next = iterate(iterable)
while next !== nothing
    i, state = next
    # body
    next = iterate(iterable, state)
end
```

Note that the purpose of the `iterate` function is to return the next element and the new
state of the iterable. The loop continues as long as iterate returns a non-null value for
the next element in the iterable.

To see how useful a range is in programming, consider the following tasks:

- Creating an array of numbers from `1` to `100000` using the literals
  `[1, 2, 3, 4, 5, ..., 100000]`.

- Creating all the even numbers from `2` to `500000` using the literals
  `[2, 4, 6, 8, ..., 500000]`.
  
If studied closely, you will observe that the above tasks introduce a number of noteworthy
concerns:

- The process will be cumbersome and tiring since we having to type all numbers from `1`
  through to `100000` in our source code, which in turn will consume a lot of lines in the
  source code and be difficult to read by others.

- The process will be error-prone because the chances of missing or incorrectly entering a
  number is high.

- The process will be memory expensive in cases where we do not need all values at once, but
  only wants to work on each at a time, as the need arises.

These are cases where "range" comes in as the best alternative. That is, a "range" is the
best to use in any situation that requires creating an iterable that follows an order or
some sort of pattern.

So, what is a range? Simply put, a range is a pair of start/stop iterators packed together
that, when iterated upon, produces an iterable that has a sequence of values within the
start/stop values. Unlike most programming languages, in Julia, the start and stop values
are inclusive of the sequence of values produced. Of course, a step can be provided in the
range, start/step/stop, to make the sequence of values produced follow a defined pattern.

## Type Hierarchy Tree
!!! note
    The tree below is not the complete type hierarchy tree of **`AbstractArray`**. It's
    **ONLY** for the **`AbstractRange`** type.

```julia
Any
└─ AbstractArray
   └─ AbstractRange
      ├─ LinRange
      ├─ OrdinalRange
      │  ├─ AbstractUnitRange
      │  │  ├─ IdentityUnitRange
      │  │  ├─ OneTo
      │  │  ├─ Slice
      │  │  └─ UnitRange
      │  └─ StepRange
      └─ StepRangeLen
```

Note that the `AbstractArray` mentioned above, being the supertype of `AbstractRange`, is
actually `AbstractVector`. However, `AbstractArray{T, 1}` where `T` is an alias for
`AbstractVector`, which means that it is a one-dimensional array. `AbstractArray` was used
instead of `AbstractVector` to keep the information on the hierarchy tree as general as
possible.

## How To Construct A Range
Depending on your use case and programming style, there exist multiple ways to create a
range object in Julia. They are highlighted below.

1. When a range of integers or floating-points with a step size of `1` is needed, use the
   `UnitRange` constructor:

```julia
julia> x = UnitRange(2.3, 5.2)
2.3:4.3

julia> typeof(x)
UnitRange{Float64}

julia> x = UnitRange(1, 5)
1:5

julia> typeof(x)
UnitRange{Int64}

julia> for i in x
           i != lastindex(x) ? print(i, ' ') : print(i)
       end
1 2 3 4 5
```

2. When a range of integers with a step size that is guaranted by the type system to be `1`
   is needed, use the `Base.OneTo` constructor:

```julia
julia> x = Base.OneTo(5)
Base.OneTo(5)

julia> typeof(x)
Base.OneTo{Int64}

julia> for i in x
           i != lastindex(x) ? print(i, ' ') : print(i)
       end
1 2 3 4 5
```

3. When a range of integers with a step size other than `1` is needed, use the `StepRange`
   constructor:

```julia
julia> x = StepRange(1, 2, 10)
1:2:9

julia> typeof(x)
StepRange{Int64, Int64}

julia> x = StepRange(1, Int8(2), 10)
1:2:9

julia> typeof(x)
StepRange{Int64, Int8}

julia> cnt = 1
       for i in x
           cnt != lastindex(x) ? print(i, ' ') : print(i)
           cnt += 1
       end
1 3 5 7 9
```

4. When a range of floating-points with a step size other than `1` is needed, use the
   `StepRangeLen` constructor:

```julia
julia> x = StepRangeLen(1.0f0, 2.0f0, Int8(5))
1.0f0:2.0f0:9.0f0

julia> typeof(x)
StepRangeLen{Float32, Float32, Float32, Int64}

julia> x = StepRangeLen(1.0, 2.0, 5)
1.0:2.0:9.0

julia> typeof(x)
StepRangeLen{Float64, Float64, Float64, Int64}

julia> cnt = 1
       for i in x
           cnt != lastindex(x) ? print(i, ' ') : print(i)
           cnt += 1
       end
1.0 3.0 5.0 7.0 9.0
```

5. If calling the `UnitRange`, `StepRange` or `StepRangeLen` constructor is too verbose for
   you, then use the `:` operator. However, note that the `:` operator has some
   short-comings when compared to the constructors. For example, `:` cannot be used to
   create a `UnitRange{T} where T <: AbstractFloat`:

```julia
julia> 1:5
1:5

julia> typeof(1:5)
UnitRange{Int64}

julia> 1:2:10
1:2:9

julia> typeof(1:2:10)
StepRange{Int64, Int64}

julia> 1.0:2.0:9.0
1.0:2.0:9.0

julia> typeof(1.0:2.0:9.0)
StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}
```

6. When a range with linearly spaced elements between its start and stop is needed, use the
   `LinRange` constructor:

```julia
julia> LinRange(-0.1, 0.3, 5)
5-element LinRange{Float64, Int64}:
 -0.1,-1.38778e-17,0.1,0.2,0.3
```

7. When a range with evenly spaced elements and optimized storage is needed, use the `range`
   function:

```julia
julia> x = range(1, length=100)
1:100

julia> typeof(x)
UnitRange{Int64}

julia> x = range(; length = 10)
Base.OneTo(10)

julia> typeof(x)
Base.OneTo{Int64}

julia> x = range(stop=10, step=1, length=5)
6:1:10

julia> typeof(x)
StepRange{Int64, Int64}

julia> x = range(; stop = 6.5)
1.0:1.0:6.0

julia> typeof(x)
StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}
```

For more information and a comprehensive overview of the constructors and functions
described here, use the `help>` mode in the Julia REPL.

## Notable Benefits Of Ranges Over Other Iterables
- **Terse Syntax**: Ranges provide a concise and readable syntax for creating iterables. For
  example, instead of writing `[1, 2, 3, 4, ..., 50]` for an iterable of elements `1` to
  `50`, one can use `1:50`.

- **Error Free**: There is no chance of making a mistake if the start, stop, and step values
  are provided correctly. For instance, the syntax `1:2:10000` will always create all the
  odd numbers from `1` to `10000`. However, the chances are slim that we could have written
  that in an array as `[1, 3, 5, 7, ..., 9999]` without making a mistake.

- **Lazy Evaluation & Memory Inexpensive**: One of the notable benefits of using a range
  over other kinds of iterables is the *lazy (or delayed) evaluation* we get, which is
  memory-efficient when compared to other kinds of iterables. For example, when we iterate
  over the range `1:10`, we get the sequence `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`. However, in
  memory, this range is comprised of only two integers, `1` and `10`. The values in between
  are only evaluated when we're looping over it, i.e., call-by-need. However, for an array
  created with the literals `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`, it is memory-intensive
  because each element is allocated a size and location in the memory.
"""
function ranges(; extmod=false)
    constants = ["Constants" => ["InsertionSort", "MergeSort", "QuickSort"]]
    macros = ["Macros" => ["@assert", "@boundscheck", "@show", "@showtime", "@simd"]]
    methods = [
        "Methods" => [
            "Cocatenation" => ["cat", "stack", "vcat"],
            "Constructors" => ["range"],
            "Step & Indices" => [
                "eachindex",
                "first",
                "firstindex",
                "get",
                "getindex",
                "indexin",
                "keys",
                "keytype",
                "last",
                "lastindex",
                "nextind",
                "prevind",
                "step",
                "to_indexˣ",
                "to_indices",
            ],
            "Loop" => ["enumerate", "foreach", "pairs", "zip"],
            "Mathematical" => [
                "accumulate",
                "argmax",
                "argmin",
                "cmp",
                "cumprod",
                "cumsum",
                "extrema",
                "intersect",
                "invperm",
                "kron",
                "lcm",
                "max",
                "maximum",
                "min",
                "minimum",
                "minmax",
                "prod",
                "setdiff",
                "sum",
                "symdiff",
                "union",
                "unique",
            ],
            "Reduce" => [
                "add_sumˣ",
                "foldl",
                "foldr",
                "mapfoldl",
                "mapfoldr",
                "mapreduce",
                "mapreduce_emptyˣ",
                "mapreduce_firstˣ",
                "mul_prodˣ",
                "reduce",
                "reduce_emptyˣ",
                "reduce_firstˣ",
            ],
            "Search & Find" => [
                "count",
                "filter",
                "findall",
                "findfirst",
                "findlast",
                "findmax",
                "findmin",
                "findnext",
                "findprev",
            ],
            "Sorting" => [
                "insorted",
                "searchsorted",
                "searchsortedfirst",
                "searchsortedlast",
                "sort",
                "sortperm",
            ],
            "True/False" => [
                "checkbounds",
                "checkbounds_indicesˣ",
                "checkindex",
                "hasfastinˣ",
                "hasproperty",
                "ifelse",
                "in",
                "isa",
                "isapprox",
                "isassigned",
                "isbits",
                "isdefined",
                "isdisjoint",
                "isdoneˣ",
                "isempty",
                "isequal",
                "isgreaterˣ",
                "isless",
                "ismutable",
                "isperm",
                "isreal",
                "issetequal",
                "issubset",
                "isunordered",
                "iszero",
            ],
            "Type-Conversion" => [
                "cconvertˣ",
                "collect",
                "complex",
                "convert",
                "float",
                "oftype",
                "promote",
                "similar",
                "string",
            ],
            "Others" => [
                "broadcast",
                "bytes2hex",
                "checked_lengthˣ",
                "clamp",
                "display",
                "dump",
                "eltype",
                "empty",
                "getfield",
                "getproperty",
                "identity",
                "iterate",
                "join",
                "length",
                "map",
                "nfields",
                "objectid",
                "only",
                "pointer",
                "print",
                "print_rangeˣ",
                "println",
                "printstyled",
                "propertynames",
                "redisplay",
                "repeat",
                "replace",
                "repr",
                "restˣ",
                "reverse",
                "show",
                "size",
                "sizeof",
                "split_restˣ",
                "summary",
                "summarysizeˣ",
                "typeassert",
                "typeof",
            ],
        ],
    ]
    types = [
        "Types" => [
            "AbstractRange",
            "AbstractUnitRange",
            "Colon",
            "DataType",
            "Generatorˣ",
            "IdentityUnitRangeˣ",
            "IteratorEltypeˣ",
            "IteratorSizeˣ",
            "LinRange",
            "LinearIndices",
            "OneToˣ",
            "OrdinalRange",
            "Pair",
            "PartialQuickSort",
            "RangeStepStyleˣ",
            "Ref",
            "Sliceˣ",
            "StepRange",
            "StepRangeLen",
            "TwicePrecisionˣ",
            "UnitRange",
        ],
    ]
    operators = [
        "Operators" => [
            "!",
            "!=",
            "!==",
            "%",
            "'",
            "*",
            "+",
            "-",
            "/",
            ":",
            "<",
            "<<",
            "<=",
            "==",
            "=>",
            ">",
            ">=",
            "\\",
            "^",
            "÷",
            "∈",
            "∉",
            "∋",
            "∌",
            "√",
            "∩",
            "∪",
            "≈",
            "≉",
            "≠",
            "≡",
            "≢",
            "≤",
            "≥",
            "⊆",
            "⊇",
            "⊈",
            "⊉",
            "⊊",
            "⊋",
            "===",
        ],
    ]
    stdlib = [
        "Stdlib" => [
            "Printf.@printf",
            "Printf.@sprintf",
            "Printf.Formatˣ",
            "Printf.Pointerˣ",
            "Printf.PositionCounterˣ",
            "Printf.Specˣ",
            "Printf.formatˣ",
            "Statistics.mean",
            "Statistics.median",
            "Statistics.middle",
            "Statistics.quantile",
            "Statistics.std",
            "Statistics.stdm",
            "Statistics.var",
            "Statistics.varm",
        ],
    ]
    _print_names(constants, macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end
