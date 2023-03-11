@doc raw"""
# CHARACTERS
When we refer to "characters" in computer programming, we are not necessarily limiting our
view to the characters that most English speakers are familiar with. Some examples of these
familiar characters include letters like `A`, `B`, `C`, etc., numbers `1`, `2`, `3`, etc.,
and common punctuation symbols such as `.`, `,`, `!`, etc. These characters are standardized
and mapped to integer values between 0 and 127 by the ASCII standard.

However, there are also many other "non-familiar" characters used in non-English languages,
including variants of ASCII characters with accents and modifications, scripts such as
Cyrillic and Greek, and scripts unrelated to ASCII and English, such as Arabic, Chinese,
Hebrew, Hindi, Japanese, and Korean.

The [Unicode standard](https://en.wikipedia.org/wiki/Unicode) addresses the complexities of
what a character is and is widely accepted as the definitive standard for this problem.
Depending on your needs, you can either ignore these complexities and only consider ASCII
characters, or you can write code that can handle any characters or encodings encountered
when handling non-ASCII text.

Julia fully supports Unicode characters and strings, making it simple and efficient to work
with both ASCII text and Unicode.

## Type Hierarchy Tree
```julia
Any
└─ AbstractChar
   └─ Char
```

A character represents a Unicode code point. A
[code point](https://en.wikipedia.org/wiki/Code_point) is a numerical value that maps to a
specific character and is expressed in the form "U+1234" where "1234" is the assigned
number. For example, the character "A" has a code point of "U+0041".

In Julia, the `AbstractChar` type is the supertype of all character implementations. The
`codepoint` function can convert a character to an integer to obtain its numerical value.
These numerical values determine how characters are compared using comparison operators such
as `>`, `==`, etc. A character can also be constructed from its code point integer using
`Char`.

A `Char` value represents a single character. It is a 32-bit primitive type with a special
literal representation and appropriate arithmetic behaviors. It can be converted to a
numeric value representing a Unicode code point. Some Julia packages may define other
subtypes of `AbstractChar` to optimize operations for different
[text encodings](https://en.wikipedia.org/wiki/Character_encoding).

For more information on `AbstractChar` and `Char`, refer to the REPL `help>` mode.

# Input & Output Of Characters
Char values are entered in single quotes, `''`. Examples include `'x'`, `'Z'`, `'1'`, `'!'`,
etc. Empty single quotes, `''`, result in an error:

```julia
julia> ''
ERROR: syntax: invalid empty character literal
```

You can input any Unicode character in single quotes using `\u` followed by up to four
hexadecimal digits or `\U` followed by up to eight hexadecimal digits
(the longest valid value only requires six). Examples include `'\u0'`, `'\u78'`, `'\U10f'`,
`'\U10ffff'`. `Char` values are outputted in the REPL in this format:

```
<literal> <representable standard> <code point> <general category>
```

Examples are:

```julia
julia> 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> '!'
'!': ASCII/Unicode U+0021 (category Po: Punctuation, other)

julia> '\u2200'
'∀': Unicode U+2200 (category Sm: Symbol, math)

julia> '\U1F60D'
'😍': Unicode U+1F60D (category So: Symbol, other)

julia> '\U10ffff'
'\U10ffff': Unicode U+10FFFF (category Cn: Other, not assigned)
```

Julia uses the system's locale and language settings to determine which characters can be
displayed as-is and which must be output using the generic, escaped `\u` or `\U` forms. The
display of these Unicode characters as either escapes or special characters depends on the
terminal's locale settings and its support for Unicode.

In addition to these Unicode escape forms, `\u`, `\U`, all of C's traditional escaped input
forms, such as `\0`, `\t`, `\n`, `\e`, \x7f, etc., can also be used.

# Mathematical Operations
You can do comparisons and a limited amount of arithmetic with `Char` values. For example,
`'A' < 'a'`, `'A' ≤ 'a' ≤ 'Z'`, `'z' - 'a'`, `'A' + 1` are all valid operations in Julia.
`Char` values can be used in `for` loops, such as:

```julia
julia> for i in 'a':'e'
           println(i)
       end
a
b
c
d
e
```

# Conversion
You can easily convert a `Char` to its integer value, i.e., code  point. For example,
`UInt8('x')` returns `0x78`, `Int('x')` returns `120`. They need not be converted to only
integers; they can as well be converted to floating-points. For example, `float('x')`
returns `120.0`. You can also convert an integer value back to a `Char` just as easily. For
example, `Char(120)` returns `'x'`, just as `Char(0x78)` does too.

However, the recommended way to retrieve the Unicode codepoint of a character is to use the
`codepoint` function. For example:

```julia
julia> codepoint('x')
0x00000078
```

# Valid Unicode Points
Not all integer values are valid Unicode code points. For performance, the `Char` conversion
does not check that every character value is valid. If you want to check that each converted
value is a valid code point, use the `isvalid` function. For example:

```julia
julia> isvalid(Char, 0x110000)
false

julia> Char(0x110000)
'\U110000': Unicode U+110000 (category In: Invalid, too high)
```

As of this writing, the valid Unicode code points are `U+0000` through `U+D7FF` and `U+E000`
through `U+10FFFF`. These have not all been assigned intelligible meanings yet, nor are they
necessarily interpretable by applications, but all of these values are considered to be
valid Unicode characters. For example:

```julia
julia> isvalid('\UD7FF')
true

julia> '\UD7FF'
'\ud7ff': Unicode U+D7FF (category Cn: Other, not assigned)
```
"""
function characters(;extmod=false)
    macros = [
        "Macros" => [
            "@assert", "@doc", "@show", "@showtime"
        ]
    ]
    methods = [
        "Methods" => [
            "Mathematical"    => [
                "canonicalize2ˣ", "cmp", "count", "max", "min", "minmax"
            ],
            "Search & Find"         => [
                "findall", "findfirst", "findlast", "findnext", "findprev"
            ],
            "True/False"      => [
                "ifelse", "in", "isascii", "isbits", "iscntrl", "isdigit", "isequal",
                "isless", "isletter", "islowercase", "ismalformedˣ", "ismutable",
                "isnumeric", "isoverlongˣ", "isprint", "ispunct", "isspace", "isunordered",
                "isuppercase", "isvalid", "isxdigit",
            ],
            "Type-Conversion" => [
                "cconvertˣ", "collect", "convert", "isa", "oftype", "parse", "promote",
                "string", "unsafe_convertˣ"
            ],
            "Others"          => [
                "bitstring", "codepoint", "decode_overlongˣ", "display", "dump", "identity",
                "join", "lowercase", "lpad", "ncodeunits", "only", "print", "println",
                "printstyled", "redisplay", "repeat", "repr", "rpad", "show",
                "show_invalidˣ", "sizeof", "summary", "summarysizeˣ", "textwidth",
                "titlecase", "typeassert", "typeof", "uppercase"
            ]
        ]
    ]
    types = [
        "Types" => [
            "AbstractChar", "Cchar", "Char", "Cuchar", "Cwchar_t", "DataType", "Ref",
            "Pair",
        ]
    ]
    operators = [
        "Operators" => [
            "!", "!=", "!==", "*", "+", "-", "<", "<=", "==", "=>", ">", ">=", "^", "∈",
            "∉", "∋", "∌", "∩", "∪", "≠", "≡", "≢", "≤", "≥", "⊆", "⊇", "⊈", "⊉", "⊊", "⊋",
            "==="
        ]
    ]
    stdlib = [
        "Stdlib" => [
            "Printf.@printf", "Printf.@sprintf", "Printf.Formatˣ", "Printf.Pointerˣ",
            "Printf.PositionCounterˣ", "Printf.Specˣ", "Printf.formatˣ",
            "Unicode.isassignedˣ", "Unicode.julia_chartransformˣ"
        ]
    ]
    _print_names(macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end
