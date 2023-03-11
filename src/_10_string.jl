@doc raw"""
# STRINGS
In mathematics, a sequence is an enumerated collection of objects in which repetitions are
allowed and order matters. Like a set, it contains members (also called elements or terms).
The number of elements (possibly infinite) is called the length of the sequence. Unlike a
set, the same elements can appear multiple times at different positions in a sequence, and
unlike a set, the order does matter.

In computer programming, strings are *finite sequences of encoded characters*. This means:

- Strings are made up of ordered sequences of characters.
- Strings can have characters repeated.
- Strings may contain any sequence of characters, visible or invisible.
- Strings are only interpretable in the context of the character encoding used.

In programming, any data type that can hold more than one item of data is known as a data
structure. When speaking about data structures, it's common in the programming space to not
include strings. However, technically, a string (since it's made up of characters) is a data
structure.

Encoding means a standard that translates a character into a sequence of bits. Character
encoding is the process of assigning numbers to characters, allowing them to be stored,
transmitted, and transformed using digital computers. By "encoded characters," it means each
character has a number assigned to it depending on the encoding in use. This means we don't
have "plain" characters; they all must have an encoding.

But why do we have different encodings? Well, we live in a world of diverse languages, which
means words are represented in different alphabets around the world, thus leading to a
different writing system. For English speakers, it's the familiar `A`, `b`, `2`, and their
counterparts, which are standardized by ASCII. For non-English speakers in Eurasia, it is
the familiar `Щ`, `Ж`, `И`, and their counterparts, which are known as the Cyrillic or
Slavic script. This goes on and on for different regions around the world. So we might have
a string of characters, but without knowing its encoding, it becomes useless as to what to
make from the characters.

The [Unicode standard](https://en.wikipedia.org/wiki/Unicode) tackles the complexities of
what exactly a character is, which has been able to simplify the picture and is now
generally accepted as the definitive standard addressing this problem.

Julia makes dealing with plain ASCII text simple and efficient, and handling Unicode is also
as simple and efficient as possible. In particular, you can write C-style string code to
process ASCII strings, and they will work as expected, both in terms of performance and
semantics. If such code encounters non-ASCII text, it will gracefully fail with a clear
error message, rather than silently introducing corrupt results. When this happens,
modifying the code to handle non-ASCII data is straightforward.

See the "Characters" manual on `REPLference.jl` or the Julia documentation for more
information about characters.

## Type Hierarchy Tree
```julia
Any
└─ AbstractString
   ├─ LazyString
   ├─ String
   ├─ SubString
   ├─ SubstitutionString
   └─ Test.GenericString
```

## Noteworthy High-Level Features Of Julia's Strings
- All string types are subtypes of the abstract type `AbstractString`, and external packages
  define additional `AbstractString` subtypes (e.g. for other encodings). If you define a
  function that expects a string argument, you should declare the type as `AbstractString`
  in order to accept any string type.

- The built-in concrete type used for strings (and string literals) in Julia is `String`.
  This supports the full range of Unicode characters via the
  [UTF-8](https://en.wikipedia.org/wiki/UTF-8) encoding. A `transcode` function is provided
  to convert to/from other Unicode encodings.

- Like C and Java, but unlike most dynamic languages, Julia has a first-class type for
  representing a single character, called `AbstractChar`. The built-in `Char` subtype of
  `AbstractChar` is a 32-bit primitive type that can represent any Unicode character (and
  which is based on the UTF-8 encoding).

- As in Java, strings are immutable: the value of an `AbstractString` object cannot be
  changed. To construct a different string value, you must construct a new string from parts
  of other strings.

- Conceptually, a string is a partial function from indices to characters: for some index
  values, no character value is returned, and instead an exception is thrown. This allows
  for efficient indexing into strings by the byte index of an encoded representation rather
  than by a character index, which cannot be implemented both efficiently and simply for
  variable-width encodings of Unicode strings.

Use the `help>` mode in the Julia REPL for information on the other subtypes of
`AbstractString`.

# String Basics
- String literals are delimited by double quotes or triple double quotes. Triple-quoted
  string literals can contain quote (`"`) characters without escaping:

```julia
julia> str = "Hello, world.\n"
"Hello, world.\n"

julia> \"""Contains "quote" characters\"""
"Contains \\"quote\\" characters"
```

- Long lines in strings can be broken up by preceding the newline with a backslash (`\`).
  Notice the space between the last character `g` and `\`:

```
julia> "This is a long \
       line"
"This is a long line"
```

- If you want to extract a character from a string, you index into it. The index of the
  first and last element of a string (a character) is returned by `firstindex(str)` and
  `lastindex(str)` respectively. String indexing, like most indexing in Julia, is 1-based:
  so `firstindex` always returns `1`` for any `AbstractString`; however, `lastindex(str)` is
  not in general the same as `length(str)` for a string, because some Unicode characters can
  occupy multiple "code units":

```
julia> str = "Hello, world.\n";

julia> str[1]
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> str[6]
',': ASCII/Unicode U+002C (category Po: Punctuation, other)

julia> str[14]
'\n': ASCII/Unicode U+000A (category Cc: Other, control)
```

- The keywords `begin` and `end` can be used inside an indexing operation as a shorthand for
  the first and last indices, respectively, along the given dimension. You can also perform
  arithmetic and other operations with `begin` and `end`, just like a normal value. Using an
  index less than `begin` (i.e. `1`) or greater than `end` raises an error:

```
julia> str = "Hello, world.\n";

julia> str[begin]
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> str[begin+1]
'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)

julia> str[end]
'\n': ASCII/Unicode U+000A (category Cc: Other, control)

julia> str[end-1]
'.': ASCII/Unicode U+002E (category Po: Punctuation, other)

julia> str[end÷2]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)

julia> str[begin-1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [0]

julia> str[end+1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [15]
```

- You can also extract a substring using range indexing (i.e. slicing). Note that the
  expressions `str[k]` and `str[k:k]` do not give the same result. `str[k]` is a single
  character value of type `Char`, while `str[k:k]` is a string value that happens to contain
  only a single character - in Julia, these are very different things:

```
julia> str[4:9]
"lo, wo"

julia> str[6]
',': ASCII/Unicode U+002C (category Po: Punctuation, other)

julia> str[6:6]
","
```

- While range indexing makes a copy of the selected part of the original string, it's
  possible to create a view into a string using the type `SubString`. Several standard
  functions like `chop`, `chomp` or `strip` also return a `SubString`:

```
julia> str = "long string"
"long string"

julia> substr = SubString(str, 1, 4)
"long"

julia> substr = SubString(str, 1:4)
"long"

julia> typeof(substr)
SubString{String}
```

While the above was described in relation to `String`s, it is general to all indexing
behaviors of any type that supports range indexing. That is, slicing with `x[i:i]` returns
an object of the same type as `x` composed of the element `x[i]`.

# Unicode and UTF-8
Julia fully supports Unicode characters and strings. Unicode code points can be represented
using Unicode `\u` and `\U` escape sequences, as well as all the standard C escape
sequences. These can likewise be used to write string literals. Whether these Unicode
characters are displayed as escapes or shown as special characters depends on your
terminal's locale settings and its support for Unicode.

```
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"
```

String literals are encoded using the UTF-8 encoding. UTF-8 is a variable-width encoding,
meaning that not all characters are encoded in the same number of bytes ("code units"). In
UTF-8, ASCII characters, i.e. those with code points less than 0x80 (128), are encoded as
they are in ASCII, using a single byte, while code points 0x80 and above are encoded using
multiple bytes — up to four per character.

String indices in Julia refer to code units (bytes for UTF-8), the fixed-width building
blocks that are used to encode arbitrary characters (code points). This means that not every
index into a `String` is necessarily a valid index for a character. If you index into a
string at such an invalid byte index, an error is thrown:

```julia
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"

julia> s[1]
'∀': Unicode U+2200 (category Sm: Symbol, math)

julia> s[2]
ERROR: StringIndexError: invalid index [2], valid nearby indices [1]=>'∀', [4]=>' '

julia> s[3]
ERROR: StringIndexError: invalid index [3], valid nearby indices [1]=>'∀', [4]=>' '

julia> s[4]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)
```

In this case, the character `∀` is a three-byte character, so the indices `2` and `3` are
invalid, and the next character's index is `4`. This next valid index can be computed by
`nextind(s, 1)`, and the next index after that by `nextind(s, 4)` and so on.

Since `end` is always the last valid index into a collection, `end-1` references an invalid
byte index if the second-to-last character is multibyte.

```
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"

julia> s[end-1]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)

julia> s[end-2]
ERROR: StringIndexError: invalid index [9], valid nearby indices [7]=>'∃', [10]=>' '
```

As seen above, the first case works because the last character `y` and the space are
one-byte characters, whereas `end-2` indexes into the middle of the `∃` multibyte
representation. The correct way for this case is to use `prevind(s, lastindex(s), 2)` or, if
you're using that value to index into `s`, you can write `s[prevind(s, end, 2)]`, and `end`
expands to `lastindex(s)`:

```julia
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"

julia> s[prevind(s, end, 2)]
'∃': Unicode U+2203 (category Sm: Symbol, math)
```

Extraction of a substring using range indexing also expects valid byte indices or an error
is thrown:

```
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"

julia> s[1:1]
"∀"

julia> s[1:2]
ERROR: StringIndexError: invalid index [2], valid nearby indices [1]=>'∀', [4]=>' '

julia> s[1:3]
ERROR: StringIndexError: invalid index [3], valid nearby indices [1]=>'∀', [4]=>' '

julia> s[1:4]
"∀ "
```

Due to variable-length encodings, the number of characters in a string, given by
`length(s)`, is not always the same as the last index. If you iterate through the indices
`1` through `lastindex(s)` and index into `s`, the sequence of characters returned, when
errors aren't thrown, is the sequence of characters comprising the string `s`. Therefore,
`length(s) <= lastindex(s)`, since each character in a string must have its own index.

You can use the string as an iterable object to get through the valid indices without
requiring any exception handling. The blank lines, as shown below, actually have spaces on
them:

```
julia> for c in s
           println(c)
       end
∀

x

∃

y
```

## How To Obtain Valid Indices For A String
If you need to obtain valid indices for a string, you can use the `nextind` and `prevind`
functions to increment or decrement to the next or previous valid index, as mentioned above.
You can also use the `eachindex` function to iterate over the valid character indices:

```
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"

julia> x = 1
       for i in 1:length(s)
           print(x, ' ')
           x = nextind(s, x)
       end
1 4 5 6 7 10 11

julia> x = lastindex(s)
       for i in 1:length(s)
           print(x, ' ')
           x = prevind(s, x)
       end
11 10 7 6 5 4 1

julia> collect(eachindex(s))
7-element Vector{Int64}:
  1
  4
  5
  6
  7
 10
 11
```

## Code Units Of Characters In A String
Each character in Unicode is given a unique ID, which is a number (integer) called the
character's "code point". A character encoding system uses one or more "code units" to
encode a Unicode "code point".

A "code unit" is the basic component used by a character encoding system (such as UTF-8 or
UTF-16). UTF-8 encoding converts each character into one to four one-byte (8 bits) code
units, depending on the character. Each byte (8 bits) is considered a unit called a
"code unit".

This means that each "element" in a string is technically not a "character" but a
"code unit". For example, in the string `"Hello"`, each character is one code unit. However,
in the string `"λ∀"`, `λ` has two code units, and `∀` has three code units. This means that
`λ` and `∀` occupy more than one index in the string `"λ∀"`. So, depending on the encoding
in use, a character in a string might have more than one code unit.

In summary, characters in a string are represented by "code points", while the string itself
is represented by "code units".

In Julia, to access the raw code units (bytes for UTF-8) of the encoding, you can use the
`codeunit(s, i)` function, where the index `i` runs consecutively from `1` to
`ncodeunits(s)`. The `codeunits(s)` function returns an `AbstractVector{UInt8}` wrapper that
lets you access these raw code units (bytes) as an array.

Strings in Julia can contain invalid UTF-8 code unit sequences. This convention allows
treating any byte sequence as a `String`. In such situations, a rule is that when parsing a
sequence of code units from left to right, characters are formed by the longest sequence of
8-bit code units that matches the start of one of the following bit patterns (each `x` can
be `0` or `1`):

- 0xxxxxxx;
- 110xxxxx 10xxxxxx;
- 1110xxxx 10xxxxxx 10xxxxxx;
- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx;
- 10xxxxxx;
- 11111xxx.

In particular, this means that overlong and too-high code unit sequences and prefixes
thereof are treated as a single invalid character rather than multiple invalid characters.
This rule may be best explained with an example:

```julia
julia> s = "\xc0\xa0\xe2\x88\xe2|"
"\xc0\xa0\xe2\x88\xe2|"

julia> foreach(display, s)
'\xc0\xa0': [overlong] ASCII/Unicode U+0020 (category Zs: Separator, space)
'\xe2\x88': Malformed UTF-8 (category Ma: Malformed, bad data)
'\xe2': Malformed UTF-8 (category Ma: Malformed, bad data)
'|': ASCII/Unicode U+007C (category Sm: Symbol, math)

julia> isvalid.(collect(s))
4-element BitArray{1}:
 0
 0
 0
 1

julia> s2 = "\xf7\xbf\xbf\xbf"
"\U1fffff"

julia> foreach(display, s2)
'\U1fffff': Unicode U+1FFFFF (category In: Invalid, too high)
```

As we can see above, the first two code units in the string `s` form an overlong encoding of
the space character. It is invalid but is accepted in a string as a single character. The
next two code units form a valid start of a three-byte UTF-8 sequence. However, the fifth
code unit `\xe2` is not a valid continuation. Therefore, code units 3 and 4 are also
interpreted as malformed characters in this string. Similarly, code unit 5 forms a malformed
character because `|` is not a valid continuation to it. Finally, the string `s2` contains
one too high code point.

Julia uses the UTF-8 encoding by default, and support for new encodings can be added by
packages. For a further discussion of UTF-8 encoding issues, see the section below on byte
array literals. The `transcode` function is provided to convert data between the various
UTF-xx encodings, primarily for working with external data and libraries.

# Concatenation
One of the most common and useful string operations is concatenation. In Julia,
concatenation is done with the function `string`. The operator `*` is also provided for
string concatenation:

```
julia> greet = "Hello"
"Hello"

julia> whom = "world"
"world"

julia> string(greet, ", ", whom, ".\n")
"Hello, world.\n"

julia> greet * ", " * whom * ".\n"
"Hello, world.\n"
```

It's important to be aware of potentially dangerous situations, such as the concatenation of
invalid UTF-8 strings. The resulting string may contain different characters than the input
strings, and the number of characters in the resulting string may be lower than the sum of
the numbers of characters in the concatenated strings:

```
julia> a, b = "\xe2\x88", "\x80"
("\xe2\x88", "\x80")

julia> c = string(a, b)
"∀"

julia> collect.([a, b, c])
3-element Vector{Vector{Char}}:
 ['\xe2\x88']
 ['\x80']
 ['∀']

julia> length.([a, b, c])
3-element Vector{Int64}:
 1
 1
 1
```

This situation can only happen with invalid UTF-8 strings. For valid UTF-8 strings,
concatenation preserves all characters in the strings and the additivity of the string
lengths.

# Interpolation
Constructing strings using concatenation can become a bit cumbersome. To reduce the need for
these verbose calls to `string` or repeated multiplications using `*`, Julia allows
interpolation into string literals using `$`, as in Perl:

```
julia> greet = "Hello"; whom = "world";

julia> "$greet, $whom.\n"
"Hello, world.\n"
```

This is more readable and convenient and is equivalent to the above string concatenation
with `string` and `*` - the system rewrites `"$greet, $whom.\n"` into the call
`string(greet, ", ", whom, ".\n")`.

The shortest complete expression after the `$` is taken as the expression whose value is to
be interpolated into the string. Thus, you can interpolate any expression into a string
using parentheses:

```
julia> "1 + 2 = $(1 + 2)"
"1 + 2 = 3"
```

Both concatenation and string interpolation call `string` to convert objects into string
form. However, `string` actually just returns the output of `print`, so new types should add
methods to `print` or `show` instead of `string`.

Most non-`AbstractString` objects are converted to strings closely corresponding to how they
are entered as literal expressions:

```julia
julia> v = [1,2,3]
3-element Vector{Int64}:
 1
 2
 3

julia> "v: $v"
"v: [1, 2, 3]"
```

`string` is the identity for `AbstractString` and `AbstractChar` values, so these are
interpolated into strings as themselves, unquoted and unescaped:

```
julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> "hi, $c"
"hi, x"
```

To include a literal `$` in a string literal, escape it with a backslash:

```
julia> print("I have \$100 in my account.\n")
I have $100 in my account.
```

# Triple-Quoted String Literals
When strings are created using triple-quotes (`\"""...\"""`), they have some special
behavior that can be useful for creating longer blocks of text. In triple-quoted string
literals, trailing whitespace is left unaltered.

- Triple-quoted strings are dedented to the level of the least-indented line; that is, the
  line before the closing `\"""` determines the dedentation. This is useful for defining
  strings within code that is indented:

```
julia> str = \"""
                   Hello
                   World
                   \"""
"Hello\nWorld\n"

julia> print(str)
Hello
World

julia> str = \"""
                   Hello
                   World
               \"""
"    Hello\n    World\n"

julia> print(str)
    Hello
    World

julia> str = \"""
                   Hello
               World
           \"""
"        Hello\n    World\n"

julia> print(str)
        Hello
    World
```

- The dedentation level is determined as the longest common starting sequence of spaces or
  tabs in all lines, excluding the line following the opening `\"""` and lines containing
  only spaces or tabs (the line containing the closing `\"""` is always included). Then for
  all lines, excluding the text following the opening `\"""`, the common starting sequence
  is removed (including lines containing only spaces and tabs if they start with this
  sequence), e.g:
```
julia> \"""    This
         is
           a test\"""
"    This\nis\n  a test"
```

- If the opening `\"""` is followed by a newline, the newline is stripped from the resulting
  string. This means:

```julia
julia> \"""hello\"""
"hello"
```

is equivalent to:

```julia
julia> \"""
       hello\"""
"hello"
```

but:

```julia
julia> \"""

       hello\"""
"\nhello"

julia> \"""
       hello
       \"""
"hello\n"
```
as shown above, will contain a literal newline, `\n`, at the beginning and end,
respectively.

- Stripping of the newline is performed after the dedentation. For example:

```
julia> \"""
         Hello,
         world.\"""
"Hello,\nworld."
```

- If the newline is removed using a backslash, dedentation will be respected as well:

```
julia> \"""
       hello\
       \"""
"hello"

julia> \"""
         Averylong\
         word\"""
"Averylongword"
```

- Note that line breaks in literal strings, whether single- or triple-quoted, result in a
  newline (LF) character `\n` in the string, even if your editor uses a carriage return
  `\r` (CR) or CRLF combination to end lines. To include a CR in a string, use an explicit
  escape `\r`; for example, you can enter the literal string "a CRLF line ending\r\n":

```julia
julia> "a CRLF line ending\r\n"
"a CRLF line ending\r\n"
```

# Non-Standard String Literals
There are situations when you want to construct a string or use string semantics, but the
behavior of the standard string construct is not quite what is needed. For these kinds of
situations, Julia provides **non-standard string literals**.

A non-standard string literal looks like a regular double-quoted string literal, `"..."`,
but is immediately prefixed by an identifier, and may behave differently from a normal
string literal.

Regular expressions, byte array literals, raw string literals and version number literals,
are some examples of non-standard string literals. Users and packages may also define new
non-standard string literals. Further documentation is given in the
[Metaprogramming section]
(https://docs.julialang.org/en/v1/manual/metaprogramming/#meta-non-standard-string-literals).

# Byte Array Literals
A byte is the basic unit of information in computer storage and processing. A byte consists
of 8 adjacent binary digits (bits), each of which consists of a `0`` or `1`. Originally, a
byte was any string of more than one bit that made up a simple piece of information like a
single character.

In Julia, the byte-array string literal `b"..."` is a useful non-standard string literal.
This form lets you use string notation to express read only literal byte arrays, i.e.,
arrays of `UInt8` values. The type of those objects is `CodeUnits{UInt8, String}`.

The rules for byte array literals are as follows:

- ASCII characters and ASCII escapes produce a single byte.
- `\x` and octal escape sequences produce the byte corresponding to the escape value.
- Unicode escape sequences produce a sequence of bytes encoding that code point in UTF-8.

There is some overlap between these rules since the behavior of `\x` and octal escapes less
than `0x80` (128) are covered by both of the first two rules, but here these rules agree.

Together, these rules allow one to easily use ASCII characters, arbitrary byte values, and
UTF-8 sequences to produce arrays of bytes. Here is an example using all three:

```julia
julia> b"DATA\xff\u2200"
8-element Base.CodeUnits{UInt8, String}:
 0x44
 0x41
 0x54
 0x41
 0xff
 0xe2
 0x88
 0x80
```

The ASCII string `"DATA"` corresponds to the bytes `68`, `65`, `84`, `65` (when coverted
with to signed integers). `\xff` produces the single byte `255`. The Unicode escape `\u2200`
is encoded in UTF-8 as the three bytes `226`, `136`, `128`. Note that the resulting byte
array does not correspond to a valid UTF-8 string:

```julia
julia> isvalid("DATA\xff\u2200")
false
```

As mentioned earlier, the `CodeUnits{UInt8, String}` type behaves like a read-only array of
`UInt8`, and if you need a standard vector, you can convert it using `Vector{UInt8}`:

```julia
julia> x = b"123"
3-element Base.CodeUnits{UInt8, String}:
 0x31
 0x32
 0x33

julia> x[1]
0x31

julia> x[1] = 0x32
ERROR: CanonicalIndexError: setindex! not defined for Base.CodeUnits{UInt8, String}

julia> Vector{UInt8}(x)
3-element Vector{UInt8}:
 0x31
 0x32
 0x33
```

Also, note the significant distinction between `\xff` and `\uff`: the former escape sequence
encodes the byte `255`, whereas the latter escape sequence represents the code point `255`,
which is encoded as two bytes in UTF-8. Character literals use this same behavior:

```julia
julia> b"\xff"
1-element Base.CodeUnits{UInt8, String}:
 0xff

julia> b"\uff"
2-element Base.CodeUnits{UInt8, String}:
 0xc3
 0xbf
```

For code points less than `\u80`, it happens that the UTF-8 encoding of each code point is
just the single byte produced by the corresponding `\x` escape, so the distinction can
safely be ignored. For the escapes `\x80` through `\xff` as compared to `\u80` through
`\uff`, however, there is a major difference: the former escapes all encode single bytes,
which - unless followed by very specific continuation bytes - do not form valid UTF-8 data,
whereas the latter escapes all represent Unicode code points with two-byte encodings.

# Raw String Literals
Escaping a string means reducing ambiguity in quotes (and other characters) used in that
string. For instance, when defining a string in Julia, it is typically surrounded by double
quotes:

```julia
julia> "Hello World."
"Hello World."
```

But what if the string has single or double quotes within it? Now there is ambiguity - the
compiler doesn't know where the string ends:

```julia
julia> "Hello "World."
ERROR: syntax: cannot juxtapose string literal

julia> "Hello "World.""
ERROR: syntax: cannot juxtapose string literal
```

If single or double quotes are to be kept, they need to be escaped:

```julia
julia> "Hello \\"World."
"Hello \\"World."

julia> "Hello \\"World.\\""
"Hello \\"World.\\""
```

In summary, any quote preceded by a backslash is escaped and understood to be part of the
value of the string.

Raw strings without interpolation or unescaping can be expressed with non-standard string
literals of the form `raw"..."`. Raw string literals create ordinary `String` objects which
contain the enclosed contents exactly as entered with no interpolation or unescaping. This
is useful for strings that contain code or markup in other languages that use `$` or `\` as
special characters.

The exception is that quotation marks, `"` still must be escaped, e.g. `raw"\""` is
equivalent to `"\""`. To make it possible to express all strings, backslashes then must also
be escaped but only when appearing right before a quote character:

```julia
julia> println(raw"\\ \\\"")
\\ \"
```

Notice that the first two backslashes appear verbatim in the output since they do not
precede a quote character. However, the next backslash character escapes the backslash that
follows it, and the last backslash escapes a quote since these backslashes appear before a
quote.
"""
function strings(;extmod=false)
    macros = [
        "Macros" => [
            "@MIME_str", "@assert", "@b_str", "@doc", "@html_str", "@int128_str",
            "@lazy_str", "@r_str", "@raw_str", "@s_str", "@show", "@showtime", "@simd",
            "@text_str", "@uint128_str", "@v_str"
        ]
    ]
    methods = [
        "Methods" => [
            "Case-Sensitive"        => [
                "lowercase", "lowercasefirst", "titlecase", "uppercase", "uppercasefirst",
            ],
            "File/url Paths"            => [
                "abspath", "basename", "cd", "chmod", "chown", "contractuser", "cp",
                "dirname", "download", "eachline", "evalfile", "expanduser", "fdio",
                "hardlink", "include_dependency", "include_string", "includeˣ", "joinpath",
                "less", "mkdir", "mkpath", "mv", "normpath", "open", "read!", "readchomp",
                "readdir", "readeach", "readline", "readlines", "readlink", "readuntil",
                "realpath", "relpath", "rm", "samefile", "set_active_projectˣ", "splitdir",
                "splitdrive", "splitext", "splitpath", "symlink", "touch", "write", "edit",
            ],
            "Indices"               => [
                "eachindex", "first", "firstindex", "get", "getindex", "keys", "last",
                "lastindex", "nextind", "prevind", "thisind"
            ],
            "Loop"                  => [
                "enumerate", "foreach", "pairs", "zip"
            ],
            "Mathematical"          => [
                "argmax", "argmin", "cmp", "cumprod", "extrema", "intersect", "max",
                "maximum", "min", "minimum", "minmax", "prod", "setdiff", "symdiff",
                "union", "unique"
            ],
            "Reduce"                => [
                "foldl", "foldr", "mapfoldl", "mapfoldr", "mapreduce", "mapreduce_emptyˣ",
                "mapreduce_firstˣ", "mul_prodˣ", "reduce", "reduce_emptyˣ", "reduce_firstˣ",
            ],
            "Search & Find"         => [
                "count", "countlines", "eachmatch", "filter", "findall", "findfirst",
                "findlast", "findmax", "findmin", "findnext", "findprev", "match"
            ],
            "Splitting & Stripping" => [
                "chomp", "chop", "chopprefix", "chopsuffix", "eachsplit", "lstrip",
                "rsplit", "rstrip", "split", "strip"
            ],
            "True/False"            => [
                "checkbounds", "contains", "endswith", "hasfastinˣ", "hastypemaxˣ",
                "ifelse", "in", "isa", "isabspath", "isascii", "isbits", "isdir",
                "isdirpath", "isdisjoint", "isdoneˣ", "isempty", "isequal", "isfile",
                "isgreaterˣ", "isless", "ismutable", "issetequal", "issubset", "istextmime",
                "isunordered", "isvalid", "occursin", "startswith"
            ],
            "Type-Conversion"       => [
                "ascii", "cconvertˣ", "collect", "convert", "oftype", "parse", "promote",
                "string", "tryparse",
            ],
            "Others"                => [
                "broadcast", "checked_lengthˣ", "clipboard", "codeunit", "codeunits",
                "display", "displayable", "dump", "eltype",
                "escape_microsoft_c_argsˣ", "escape_raw_stringˣ", "escape_string",
                "getpassˣ", "hex2bytes", "identify_package_envˣ", "identify_packageˣ",
                "identity", "indentationˣ", "iterate", "join", "length", "locate_packageˣ",
                "lpad", "map", "objectid", "one", "oneunit", "only", "print", "println",
                "printstyled", "promptˣ", "redisplay", "repeat", "replace", "repr", "restˣ",
                "reverse", "reverseind", "rpad", "shell_escape_cshˣ",
                "shell_escape_posixlyˣ", "shell_escape_wincmdˣ", "shell_escapeˣ", "show",
                "showable", "sizeof", "split_restˣ", "stack", "summary", "summarysizeˣ",
                "textwidth", "transcode", "typeassert", "typeof", "typemin",
                "unescape_string", "unindentˣ", "view"
            ]
        ]
    ]
    types = [
        "Types" => [
            "AbstractString", "CodeUnitsˣ", "Cstring", "Cwstring", "DataType", "Generatorˣ",
            "IteratorEltypeˣ", "IteratorSizeˣ", "LazyString", "Pair", "Ref",
            "SecretBufferˣ", "String", "SubString", "SubstitutionString", "Text", "UUIDˣ",
            "VersionNumber"
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "*", "<", "<=", "==", "=>", ">", ">=", "^", "∈", "∉", "∋",
            "∌", "∩", "∪", "≠", "≡", "≢", "≤", "≥", "⊆", "⊇", "⊈", "⊉", "⊊", "⊋", "===",
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Base64.base64decode", "Base64.stringmime", "Printf.@printf", "Printf.@sprintf",
            "Printf.Formatˣ", "Printf.Pointerˣ", "Printf.PositionCounterˣ", "Printf.Specˣ",
            "Printf.formatˣ", "Unicode.isequal_normalized", "Unicode.normalizeˣ",
            "Statistics.mean!",
        ]
    ]
    _print_names(macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end
