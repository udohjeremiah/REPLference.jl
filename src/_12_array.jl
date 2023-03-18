@doc raw"""
# ARRAYS
In programming, an array is the most common data structure one would ever work with.
Consider a situation where we need to store the quiz scores of 3 students, represented by 3
integers, and these scores are likely to change as the quiz progresses. If we choose to go
the simple route, we can create 3 variables and initialize each one to a student's score:

```julia
julia> s1_score = 54; s2_score = 49; s3_score = 31;
```

As the quiz progresses, we can simply change the score each student is assigned to:

```julia
julia> s1_score = 78; s2_score = 52; s3_score = 47;
```

The above approach is simple because we only had to store 3 integers. But if there were 5000
students, we wouldn't want to use 5000 variables. And if we needed to change the score for
1000 students, we'd have to re-initialize 1000 variables.

Instead of declaring individual variables, we can declare an array with a unique identifier
name, such as `quiz_scores`, which would contain all the scores of each student. The first
student's score would be the first integer in the array, the second student's score would be
the second integer, and so on. To change the value for a student's score, we'd simply change
the value in the array using the student's position.

This is the simplest reason why arrays are useful in programming: they are commonly used to
organize data so that a related set of values can be easily worked with under one name. In
our case study, using an array for the quiz scores will not only make our work more
organized (since all the scores of the students will be in one container), but it will also
increase our productivity (since we only have to remember the unique identifier name for the
container holding the quiz scores, instead of all the individual variable names).

Technically, an array is a data structure for storing a sequential collection of objects,
which are typically of similar types, ordered and can be repeated, systematically arranged
in rows and/or columns, stored at contiguous and adjacent memory locations, and individually
referenced by using an index.

Each item in an array is called an element. Elements may not always be known beforehand, so
it's sensible to create an array without any elements, hoping to add them later. Such an
array is known as an uninitialized array. The opposite is an initialized array, i.e., an
array declared with elements.

# Types Of Array Based On Size Mutability
In all programming languages, every array has what we call a "capacity" and a "size"
(the word "length" is another word frequently used for "size").

The "capacity" of an array is the maximum number of elements that can be stored in it. The
"capacity" asks "how many can I hold?". While the "length" of an array is the total number
of elements currently stored in it. The "length" asks "how many do I hold?" The "length" of
an array is treated differently among different programming languages and has led to three
types of arrays that are commonly seen today:

- Fixed-length Arrays: the length of the array is set once at compile-time, meaning it is
  determined when the array is created. After creation, its length is fixed and cannot
  change, so elements cannot be added or removed from the array.
- Variable-length Arrays: like a fixed-length array, but its length is determined at
  run-time. Despite its name, you cannot change the size of a variable-length array after it
  has been defined; "variable-length" simply means that the size isn't fixed at compile-time
  and can change from definition to definition.
- Dynamic Arrays: like a variable-length array, but even after its length is determined, we
  can still change it. Hence, elements can be added or removed from the array.

# Types Of Array Based On Dimension
When talking about the dimension of an array, words like "subscripts" and "rank" are also
frequently used:

"Subscript" is another word used for "index," which is the number used to specify an
individual element in an array. The dimension of an array is the number of subscripts
(or indices) needed to specify an individual element, and the "rank" is the number of
dimensions an array has. Based on the dimension of an array, there are mainly two types of
arrays:

- One-Dimensional (1D) Array: contains a row or column of elements; visualize it as a
  horizontal or vertical line, where each position in the line contains an element. A vector
  is a 1D array.
- Multi-Dimensional Arrays: the most common types of multi-dimensional arrays are
  2-dimensional and 3-dimensional arrays. Although dimensions greater than 3 can't be viewed
  in the real world, it's possible to create N-dimensional arrays if one chooses to.

A two-dimensional (2D) array contains a row and column of elements; visualize it as a table,
where each cell contains an element. A matrix is a 2D array. A three-dimensional (3D) array
contains a block, a row, and a column of elements; visualize it as a cube made up of smaller
cubes, where each smaller cube contains an element.

The above definition of the dimension of an array is not sufficient because, as with most
things in programming, the number of subscripts needed to specify individual elements in an
array is language-dependent. For 2D arrays, some languages use `[x, y]` as the indices,
others use `[x][y]`, and to worsen matters, others allow using `[x]`. And even for a 1D
array, where its elements are arrays (i.e., an array of arrays), one would usually use
`[x][y]` to refer to individual elements of the inner arrays. So, how do we separate a 1D
array indexed with `[x][y]` from a 2D array indexed with `[x][y]` if we are to look only at
the index?

A better and more general meaning is this: the dimension of an array is simply a direction
in which you can vary the specification of an array's elements. For example, regardless of
how we choose to do indexing:

- A 1D array will only contain a row or a column; hence, elements can only be chosen from a
  row or a column (just 1 direction).
- A 2D array will contain a row and column; hence, elements are chosen from a row and a
  column (2 directions).
- A 3D array will contain a block, row, and column; hence elements are chosen from a block,
  row, and column (3 directions).

# Types Of Ordering In Arrays
While the elements in an array are always ordered, the way in which the order is handled
varies among programming languages. The representation of elements in 1D arrays can be
either in a column or a row, resulting in
[column vectors and row vectors](https://en.wikipedia.org/wiki/Row_and_column_vectors),
respectively. You can visualize this as column vectors having their elements in a vertical
line and row vectors having their elements in a horizontal line.

For multidimensional arrays, the order in which elements are stored can be either in a
column or a row, leading to [column-major order and row-major order]
(https://en.wikipedia.org/wiki/Row_and_column_vectors), respectively. The difference between
these orders lies in which elements of the array are contiguous in memory. In row-major
order, the consecutive elements of a row are stored next to each other, while in
column-major order, the consecutive elements of a column are stored next to each other.

# Types Of Indexing In Arrays
Different programming languages implement different styles for their indexing systems. Some
allow negative indexing, meaning negative numbers can be used as indices, while others do
not. The three main indexing systems are:

- Zero-Based Indexing: The first and last elements of the array refer to indices `0` and
  `n-1`, respectively.
- One-Based Indexing: The first and last elements of the array refer to indices `1` and `n`,
  respectively.
- N-Based Indexing: The base index of the array can be freely chosen.

Typically, the index type for the indexing systems described above is usually an integer,
used to retrieve a single element from the array. To retrieve multiple values, multiple
indexing must be used. The two types of multiple indexing are:

- Range Indexing: The index type is a range object, where elements with indices within the
  lower and upper bounds of the range are returned.
- Logical Indexing: The index type is a boolean condition that produces an array of boolean
  values. Only elements that return "true" when the condition is applied to them are
  returned. An array used for logical indexing is called a "mask" because it masks out the
  values that are "false".

## Type Hierarchy Tree
!!! note
    The tree below does not represent the complete type hierarchy tree of either
    `AbstractVector` or `AbstractMatrix`, but it shows all the necessary types for working
    with arrays in Julia. This type hierarchy tree assumes that the `SharedArrays` and
    `SparseArrays` modules have been loaded into your namespace.

```julia
Any
└─ AbstractArray
   ├─ AbstractVector        (alias for AbstractArray{T, 1})
   │  ├─ BitVector          (alias for BitArray{1})
   │  ├─ DenseVector        (alias for DenseArray{T, 1})
   │  │  ├─ Vector          (alias for Array{T, 1})
   │  │  └─ SharedVector    (alias for SharedArray{T, 1})
   │  ├─ AbstractSparseVector
   │  │  └─ SparseVector
   │  ├─ CartesianIndices{1, R}
   │  ├─ LinearIndices{1, R}
   │  ├─ LogicalIndex
   │  ├─ PermutedDimsArray{T, 1}
   │  ├─ ReinterpretArray{T, 1, S}
   │  ├─ ReshapedArray{T, 1}
   │  ├─ SubArray{T, 1}
   │  └─ Test.GenericArray{T, 1}
   └─ AbstractMatrix        (alias for AbstractArray{T, 2})
      ├─ BitMatrix          (alias for BitArray{2})
      ├─ DenseMatrix        (alias for DenseArray{T, 2})
      │  ├─ Matrix          (alias for Array{T, 2})
      │  └─ SharedMatrix    (alias for SharedArray{T, 2})
      ├─ AbstractSparseMatrix
      │  └─ AbstractSparseMatrixCSC
      │     └─ SparseMatrixCSC
      ├─ CartesianIndices{2, R}
      ├─ LinearIndices{2, R}
      ├─ PermutedDimsArray{T, 2}
      ├─ ReinterpretArray{T, 2, S}
      ├─ ReshapedArray{T, 2}
      ├─ SubArray{T, 2}
      └─ Test.GenericArray{T, 2}
```

## Noteworthy High-Level Features Of Julia's Arrays
- Julia arrays are dynamic and support multi-dimensional arrays of any dimension.

- In addition to its support for multi-dimensional arrays, Julia provides native
  implementations of many common and useful statistics and linear algebra operations which
  can be loaded with `using Statistics` and `using LinearAlgebra`.

- All arrays are subtypes of the abstract type `AbstractArray`, and external packages can
  define additional subtypes of `AbstractArray` for custom array types. If you define a
  function that expects an array argument, you should declare the type as `AbstractArray` to
  accept any array type.

- The built-in type used for 1D arrays in Julia is `AbstractVector` and the built-in type
  used for 2D arrays is `AbstractMatrix`. Besides these, there are many other built-in array
  types that serve various purposes (see the type hierarchy tree above).

- Zero-dimensional arrays are allowed and they are mutable containers that contain one
  element, not empty. One-dimensional arrays are column vectors with size `n`, not `n×1`,
  and multidimensional arrays are stored in column-major order.

- Array elements should typically be of the same concrete type. If they are not of the same
  type by default, but have a common promoted type, then they are converted to that concrete
  type using `convert`. If no common promoted type is found, the elements are not promoted.

- The type of the elements in the resulting array (`eltype`) is automatically determined
  from the types of the arguments inside the square brackets, `[]`. If the elements have
  different concrete types and no common promotion type exists, the `eltype` of the array
  defaults to `Any`, which allows it to hold any type of data.

- The element type (`eltype`) of an array can be explicitly specified by prepending the type
  to the array literal (in which case, all its elements are converted to the prepended
  type). For example, `T[a, b, c]` creates a 1D array of type `T`, and `a`, `b`, `c`, are
  all converted to `T` (if they're not already of type `T`).

- Julia uses a one-based indexing system and does not allow negative indexing. Range
  indexing is supported in the format `array[start:step:stop]`, where `start` and `stop`
  must be specified, with the last element always included. Logical indexing is also
  supported, but the vector used as an index must have the same length as the indexed
  object. Higher-order functions such as `filter` and `filter!` can be used as alternatives
  to logical indexing. In addition, Julia supports `AbstractArray`s with N-based indexing,
  meaning that arbitrary indexes can be used.

- Array indexing in Julia is of two styles: linear indexing and cartesian indexing (see
  `IndexStyle`). Linear indexing uses a single index (even for multidimensional arrays), and
  elements are retrieved in column major iteration order e.g. `A[i]`. Cartesian indexing
  (written row-first), uses `N` indices for an `N`-dimensional array e.g. a 2D array can be
  indexed as `A[i, j]`. A linear index into the array `A` can be converted to a
  `CartesianIndex` for cartesian indexing with `CartesianIndices(A)[i]`, and a set of `N`
  cartesian indices can be converted to a linear index with
  `LinearIndices(A)[i_1, i_2, ..., i_N]`. Converting from a linear index to a set of
  cartesian indices is slow when compared with the opposite operation. Also, you can write
  `for i in CartesianIndices(A)`, when a `CartesianIndex` representing
  each element in `A` in each iteration is needed. The opposite is also possible:
  `for i in LinearIndices(A)`, where `i` is an `Int`, representing each element's index on
  each iteration.

- Indices can either be of these types:
  - an empty array which select no elements (e.g `A[[]]`).
  - scalars of non-boolean integers or `CartesianIndex{N}` for retrieving a single element
    (e.g `A[1]`, `A[1, 2]`, `A[CartesianIndex(1)]`, `A[CartesianIndex(1, 2)]`).
  - an array of integers or `CartesianIndex{N}`s for retrieving multiple elements
    (e.g. `A[[1, 2]]`, `A[[1 2; 3 4]], `x[[CartesianIndex(1, 2), CartesianIndex(1, 3)]]`).
  - ranges such as `a:c` or `a:b:c`, which select contiguous or strided sections from `a`
    to `c` (inclusive) i.e. range indexing.
  - an array of booleans, which select elements at their true indices  i.e. logical
    indexing e.g `A[[true, true, false]]`, `A[A .> 2]`, `A[isodd.(A)`, `A[[map(isodd, A)]]`.
  - a colon (`:`), which represents all indices within an entire dimension or across the
    entire array (e.g. `A[:]`, `A[:, 1]`, `A[1, 2, :]`). Note that  `CartesianIndex` does
    not support having `:` as one of its index.
  
- In Julia, trailing indices in an array can be omitted if the dimension size is 1. The
  missing dimension will be assumed to be of length 1. For example, you can index into a 3D
  array with shape `(3, 4, 1)` using only two indices e.g. `A[2, 5]`. Omitting all indices
  (e.g. `A[]`), provides a simple idiom to retrieve the only element in an array and
  simultaneously ensure that there was only one element. You can also specify more than the
  required number of indices, provided that the extra indices correspond to dimensions of
  size 1. For example, you can index into a 1D array with two indices e.g. `x[2, 1]`.
  Additionally, an optional trailing comma is allowed in Julia if it does not change the
  meaning of the code. For example, `A[i,]` is equivalent to `A[i]`. However, if the
  dimensions beyond the size of the array are not 1, then the missing indices must be
  explicitly specified. Also, if the indices are specified but the dimension size is not 1,
  then the extra indices are ignored and the last specified index is used. Linear indexing
  takes precedence over this rule.

- The recommended ways to iterate over a whole array are `for a in A` and
  `for i in eachindex(A)`. The first construct is used when you need the value but not the
  index of each element, while the second construct is used when you need the indices, which
  can also be used to retrieve elements with `A[i]`. If `A` is an array type with fast
  linear indexing, `i` in the second construct will be an `Int`, otherwise it will be a
  `CartesianIndex`. It is recommended to use `for i in eachindex(A)` instead of
  `for i in 1:length(A)`, as it is much faster (when `A` is `IndexCartesian`) and provides
  an efficient way to iterate over any array type.

- If you write a custom `AbstractArray` type, you can specify that it has fast linear
  indexing using `Base.IndexStyle(::Type{<:MyArray}) = IndexLinear()`. This setting will
  cause `eachindex` iteration over a `MyArray` to use integers. If you don't specify this
  trait, the default value is `IndexCartesian()`.

- The general syntax for assigning values in an n-dimensional array `A` is:
  `A[I_1, I_2, ..., I_n] = X`, where each `I_k` can be any of the supported index
  types (described above).
  - If all indices `I_k` are integers, then the value in location
    `I_1, I_2, ..., I_n` of `A` is overwritten with the value of `X`, converting to the
    `eltype` of `A` if necessary.
  - If any index `I_k` is itself an array, then the right hand side `X` must also be an
    array with the same shape as the result of indexing `A[I_1, I_2, ..., I_n]` or a vector
    with the same number of elements. The value in location
    `I_1[i_1], I_2[i_2], ..., I_n[i_n]` of `A` is overwritten with the value
    `X[I_1, I_2, ..., I_n]`, converting if necessary.
  - The element-wise assignment operator `.=` may be used to broadcast `X` across the
    selected locations: `A[I_1, I_2, ..., I_n] .= X`.
  - Just as in indexing, the `end` keyword may be used to represent the last index of each
    dimension within the indexing brackets, as determined by the size of the array being
    assigned into. Indexed assignment syntax without the `end` keyword is equivalent to a
    call to `setindex!`: `setindex!(A, X, I_1, I_2, ..., I_n)`.

- Julia does not automatically grow arrays in assignment statements. For example, if the
  length of `A` is less than `5`, the assignment `A[5] = 7` will result in an error.
  However, there are methods such as `push!`, `append!`, etc. that can be used to grow
  arrays.

- Julia arrays are not copied when assigned to another variable. For example, after `A = B`,
  any changes made to elements of `B` will also modify `A`. Updating operators, such as
  `+=`, do not operate in-place. They are equivalent to `A = A + B`, which rebinds the
  left-hand side to the result of the right-hand side expression. This means that
  `A = [1, 1]; B = A; B += [3, 3]` does not change the values in `A`, but instead rebinds
  the name `B` to the result of `B + [3, 3]`, which is a new array. For in-place operations,
  you can use the vectorized dot operator, such as `B .+= [3, 3]`, or explicit loops.

- In Julia, the standard operators on a matrix type perform matrix operations. For example,
  `A * B` performs matrix multiplication, not element-wise multiplication. For element-wise
  operations, use the dot operator, such as `A .* B`.

- Like many programming languages, Julia does not permit operations on vectors of different
  lengths or dimensions. For example, `[1, 2, 3, 4] + [1, 2]` or
  `[1 2; 3 4] + [1 2; 3 4; 5 6]` will result in an error in Julia.

- In Julia, the elements of a collection can be passed as separate arguments to a function
  using the splat operator `...`, as in `f(A...)`. This is similar to extracting
  (or "dereferencing") all elements of a cell array in other languages.

- If your application involves many small (< 100 element) arrays of fixed sizes (i.e. the
  size is known prior to execution), then you might want to consider using the
  `StaticArrays.jl` package. This package allows you to represent such arrays in a way that
  avoids unnecessary heap allocations and allows the compiler to specialize code for the
  size of the array, e.g. by completely unrolling vector operations (eliminating the loops)
  and storing elements in CPU registers.

- Support for multi-dimensional arrays can also be provided by external libraries, which may
  even support arbitrary orderings, where each dimension has a [stride value]
  (https://en.wikipedia.org/wiki/Stride_of_an_array). Row-major or column-major are just two
  possible interpretations of these orderings.

# How To Create Arrays
Many functions for constructing and initializing arrays exist, but only array literals will
be discussed here.

### 0D array - Zero-Dimensional
Zero-dimensional arrays are arrays of the form `Array{T, 0}`. Use the functions `fill`,
`ones`, or `zeros` to create a 0D array.

```julia
julia> fill(1)
0-dimensional Array{Int64, 0}:
1

julia> ones()
0-dimensional Array{Float64, 0}:
1.0

julia> zeros()
0-dimensional Array{Float64, 0}:
0.0
```

They behave similar to scalars, but there are important differences; see
https://docs.julialang.org/en/v1/manual/faq/#faq-array-0dim.

### 1D array - Vector
Wrap the elements in a square bracket, `[]`, seperated by `,`:
```julia
julia> []       # empty vector
Any[]

julia> [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3
```

### 2D array - Matrix
Wrap the elements in square brackets `[]`, separated into columns with whitespace and rows
with a semicolon `;`:
```julia
julia> [;;]       # empty matrix
0×0 Matrix{Any}

julia> [1 2 3]
1×3 Matrix{Int64}:
 1  2  3

julia> [1; 2; 3;;]
3×1 Matrix{Int64}:
 1
 2
 3

julia> [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6
```

### 3D Array
Wrap the elements in square brackets `[]`, separated into columns with whitespace and rows
with semicolons `;`, and blocks with three semicolons `;;;`:
```julia
julia> [;;;]          # empty 3D array
0×0×0 Array{Any, 3}

julia> [1 2 3;;;]
1×3×1 Array{Int64, 3}:
[:, :, 1] =
 1  2  3

julia> [1; 2; 3;;;]
3×1×1 Array{Int64, 3}:
[:, :, 1] =
 1
 2
 3

julia> [1 2 3; 4 5 6;;; 7 8 9; 10 12 13]
2×3×2 Array{Int64, 3}:
[:, :, 1] =
 1  2  3
 4  5  6

[:, :, 2] =
  7   8   9
 10  12  13
```

### N-D Array
Generally, empty n-dimensional arrays can be created using `n` number of semicolons inside
square brackets:
```julia
julia> [;;;;;;]
0×0×0×0×0×0 Array{Any, 6}
```

Just like for 3D arrays, `N`-D arrays can be created using the same syntax, but with `N`
number of semicolons (`;`) to denote the end of each dimension. There is also the `reshape`
or `cat` function for creating arrays of dimensions greater than 3.

### Creating An Uninitialized Array
To create an uninitialized array, you can use `UndefInitializer` or `undef` with the
constructors `Array`, `Vector`, `Matrix`, or `BitArray`. There is also the function
`similar`, which creates an uninitialized mutable array based on an existing array.


### Creating An Array From Comprehensions And Generator Expressions
Comprehensions provide a general and powerful way to construct arrays, with the resulting
array being an `N`-dimensional dense array. The type of the resulting array depends on the
types of the computed elements, just like in array literals.

For single iterable comprehension, the syntax is:

```julia
[i for i in iter if cond]
```

And for multiple iterable comprehension, the syntax is:

```julia
[(i, j, ...) for i in iter if cond for j in iter if cond ...)]

[(i, j, ...) for i in iter, j in iter, ...]
```

"`=`" can be used in place of "`in`". The `if cond` is used for filtering values, and its
optional.

In the second form of the multiple comprehensions, where multiple `for` keywords are used,
ranges can depend on previous ranges. In such cases, the result is always a 1D array e.g.
`[(i, j) for i=1:3 for j=1:i]`.

In order to control the type explicitly in comprehensions, a type can be prepended to the
expression, just like in array literals, for example `T[i for i in iter if cond]`.

Comprehensions can also be written without square brackets, producing a generator object.
The syntax is the same as comprehensions, with the square brackets `[]` being replaced by
parentheses `()`.

A generator object can be iterated to produce values as needed, avoiding the allocation of
an array to store them in advance. For instance, the following expression calculates the sum
of a series without allocating memory:

```julia
julia> sum(1/n^2 for n=1:1000)
1.6439345666815615
```

When writing a generator expression in an argument list, parentheses can be omitted if the
generator is the last argument, for example `map(Tuple, i for i=1:4)`. If the generator is
not the last argument, parentheses must be used to separate it from subsequent arguments,
for example `map(tuple, (i for i=1:4), 5:8)`.

Generators are implemented as inner functions, which means they can "capture" variables from
the enclosing scope, just like inner functions in the language. For example,
`sum(p[i] - q[i] for i=1:n)` captures the variables `p`, `q`, and `n` from the surrounding
scope. However, captured variables can lead to performance issues, so it is important to
understand their effects, as outlined in the Julia manual at
https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-captured.

# Looping Over Arrays
Multidimensional arrays in Julia are stored in column-major order, meaning that arrays are
stacked column by column (verify this with the function `vec` or the `[:]` syntax). The
ordering of arrays can affect performance when looping over them. In column-major arrays,
the first index changes most quickly, so looping is faster when the innermost loop index is
the first in a slice expression. Indexing an array with `:` is an implicit loop that
iterates through all elements in a particular dimension. In Julia, it may be faster to
extract columns rather than rows. For more information, see the link:
https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-column-major.

# Adding And/Or Removing Elements From An Array
### 1D Arrays
In Julia, arrays are dynamic, meaning their contents can be modified after creation. To
remove an element, use functions like `pop!`, `popfirst!`, etc. To insert an element, use
`push!`, `pushfirst!`, etc. The length of an array can also be modified using `resize!`,
`sizehint!`, etc.

### Multidimensional Arrays
The methods described above for modifying arrays only work for 1D arrays because
multidimensional arrays can't have an element deleted as this will change their shape.
However, one can assign `0` (or any other relevant value) at the location of the
element to be deleted. This will not affect the order or shape of the array. Another way to
modify a multidimensional array is by deleting an entire row or column.

Some programming languages that support multidimensional arrays have syntax for adding or
deleting a row or column (e.g., Matlab). However, in Julia, this is not allowed because
adding or deleting a row or column requires creating a copy of the original array. Instead
of doing these operations behind the scenes, Julia makes them explicit, thereby having more
transparent performance characteristics.

If you know the size of your data in advance, it is always better to preallocate and then
insert elements in the allocated space to gain the most performance. However, there are
workarounds for adding or deleting a column or row in Julia. These include using a vector of
arrays to represent your multidimensional array and then converting the array to a
multidimensional array using the concatenation syntax, or creating a copy of the array and
using logical indexing to remove a column or row. For example:

```julia
julia> a = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
3-element Vector{Vector{Int64}}:
 [1, 2, 3]
 [4, 5, 6]
 [7, 8, 9]

julia> A = hcat(a...)
3×3 Matrix{Int64}:
 1  4  7
 2  5  8
 3  6  9

julia> [A; 10 11 12]            # to add a new row
4×3 Matrix{Int64}:
  1   4   7
  2   5   8
  3   6   9
 10  11  12

julia> hcat(A, [10, 11, 12])    # to add a new column
3×4 Matrix{Int64}:
 1  4  7  10
 2  5  8  11
 3  6  9  12

julia> A[1:end .!= 1, :]        # to remove the first row
2×3 Matrix{Int64}:
 2  5  8
 3  6  9

julia> A[:, 1:end .!= 1]        # to remove the first col
3×2 Matrix{Int64}:
 4  7
 5  8
 6  9
```

We can perform more complex logical indexing, such as removing the 1st and 3rd rows along
with the 2nd and 4th columns:

```
julia> A[1:end .∉ [[1, 3]], 1:end .∉ [[2, 4]]]
1×2 Matrix{Int64}:
 2  8
```

You can also use `eachrow` or `eachcol`, a method that creates a generator that iterates
over the first or second dimension of an array. You can use `dropdims` when a dimension is
to be deleted. Additionally, there is the `ElasticArrays.jl` package, which provides
resizeable multidimensional arrays for Julia.

# Concatenation Of Arrays
Concatenating arrays in Julia can be done in two ways:
- using the concatenation functions provided.
- using the array concatenation syntaxes, which are just shorthands for the concatenation
  functions.

### Using The Concatenation Functions Provided
There exists many workarounds for concatenating arrays along a dimension in Julia. However,
the primary functions provided for this operation are: `cat`, `hcat`, `vcat`, `hvcat`,
`hvncat`, and `stack`.

### Using The Array Concatenation Syntaxes
Normally, a list of values wrapped in square brackets (`[]`), separated by commas (`,`),
creates a Vector, regardless of what values are in the brackets:

```julia
julia> [1:2, 3:4, [5, 6], 7]
4-element Vector{Any}:
  1:2
  3:4
  [5, 6]
 7
```

However, if the arguments inside the square brackets are separated by:

- Single semicolons (`;`) or newlines, then they are vertically concatenated. For example,
  `[1:2; [3]; 4]`.
- Multiple semicolons, spaces (or tabs), then they are horizontally concatenated. For 
  example, `[1:2 [3, 4] [5, 6]], [1:2;; 3:4;; 5:6]`.
- Single semicolons (or newlines) and multiple semicolons (or spaces), then they are
  combined to concatenate both horizontally and vertically at the same time. For example,
  `[1 2; 3 4]`.

The general syntax is:

| Syntax                 | Function | Description                                   |
|:---------------------- |:---------|:----------------------------------------------|
|                        | `cat`    | Concatenate input arrays along                |
|                        |          | dimension(s) `k`.                             |
|                        |          |                                               |
| `[A; B; C; ...]`       | `vcat`   | Concatenate in the first ("vertical")         |
|                        |          | dimesion; shorthand for                       |
|                        |          | `cat(A...; dims=1)`.                          |
|                        |          |                                               |
| `[A B C ...]`          | `hcat`   | Concatenate in the second ("horizontal")      |
|                        |          | dimension; shorthand for                      |
|                        |          | `cat(A...; dims=2)`.                          |
|                        |          |                                               |
| `[A B; C D; ...]`      | `hvcat`  | Simultaneous vertical and horizontal          |
|                        |          | concatenation.                                |
|                        |          |                                               |
| `[A; C;; B; D;;; ...]` | `hvncat` | Simultaneous n-dimensional concatenation,     |
|                        |          | where number of semicolons indicate the       |
|                        |          | dimension to concatenate.                     |

The highest number of repeated semicolons used inside an array concatenation expression
determines the dimension of the resulting array. For example the function calls,
`ndims([1:2 ; 3:4])`, `ndims([1:2 ;; 3:4])`, `ndims([1:2 ;;; 3:4])`,
`ndims([1:2; 3:4; 5:6;;; 7:8; 9:10; 11:12])` returns `1`, `2`, `3`, `4`, respectively.

Terminating semicolons may also be used to add trailing length-1 dimensions; this is
especially useful for creating `n×1` multidimensional arrays, e.g., `[1:2;]`, `[1:2;;]`.

# Vectorizing And Broadcasting Of Arrays
To allow for easy vectorization of mathematical and other operations, Julia provides the dot
syntax `f.(args...)`, such as `sin.(x)` or `min.(x, y)`, for element-wise operations on
arrays or combinations of arrays and scalars
(https://docs.julialang.org/en/v1/manual/arrays/#Broadcasting). These operations benefit
from "fusion," where they are combined into a single loop, as demonstrated in
`sin.(cos.(x))`.

Every binary operator in Julia also has a dot version that can be applied to arrays and
combinations of arrays and scalars in broadcast operations
(https://docs.julialang.org/en/v1/manual/functions/#man-vectorized), such as
`z .> sin.(x .* y)`.

It's important to note that non-dot comparisons like `==`, `>`, etc. perform lexicographic
operations on whole arrays, while dot comparisons like `.==`, `.>`, etc. perform
element-wise comparisons.

For element-by-element binary operations on arrays of different sizes, Julia provides the
`broadcast` function. This expands singleton dimensions in arrays to match corresponding
dimensions in the other arrays without using additional memory and performs the given
function element-wise. Dotted operations, such as `.+`, `.*`, and nested dot calls, such as,
`f.(...)`, `f.(g.(...))`, are equivalent to `broadcast` calls, but they fuse into a single
broadcast call. There is also the `broadcast!` function, which allows you to specify a
destination.

If you want to prevent a container, such as an array, from participating in broadcast, you
can place it inside another container, such as a single-element tuple. Broadcast will then
treat the container as a single value. For example:

```julia
julia> ([1, 2, 3], [4, 5, 6]) .+ ([1, 2, 3],)
([2, 4, 6], [5, 7, 9])
```

# Sorting An Array
Julia has an extensive and flexible API for sorting and interacting with already-sorted
arrays of values. By default, Julia selects reasonable algorithms and sorts in ascending
order. The full function signature of the `sort` function for 1D and multidimensional arrays
is shown below:

```julia
sort(v; alg::Algorithm=defalg(v), lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)

sort(A; dims::Integer, alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)
```

This shows that we can sort:

- along a given dimension using the `dims` keyword.
- choose our own sort algorithm from the predefined ones using the `alg` keyword.
- specify our own "less than" function using the `lt` keyword.
- sort according to an arbitrary transformation of the values using the `by` keyword.
- sort in reverse order using the `rev` keyword.
- specify the order using the `order` keyword.

These options are independent and can be combined in all possible ways. If both `by` and
`lt` are specified, the `lt` function is applied to the result of the `by` function. To sort
an array in-place, use the "bang" version of the sort function, i.e., `sort!`.

Instead of directly sorting an array, you can compute a permutation of the array's indices
that puts the array into sorted order, using the functions `sortperm` and `sortperm!`.

# SubArrays
In Julia, slicing operations like `x[1:10]` create a copy by default. However, copying data
is not always the fastest option; in some cases, using a "view" into the parent array is
more efficient. To address this, Julia provides functions and macros like `view`, `@view`,
and `@views` for creating a "view" of a parent array, which is returned as a `SubArray`
type. `SubArray` in Julia refers to the type of an array that shares memory with another
array — that is, it's a container encoding a "view" of a parent AbstractArray.

A "view" in a parent `AbstractArray` acts like an array, but the underlying data is actually
part of another array. For example, adding the `@view` macro to the slicing operation
`x[1:10]` changes it to a "view" that acts like a 10-element array, but accesses the first
`10` elements of `x`. This can also be achieved by using the `view` function, which is like
`getindex` but returns a `SubArray`. Since a "view" is just a view of the parent array,
writing to it writes directly to the parent array.

The `@views` macro can be applied to a whole block of code to change all slicing operations
in the block to return a view. To return the parent array from a `SubArray`, use `parent`.
The choice between using a copy or a view depends on the specific case and is described in
more detail in the link
https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-views.

# Missing Values
In Julia, missing values in the statistical sense are represented using the `missing`
object. It is the single instance of the `Missing` type, and is equivalent to `NULL` in SQL
and `NA` in R. `missing` behaves like these in most situations.

For more information on how the `Missing` type works, including arrays with `missing`
values, refer to https://docs.julialang.org/en/v1/manual/missing/.

# Bounds Checking
Like many modern programming languages, Julia uses bound checking to ensure program safety
when accessing arrays. In tight inner loops or performance-critical situations, you may want
to skip these checks to improve runtime performance. For example, to emit vectorized (SIMD)
instructions, the loop body cannot contain branches, including bound checks. To address
this, Julia includes the `@inbounds(...)` macro, which tells the compiler to skip bound
checks within the specified block. Array types defined by the user can also use the
`@boundscheck(...)` macro for context-sensitive code selection.

The `--check-bounds` option can be used to launch Julia with the `yes`, `no`, or `auto`
setting to always, never, or respect `@inbounds` declarations, respectively. For more
information on bound checking, see the documentation at
https://docs.julialang.org/en/v1/devdocs/boundscheck/#Bounds-checking.

# Strided Arrays
In Julia, a strided array is a set of hard-coded union of common array types and is a
subtype of `AbstractArray`. Its entries are stored in memory with fixed strides.

Here are some examples to demonstrate which type of arrays are strided and which are not:

```julia
1:5 # not strided (there is no storage associated with this array.)
Vector(1:5)              # is strided with strides (1,)
A = [1 5; 2 6; 3 7; 4 8] # is strided with strides (1, 4)
V = view(A, 1:2, :)      # is strided with strides (1, 4)
V = view(A, 1:2:3, 1:2)  # is strided with strides (2, 4)
V = view(A, [1,2,4], :)  # is not strided, as the spacing between rows is not fixed.
```

These hard-coded `Union`s follow the strided array interface and are unexported; use
`Base.Strided<TAB><TAB>` to see a full list of these `UnionAll` types. See
https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-strided-arrays for the
strided array interface in Julia.

# Sparse Arrays
Sparse arrays are arrays that contain many zero values, making it more space and time
efficient to store them in a specialized data structure, as compared to dense arrays. Julia
provides support for sparse arrays in the `SparseArrays` standard library module, which can
be loaded by using `using SparseArrays`. For more information on `SparseArrays`, visit
https://docs.julialang.org/en/v1/stdlib/SparseArrays.

# Shared Arrays
Additionally, for large scale, multi-node parallel computing, Julia provides distributed
arrays through the `Distributed` package. These arrays are stored and operated on across
multiple machines, allowing for efficient computation on large datasets.

See https://docs.julialang.org/en/v1/stdlib/Distributed/ for more information on distributed
arrays in Julia.

# Offset Arrays
While arrays in Julia start indexing at 1, they also support arrays with arbitrary indices.
For more information on writing custom array types with non-1 indexing, see
https://docs.julialang.org/en/v1/devdocs/offset-arrays/.

Additionally, the package `OffsetArrays.jl` provides arrays with arbitrary indices similar
to those found in programming languages such as Fortran.

# Iteration Utilities
Julia provides the `Iterators` module, which has methods for working with iterators. See
https://docs.julialang.org/en/v1/base/iterators for a list of the available methods.

# `Base.Cartesian`
The (non-exported) `Cartesian` module provides macros that facilitate writing
multidimensional algorithms. Most often, you can write such algorithms with straightforward
techniques, however, there are a few cases where `Base.Cartesian` is still useful or
necessary. For more information on how it works, see
https://docs.julialang.org/en/v1/devdocs/cartesian.

# Custom Implementation & Interfaces Of An Array
If you wish to implement a custom array that resembles the `AbstractArray` in the `Base`
package, see the following resources for more information:
https://docs.julialang.org/en/v1/manual/arrays/#Implementation,
https://docs.julialang.org/en/v1/manual/interfaces.
"""
function arrays(; extmod=false)
    constants = [
        "Constants" =>
            ["InsertionSort", "Base.MergeSort", "QuickSort", "missing", "nothing", "undef"],
    ]
    macros = [
        "Macros" => [
            "@assert",
            "@b_str",
            "@boundscheck",
            "@coalesce",
            "@inbounds",
            "@show",
            "@showtime",
            "@simd",
            "@something",
            "@view",
            "@views",
        ],
    ]
    methods = [
        "Methods" => [
            "Concatenation" => ["cat", "hcat", "hvcat", "hvncat", "stack", "vcat"],
            "Constructors" => [
                "falses",
                "fill",
                "ones",
                "repeat",
                "similar",
                "trues",
                "vectˣ",
                "zeros",
            ],
            "Dimension, Size & Indices" => [
                "axes",
                "checked_lengthˣ",
                "dropdims",
                "eachindex",
                "eachcol",
                "eachrow",
                "eachslice",
                "elsizeˣ",
                "first",
                "firstindex",
                "get",
                "getindex",
                "indexin",
                "keys",
                "keytype",
                "last",
                "lastindex",
                "mapslices",
                "ndims",
                "nextind",
                "permutedims",
                "prevind",
                "reverse",
                "selectdim",
                "setindexˣ",
                "size",
                "sizeof",
                "to_indexˣ",
                "to_indices",
            ],
            "In-Place" => [
                "accumulate!",
                "all!",
                "any!",
                "append!",
                "broadcast!",
                "circcopy!",
                "circshift!",
                "clamp!",
                "conj!",
                "copy!",
                "copyfirst!ˣ",
                "copyto!",
                "count!",
                "cumprod!",
                "cumsum!",
                "delete!",
                "deleteat!",
                "digits!",
                "empty!",
                "extrema!",
                "fill!",
                "filter!",
                "findmax!",
                "findmin!",
                "hex2bytes!",
                "insert!",
                "intersect!",
                "invpermute!",
                "keepat!",
                "kron!",
                "map!",
                "maximum!",
                "minimum!",
                "partialsort!",
                "partialsortperm!",
                "permute!",
                "permutedims!",
                "pop!",
                "popat!",
                "popfirst!",
                "prepend!",
                "prod!",
                "push!",
                "pushfirst!",
                "read!",
                "readbytes!",
                "replace!",
                "resize!",
                "reverse!",
                "setdiff!",
                "sizehint!",
                "sort!",
                "sortperm!",
                "splice!",
                "sum!",
                "symdiff!",
                "union!",
                "unique!",
                "unsafe_copyto!",
            ],
            "Loop" => ["enumerate", "foreach", "pairs", "zip"],
            "Mathematical" => [
                "accumulate",
                "acos",
                "acot",
                "acotd",
                "acoth",
                "acsc",
                "acscd",
                "acsch",
                "adjoint",
                "argmax",
                "argmin",
                "asec",
                "asecd",
                "asech",
                "asin",
                "asind",
                "asinh",
                "atan",
                "atand",
                "atanh",
                "canonicalize2ˣ",
                "cis",
                "cmp",
                "conj",
                "cos",
                "cosd",
                "cosh",
                "cot",
                "coth",
                "csc",
                "csch",
                "cumprod",
                "cumsum",
                "diff",
                "exp",
                "extrema",
                "intersect",
                "inv",
                "invperm",
                "kron",
                "lcm",
                "log",
                "max",
                "maximum",
                "min",
                "minimum",
                "minmax",
                "muladd",
                "prod",
                "rot180",
                "rotl90",
                "rotr90",
                "sec",
                "sech",
                "setdiff",
                "sin",
                "sincos",
                "sincosd",
                "sind",
                "sinh",
                "sqrt",
                "sum",
                "symdiff",
                "tan",
                "tand",
                "tanh",
                "transpose",
                "union",
                "unique",
            ],
            "Missing & Nothing" =>
                ["coalesce", "notnothingˣ", "skipmissing", "something"],
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
                "partialsort",
                "partialsortperm",
                "searchsorted",
                "searchsortedfirst",
                "searchsortedlast",
                "sort",
                "sortperm",
                "sortslices",
            ],
            "True/False" => [
                "all",
                "allequal",
                "allunique",
                "any",
                "checkbounds",
                "checkbounds_indicesˣ",
                "has_offset_axesˣ",
                "hasfastinˣ",
                "ifelse",
                "in",
                "isa",
                "isapprox",
                "isassigned",
                "isbits",
                "isdisjoint",
                "isdoneˣ",
                "isempty",
                "isequal",
                "isgreaterˣ",
                "isless",
                "ismissing",
                "ismutable",
                "isnothing",
                "isone",
                "isperm",
                "isreal",
                "issetequal",
                "issorted",
                "issubset",
                "isunordered",
                "iszero",
                "promote",
            ],
            "Type-Conversion" => [
                "cconvertˣ",
                "collect",
                "complex",
                "convert",
                "float",
                "oftype",
                "promote",
                "promote_shape",
                "string",
                "transcode",
                "vec",
            ],
            "Others" => [
                "PipeBuffer",
                "SecretBuffer!ˣ",
                "alignmentˣ",
                "broadcast",
                "bytes2hex",
                "circshift",
                "copy",
                "copymutableˣ",
                "dataidsˣ",
                "deepcopy",
                "display",
                "dump",
                "eltype",
                "empty",
                "hash",
                "identity",
                "iterate",
                "join",
                "length",
                "map",
                "mightaliasˣ",
                "objectid",
                "only",
                "parent",
                "parentindices",
                "print",
                "print_matrix_rowˣ",
                "print_matrix_vdotsˣ",
                "print_matrixˣ",
                "println",
                "printstyled",
                "real",
                "redisplay",
                "reim",
                "reinterpret",
                "replace",
                "replace_with_centered_markˣ",
                "repr",
                "require_one_based_indexingˣ",
                "reshape",
                "restˣ",
                "reverseind",
                "show",
                "split_restˣ",
                "stride",
                "strides",
                "summary",
                "summarysizeˣ",
                "typeassert",
                "typeof",
                "unaliascopyˣ",
                "unaliasˣ",
                "unsafe_wrap",
                "valtype",
                "values",
                "view",
                "zero",
            ],
        ],
    ]
    types = [
        "Types" => [
            "AbstractArray",
            "AbstractMatrix",
            "AbstractSlices",
            "AbstractVecOrMat",
            "AbstractVector",
            "Array",
            "BitArray",
            "BitMatrix",
            "BitVector",
            "Bitsˣ",
            "CartesianIndex",
            "CartesianIndices",
            "Colon",
            "ColumnSlices",
            "Cvoid",
            "DataType",
            "DenseArray",
            "DenseMatrix",
            "DenseVecOrMat",
            "DenseVector",
            "Dims",
            "Generatorˣ",
            "IndexCartesian",
            "IndexLinear",
            "IndexStyle",
            "IteratorEltypeˣ",
            "IteratorSizeˣ",
            "LinearIndices",
            "LogicalIndexˣ",
            "Matrix",
            "Missing",
            "Nothing",
            "Pair",
            "PartialQuickSort",
            "PermutedDimsArray",
            "Ref",
            "ReinterpretArrayˣ",
            "RowSlices",
            "ScalarIndexˣ",
            "Slices",
            "Sliceˣ",
            "Some",
            "StridedArray",
            "StridedMatrix",
            "StridedVecOrMat",
            "StridedVector",
            "SubArray",
            "UndefInitializer",
            "VecOrMat",
            "Vector",
        ],
    ]
    operators = [
        "Operators" => [
            "!",
            "!=",
            "!==",
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
            ">>",
            ">>>",
            "\\",
            "^",
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
            "Statistics.cor",
            "Statistics.cov",
            "Statistics.mean",
            "Statistics.mean!",
            "Statistics.median",
            "Statistics.median!",
            "Statistics.middle",
            "Statistics.quantile",
            "Statistics.quantile!",
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
