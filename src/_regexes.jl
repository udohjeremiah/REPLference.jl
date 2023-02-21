@doc raw"""
# REGEX
A regular expression (a.k.a. regex, regexp, r.e.) is a string used to specify a pattern to
search for in text. It provides a powerful, flexible, and efficient way to process text, and
is often used in applications that deal with strings or parse large amounts of text. Regexes
can be used to find specific character patterns, validate text to ensure it matches a
predefined pattern, extract, edit, replace, or delete text substrings, and add extracted
strings to a collection for reporting. Regexes are typically compiled to forms that can be
executed efficiently on a computer using software called regex engines.

# Regex Engines & Flavors
A regex engine is software that processes regexes by compiling them into an internal
representation and then matching the pattern to a given string, returning the leftmost
match. It can be implemented as a Deterministic Finite Automation (DFA) or Non-Deterministic
Finite Automation (NFA). The syntax and behavior of a particular regex engine is called a
regex flavor, and different regex engines are not fully compatible with each other.

### DFA
DFA engine is a **text-directed** engine that drives the processing order based on the input
string and can guarantee to match the longest string possible. However, DFA engines don't
support backtracking and cannot match patterns with backreferences or capture
subexpressions. And because it does not construct an explicit expansion, it cannot capture
subexpressions; for example, the regex `"Set|SetValue"` on the string `"SetValue"` will
match `"SetValue"`.

### Traditional NFA
NFA engine is a **regex-directed** engine that drives the processing order based on the
regex pattern, and use greedy matching and also save state for backtracking, allowing for
the capture of subexpressions and backreferences; for example, the regex `"Set|SetValue"` on
the string `"SetValue"` will match `"Set"`. However, they can run slowly in the worst case.
NFA engines are favored by programmers and are used by most modern regex engines, but it is
important to use well-written regexes to avoid slow performance.

# Regexes In Julia
Julia uses the PCRE library, which is a traditional NFA engine, for its regex engine. Its
regex flavor is PCRE2, which is the revised API for the PCRE library.

In Julia, a non-standard string literal is used to create a regex, which is prefixed with
`r` and can include regex flags:

```julia
julia> r"^\d+$"
r"^\d+$"

julia> r"^\d+$"i
r"^\d+$"i
```

The `Regex` constructor can also be used, but it requires escaping certain characters, so is
less commonly used except for pattern that needs to be interpolated:

```julia
julia> Regex("^\\d+\$")
r"^\d+$"

julia> amount = "\\d+(?:\\.\\d+)?"; currency = "(?: )?dollars";

julia> re = Regex("$amount$currency")
r"\d+(?:\.\d+)?(?: )?dollars"
```

To check if a regex matches a string, one can use the `occursin` function, and to capture
the match information, the `match` function can be used. The `match` function returns a
`RegexMatch` object, which has `regex`, `match`, and `offset` fields that can be accessed to
retrieve the pattern, matched substring, and the index at which the match begins:

```julia
julia> occursin(re, "I have 150 dollars in my pocket")
true

julia> m = match(re, "I have 150dollars in my pocket")
RegexMatch("150dollars")

julia> m.regex, m.match, m.offset
(r"\d+(?:\.\d+)?(?: )?dollars", "150dollars", 8)
```

# Syntax & Semantics Of Regex In Julia
## Literal Characters
The most basic regex consists of literal characters (i.e. characters with no special
meaning), which match the first occurrence of that character in a string. The `match`
function matches only the first occurrence of the pattern, while the `eachmatch` function
matches all occurrences:

```julia
julia> match(r"a", "Jack is a boy")
RegexMatch("a")

julia> eachmatch(r"a", "Jack is a boy") |> collect
2-element Vector{RegexMatch}:
 RegexMatch("a")
 RegexMatch("a")
```

The pattern `"cat"` matches `cat` in the string `"About cats and dogs"`. The regex engine is
case sensitive by default, but can be made case-insensitive by using the CASELESS flag
(`i`):

```julia
julia> match(r"cat", "About Cats and dogs")

julia> match(r"cat"i, "About Cats and dogs")
RegexMatch("Cat")
```

## Meta-Characters
There are two different sets of metacharacters: those that are recognized anywhere in the
pattern except within square brackets, and those that are recognized within square brackets.

| Character | Interpretation                                                |
|:----------|:--------------------------------------------------------------|
| `\`       | General escape character inside and outside square brackets.  |
|           | Used to remove special meaning from characters. If it is a    |
|           | prefix to an ASCII digit/letter (i.e. characters of Unicode   |
|           | category as "Nd", "Ll" or "Lu"), a character with special     |
|           | meaning is created.                                           |
|           |                                                               |
| `^`       | Assert start of string (or line, in multiline mode). Inside a |
|           | character class, it negates the class.                        |
|           |                                                               |
| `$`       | Assert end of string (or line, in multiline mode).            |
|           |                                                               |
| `.`       | Match any character except newline. When a line ending is     |
|           | defined as a single character, `.` never matches that         |
|           | character. When the two-character sequence CRLF is used, `.`  |
|           | does not match CR if it is immediately followed by LF, but    |
|           | otherwise it matches all characters (including isolated CRs   |
|           | and LFs). When any Unicode line endings are being recognized, |
|           | `.` does not match CR or LF or any of the other line ending   |
|           | characters. If the DOTALL flag (s) is raised, `.` matches any |
|           | character including newline as well. `.` has no special       |
|           | meaning in a character class.                                 |
|           |                                                               |
| `[`       | Outside a character class, it starts a character class        |
|           | definition. Inside a character class, it creates a POSIX      |
|           | character class (if followed by POSIX syntax).                |
|           |                                                               |
| `]`       | Terminates a character class, hence only has special meaning  |
|           | if preceded by `[`.                                           |
|           |                                                               |
| `-`       | Inside a character class, it indicates a character range when |
|           | between two characters.                                       |
|           |                                                               |
| `\|`      | Start of alternative branch.                                  |
|           |                                                               |
|           | Vertical bar characters are used to separate alternative      |
|           | patterns. For example, the pattern `"gilbert|sullivan"`       |
|           | matches either `"gilbert"` or `"sullivan"`. Any number of     |
|           | alternatives may appear, and an empty alternative is          |
|           | permitted (matching the empty string). The matching process   |
|           | tries each alternative in turn, from left to right, and the   |
|           | first one that succeeds is used. If the alternatives are      |
|           | within a group (i.e. enclosed in parentheses), "succeeds"     |
|           | means matching the rest of the main pattern as well as the    |
|           | alternative in the group. For example, the pattern            |
|           | `"a(pp|pple)s"` matches `"apps"` (and captures `"pp"`) or     |
|           | matches `"apples"` and captures `"pple"`.                     |
|           |                                                               |
| `*`       | 0 or more quantifier.                                         |
|           |                                                               |
| `+`       | 1 or more quantifier; also "possessive quantifier".           |
|           |                                                               |
| `?`       | 0 or 1 quantifier; also "quantifier minimizer".               |
|           |                                                               |
| `{`       | Start min/max quantifier.                                     |
|           |                                                               |
| `(`       | Start group or control verb.                                  |
|           |                                                               |
| `)`       | End group or control verb.                                    |

## Non-Printing Characters
Backslashes can be used to provide a way of encoding non-printing characters in patterns in
a visible manner. In an ASCII or Unicode environment, these escapes are as follows:

| Character     | Interpretation                                            |
|:--------------|:----------------------------------------------------------|
| `\a`          | Alarm, that is, the BEL character (hex 07)                |
|               |                                                           |
| `\cx`         | "control-x", where `x` is any printable ASCII character.  |
|               |                                                           |
|               | The precise effect of `\cx` on ASCII characters is as     |
|               | follows: if `x` is a lower case letter, it is converted   |
|               | to upper case. Then bit 6 of the character (hex 40) is    |
|               | inverted. Thus `\cA` to `\cZ` become hex 01 to hex 1A     |
|               | (`A` is 41, `Z` is 5A), but `\c{` becomes hex 3B (`{` is  |
|               | 7B), and `\c;` becomes hex 7B (`;` is 3B). If the code    |
|               | unit following `\c` has a value less than 32 or greater   |
|               | than 126, a compile-time error occurs. Thus, apart from   |
|               | `\c?`, these escapes generate the same character code     |
|               | values as they do in an ASCII environment, though the     |
|               | meanings of the values mostly differ. For example, `\cG`  |
|               | always generates code value 7, which is BEL in ASCII but  |
|               | DEL in EBCDIC.                                            |
|               |                                                           |
| `\e`          | Escape (hex 1B).                                          |
|               |                                                           |
| `\f`          | Form feed (hex 0C).                                       |
|               |                                                           |
| `\n`          | Linefeed (hex 0A).                                        |
|               |                                                           |
| `\r`          | Carriage return (hex 0D).                                 |
|               |                                                           |
| `\t`          | Tab (hex 09).                                             |
|               |                                                           |
| `\uhhhh`      | Character with hex code  hhhh.                            |
|               |                                                           |
| `\0dd`        | Character with octal code 0dd.                            |
|               |                                                           |
|               | After `\0` up to two further octal digits are read. If    |
|               | there are fewer than two digits, just those that are      |
|               | present are used. Thus the sequence `\0\x\015` specifies  |
|               | two binary zeros followed by a CR character (code value   |
|               | 13). Make sure you supply two digits after the initial    |
|               | zero if the pattern character that follows is itself an   |
|               | octal digit. For greater clarity and unambiguity, it is   |
|               | best to avoid following `\` by a digit greater than zero. |
|               | Instead, use `\o{}` or `\x{}` to specify numerical        |
|               | character code points, and `\g{}` to specify              |
|               | backreferences.                                           |
|               |                                                           |
| `\ddd`        | Character with octal code ddd, or backreference.          |
|               |                                                           |
| `\o{ddd..}`   | Character with octal code ddd..                           |
|               |                                                           |
|               | The escape `\o` must be followed by a sequence of octal   |
|               | digits, enclosed in braces. An error occurs if this is    |
|               | not the case. This escape iprovides way of specifying     |
|               | character code points as octal numbers greater than 0777, |
|               | and it also allows octal numbers and backreferences to be |
|               | unambiguously specified.                                  |
|               |                                                           |
| `\xhh`        | Character with hex code hh                                |
|               |                                                           |
|               | Characters whose code points are less than 256 can be     |
|               | defined by either of the two syntaxes for `\x` or by an   |
|               | octal sequence; there is no difference in the way they    |
|               | are handled. For example, `\xdc` is exactly the same as   |
|               | `\x{dc}` or `\334`.                                       |
|               |                                                           |
| `\x{hhh..}`   | Character with hex code hhh..                             |
|               |                                                           |
|               | By default, after `\x`  that is not followed by `{`, from |
|               | zero to two hexadecimal digits are read (letters can be   |
|               | in upper or lower case). Any number of hexadecimal digits |
|               | may appear between `\x{` and `}`. If a character other    |
|               | than a hexadecimal digit appears between `\x{` and `}`,   |
|               | or if there is no terminating `}`, an error occurs.       |
|               |                                                           |
| `\N{U+hhh..}` | Character with Unicode hex code point hhh..               |
|               |                                                           |
|               | Note that when `\N` is not followed by an opening brace   |
|               | (curly bracket) it has an entirely different meaning,     |
|               | matching any character that is not a newline.             |
|               |                                                           |
| `\U`          | The character "U".                                        |

#### Newline Conventions
The term "newline" in regex refers to "the character(s) that indicate a line break." The
default newline convention in PCRE2 is usually the standard convention of the OS, but if it
is not specified, it is set to the Unix standard (line feed (LF)). The newline convention in
a pattern can be changed to one of the six different conventions supported by PCRE using a
specific syntax at the start of the pattern.

| Syntax       | Interpretation                                             |
|:-------------|:-----------------------------------------------------------|
| `(*CR)`      | Carriage return only.                                      |
|              |                                                            |
| `(*LF)`      | Linefeed only.                                             |
|              |                                                            |
| `(*CRLF)`    | Carriage return followed by linefeed.                      |
|              |                                                            |
| `(*ANYCRLF)` | All three of the above.                                    |
|              |                                                            |
| `(*ANY)`     | Any Unicode newline sequence (the three just mentioned     |
|              | above, VT (vertical tab, U+000B), FF (form feed, U+000C),  |
|              | NEL (next line, U+0085), LS (line separator, U+2028),      |
|              | PS (paragraph separator, U+2029)).                         |
|              |                                                            |
| `(*NUL)`     | The NUL character (binary zero).                           |

When the newline convention is specified as `(*CRLF)`, `(*ANYCRLF)`, or `(*ANY)`, the match
position is advanced by two characters instead of one if a match attempt for an unanchored
pattern fails when the current starting position is at a CRLF sequence and the pattern
contains no explicit matches for CR or LF characters.

For example

```julia
julia> match(r"(*CRLF).+A", "\r\nA")
```

However, the pattern `[\r\n]A` does match that string because it contains an explicit CR or
LF reference, and so advances only by one character after the first failure:

```julia
julia> match(r"(*CRLF)[\r\n]A", "\r\nA")
RegexMatch("\nA")
```

An explicit match for CR or LF can be either a literal appearance of one of these characters
in the pattern, or a `\r` or `\n` equivalent octal or hexadecimal escape sequence. Implicit
matches, such as `[^X]` and `\s`, do not count, even though they include CR and LF in the
characters that they match:

```julia
julia> match(r"(*CRLF)[^X]+A", "\r\nA")
RegexMatch("\r\nA")
```

However, anomalous effects may still occur when CRLF is a valid newline sequence and
explicit `\r` or `\n` escapes are used in the pattern.

## Generic Character Types
Another use of backslash is for specifying generic character types:

| Character | Interpretation                                                |
|:----------|:--------------------------------------------------------------|
| `\d`      | Any decimal digit i.e. from `0` to `9` or Unicode digit.      |
|           |                                                               |
| `\D`      | Any character that is not a decimal digit.                    |
|           |                                                               |
| `\h`      | Any horizontal white space character i.e. tab or Unicode      |
|           | space separator.                                              |
|           |                                                               |
| `\H`      | Any character that is not a horizontal white space character. |
|           |                                                               |
| `\N`      | Any character that is not a newline.                          |
|           |                                                               |
|           | The `\N` escape sequence has the same meaning as the `.`      |
|           | metacharacter when the DOTALL flag (`s`) is not raised, but   |
|           | raising the DOTALL flag (`s`) does not change the meaning of  |
|           | `\N` as it would do for `.`. When not followed by `{`, `\N`   |
|           | is  not allowed in a character class. Note that when `\N` is  |
|           | followed by `{` it has a different meaning.                   |
|           |                                                               |
| `\p{xx}`  | A character with the `xx` property, where `xx` is             |
|           | case-sensitive.                                               |
|           |                                                               |
|           | There is support for Unicode script names, Unicode general    |
|           | category properties, "Any" (which matches any character,      |
|           | including newline), and some special PCRE2 properties. Sets   |
|           | of Unicode characters are defined as belonging to certain     |
|           | scripts. A character from one of these sets can be matched    |
|           | using a script name e.g. `\p{Greek}`, `\P{Han}`. Unassigned   |
|           | characters are assigned the "Unknown" script. Others that are |
|           | not part of an identified script are lumped together as       |
|           | "Common".                                                     |
|           |                                                               |
|           | Each character has exactly one Unicode general category       |
|           | property, specified by a two-letter abbreviation. Negation    |
|           | can be specified by including a `^` between `{` and the       |
|           | property name e.g. `\p{^Lu}` is the same as `\P{Lu}`. If only |
|           | one letter is specified with `\p` or `\P`, it includes all    |
|           | the general category properties that start with that letter.  |
|           | In this case, in the absence of negation, the curly brackets  |
|           | in the escape sequence re optional e.g. `\p{L}` and `\pL`     |
|           | have the same effect.                                         |
|           |                                                               |
|           | Specifying caseless matching does not affect these escape     |
|           | sequences. For example, `\p{Lu}` always matches only upper    |
|           | case letters.                                                 |
|           |                                                               |
| `\P{xx}`  | A character without the `xx` property, where `xx` is          |
|           | case-sensitive.                                               |
|           |                                                               |
|           | Note that `\P{Any}` does not match any characters, so always  |
|           | causes a match failure. Matching characters by Unicode        |
|           | property is not fast, because PCRE2 has to do a multistage    |
|           | table lookup in order to find a character's property. That is |
|           | why the traditional escape sequences such as `\d` and `\w` do |
|           | not use Unicode properties in PCRE2 by default, though you    |
|           | can make them do so by starting the pattern with `(*UCP)`.    |
|           |                                                               |
|           | See the "Unicode character properties" section under          |
|           | https://www.pcre.org/current/doc/html/pcre2pattern.html#SEC5  |
|           | for the current list of script names, general category        |
|           | property, and PCRE2 special properties, that are supported.   |
|           |                                                               |   
| `\R`      | Any character that is a line break i.e. CR + LF pair, and all |
|           | the characters matched by `\v`.                               |
|           |                                                               |
|           | The newline convention does not affect what the `\R` escape   |
|           | sequence matches. By default, this is any Unicode newline     |
|           | sequence, for Perl compatibility. It is possible to restrict  |
|           | `\R` to match only CR, LF, or CRLF instead of the complete    |
|           | set of Unicode line endings) by starting a pattern with       |
|           | `(*BSR_ANYCRLF)`. For completeness, `(*BSR_UNICODE)` is also  |
|           | recognized, which sets `\R` to match any Unicode newline      |
|           | sequence. If more than one of them is present, the last one   |
|           | is used. A change of `\R` setting can be combined with a      |
|           | change of newline convention e.g `(*ANY)(*BSR_ANYCRLF)`. `\R` |
|           | is not special inside a character class, instead it causes an |
|           | error. `\R`, which can match different numbers of code units, |
|           | are never permitted in lookbehinds.                           |
|           |                                                               |
| `\s`      | Any white space character i.e. space, tab, linefeed, carriage |
|           | return, vertical tab or Unicode space separator.              |
|           |                                                               |
| `\S`      | Any character that is not a white space character.            |
|           |                                                               |
| `\v`      | Any vertical white space character i.e line feed, carriage    |
|           | return, form feed, vertical tab, paragraph or line separator. |
|           |                                                               |
| `\V`      | Any character that is not a vertical white space character.   |
|           |                                                               |
| `\w`      | Any "word" character i.e. ASCII/Unicode letter, digit or      |
|           | underscore.                                                   |
|           |                                                               |
| `\W`      | Any "non-word" character.                                     |
|           |                                                               |
| `\X`      | A Unicode extended grapheme cluster.                          |
|           |                                                               |
|           | The `\X` escape matches any number of Unicode characters that |
|           | form an "extended grapheme cluster", and treats the sequence  |
|           | as an atomic group. Unicode supports various kinds of         |
|           | composite character by giving each character a grapheme       |
|           | breaking property, and having rules that use these properties |
|           | to define the boundaries of extended grapheme clusters. PCRE2 |
|           | uses only the Extended Pictographic property. \X` always      |
|           | matches at least one character. Then it decides whether to    |
|           | add additional characters according to the rules for ending a |
|           | cluster. See the "Extended grapheme clusters" section under   |
|           | https://www.pcre.org/current/doc/html/pcre2pattern.html#SEC5  |
|           | for these rules. `\X` is not special inside a character       |
|           | class, instead it causes an error.                            |

## Simple Assertions With Anchors & Boundaries
Another use of the backslash is to specify certain simple assertions. An assertion specifies
a condition that has to be met at a particular point in a match without "consuming" any
characters from the subject string; hence, they are called *zero-width* assertions. These
backslashed assertions, along with `^` and `$`, which also perform assertions, are:

| Character | Asserts                                                       |
|:----------|:--------------------------------------------------------------|
| `^`       | Start of string (or line, in multiline mode); when inside     |
|           | square brackets, it negates the class.                        |
|           |                                                               |
|           | Outside a character class, in the default matching mode, the  |
|           | `^` character is an assertion that is true only if the        |
|           | current matching point is at the start of the subject string; |
|           | if the start of a string to be matched is any one of the      |
|           | possible newline conventions, then `^` does not match (except |
|           | if the pattern seeks to match the newline convention          |
|           | explicitly). However, if the MULTILINE flag (`m`) is raised,  |
|           | `^` matches immediately after internal newlines as well as at |
|           | the start of the subject string.                              |
|           | When the newline convention recognizes the two-character      |
|           | sequence CRLF as a newline, this is preferred, even if the    |
|           | single characters CR and LF are also recognized as newlines.  |
|           | For example, if the newline convention is "any", a multiline  |
|           | mode `^` matches before `"xyz"` in the string `"abc\r\nxyz"`  |
|           | rather than after CR, even though CR on its own is a valid    |
|           | newline. (It also matches at the very start of the string)    |
|           |                                                               |
|           | `^` need not be the first character of the pattern if a       |
|           | number of alternatives are involved, but it should be the     |
|           | first thing in each alternative in which it appears if the    |
|           | pattern is ever to match that branch. If all possible         |
|           | alternatives start with a `^`, that is, if the pattern is     |
|           | constrained to match only at the start of the subject, it is  |
|           | said to be an "anchored" pattern. (There are also other       |
|           | constructs that can cause a pattern to be anchored.)          |
|           |                                                               |
|           | Inside a character class, `^` has an entirely different       |
|           | meaning: it negates a class. For example, the character class |
|           | `[aeiou]` matches any lower case vowel, while `[^aeiou]`      |
|           | matches any character that is not a lower case vowel. Note    |
|           | that a `^` is just a convenient notation for specifying the   |
|           | characters that are in the class by enumerating those that    |
|           | are not. Note that, `^` only has special meaning inside a     |
|           | character class, if it starts the class. For example,         |
|           | `[^1-3abcd]` matches any character that is not `1`, `2`, `3`  |
|           | `a`, `b`, `c`, and `d`; however `[1-3^abcd]` matches any one  |
|           | of these characters: `1`, `2`, `3`, `^`, `a`, `b`, `c`, `d`.  |
|           |                                                               |
| `$`       | End of string (or line, in multiline mode).                   |
|           |                                                               |
|           | The `$` character is an assertion that is true only if the    |
|           | current matching point is at the end of the subject string,   |
|           | or immediately before a newline at the end of the string.     |
|           | Note, however, that it does not actually match the newline.   |
|           | However, if the MULTILINE flag (`m`) is raised, `$` matches   |
|           | before any newlines in the string, as well as at the very     |
|           | end. For example, without the `m` flag, `"\w$"` matches `"a"` |
|           | in the string `"apple\nbanana"`; but with the `m` flag        |
|           | raised, `"\w$"` matches `"e". And with the `eachmatch`        |
|           | function, we see that `"\w$"` (with the `m` flag raised)      |
|           | matches both `"e"` and `"a"`, as `"e"` is the letter          |
|           | before a newline, and `"a"` the end of the string.            | 
|           |                                                               |
|           | `$` need not be the last character of the pattern if a number |
|           | of alternatives are involved, but it should be the last item  |
|           | in any branch in which it appears. `$` has no special meaning |
|           | in a character class.                                         |
|           |                                                               |
| `\A`      | Beginning of string.                                          |
|           |                                                               |
|           | The `A` assertion differs from `^`, in that it only match at  |
|           | the very start of the subject string, regardless of whatever  |
|           | options are set; thus, it is independent of multiline mode.   |
|           | For example, `"^\w"` and `"\A\w"` does not match `"\nA"`, but |
|           | raising the MULTILINE flag (`m`) makes `"^\w"` match `"a"`;   |
|           | `"\A\w"` does not. Using another example, `"^a"` and `"\Aa"`  |
|           | both match the `"a"` in the start of the string               |
|           | `"alms\nant"`; but raising the MULTILINE flag (`m`) makes     |
|           | `"^a"` match both the `"a"` at the start of the string and    |
|           | also after the newline; whereas `"\Aa" would still only match |
|           | the `"a"` at the start of the string.                         |
|           |                                                               |
|           | If all branches of a pattern start with `\A` it is always     |
|           | anchored, whether or not the MULTILINE flag (`m`) is raised.  |
|           |                                                               |
| `\G`      | Beginning of string or end of previous match.                 |
|           |                                                               |
|           | The `\G` assertion is true only when the current matching     |
|           | position is at the start point of the matching process, hence |
|           | it is equivalent to `\A` when the matching process is at `0`  |
|           | i.e. the beginning.                                           |
|           |                                                               |
|           | However, it differs from `\A` when the matching position is   |
|           | is non-zero; and it is in this kind of implementation where   |
|           | `\G` can be useful. For example, consider this string:        |
|           | `"A1B1C1vsA1A2A3"`. Each position (on either side of "vs")    |
|           | has three tokens composed of one letter and one digit.        |
|           | Suppose we want to match the first three tokens, i.e. `A1`,   |
|           | `B1`, `C1`, we can do this quite easily with this regex:      |
|           | `"\G[A-Z]\d"`. The `\G` matches at the beginning of the       |
|           | string, allowing us to match `"A1"`. Then `\G` matches before |
|           | the next token, so we match it, as well as the following      |
|           | token. `\G` succeeds again before the `vs`, but `[A-Z]`       |
|           | cannot match the `"v"`, so the match fails. There is no more  |
|           | position for `\G` to match, and we therefore avoid the tokens |
|           | to the right, as we wanted (use `eachmatch` to see the match  |
|           | results).                                                     | 
|           |                                                               |
|           | If all the alternatives of a pattern begin with `\G`, the     |
|           | expression is anchored to the starting match position, and    |
|           | the "anchored" flag is set in the compiled regular            |
|           | expression.                                                   |
|           |                                                               |
| `\z`      | Very end of the string.                                       |
|           |                                                               |
|           | The `\z` assertion differs from `$`, in that it only match at |
|           | the very end of the subject string, regardless of whatever    |
|           | options are set; thus it is independent of multiline mode.    |
|           | For example, `"e$"` and `"e\z" both match the last `"e"` in   |
|           | the string `"apple\norange"`. But raisng the MULTILINE flag   |
|           | (`s`) makes `"e$"` match the `"e"` before the newline, and    |
|           | also the `"e"` at the end of the string; whereas, `"e\z"`     |
|           | would still only match the last `"e"` in the string.          |
|           |                                                               |
| `\Z`      | Very end of string or before a line break at the very end of  |
|           | string.                                                       |
|           |                                                               |
|           | The `\Z` assertion differs from `\z`, in that though they     |
|           | both match "end-of-strings", `\Z` can as well match the end   |
|           | of a string that comes before a newline, whereas `\z` can     |
|           | only match the "very" end, with no consideration of any       |
|           | characters being newline(s) or not. For example, both `"e\z"` |
|           | and `"e\Z"` would match the `"e"` at the end of the string    |
|           | `"apple\norange"`. Now, if we should add a newline to the end |
|           | of the string, making it `"apple\norange\n"`, and try         |
|           | matching with `"e\z"`, no match would be found; however,      |
|           | `"e\Z"` would still match the `"e"` before the newline at the |
|           | of the string.                                                |   
|           |                                                               |
|           | The `\Z` assertion also differs from `$`, in that though they |
|           | they can both match the "end-of-string" before a line break,  |
|           | `\Z` only matches the very end of that string, regardless of  |
|           | whatever options are set; thus it is independent of multiline |
|           | mode. For example, `"e$"` and `"e\Z"` would both match the    |
|           | last `"e"` in the string `"apple\norange"`. But raising the   |
|           | MULTILINE flag (`s`) makes `"e$" match the "e"` before the    |
|           | newline, and also the `"e"` at the end of the string;         |
|           | whereas, `"e\Z"` would still only match the last `"e"` in the |
|           | string.                                                       |
|           |                                                               |
| `\b`      | Word boundary i.e. position where one side only is an         |
|           | ASCII/Unicode letter, digit or underscore.                    |
|           |                                                               |
|           | A word boundary is a position in the subject string where the |
|           | current character and the previous character do not both      |
|           | match `\w` or `\W` (i.e. one matches `\w` and the other       |
|           | matches `\W`), or the start or end of the string if the first |
|           | or last character matches `\w`, respectively.                 |
|           |                                                               |
|           | Neither PCRE2 nor Perl has a separate **"start of word"** or  |
|           | **"end of word"** metasequence. However, whatever follows     |
|           | `"\b"` normally determines which it is. For example, `"\ba"`  |
|           | matches `"a"` at the start of a word, `"a\b:` matches `"a"`   |
|           | at the end of a word, and `"\ba\b"` matches `"a"` that is     |
|           | surrounded by word boundaries on both sides e.g.              |
|           | `"I have a pen"`; `"\ba\b"` also matches `"a"` that is on its |
|           | own at the start or end of a string e.g. `"a book"`,          |
|           | `"small letter a"`.                                           |
|           |                                                               |
|           | Note also that when the start of a pattern is `(*UCP)`, it    |
|           | affects `\b` and `\B` because they are defined in terms of    |
|           | `\w` and `\W`. Matching these sequences is noticeably slower  |
|           | when `(*UCP)` is used at the start of a pattern.              |
|           |                                                               |
|           | Inside a character class, `\b` has a different meaning; it    |
|           | matches the backspace character (hex 08).                     |
|           |                                                               |
| `\B`      | Not a word boundary.                                          |
|           |                                                               |
|           | `\B` is not special inside a character class. Like other      |
|           | unrecognized alphabetic escape sequences, it causes an error. |

## Quoting & Keeping Out
| Character | Interpretation                                                |
|:----------|:--------------------------------------------------------------|
| `\Q...\E` | Treat all characters in a sequence as literals i.e. no        |
|           | character(s) has a special meaning when delimited inside      |
|           | `\Q...\E`. This is different from Perl in that `$` and `@`    |
|           | are handled as literals in `\Q...\E` sequences in PCRE2,      |
|           | whereas in Perl, `$` and `@` cause variable interpolation.    |
|           | Also, Perl does "double-quotish backslash interpolation" on   |
|           | any backslashes between `\Q` and `\E` which, its              |
|           | documentation says, "may lead to confusing results". PCRE2    |
|           | treats a backslash between `\Q` and `\E` just like any other  |
|           | character. For example, the pattern `r"\Qabc\$xyz\E"` matches |
|           | "abc\$xyz".                                                   |
|           |                                                               |
|           | The `\Q...\E` sequence is recognized both inside and outside  |
|           | character classes. An isolated `\E` that is not preceded by   |
|           | `\Q` is ignored. If `\Q` is not followed by `\E` later in the |
|           | pattern, the literal interpretation continues to the end of   |
|           | the pattern (that is, `\E` is assumed at the end). If the     |
|           | isolated `\Q` is inside a character class, this causes an     |
|           | error, because the character class is not terminated by a     |
|           | closing square bracket.                                       |
|           |                                                               |
| `\K`      | Drop all characters that was matched so far from the overall  |
|           | match to be returned e.g. `"foo\Kbar"` matches `"foobar"`,    |
|           | but reports that it has matched `"bar"`.                      |
|           |                                                               |
|           | *Lookbehinds*, a kind of *lookaround* assertion, are often    |
|           | used to match certain text that is preceded by other text,    |
|           | without including the other text in the overall regex match.  |
|           | They start with `(?<=` (for positive assertions) and          |
|           | `(?<!` (for negative assertions) e.g. `"(?<=h)d"` matches     |
|           | only the second `d` in `"adhd"`. However, only a subset of    |
|           | the regex syntax can be used inside lookbehinds; PCRE2 allow  |
|           | alternatives of different length, but still don't allow       |
|           | quantifiers other than the fixed-length `{n}`. To overcome    |
|           | these limitations, `\K` can be used for its most common       |
|           | purpose, as the part of the string before the "real match"    |
|           | does not have to be of fixed length. For example,             |
|           | `"^\d+ \K\[a-zA-Z]+"` matches the letters from a string       |
|           | provided it was preceded and started with any number of       |
|           | digits and a whitespace e.g. `"100 dollars"`, where           |
|           | `"dollars"` would be matched; trying to do this with a        |
|           | lookbehind is impossible as the number of digits before the   |
|           | whitespace has to be fixed.                                   |
|           |                                                               |
|           | You can use `\K` pretty much anywhere in any regex; you       |
|           | should only avoid using it inside lookaround assertions. You  |
|           | can use it inside groups, even when they have quantifiers.    |
|           | You can have as many instances of `\K` in your regex as you   |
|           | like. For example, `"(ab\Kc|d\Ke)f"` matches `"cf"` when      |
|           | preceded by `"ab"`. It also matches `"ef"` when preceded by   |
|           | `"d"`. `\K` does not affect capturing groups. When            |
|           | `"(ab\Kc|d\Ke)f"` matches `"cf"`, the capturing group         |
|           | captures `"abc"` as if the `\K` weren't there. When the regex |
|           | matches `"ef"`, the capturing group stores `"de"`. `\K` also  |
|           | does not interact with anchoring in any way; for example,     |
|           | `"^foo\Kbar"` matches only when the string begins with        |
|           | "foobar" (in single line mode), though it reports the matched |
|           | string as `"bar"`.                                            |
|           |                                                               |
|           | However, `\K` has two profound limitations when compared to   |
|           | lookbehinds. The most obvious one is that while lookbehind    |
|           | comes in positive and negative variants, `\K` does not        |
|           | provide a way to negate anything. `(?<!a)b` matches the       |
|           | string `"b"` entirely, because it is a `"b"` not preceded by  |
|           | an `"a”`. `[^a]\Kb` does not match the string `"b"` at all.   |
|           | Because when attempting the match, `[^a]` matches `b`. The    |
|           | regex has now reached the end of the string. `\K` notes this  |
|           | position. But now there is nothing left for `b` to match, so  |
|           | the match attempt fails. `[^a]\Kb` is the same as             |
|           | `"(?<=[^a])b"`, which are both different from `"(?<!a)b"`.    |
|           |                                                               |
|           | The second limitation is that `\K` cannot match a             |
|           | character(s) that was part of the previous match; lookbehind  |
|           | can do this. This limitation is only an "issue" when the part |
|           | of a regex before `\K` can match the same text as the part of |
|           | the regex after \K`. For example, iterating over all matches  |
|           | of `"(?<=a)a"` in `"aaaa"`, will return three matches: the    |
|           | second, third, and fourth `a` in the string. However,         |
|           | iterating over `"a\Ka"` in the same string will return only   |
|           | two matches: the second and the fourth `"a"`.                 |

## Character Classes
A character class is a group of characters defined within square brackets, which can match a
single character from the input string. The only metacharacters recognized within a
character class are `\`, `-`, `^`, `[`, and `]`. Other regex elements such as character
escapes (e.g `\d`), octal escapes (e.g. `\141`), hexadecimal escapes (`\x97`), Unicode
character escapes (e.g. `\u20AC`), and Unicode properties (e.g. `\p{Lu}`) can also be used
within character classes.

| Character | Interpretation                                                |
|:----------|:--------------------------------------------------------------|
| `[`       | `[` introduces a character class, terminated by `]`. A `]` on |
|           | its own is not special by default, and if it is required as a |
|           | member of the class, it should be the first character in the  |
|           | class (after an initial `^`, if present) or escaped with a    |
|           | `\`. This means that, by default, an empty class cannot be    |
|           | defined. The order of the characters inside a character class |
|           | does not matter; the results will be the same.                |
|           |                                                               |
|           | A character class matches a single character in the subject   |
|           | once. A matched character must be in the set of characters    |
|           | defined by the class, unless the first character in the class |
|           | definition is `^`, in which case the matched character must   |
|           | not be in the set defined by the class. For example,          |
|           | `"[brc]at"` matches either `"bat"`, `"rat"` or `"cat"`; but   |
|           | it does not match `"hat"`, since `h` isn't among the          |
|           | characters in the class. Since a character class only matches |
|           | a single letter, `"[brc]at"` will not match `"brat"`, but     |
|           | rather it will match `"rat"` in the string `"brat"`. To match |
|           | more than one, use a quantifier; so `"[brc]+at"` matches      |
|           | `"brat"`.                                                     |
|           |                                                               |
|           | If you repeat a character class with any one of the           |
|           | quantifiers, you're repeating the entire character class, and |
|           | not just the character that it matched. For example,          |
|           | `"[0-9]+"` can match `"837"` as well as `"222"`. If you want  |
|           | to repeat the matched character, rather than the class, you   |
|           | need to use *backreferences*. For example, `"([0-9])\1+"`     |
|           | matches `"222"` but not `"837"`. When applied to the string   |
|           | `"833337"`, it matches `"3333"` in the middle of this string. |
|           |                                                               |
|           | The generic character type escape sequences may appear in a   |
|           | character class, and add the characters that they match to    |
|           | the class. For example, `"[\dABCDEF]"` matches any            |
|           | hexadecimal digit. In UTF modes, the `(*UCP)` syntax affects  |
|           | the meanings of `\d`, `\s`, `\w` and their upper case         |
|           | partners, just as it does when they appear outside a          |
|           | character class.                                              |
|           |                                                               |
| `]`       | `[` terminates a character class, introduced by `]`. It is    |
|           | not possible to have the literal character `"]"` as the end   |
|           | character of a range. A pattern such as `"[W-]46]"` is        |
|           | interpreted as a class of two characters (`"W"` and `"-"`)    |
|           | followed by a literal string `"46]"`, so it would match       |
|           | `"W46]"` or `"-46]"`. However, if the `"]"` is escaped with a |
|           | backslash it is interpreted as the end of range, so           |
|           | `"[W-\]46]"` is interpreted as a class containing a range of  |
|           | characters from `W` to `]`, `4` or `6`. Since the octal or    |
|           | hexadecimal representation of characters can be used inside a |
|           | character class, we can write `"[W-\]46]"` as `""[W-\x5d46]"` |
|           | where `\x5d` is the hexadecimal representation of `"]"`.      |
|           |                                                               |
| `-`       | `-` between two ASCII/Unicode characters, creates/specifies a |
|           | range of characters that can be matched. For example,         |
|           | `"[0-9]"` matches a single digit between `0` and `9`,         |
|           | inclusive; and `"[a-e]"` matches any character between `a`    |
|           | and `e` i.e. `a`, `b,`, `c`, `d`, or `e`. There is no         |
|           | restriction on the characters allowed to create a range;      |
|           | `"[!-~]"` is a valid range, just as `"[0-9]"` is too. Ranges  |
|           | normally include all code points between the start and end    |
|           | characters, inclusive. And they can also be used for code     |
|           | points specified numerically; for example, `"[\141-\145]"` is |
|           | same as `"[a-e]"`.                                            |
|           |                                                               |
|           | You can use more than one range: `"[0-9a-fA-F]"` matches a    |
|           | single hexadecimal digit, case insensitively. You can combine |
|           | ranges and single characters: `"[0-9a-fxA-FX]"` matches a     |
|           | hexadecimal digit, or the letters `x` or `X`. Again, the      |
|           | order of the characters and the ranges does not matter. If a  |
|           | range that includes letters of different case is used, it     |
|           | matches the letters taking the case into account. For         |
|           | example, `"[W-c]"` is equivalent to ```"[][\\^_`WXYZabc]"```, |
|           | matching casefully. However, if the CASELESS flag (`i`) is    |
|           | raised, it matches the letters in either case; so `"[W-c]"`   |
|           | becomes equivalent to ```"[][\\^_`wxyabc]"```, matching       |
|           | caselessly.                                                   |
|           |                                                               |
|           | If `-` is required in a class, it must be escaped with a      |
|           | backslash, or appear in a position where it cannot be         |
|           | interpreted as indicating a range, typically as the first (or |
|           | right after `^` if present) or last character in the class,   |
|           | or immediately after a range. For example, `"[b-d-z]"`        |
|           | matches letters in the range `b` to `d`, `-`, or `z`. Note    |
|           | that a regex like `"[a-z-[aeiuo]]"` does not cause any        |
|           | errors, but it does not mean character class subtraction, as  |
|           | PCRE2 does not support it; hence it won't match what you      |
|           | intended. Reading this regex character-by-character: `[`      |
|           | starts a character class, comprising of the characters from   |
|           | `a` to `z`, `-`, `[`, `a`, `e`, `i`, `u`, `o`, then `]`       |
|           | terminates the character class; followed by the character     |
|           | `]`. So this regex would match a string with anyone of the    |
|           | characters in the class followed by `]` e.g. `"a]"`, `"[]"`,  |
|           | `"-]"`, etc. Since the `"a-z"` range and the vowels are       |
|           | redundant, you could write this character class as            |
|           | `"[a-z-\[\]]]"`.                                              |
|           |                                                               |
| `^`       | `^` at the start of a character class, negates the class. The |
|           | result is that the character class matches any character that |
|           | is not in the character class. For example, the character     |
|           | class `"[aeiou]"` matches any lower case vowel, while         |
|           | `"[^aeiou]"` matches any character that is not a lower case   |
|           | vowel. When caseless matching is set, any letters in a class  |
|           | represent both their upper case and lower case versions, so   |
|           | for example, a caseless `"[aeiou]"` matches `"A"` as well as  |
|           | `"a"`, and a caseless `"[^aeiou]"` does not match `"A"`,      |
|           | whereas a caseful version would.                              |
|           |                                                               |
|           | Unlike the `.`, negated character classes also match          |
|           | (invisible) line break characters, regardless of whatever     |
|           | flag(s) is raised. If you don't want a negated character      |
|           | class to match line breaks, you need to explicitly write the  |
|           | line break characters in the class. For example,              |
|           | `"[^0-9\r\n]"` matches any character that is not a digit or a |
|           | line break.                                                   |
|           |                                                               |
|           | Note that a `^` is just a convenient notation for specifying  |
|           | the characters that are in the class by enumerating those     |
|           | that are not. A class that starts with `^` is not an          |
|           | assertion; it still consumes a character from the subject     |
|           | string, and therefore it fails if the current pointer is at   |
|           | the end of the string. For example, `"q[^u]"` does not match  |
|           | the `q` in the string `"Iraq"`; it does match the `"q"` and   |
|           | the space after the `"q"` in `"Iraq is a country"`. If you    |
|           | want the regex to match the `q`, and only the `q`, in both    |
|           | strings, you need to use negative lookahead: `"q(?!u)"`       |
|           |                                                               |
|           | If `^` is actually required as a member of the class, ensure  |
|           | it is not the first character, or escape it with a backslash. |
|           | For example, `"[x^]"` matches an `x` or a `^`.                |
|           |                                                               |
| `[:`      | `[` if followed by `:` inside a character class, introduces a |
|           | POSIX character class, terminated by `:]`. For example,       |
|           | `"[01[:alpha:]%]"` matches `"0"`, `"1"`, any alphabetic       |
|           | character, or `"%"`. Negation can also be used inside a POSIX |
|           | character class. For example, `"[12[:^digit:]]"` matches      |
|           | `"1"`, `"2"`, or any non-digit.                               |
|           |                                                               |
|           | See the "POSIX CHARACTER CLASSES" section under               |
|           | https://www.pcre.org/current/doc/html/pcre2pattern.html#SEC9, |
|           | for the supported classes names and their descriptions.       |
|           |                                                               |
| `:]`      | `]` if followed by `:` inside a character class, terminates a |
|           | POSIX character class introduced by `[:`.                     |

## Quantifiers
Quantifiers in regex specify the number of occurrences of a character, group, or character
class that must be present for a match to be found. Quantifiers can follow a literal
character, dot, escape sequence, character class, backreference, group, lookaround, or
subroutine call.

They can be greedy and docile (matching as many characters as possible and giving back
matched characters if the engine needs to backtrack), lazy and expandable (matching as few
characters as needed and expanding its match if the engine needs to backtrack), or greedy
and possessive (matching as many characters as possible and not giving back matched
characters, avoiding backtracking). Generally, the quantifiers `{n}`, `{n,}`, and `{n,m}`
are all greedy and docile by default. However, if `?` or `+` is appended to any one of them,
it becomes lazy (and expandable) or greedy (and possessive) respectively.

Backtracking occurs when the regex engine contains optional quantifiers or alternation
constructs and goes back to a previously saved state to continue the search for a match.
Consider these two examples:

Against the string `"A tasty apple"`, using the regex `".*apple"`, the token `.*` starts out
by greedily matching every single character in the string. The engine then advances to the
next token `a`, which fails to match as there are no characters left in the string. The
engine backtracks into the `.*`, which gives up the `e` in apple. The engine once again
advances to the next token, but the a fails to match the `e`. The engine again backtracks
into the `.*`, which gives up the `l`. The process repeats itself until the `.*` has given
up the `a`, at which stage the text tokens `a`, `p`, `p`, `l`, and `e` are all able to
match, and the overall match is successful.

Against the string `"Two_apples"`, using the regex `".*?apples"`, the token `.*?` starts out
by matching zero characters — the minimum allowed by the `*` quantifier. The engine then
advances in the pattern and tries to match the `a` token against the `T` in `Two`. That
fails, so the engine backtracks to the `.*?`, which expands to match the `T`. The engine
advances both in the pattern and in the string and tries to match the a token against the
`w` in `Two`, which fails. Once again, the engine has to backtrack. The `.*?` expands to
match the `w`, then the `a` token fails against the `o` in `Two`. This process of advancing,
failing, backtracking, and expanding repeats itself until the `.*?` has expanded to match
`Two_`. At that stage, the following token `a` is able to match, as are the `p` and all the
tokens that follow. The match attempt finally succeeds.

However, backtracking can slow down the performance of the engine, so possessive quantifiers
can be used to match characters as solid blocks that cannot be backtracked into, improving
the performance of the engine. PCRE2 has an optimization that automatically possessifies
certain pattern constructs, but this feature can be disabled by starting the pattern with
`(*NO_AUTO_POSSESS)`.

| Character | Interpretation                                                |
|:----------|:--------------------------------------------------------------|
| `{`       | General repitition quantifier, for specifying a number of     |
|           | permitted matches.                                            |
|           |                                                               |
|           | `{n}`: exactly `n` occurences of a pattern (neither greedy    |
|           | nor lazy); e.g. `"\d{8}"` matches exactly 8 digits.           |
|           |                                                               |
|           | `{n,}`: `n` or more occurences of a pattern                   |
|           | (greedy and docile); e.g. `"\d{2,}"` matches exactly 2 or     |
|           | more digits.                                                  |
|           |                                                               | 
|           | `{n, m}`: at least `n`, no more than `m`                      |
|           | (greedy and docile). `n` and `m` must be less than 65536`,    |
|           | and `n` must be less than or equal to `m`; e.g. `"\d{2, 5}"`  |
|           | matches exactly 2, 3, 4 or 5 digits.                          |
|           |                                                               |
| `}`       | Terminates a quantifier, introduced by `{`. A closing brace   |
|           | on its own is not a special character.                        |
|           |                                                               |
| `*`       | 0 or more occurences of a pattern (greedy and docile). This   |
|           | is equivalent to `{0,}`; e.g. `"A*B*C*"` matches `"AAACC"`.   |
|           |                                                               |
| `+`       | 1 or more occurences of a pattern (greedy and docile). This   |
|           | is equivalent to `{1,}`; e.g. `"A+B+C"` matches `"AAABCC"`.   |
|           |                                                               |
| `?`       | 0 or 1 occurences of a pattern (greedy and docile). This is   |
|           | equivalent to `{0,1}`; e.g. `"A?B?C?"` matches `"AC"`.        |
|           |                                                               |
| `{n,}?`   | `n` or more occurences of a pattern (lazy and expandable);    |
|           | e.g. `"\d{2,}"` on the string `"123"` would match `123`,      |
|           | whereas `"\d{2,}?"` on the same string matches `"12"`.        |
|           |                                                               |
| `{n,}+`   | `n` or more occurences of a pattern (greedy and possessive);  |
|           | `".{2,}days"` on the string `"365 days"` matches `365 days`,  |
|           | whereas `".{2,}+days"` on the same string does not match.     |
|           |                                                               |
| `{n,m}?`  | at least `n`, no more than `m` (lazy and expandable); e.g.    |
|           | `"\d{2,5}"` on the string "12345"` would match `12345`,       |
|           | whereas `"\d{2,5}?"` on the same string matches `12`.         |
|           |                                                               |
| `{n,m}+`  | at least `n`, no more than `m` (greedy and possessive); e.g.  |
|           | `".{2,5}days"` on the string `"365 days"` matches `365 days`, |
|           | whereas `".{2,5}+days"` on the same string does not match.    |
|           |                                                               |
| `*?`      | 0 or more occurences of a pattern (lazy and expandable); e.g. |
|           | `".*"` on the string `"123"` would match `123`, whereas       |
|           | `".*?"` on the same string matches nothing.                   |
|           |                                                               |
| `*+`      | 0 or more occurences of a pattern (greedy and possessive);    |
|           | e.g. `"A*."` on the string `"AAA"` would match `AAA`, whereas |
|           | `"A*+."` on the same string does not match.                   |
|           |                                                               |
| `+?`      | 1 or more occurences of a pattern (lazy and expandable); e.g. |
|           | `".+"` on the string `"123"` would match `123`, whereas       |
|           | `".+?"` on the same string matches `1`.                       |
|           |                                                               |
| `++`      | 1 or more occurences of a pattern (greedy and possessive);    |
|           | e.g. `"A+."` on the string `"AAA"` would match `AAA`, whereas |
|           | `"A++."` on the same string does not match.                   |
|           |                                                               |
| `??`      | 0 or more occurences of a pattern (lazy and expandable); e.g. |
|           | `".?"` on the string `"123" would match `1`, whereas `".??"`  |
|           | on the same string matches nothing.                           |
|           |                                                               |
| `?+`      | 0 or more occurences of a pattern (greedy and possessive);    |
|           | e..g. `".?BC"` on the string `"BC"` would match `BC`, whereas |
|           | `".?+BC"` does not match.                                     |

## Grouping & Capturing
Groups are delimited by parentheses (round brackets), which can be nested. Turning a part of
a pattern into a group does two things:

1. It localizes a set of alternatives. For example, the pattern `"cat(aract|erpillar|)"`
   matches `"cataract"`, `"caterpillar"`, or `"cat"`. Without the parentheses, the pattern
   `"cataract|erpillar|"` would match `"cataract"`, `"erpillar"` or an empty string.

2. It creates a "capture group". This means that when the whole pattern matches, the portion
   of the subject string that matched the group is passed back to the caller, separately
   from the portion that matched the whole pattern. Opening parentheses, ( are counted from
   left to right (starting from 1) to obtain numbers for capture groups. For example, if the
   string `"the red king"` is matched against the pattern
   `"the ((red|white) (king|queen))"`, the captured substrings are `"red king"`, `"red"`,
   and `"king"`, and they are numbered `1`, `2`, and `3`, respectively. The maximum number
   of capture groups is 65535.

| Character   | Interpretation                                              |
|:------------|:------------------------------------------------------------|
| `(`         | Introduces a *numbered capture* group, terminated by `)`.   |
|             |                                                             |
|             | The `captures` field of a `RegexMatch` object stores the    |
|             | substrings for each capture group. To access a capture      |
|             | group, index its number into the `captures` field of the    |
|             | `RegexMatch` or the object itself. For example, the pattern |
|             | `"(\d+):(\d+)(am\|pm)?"`, assigned to the variable `m`      |
|             | matches `11:30` in the string `"The time is 11:30"`, and    |
|             | captures `"11"`, "30", and `nothing` into group `1`, `2`    |
|             | and `3` respectively. To access the second captured group,  |
|             | we can use any of these syntax: `m.captures[2]` or `m[2]`.  |
|             |                                                             |
|             | The `offset` field of the `RegexMatch` object stores the    |
|             | locations of the start of each capture group, with `0`      |
|             | denoting a group that was not captured. Using the example   |
|             | above, `m.offsets[2]` returns `16`, denoting the index      |
|             | at which the match for the second captured group begins     |
|             | from.                                                       |
|             |                                                             |
|             | In a regex pattern, every set of capturing parentheses from |
|             | left to right as you read the pattern gets assigned a       |
|             | number, whether or not the engine uses these parentheses    |
|             | when it evaluates the match. For example, the pattern       |
|             | `"((sun)\|(satur))day"` matches the string `"saturday"`,    |
|             | and captures `"satur"`, `"nothing"`, and `"satur"` into     |
|             | groups 1, 2, and 3 respectively. The group 2 was also       |
|             | captured, even when it lives on the wrong side of the `\|`  |
|             | metacharacter.                                              |
|             |                                                             |
|             | This left-to-right numbering is strict. You cannot generate |
|             | new capture groups automatically, even with quantifiers;    |
|             | the capturing parentheses you see in a pattern only capture |
|             | a single group. For example, the regex `"(\d)+"` on the     |
|             | string `"1234"` will repeatedly refer to group 1, while     |
|             | greedily matching the digits, until the string is           |
|             | exhausted; the matched results will be `1234` and the       |
|             | captured value will be the last match, `4`. In essence,     |
|             | group 1 gets overwritten each time the regex is matched.    |
|             | The same thing happens if you use recursive patterns or     |
|             | named captured group instead of quantifiers.                |
|             |                                                             |
|             | There is an exception to the strict left-to-right           |
|             | numbering. It is the branch reset syntax (which itself is a |
|             | non-capturing group), introduced by `(?\|`. All groups      |
|             | enclosed within `(?\|` are treated as one, regardless of    |
|             | the numbers.                                                |
|             |                                                             |
| `(?<name>`  | Introduces a *named capture* group, terminated by `)`.      |
| `(?'name'`  |                                                             |
| `(?P<name>` | Identifying capture groups by number is simple, but it can  |
|             | be very hard to keep track of the numbers in complicated    |
|             | patterns, with groups above 3 or 4. Furthermore, if an      |
|             | expression is modified, the numbers may change. To solve    |
|             | these, one can provide a name for a capture group, which    |
|             | can be used to refer to that captured group. A capture      |
|             | group can be named in any one of these three ways shown in  |
|             | this table. Names may be up to 32 code units long, and must |
|             | not start with a digit.                                     |
|             |                                                             |
|             | Named capture groups are allocated numbers as well as       |
|             | names, exactly as if the names were not present; Hence,     |
|             | adding a named capturing group to an existing regex still   |
|             | upsets the numbers of the unnamed groups. Capture groups    |
|             | are primarily identified by numbers; any names are just     |
|             | aliases for these numbers. However, mixing named and        |
|             | numbered capturing groups in a pattern is not recommended,  |
|             | because it reduces readability and may cause inconsistency  |
|             | when a pattern is modified (as the numbers for the captured |
|             | groups changes as well). If a group doesn't need to have a  |
|             | name, make it non-capturing using any of the non-capturing  |
|             | syntaxes.                                                   |
|             |                                                             |
|             | References to capture groups from other parts of the        |
|             | pattern, such as backreferences, recursion, and conditions, |
|             | can all be made by name as well as by number.               |
|             |                                                             |
|             | Duplicate named groups are not allowed by default; they're  |
|             | only allowed if you use the mode modifier `(?J)`. In such a |
|             | case, trying to access the captured groups will only be     |
|             | possible by numbers; an error is thrown if one tries to     |
|             | access them by names.                                       |
|             |                                                             |
|             | One should only use groups with the same name in seperate   |
|             | alternatives. This can prove useful for patterns where only |
|             | one instance of the named capture group can match; however  |
|             | the other groups not matched are also captured. To achieve  |
|             | the same behaviour, while not capturing the groups not      |
|             | matched, use a "branch rest" group, introduced by `(?|`.    |
|             |                                                             |
|             | If you make a backreference to a non-unique named group     |
|             | from elsewhere in the pattern, the groups to which the name |
|             | refers are checked in the order in which they appear in the |
|             | overall pattern. The first one that is set is used for the  |
|             | reference. For example, this pattern,                       |
|             | `"(?J)(?<n>foo)\|(?<n>bar)\k<n>"` matches both `"foofoo"`   |
|             | and `"barbar"` but not `"foobar"` or `"barfoo"`.            |
|             |                                                             |
|             | If you make a subroutine call to a non-unique named group,  |
|             | the one that corresponds to the first occurrence of the     |
|             | name is used. In the absence of duplicate numbers this is   |
|             | the one with the lowest number.                             |
|             |                                                             |
|             | If you use a named reference in a condition test, either to |
|             | check whether a capture group has matched, or to check for  |
|             | recursion, all groups with the same name are tested. If the |
|             | condition is true for any one of them, the overall          |
|             | condition is true. This is the same behaviour as testing by |
|             | number.                                                     |
|             |                                                             |
| `(?:`       | Introduces a *non capture* group, terminated by `)`.        |
|             |                                                             |
|             | The fact that plain parentheses fulfil two functions is not |
|             | always helpful. There are often times when grouping is      |
|             | required without capturing. `(?:` starts a group that does  |
|             | not do any capturing, and is not counted when computing the |
|             | number of any subsequent capture groups.                    |
|             |                                                             |
|             | As a convenient shorthand, if any option settings are       |
|             | required at the start of a non-capturing group, the option  |
|             | letters may appear between the `"?"` and the `":"`. Thus    |
|             | the two patterns, `"(?i:saturday\|sunday)"` and             |
|             | `"(?:(?i)saturday\|sunday)"`, match exactly the same set of |
|             | strings.                                                    |
|             |                                                             |
|             | Because alternative branches are tried from left to right,  |
|             | and options are not reset until the end of the group is     |
|             | reached, an option setting in one branch does affect        |
|             | subsequent branches, so the above patterns match `"SUNDAY"` |
|             | as well as `"Saturday"`.                                    |
|             |                                                             |
|             | The NO\_AUTO_CAPTURE flag (`n`) tells the engine to treat   |
|             | all groups as non-capture group. This means that            |
|             | `"(?n)(subpattern)"` becomes equivalent to                  |
|             | `"(?:subpattern)"`.                                         |
|             |                                                             |
| `(?\|`      | Introduces a *non capture* group, which reset group numbers |
|             | for capture groups in each alternative; terminated by `)`.  |
|             |                                                             |
|             | By default, a name must be unique within a pattern.         |
|             | However, as shown above, with the `(?J)` modifier at the    |
|             | start of a pattern, duplicate names can be used. `(?J)`,    |
|             | however, captures all groups (both the matched and          |
|             | unmatched); most times this is not what is needed, as it    |
|             | leads to confusion and inconsistency when handling the      |
|             | captured groups with references like backreferences, etc.   |
|             | This is where the `(?\|` syntax comes in: it's a            |
|             | non-capturing group which enables duplicate group names in  |
|             | different alternatives to have the same name; that is, all  |
|             | groups enclosed within `(?\|` are treated as one.           |
|             | References to such group are always handled correctly and   |
|             | consistently.                                               |
|             |                                                             |
|             | For example, the patttern `"(?J)(?<n>foo)\|(?<n>bar)\k<n>"` |
|             | matches the string `"foofoo"`, and captures `"foo"` and     |
|             | `nothing` into two groups named `n` respectively. However,  |
|             | the pattern `"(?\|(?<n>foo)\|(?<n>bar))\k<n>"` matches the  |
|             | the same string, but captures `"foo"` into just one group   |
|             | named `n`.                                                  |

## Atomic Grouping
| Character   | Interpretation                                              |
|:------------|:------------------------------------------------------------|
| `(?<`       | Introduces an atomic *non-capture* group, which prevents    |
| `(*atomic:` | backtracing into the group; terminated by `)`.              |
|             |                                                             |
|             | With both maximizing ("greedy") and minimizing ("lazy")     |
|             | repetition, failure of what follows normally causes the     |
|             | repeated item to *backtrack* i.e. re-evaluated to see if a  |
|             | different number of repeats or alternation allows the rest  |
|             | of the pattern to match. Sometimes it is useful to prevent  |
|             | this, either to change the nature of the match, or to cause |
|             | it fail earlier than it otherwise might, when the author of |
|             | the pattern knows there is no point in carrying on. Putting |
|             | an expression inside a `(?<` or `(*atomic:`, specifies that |
|             | once a group has matched, it should not backtrack into it.  |
|             |                                                             |
|             | Possessive quantifiers are essentially a notational         |
|             | convenience for the simpler forms of atomic group; for      |
|             | example, `"(?>A*)"` is equivalent to `"A*+"`. They may also |
|             | be used with the non-capturing group, `(?:`, to create      |
|             | arbitrarily complicated expressions which can be nested,    |
|             | just like an atomic group; for example, `"a(?>bc\|b)c"` is  |
|             | equivalent to `"a(?:bc|b)++c"`. Though equivalent, there    |
|             | may be a performance difference; possessive quantifiers     |
|             | should be slightly faster.                                  |
|             |                                                             |
|             | Atomic groups are non-capturing, though as with other       |
|             | non-capturing groups, you can place the atomic group inside |
|             | another set of parentheses to capture the group's entire    |
|             | match; and you can place parentheses inside the atomic      |
|             | group to capture a section of the match.                    |

## Back-References
Backreferences are used to "reference" a *captured group* that was matched "back"
(i.e., to the left) in a pattern, hence the name "back-reference." They allow the exact
content captured by one group in a pattern to be matched again later in the regex. Simply
put, a backreference is a way to repeat a capturing group.

Outside a character class, a backslash followed by the captured group specifies a
backreference. For example, `\1` is a backreference to the numbered-captured group `1`, and
`\k'hour'` is a backreference to the named-captured group `hour`. You can reuse the same
backreference more than once. For example, the pattern `"([a-c])x\1x\1"` matches `"axaxa"`,
`"bxbxb"`, and `"cxcxc"`. Backreferences cannot be used inside a character class, so the
`\1` in a regex like `"(a)[\1b]"` is an octal escape.

Because there may be many capture groups in a pattern, all digits following a backslash are
taken as part of a potential backreference number. If the pattern continues with a digit
character, some delimiter must be used to terminate the backreference. For example, to match
the string `"a1 a2 a3"`, one would be tempted to use the pattern `"(\w+) \12 \13"`; however,
this pattern does not match our intended string, instead, it matches `"a1 \n \v"` because
the digits after the backslash are all taken as a possible capture group, and since there is
none, they are used as octal escapes. There are many ways to solve this: if the EXTENDED
flag (`x`) or EXTENDED_MORE flag (`xx`) is raised, whitespace can be used; or an empty
comment (i.e., the (?# syntax) can also be used. However, the most elegant way is to use the
`\g{}` syntax: `"(\w+)1 \g{1}2 \g{1}3"`.

When a group makes multiple captures, a backreference refers to the most recent capture
(i.e., the group most immediately to the left, when matching left to right). For example,
the pattern, `"(?J)(?<n>(?<n>red|white) (?<n>king|queen)) \k<n>"` matches only the string
`"red king red king"` and not `"red king red"` or `"red king king"` since `"red king"` was
the captured group named `n` most immediately to the left of the pattern.

If caseful matching is in force at the time of the backreference, the case of letters is
relevant. For example, the pattern `"((?i)rah) \1"` matches `"rah rah"` and `"RAH RAH"`, but
not `"RAH rah"`, even though the original capture group is matched caselessly. However, the
pattern `"(?i)(rah) \1"`, where caseful matching is applied outside the pattern, matches the
same string as the former, and also `"RAH rah"`.

A "forward backreference" is also possible. This involves creating a backreference to a
group that would later be captured. They are obviously only useful when they are inside a
repeated group that has alternations because there is a possibility for the regex engine to
evaluate the backreference after the group has already matched in one of the alternations.
Before the group is attempted, the backreference fails, just like a backreference to a
non-existing group. For example, the pattern `"(\2two|(one))+"` matches `"oneonetwo"`,
capturing `"onetwo"` into group 1 and `"one"` into group 2.

A "recursive backreference" is also supported. This involves a backreference that occurs
inside the capturing group to which it refers (also known as a "nested backreference").
Recursive backreferences are only useful if they are inside a repeated group that has
alternations or by a quantifier with a minimum of zero. For example, `"(a\1)"` never
matches; however, `"(a|b\1)+"` matches any number of `"a"`s and also `"aba"`, `"ababbaa"`,
etc. At each iteration of the group, the backreference matches the character string
corresponding to the previous iteration, capturing the last iteration before the match ends.
Also, `"(\1two|(one))+"` matches `"oneonetwo"`, capturing `"onetwo"` into group 1 and
`"one"` (the first occurrence of `one`) into group 2.

There is a difference between a backreference to a capturing group that matched nothing
(captured an empty string) and one to a capturing group that did not participate in the
match at all (captured `nothing`):

- The regex `"(q?)b\1"` matches `"b"`. `q?` is optional and matches nothing, causing `(q?)`
  to successfully match and capture nothing (empty string). `b` matches `b`, and `\1`
  successfully matches the nothing (empty string) captured by the group.

- The regex `"(q)?b\1"` fails to match `"b"`. `(q)` fails to match at all, so the group
  never gets to capture anything at all (i.e., nothing is captured). Because the whole group
  is optional, the engine does proceed to match `"b"`. The engine now arrives at `\1`, which
  references a group that did not participate in the match attempt at all. This causes the
  backreference to fail to match at all, mimicking the result of the group. Since there's no
  `?` making `\1` optional, the overall match attempt fails.

There are three ways of referring to such a backreference: absolutely, relatively, and by
name.

| Character   | Interpretation                                              |
|:------------|:------------------------------------------------------------|
| `\n`        | Absolute backreference by number.                           |
| `gn`        |                                                             |
| `\g{n}`     | A backslash followed by an unsigned number                  |
|             | (i.e. a number without a `+` or `-` sign) greater than 0 is |
|             | a backreference to a capture group earlier                  |
|             | (that is, to its left) in the pattern, provided there have  |
|             | been that many previous capture groups.                     |
|             |                                                             |
|             | If the number following the backslash is greater than 8, it |
|             | is read ambiguously, depending on the situation: if there's |
|             | a capture group with that number, it references that        |
|             | capture group; otherwise its an octal escape. For example,  |
|             | `\10` is read this way: if group 10 has been set, it is a   |
|             | backreference to group 10; if there's no group 10, it as an |
|             | instruction to match "the backspace character" since `10`   |
|             | is the octal code for the backspace character. Note that it |
|             | is never read as group 1 followed by a 0.                   |
|             |                                                             |
|             | However, if the decimal number following the backslash is   |
|             | less than 8, it is always taken as a backreference, and     |
|             | causes an error only if there are not that many capture     |
|             | groups in the entire pattern.                               |
|             |                                                             |
|             | Therefore, it is not possible to have a numerical           |
|             | "forward backreference" to a group whose number is 8 or     |
|             | more using this syntax because a sequence would be          |
|             | interpreted as a character defined in octal. For example,   |
|             | the pattern `"(\10s|(f)(o)(o)(t)(b)(a)(l)(l)(e)(r))+"`      |
|             | matches the whole string `"footballer\bs"`, but not         |
|             | `"footballeres"`.                                           |
|             |                                                             |
|             | To create a backreference with a number and still avoid the |
|             | above stated ambiguities and restriction, the proper syntax |
|             | to use is to use the `\g` sequence with the unsigned        |
|             | number: `\gn` or `\g{n}`.                                   |
|             |                                                             |
| `\g+n`      | Relative backreference by number.                           |
| `\g-n`      |                                                             |
| `\g{+n}`    | The sequence `\g` followed by a signed number, optionally   |
| `\g{-n}`    | enclosed in braces (to avoid ambiguities), is a relative    |
|             | backreference. That is, the backreference specifies the     |
|             | relative position of the capture group in relation to other |
|             | captured groups before (when the sign is `-`) or after      |
|             | (when the sign is `+`) it.                                  |
|             |                                                             |
|             | The sequence `\g-n` (can also be written as `\g{-n}`) is a  |
|             | backreference to the `n`th captured group before the        |
|             | `"\g-N"` i.e. going from right to left through the pattern. |
|             | For example, `"(a)(b)(c)\g{-1}"` matches `"abcc"` since `c` |
|             | is the `1`st captured group before `\g{-1}`; and            |
|             | `"(a)(b)(c)\g{-3}"` matches `"abca"` since `a` is the `3`rd |
|             | captured group before `\g{-3}`. If the backreference is     |
|             | inside a capturing group, then that capturing group is also |
|             | counted; so `"(a)(b)(c\g{-2})"` matches "abcb", and         |
|             | `"(a)(b)(c\g{-1})"` fails to match since `g{-1}` is         |
|             | referencing itself, when it has not been captured yet.      |
|             |                                                             |
|             | The sequence `\g+n` (can also be written as `\g{+n}`) is a  |
|             | forward backreference to the `n`th captured group after the |
|             | `"\g+N"` i.e. going from left to right through the pattern. |
|             | For example, `"(two\g{+1}|(one))+"` matches `"onetwoone"`   |
|             | since `one` which is captured to group 2 was not yet        |
|             | captured when `\g{+1}` was seen in the pattern; but         |
|             | `"((one)|two\g{+1})+"` throws an error because `one` which  |
|             | is captured to group 2 has already been captured when       |
|             | `\g{+1}` was seen in the pattern, hence `\g{+1}` was        |
|             | referencing group 3, a non-existing group.                  |
|             |                                                             |
| `\k<name>`  | Bacreference by name.                                       |
| `\k'name'`  |                                                             |
| `\g{name}`  | Shown on the left-hand side, are the several different ways |
| `\k{name}`  | of writing backreferences to named capture groups.          |
|             |                                                             |
|             | A capture group that is referenced by name may appear in    |
|             | the pattern before or after the backreference. This,        |
|             | however, does not guarantee to match a group before it is   |
|             | actually captured; if a named captured group appears in a   |
|             | pattern before it is captured, no error will be thrown but  |
|             | also no match will be found.                                |
|             |                                                             |
|             | Like numbered captured group in backreferences, named       |
|             | captured groups can also be used in forward and recursive   |
|             | backreferences (either by their names or numbers allocated  |
|             | to the groups).                                             |

## Recursive & Non-Recursive Subroutines
As you know by now, when you create a capture group such as `"(\d+)"`, you can create a
backreference to that group — for instance, `\1` for group 1 — to match the very characters
that were captured by the group; for example, `"(\w+) \1"` matches `"Hey Hey"`.

You can also repeat the actual pattern defined by a capture group. The syntax to repeat the
pattern of group 1 is (?1). For example, `"(\w+) (?1)"` will match `"Hey Ho"`. The
parentheses in `"(\w+)"` not only capture `"Hey"` to group 1 — it also defines subroutine 1,
whose pattern is `"\w+"`. Later, `"(?1)"` is a call to subroutine 1. The entire regex is,
therefore, equivalent to `"(\w+) \w+"`. Subroutines can make long expressions much easier to
look at and far less prone to copy-paste errors.

A subroutine when used outside the capture group to which it refers is called a
*non-recursive subroutine* (and is simply referred to as subroutine). An example of a
subroutine call is `"(\w+) (?1)"`, as shown above

A subroutine when used inside the capture group to which it refers is called
a *recursive subroutine* (and is simply referred to as *recursion*). For instance, the regex
`"^(A(?1)?Z)$"` contains a recursive sub-pattern because the call `"(?1)"` to subroutine 1
is embedded in the parentheses that define group 1. This pattern matches strings that start
with any number of letters `A` and end with letters `Z` that perfectly balance the `A`s,
such as `AZ`, `AAAZZZ`, etc.

Using another example: in the regex `"b(?:m|(?R))*e"`, `b` is what begins the construct, `m`
is what can occur in the middle of the construct, and `e` is what can occur at the end of
the construct. For correct results, no two of `b`, `m`, and `e` should be able to match the
same text. You can use an atomic group instead of the non-capturing group for improved
performance: `"b(?>m|(?R))*e"`.

Like backreferences, subroutines can be referenced by their relative positions and also
their group names (if it's a named capture group). For instance, `"(?-1)"` refers to the
last defined subroutine, and `"(?+1)"` refers to the next defined subroutine; therefore,
`"(\w+) (?-1)"` and `"(?+1) (\w+)"` are both equivalent to `"(\w+) (?1)"`.

Processing options such as case-independence are fixed when a group is defined, so if it is
used as a subroutine, such options cannot be changed for different calls. For example,
consider `"(abc)(?i:(?-1))"`. It matches `"abcabc"`, but does not match `"abcABC"` because
the change of processing option does not affect the called group.

Unlike recursions, subroutine calls are not treated as atomic; therefore, backtracking into
subroutine calls is possible. However, any capturing parentheses that are set during the
subroutine call revert to their previous values afterwards.

The recursive pattern, `"\w{3}\d{3}(?R)?"`, matches the string `"aaa111bbb222"`. The table
below traces the recursive pattern as it tries to match the subject.

| #  | Depth| Pos. in Regex      | String Pos.     | Notes                    | Backtracks |
|:--:|:----:|:------------------:|:---------------:|:-------------------------|:-----------|
| S1 | D0   | `\w{3}`\d{3}(?R)?  | `aaa`111bbb222  | Match.                   |            |
| S2 | D0   | w{3}`\d{3}`(?R)?   | aaa`111`bbb222  | Match.                   |            |
| S3 | D0   | \w{3}\d{3}`(?R)?`  | aaa111`bbb`222  | Try Depth 1.             |            |
| S4 | D1   | `\w{3}`\d{3}(?R)?  | aaa111`bbb`222  | Match.                   | 3          |
| S5 | D1   | \w{3}`\d{3}`(?R)?  | aaa111bbb`222`  | Match.                   | 3          |
| S6 | D1   | \w{3}\d{3}`(?R)?`  | aaa111bbb222`#` | Try Depth 2.             | 3          |
| S7 | D2   | `\w{3}`\d{3}(?R)?  | aaa111bbb222`#` | No Match, back to S6.    | 6, 3       |
| S8 | D1   | \w{3}\d{3}(?R)?`#` | aaa111bbb222`#` | D1 succeeds, back to D0. | 3          |
| S9 | D0   | \w{3}\d{3}(?R)?`#` | aaa111bbb222`#` | D0 succeeds.             |            |

To obtain an overall match, depth 0 (`D0`) must succeed all the way to the end of the
expression. In the middle of `D0`, the engine may have to dip down a number of levels. These
levels eventually all succeed or fail, throwing the engine back to the prior level. At some
stage, the engine gets back to `D0`, and either fails or eventually succeeds in finding a
match.

Another common real-world use is to match a balanced set of parentheses. The pattern
`"\((?>[^()]|(?R))*\)" or "\((?R)*\)|[^()]*"` matches a single pair of parentheses with any
text in between, including an unlimited number of parentheses that are nested or not, as
long as they are all properly paired. If the subject string contains unbalanced parentheses,
then the first regex match is the leftmost pair of balanced parentheses, which may occur
after unbalanced opening parentheses. If you want a regex that does not find any matches in
a string that contains unbalanced parentheses, then you need to use a subroutine call
instead of recursion. If you want to find a sequence of multiple pairs of balanced
parentheses as a single match, then you also need a subroutine call.

To avoid infinite loops, you need to make sure that at some stage the `(?R)` will stop
breeding. In the above pattern, this was achieved by adding a question mark after the
`(?R)`. This ensures that if a recursion level fails, the engine can continue with the match
at the level just above. Another way to make sure you can exit a recursion is to make the
`(?R)` part of an alternation. Consider this: `abc(?:$|(?R))`.

This pattern matches series of the string `"abc"` strung together. This series must be
located at the end of the subject string, as it is anchored there by the dollar sign. The
pattern matches `"abc"`, `"abcabc"`, but not `"abc123"`. How does it work? After each
`"abc"` match, the regex engine meets an alternation. On the left side, if it finds the end
of string position (expressed by the dollar symbol in the regex), that's the end of the
expression. On the other hand, if the end of the string has not yet been reached, the engine
moves to the right side of the alternation, goes down one level, and tries to find `"abc"`
once again. Without some kind of way out, the expression would never match, as eventually
any string must run out of `"abc"`s to feed the regex engine.

In PCRE, one interesting twist is that the "local" version of a group in a subroutine or
recursion starts out with the value set at the next depth level up the ladder, until it is
overwritten. This means that in PCRE, `"([A-Z]\2?)([A-Z])_(?1)"` would match `"AB_CB"`.

All quantifiers and alternatives behave as if the matching process prior to the recursion
had never happened at all, other than the engine advancing through the string. The regex
engine restores the states of all quantifiers and alternatives when it exits from a
recursion, whether the recursion matched or failed. Basically, the matching process
continues normally as if the recursion never happened, other than the engine advancing
through the string.

Let's see how `"a(?R){3}z|q"` behaves. The simplest possible match is q, found by the
second alternative in the regex. The simplest match in which the first alternative matches
is `"aqqqz"`. After `a` is matched, the regex engine begins a recursion. `a` fails to match
`q`. Still inside the recursion, the engine attempts the second alternative. `q` matches
`q`. The engine exits from the recursion with a successful match. The engine now notes that
the quantifier `{3}` has successfully repeated once. It needs two more repetitions, so the
engine begins another recursion. It again matches `q`. On the third iteration of the
quantifier, the third recursion matches `q`. Finally, `z` matches `z`, and an overall match
is found.

This regex does not match `"aqqz"` or `"aqqqqz"`. `"aqqz"` fails because, during the third
iteration of the quantifier, the recursion fails to match `z`. `"aqqqqz"` fails because,
after `a(?R){3}` has matched `aqqq`, `z` fails to match the fourth `q`. The regex can match
longer strings such as `"aqaqqqzqz"`. With this string, during the second iteration of the
quantifier, the recursion matches `"aqqqz"`. Since each recursion tracks the quantifier
separately, the recursion needs three consecutive recursions of its own to satisfy its own
instance of the quantifier. This can lead to arbitrarily long matches such as
`"aaaqqaqqqzzaqqqzqzqaqqaaqqqzqqzzz"`.

Supporting backtracking into recursions simplifies certain types of recursive pattern. For
example, this pattern matches palindromic strings: `"^((.)(?1)\2|.?)$"`.

The second branch in the group matches a single central character in the palindrome when
there are an odd number of characters, or nothing when there are an even number of
characters, but to work, it has to be able to try the second case when the rest of the
pattern match fails. If you want to match typical palindromic phrases, the pattern has
to ignore all non-word characters, which can be done like this:
`"^\W*+((.)\W*+(?1)\W*+\2|\W*+.?)\W*+$"`.

If run with the CASELESS flag (`i`), this pattern matches phrases such as
`"A man, a plan, a canal: Panama!"`. Note the use of the possessive quantifier `*+` to avoid
backtracking into sequences of non-word characters. Without this, it takes a great deal
longer (ten times or more) to match typical phrases.

Instead of looking at the classic "match nested parentheses" pattern presented elsewhere, I
will now show you a pattern that is just as powerful but easier to read. As an exercise, you
can tweak it to match nested parentheses. Here's the pattern: `"(\w)(?:(?R)|\w?)\1"`. What
does this do? This pattern matches palindromes, which are "mirror words" that can be read in
either direction, such as "level" and "peep". Let's unroll it to see how it works.

The pattern starts with one word character. This character is mirrored at the very end with
the group 1 back reference. These are the basic mechanics of how we are
"building our mirror". In the very middle of the mirror, we are happy to have either a
single character (the `\w` in the alternation) or nothing (made possible by `?` after the
\w). Note that the pattern is not anchored, so it can match mirror words inside longer
strings.

| Character    | Interpretation                                             |
|:-------------|:-----------------------------------------------------------|
| `(?R)`       | Recurse whole pattern.                                     |
|              |                                                            |
|              | A recursive pattern allows you to repeat an expression     |
|              | within itself any number of times. The main purpose of     |
|              | recursion is to match balanced constructs or nested        |
|              | constructs.                                                |
|              |                                                            |
|              | The regexes `"a(?R)?z"`, `"a(?0)?z"`, and `"a\g<0>?z"` all |
|              | match one or more letters `a` followed by exactly the same |
|              | number of letters `z`. Since these regexes are             |
|              | functionally identical, we'll use the syntax with `R` for  |
|              | recursion to see how this regex matches the string         |
|              | `"aaazzz"`.                                                |
|              |                                                            |
|              | First, `a` matches the first `a` in the string. Then the   |
|              | regex engine reaches `(?R)`. This tells the engine to      |
|              | attempt the whole regex again at the present position in   |
|              | the string. Now, `a` matches the second `a` in the string. |
|              | The engine reaches `(?R)` again. On the second recursion,  |
|              | `a` matches the third `a`. On the third recursion, `a`     |
|              | fails to match the first `z` in the string. This causes    |
|              | `(?R)` to fail. But the regex uses a quantifier to make    |
|              | `(?R)` optional. So the engine continues with `z` which    |
|              | matches the first `z` in the string.                       |
|              |                                                            |
|              | Now, the regex engine has reached the end of the regex.    |
|              | But since it's two levels deep in recursion, it hasn't     |
|              | found an overall match yet. It only has found `a` match    |
|              | for `(?R)`. Exiting the recursion after a successful       |
|              | match, the engine also reaches `z`. It now matches the     |
|              | second `z` in the string. The engine is still one level    |
|              | deep in recursion, from which it exits with a successful   |
|              | match. Finally, `z` matches the third `z` in the string.   |
|              | The engine is again at the end of the regex. This time,    |
|              | it's not inside any recursion. Thus, it returns `aaazzz`   |
|              | as the overall regex match.                                |
|              |                                                            |
|              | A regex such as `"a(?R)z"` that has a recursion token that |
|              | is not optional and is not have an alternative without the |
|              | same recursion leads to *endless recursion*. Such a regex  |
|              | can never find a match. When `a` matches the regex engine  |
|              | attempts the recursion. If it can match another `a` then   |
|              | it has to attempt the recursion again. Eventually `a` will |
|              | run out of letters to match. The recursion then fails.     |
|              | Because it's not optional the regex fails to match. PCRE2  |
|              | do not detect endless recursion when compiling your regex; |
|              | they simply go through the matching process which finds no |
|              | matches.                                                   |
|              |                                                            |
|              | Regex such as `"(?R)?z"` or `"a?(?R)?z"` or `"a|(?R)z"`    |
|              | that use recursion without having anything that must be    |
|              | matched in front of the recursion can result in            |
|              | *infinite recursion*. If the regex engine reaches the      |
|              | recursion without having advanced through the text then    |
|              | the next recursion will again reach the recursion without  |
|              | having advanced through the text. With the first regex     |
|              | this happens immediately at the start of the match         |
|              | attempt. With the other two this happens as soon as there  |
|              | are no further letters `a` to be matched.                  |
|              |                                                            |
|              | To limit recursion, use `(*LIMIT_RECURSION=d)`, setting    |
|              | `d` to the deepest recursion level allowed.                |
|              |                                                            |
|              | Quantifiers on other tokens in the regex behave normally   |
|              | during recursion. They track their iterations separately   |
|              | at each recursion. So `"a{2}(?R)z|q"` matches `"aaqz"`,    |
|              | `"aaaaqzz"`, `"aaaaaaqzzz"`, and so on. `a` has to match   |
|              | twice during each recursion.                               |
|              |                                                            |
|              | Like quantifiers, recursive patterns do not generate new   |
|              | capture groups automatically.                              |
|              |                                                            |
| `(?n)`       | Call subroutine by absolute number.                        |
| `\g<n>`      |                                                            |
| `\g'n'`      | Quantifiers on subroutine calls work just like a           |
|              | quantifier on recursion. The call is repeated as many      |
|              | times in sequence as needed to satisfy the quantifier.     |
|              | For example, `"([abc])(?1){3}"` matches `"abcb"` and any   |
|              | other four-letter combination of the first three letters   |
|              | of the alphabet. First, the group matches once, and then   |
|              | the call matches three times. This regex is equivalent to  |
|              | `"([abc])[abc]{3}"`.                                       |
|              |                                                            |
|              | Quantifiers on the group are ignored by the subroutine     |
|              | call. `"([abc]){3}(?1)"` also matches `"abcb"`. First, the |
|              | group matches three times, because it has a quantifier.    |
|              | Then the subroutine call matches once, because it has no   |
|              | quantifier. `"([abc]){3}(?1){3}"` matches six letters,     |
|              | such as `"abbcab"`, because now both the group and the     |
|              | call are repeated 3 times. These two regexes are           |
|              | equivalent to `"([abc]){3}[abc]"` and                      |
|              | `"([abc]){3}[abc]{3}"`.                                    |
|              |
| `(?+n)`      | Call subroutine by relative number.                        |
| `(?-n)`      |                                                            |
| `\g<+n>`     |                                                            |
| `\g<-n>`     |                                                            |
| `\g'+n'`     |                                                            |
| `\g'-n'`     |                                                            |
|              |                                                            |
| `(?&name)`   | Call subroutine by name.                                   |
| `(?P>name)`  |                                                            |
| `\g<name>`   |                                                            |
| `\g'name'`   |                                                            |
|              |                                                            |
| `(?(DEFINE)` | Predefine subroutine(s) that can be called by name from    |
|              | elsewhere; terminated by `)`.                              |
|              |                                                            |
|              | So far, when we defined our subroutines, we also matched   |
|              | something. For instance, `"(\w+)"` defines subroutine 1    |
|              | but also immediately matches some word characters. There's |
|              | the `"(?(DEFINE)"` syntax that allows you to predefine a   |
|              | named subroutine(s) without initially matching anything.   |
|              |                                                            |
|              | Predefined subroutines allow you to produce regexes that   |
|              | are beautifully modular and start to feel like clean       |
|              | procedural code. This makes your regex more maintainable,  |
|              | both because it is easier to understand and because you    |
|              | don't need to fix a sub-pattern in multiple places.        |
|              |                                                            |
|              | As with `(?(DEFINE)`, the idea is to place the definitions |
|              | in a section at the beginning of the regex — although you  |
|              | can put them anywhere before the subroutine is called. You |
|              | can even predefine subroutines based on other subroutines. |
|              | When you get to the matching part of the regex, this       |
|              | allows you to match complex expressions with compact and   |
|              | readable syntax — and to match the same kind of            |
|              | expressions in multiple places without needing to repeat   |
|              | your regex code.                                           |
|              |                                                            |
|              | `r"`                                                       |
|              | `(?(DEFINE)  # start DEFINE block`                         |
|              | `# pre-define quantifier subroutine`                       | 
|              | `(?<quant>many\|some\|five)`                               |
|              |                                                            |
|              | `# pre-define adj subroutine`                              |
|              | `(?<adj>blue\|large\|interesting)`                         |               
|              |                                                            |
|              | `# pre-define object subroutine`                           |
|              | `(?<object>cars\|elephants\|problems)`                     |             
|              |                                                            |
|              | `# pre-define noun_phrase subroutine`                      |
|              | `(?<noun_phrase>(?&quant)\ (?&adj)\ (?&object))`           |  
|              |                                                            |
|              | `# pre-define verb subroutine`                             |
|              | `(?<verb>borrow\|solve\|resemble)`                         |
|              | `)          # end DEFINE block`                            |
|              |                                                            |
|              | `##### The regex matching starts here #####`               |
|              | `(?&noun_phrase)\ (?&verb)\ (?&noun_phrase)`               |
|              | `"x`                                                       |
|              |                                                            |
|              | This regex would match phrases such as:                    |
|              | `"five blue elephants solve many interesting problems"`,   |
|              | `"many large problems resemble some interesting cars"`,    |
|              | etc.                                                       |

## Lookaround Assertions
An assertion is a test on the characters following or preceding the current matching point
that does not consume any characters. In other words, at the end of an assertion, the regex
engine hasn't moved on the string. The simple assertions coded as \b`, `\B`, `\A`, `\G`,
`\Z`, `\z`, `^`, and `$` are described above.

More complicated assertions are coded as parenthesized groups, and collectively they are
known as "lookarounds." There are two kinds: those that look ahead of the current position
in the subject string ("lookaheads"), and those that look behind it ("lookbehinds"). In each
case, an assertion may be positive (must match for the assertion to be true) or negative
(must not match for the assertion to be true). An assertion group is matched in the normal
way, and if it is true, matching continues after it, but with the matching position in the
subject string reset to what it was before the assertion was processed.

Lookaround assertions are atomic by default. If an assertion is true, but there is a
subsequent matching failure, there is no backtracking into the assertion. However, there are
some cases where non-atomic assertions can be useful, and there is support for these as
well.

Assertion groups are not capture groups. If an assertion contains capture groups within it,
these are counted for the purposes of numbering the capture groups in the whole pattern.
Within each branch of an assertion, locally captured substrings may be referenced in the
usual way. For example, a sequence such as `"(.)\g{-1}"` can be used to check that two
adjacent characters are the same. This can be useful in finding overlapping matches. For
instance, suppose that from a string such as `"ABCD"`, you want to extract `ABCD`, `BCD`,
`CD`, and `D`. You can do it with this single regex: `"(?=(\w+))"`, along with the
`eachmatch` function, and all the substrings will be captured to group 1.

How does this work? At the first position in the string (before the `A`), the engine starts
the first match attempt. The lookahead asserts that what immediately follows the current
position is one or more word characters, and captures these characters to Group 1. The
lookahead succeeds, and so does the match attempt. Since the pattern didn't match any actual
characters (the lookahead only looks), the engine returns a zero-width match
(the empty string). It also returns what was captured by group 1: `"ABCD"`.

The engine then moves to the next position in the string and starts the next match attempt.
Again, the lookahead asserts that what immediately follows that position is word characters,
and captures these characters to Group 1. The match succeeds, and group 1 contains `BCD`.
The engine moves to the next position in the string, and the process repeats itself for `CD`
then `D`.

When a branch within an assertion fails to match, any substrings that were captured are
discarded (as happens with any pattern branch that fails to match). A negative assertion is
true only when all its branches fail to match; this means that no captured substrings are
ever retained after a successful negative assertion. When an assertion contains a matching
branch, what happens depends on the type of assertion.

For a positive assertion, internally captured substrings in the successful branch are
retained, and matching continues with the next pattern item after the assertion. For a
negative assertion, a matching branch means that the assertion is not true. If such an
assertion is being used as a condition in a conditional group (see below), captured
substrings are retained, because matching continues with the "no" branch of the condition.
For other failing negative assertions, control passes to the previous backtracking point,
thus discarding any captured strings within the assertion.

Most assertion groups may be repeated; though it makes no sense to assert the same thing
several times, the side effect of capturing in positive assertions may occasionally be
useful. However, an assertion that forms the condition for a conditional group may not be
quantified. The only restriction is that an unlimited maximum repetition is changed to be
one more than the minimum. For example, `{3,}` is treated as `{3,4}`.

In some cases, the escape sequence `\K` can be used instead of a lookbehind assertion to get
round the fixed-length restriction. The implementation of lookbehind assertions is, for each
alternative, to temporarily move the current position back by the fixed length and then try
to match. If there are insufficient characters before the current position, the assertion
fails.

In UTF-8 and UTF-16 modes, PCRE2 does not allow the `\C` escape
(which matches a single code unit even in a UTF mode) to appear in lookbehind assertions,
because it makes it impossible to calculate the length of the lookbehind. The `\X` and `\R`
escapes, which can match different numbers of code units, are never permitted in
lookbehinds.

"Subroutine" calls such as `(?2)` or `(?&X)` are permitted in lookbehinds, as long as the
called capture group matches a fixed-length string. However, recursion, that is, a
"subroutine" call into a group that is already active, is not supported.

PCRE2 does support backreferences in lookbehinds, but only if certain conditions are met.
The `PCRE2_MATCH_UNSET_BACKREF` option must not be set, there must be no use of `(?|` in the
pattern (it creates duplicate group numbers), and if the backreference is by name, the name
must be unique. Of course, the referenced group must itself match a fixed length substring.
The following pattern matches words containing at least two characters that begin and end
with the same character: `"\b(\w)\w++(?<=\1)"`.

Possessive quantifiers can be used in conjunction with lookbehind assertions to specify
efficient matching of fixed-length strings at the end of subject strings. Consider a simple
pattern such as `"abcd$"`, when applied to a long string that does not match. Because
matching proceeds from left to right, PCRE2 will look for each `"a"` in the subject and then
see if what follows matches the rest of the pattern. If the pattern is specified as
`"^.abcd$"`, the initial `"."` matches the entire string at first, but when this fails
(because there is no following `"a"`), it backtracks to match all but the last character,
then all but the last two characters, and so on. Once again, the search for `"a"` covers the
entire string, from right to left, so we are no better off. However, if the pattern is
written as `"^.+(?<=abcd)"`, there can be no backtracking for the `".+"` item because of the
possessive quantifier; it can match only the entire string. The subsequent lookbehind
assertion does a single test on the last four characters. If it fails, the match fails
immediately. For long strings, this approach makes a significant difference to the
processing time.

Several assertions (of any sort) may occur in succession, and the regex engine still won't
move on the string. For example, `"(?<=\d{3})(?<!999)foo"` matches `"foo"` preceded by three
digits that are not `"999"`. Notice that each of the assertions is applied independently at
the same point in the subject string. First, there is a check that the previous three
characters are all digits, and then there is a check that the same three characters are not
`"999"`. This pattern does not match `"foo"` preceded by six characters, the first of which
are digits and the last three of which are not `"999"`. For example, it doesn't match
`"123abcfoo"`. A pattern to do that is `"(?<=\d{3}...)(?<!999)foo"`. This time, the first
assertion looks at the preceding six characters, checking that the first three are digits,
and then the second assertion checks that the preceding three characters are not `"999"`.

Assertions can be nested in any combination. For example, `"(?<=(?<!foo)bar)baz"` matches an
occurrence of `"baz"` that is preceded by `"bar"`, which in turn is not preceded by `"foo"`,
while `"(?<=\d{3}(?!999)...)foo"` is another pattern that matches `"foo"` preceded by three
digits and any three characters that are not `"999"`. Generally, if you must check for `n`
conditions, your pattern only needs to include `n-1` lookaheads at the most, as one
condition can be removed and used in the matching section of the pattern. But if all you
want to do is validate, all the conditions can stay inside lookarounds, giving you a
zero-width match (i.e., an empty string). We can rearrange lookaheads in any order without
affecting the overall logic. While the order of lookaheads doesn't matter on a logical
level, keep in mind that it may affect matching speed. If one lookahead is more likely to
fail than the other two, it makes little sense to place it in the third position and expend
a lot of energy checking the first two conditions. Make it first, so that if we're going to
fail, we fail early.

Lookahead and lookbehind don't mean "look way ahead into the distance." They mean "look at
the text immediately to the left or to the right." If you want to inspect a piece of string
further down, you will need to insert "binoculars" inside the lookahead to get you to the
part of the string you want to inspect — for instance, a `.*`, `.*?`, or, ideally, more
specific tokens. For example, many assume that the lookahead says that "there is a 5
somewhere to the right," so the pattern `"A(?=5)"` should match the `A` in the string
`"AB25"`. But that is not so. After the engine matches the `A`, the lookahead `(?=5)`
asserts that at the current position in the string, what immediately follows is a `5`. If
you want to check if there is a `5` somewhere (anywhere) to the right, you can use
`"(?=[^5]*5)"`.

Moreover, don't expect the pattern `"A(?=5)(?=[A-Z])"` to match the `A` in the string
`"A5B"`. Many beginners assume that the second lookahead looks to the right of the first
lookahead. It is not so. At the end of the first lookahead, the engine is still planted at
the very same spot in the string, after the `A`. When the lookahead `"(?=[A-Z])"` tries to
assert that what immediately follows the current position is an uppercase letter, it fails
because the next character is still the `5`. If you want to check that the `5` is followed
by an uppercase letter, just state it in the first lookahead: `"(?=5[A-Z])"`, or use the
redundant syntax: `"A(?=5(?=[A-Z]))`".

The traditional lookaround assertions are atomic, meaning that if an assertion is true but
there is a subsequent matching failure, there is no backtracking into the assertion.
However, there are some cases where non-atomic positive assertions can be useful, and PCRE2
provides these.

Consider the problem of finding the rightmost word in a string that also appears earlier in
the string, which means it must appear at least twice in total. This pattern returns the
required result as the captured substring 1: `"^(*napla:.*\b(\w++))(?>.*?\b\1\b){2}"`.

For a subject such as `"word1 word2 word3 word2 word3 word4"`, the result is `"word3"`. How
does it work? At the start, the `^` anchor the pattern. Inside the assertion, the greedy
`.*` at first consumes the entire string, but then has to backtrack until the rest of the
assertion can match a word, which is captured by group 1. In other words, when the assertion
first succeeds, it captures the rightmost word in the string.

The current matching point is then reset to the start of the subject, and the rest of the
pattern match checks for two occurrences of the captured word, using an ungreedy `.*?` to
scan from the left. If this succeeds, we are done, but if the last word in the string does
not occur twice, this part of the pattern fails. If a traditional atomic lookahead `(?=` or
`(*pla:)` had been used, the assertion could not be re-entered, and the whole match would
fail. The pattern would succeed only if the very last word in the subject was found twice.

Using a non-atomic lookahead, however, means that when the last word does not occur twice in
the string, the lookahead can backtrack and find the second-last word, and so on, until
either the match succeeds or all words have been tested.

Two conditions must be met for a non-atomic assertion to be useful: the contents of one or
more capturing groups must change after a backtrack into the assertion, and there must be a
backreference to a changed group later in the pattern. If this is not the case, the rest of
the pattern match fails exactly as before because nothing has changed, so using a non-atomic
assertion just wastes resources.

There is one exception to backtracking into a non-atomic assertion. If an `(*ACCEPT)`
control verb is triggered, the assertion succeeds atomically. That is, a subsequent match
failure cannot backtrack into the assertion. Note that assertions that appear as conditions
for conditional groups must be atomic.

| Character                           | Interpretation                      |
|:------------------------------------|:------------------------------------|
| `(?=`                               | Atomic positive lookahead,          |
| `(*pla:`                            | terminated by `)`.                  |
| `(*positive_lookahead:`             |                                     |
|                                     |                                     |
| `(?*`                               | Non-Atomic positive lookahead,      |
| `(*napla:`                          | terminated by `)`.                  |
| `(*non_atomic_positive_lookahead:`  |                                     |
|                                     |                                     |
| `(?!`                               | Atomic negative lookahead,          |
| `(*nla:`                            | terminated by `)`.                  |
| `(*negative_lookahead:`             |                                     |
|                                     |                                     |
| `(?<=`                              | Atomic positive lookbehind,         | 
| `(*plb:`                            | terminated by `)`.                  |
| `(*positive_lookbehind:`            |                                     |
|                                     |                                     |
| `(?<*`                              | Non-Atomic positive lookbehind,     |
| `(*naplb:`                          | terminated by `)`.                  |
| `(*non_atomic_positive_lookbehind:` |                                     |
|                                     |                                     |
| `(?<!`                              | Atomic negative lookbehind,         |
| `(*nlb:`                            | terminated by `)`.                  |
| `(*negative_lookbehind:`            |                                     |

## Conditional Groups
A special construct, `(?(if condition)then|else)`, allows you to create conditional regexes,
where the else part (along with |) is optional. There are five kinds of conditions:
references to capture groups, references to recursion, two pseudo-conditions called `DEFINE`
and `VERSION`, and assertions.

The first three conditions (references to capture groups, references to recursion, and
assertions) are used to check whether a certain pattern has been matched before or not. For
example, the condition `(?(1)then|else)` checks if the first capture group has been matched.
If it has, it will try to match the `then` part, otherwise, it will try to match the `else`
part. The `DEFINE` and `VERSION` conditions are used to define and check the version of the
regex engine being used. The `DEFINE` condition allows you to define a named subroutine with
a specific pattern, and the VERSION condition allows you to check the version of the regex
engine being used. This allows you to create regexes that are compatible with multiple
versions of the engine.

| Character            | Interpretation                                     |
|:---------------------|:---------------------------------------------------|
| `(?(n)`              | Absolute reference condition, terminated by `)`.   |
|                      |                                                    |
|                      | If the text between the parentheses consists of a  |
|                      | sequence of digits, the condition is true if a     |
|                      | capture group of that number has previously        |
|                      | matched. If there is more than one capture group   |
|                      | with the same number (i.e duplicate group          |
|                      | numbers), the condition is true if any of them     |
|                      | have matched.                                      |
|                      |                                                    |
|                      | Consider the following pattern, which contains     |
|                      | non-significant white space to make it more        |
|                      | readable (assume the EXTENDED flag (`x`) is        |
|                      | raised): `( \( )?    [^()]+    (?(1) \) )`.        |
|                      | The first part matches an optional opening         |
|                      | parenthesis, and if that character is present,     |
|                      | sets it as the first captured substring. The       |
|                      | second part matches one or more characters that    |
|                      | are not parentheses. The third part is a           |
|                      | conditional group that tests whether or not the    |
|                      | first capture group matched. If it did, that is,   |
|                      | if subject started with an opening parenthesis,    |
|                      | the condition is true, and so the yes-pattern is   |
|                      | executed and a closing parenthesis is required.    |
|                      | Otherwise, since no-pattern is not present, the    |
|                      | conditional group matches nothing. In other words, |
|                      | this pattern matches a sequence of                 |
|                      | non-parentheses, optionally enclosed in            |
|                      | parentheses.                                       |
|                      |                                                    |
| `(?(+n)`             | Relative reference condition, terminated by `)`.   |
| `(?(-n)`             |                                                    |
|                      | An alternative notation is to precede the digits   |
|                      | with a plus or minus sign. In this case, the group |
|                      | number is relative rather than absolute. The most  |
|                      | recently opened capture group can be referenced by |
|                      | `(?(-1)`, the next most recent by `(?(-2)`, and so |
|                      | on. Inside loops it can also make sense to refer   |
|                      | to subsequent groups. The next capture group can   |
|                      | be referenced as `(?(+1)`, and so on. The value    |
|                      | zero in any of these forms is not used; it         |
|                      | provokes a compile-time error.                     |
|                      |                                                    |
|                      | If you were embedding this pattern in a larger     |
|                      | one, you could use a relative reference:           |
|                      | `... ( \( )?  [^()]+  (?(-1) \) ) ...`.            |
|                      | This makes the fragment independent of the         |
|                      | parentheses in the larger pattern.                 |
|                      |                                                    |
| `(?(<name>)`         | Named reference condition, terminated by `)`.      |
| `(?('name')`         |                                                    |
|                      | Rewriting the above example to test for a used     |
|                      | capture group by name gives this:                  |
|                      | `(?<OPEN>\()?[^()]+(?(<OPEN>)\))`.                 |
|                      |                                                    |
|                      | If the name used in a condition of this kind is a  |
|                      | duplicate, the test is applied to all groups of    |
|                      | the same name, and is true if any one of them has  |
|                      | matched.                                           |
|                      |                                                    |
| `(?(R)`              | Overall recursion condition, terminated by `)`.    |
|                      |                                                    |
|                      | "Recursion" in this sense refers to any subroutine |
|                      | - like call from one part of the pattern to        |
|                      | another, whether or not it is actually recursive.  |
|                      |                                                    |
|                      | If a condition is the string `(R)`, and there is   |
|                      | no capture group with the name `R`, the condition  |
|                      | is true if matching is currently in a recursion or |
|                      | subroutine call to the whole pattern or any        |
|                      | capture group.                                     |
|                      |                                                    |
| `(?(Rn)`             | Specific numbered group recursion condition,       |
|                      | terminated by `)`.                                 |
|                      |                                                    |
|                      | If digits follow the letter `R`, and there is no   |
|                      | group with that name, the condition is true if the |
|                      | most recent call is into a group with the given    |
|                      | number, which must exist somewhere in the overall  |
|                      | pattern. This is a contrived example that is       |
|                      | equivalent to `a+b`: `((?(R1)a+|(?1)b))`.          |
|                      |                                                    |
|                      | However, in both cases, if there is a capture      |
|                      | group with a matching name, the condition tests    |
|                      | for its being set, as described in the section     |
|                      | above, instead of testing for recursion. For       |
|                      | example, creating a group with the name R1 by      |
|                      | adding `(?<R1>)` to the above pattern completely   |
|                      | changes its meaning.                               |
|                      |                                                    |
| `(?(R&name)`         | Specific named group recursion condition,          |
|                      | terminated by `)`.                                 |
|                      |                                                    |
|                      | If a name preceded by ampersand follows the letter |
|                      | `R`, for example: `(?(R&name)...)` the condition   |
|                      | is true if the most recent recursion is into a     |
|                      | group of that name (which must exist within the    |
|                      | pattern).                                          |
|                      |                                                    |
|                      | This condition does not check the entire recursion |
|                      | stack. It tests only the current level. If the     |
|                      | name used in a condition of this kind is a         |
|                      | duplicate, the test is applied to all groups of    |
|                      | the same name, and is true if any one of them is   |
|                      | the most recent recursion. At "top level", all     |
|                      | these recursion test conditions are false.         |
|                      |                                                    |
| `(?(DEFINE)`         | Define groups for reference, terminated by `)`.    |
|                      |                                                    |
|                      | If the condition is the string `(DEFINE)`, the     |
|                      | condition is always false, even if there is a      |
|                      | group with the name `DEFINE`. In this case, there  |
|                      | may be only one alternative in the rest of the     |
|                      | conditional group. It is always skipped if control |
|                      | reaches this point in the pattern; the idea of     |
|                      | `DEFINE` is that it can be used to define          |
|                      | subroutines that can be referenced from elsewhere. |
|                      |                                                    |
|                      | For example, a pattern to match an IPv4 address    |
|                      | such as `"192.168.23.245"` could be written like   |
|                      | this:                                              |
|                      | `(?(DEFINE)`                                       |
|                      | `(?<byte>2[0-4]\d|25[0-5]|1\d\d|[1-9]?\d)`         |
|                      | `)`                                                |
|                      | `\b(?&byte)(\.(?&byte)){3}\b`                      |
|                      |                                                    |
|                      | The first part of the pattern is a `DEFINE` group  |
|                      | inside which another group named `byte` is         |
|                      | defined. This matches an individual component of   |
|                      | an IPv4 address (a number less than 256). When     |
|                      | matching takes place, this part of the pattern is  |
|                      | skipped because `DEFINE` acts like a false         |
|                      | condition. The rest of the pattern uses references |
|                      | to the named group to match the four dot-separated |
|                      | components of an IPv4 address, insisting on a word |
|                      | boundary at each end.                              |
|                      |                                                    |
| `(?(VERSION[>]=n.m)` | Test PCRE2 version (where the fractional part of   |
|                      | the version number may not contain more than two   |
|                      | digits), terminated by `)`.                        |
|                      |                                                    |
|                      | A special "condition" called `VERSION` exists to   |
|                      | allow users to discover which version of PCRE2     |
|                      | they are dealing with by using this condition to   |
|                      | match a string such as `"yes"` or `"no"`.          |
|                      | `VERSION` must be followed either by `=` or ``>=`  |
|                      | and a version number. For example, the pattern:    |
|                      | `(?(VERSION>=10.4)yes|no)` matches `"yes"` if the  |
|                      | PCRE2 version is greater or equal to `10.4`, or    |
|                      | `"no"` otherwise.                                  |
|                      |                                                    |
| `(?(assert)`         | Traditional atomic lookaround assertion condition, |
|                      | terminated by `)`.                                 |
|                      |                                                    |
|                      | When an assertion that is a condition contains     |
|                      | capture groups, any capturing that occurs in a     |
|                      | matching branch is retained afterwards, for both   |
|                      | positive and negative assertions, because matching |
|                      | always continues after the assertion, whether it   |
|                      | succeeds or fails. This is in constrast with the   |
|                      | non-conditional assertions, for which captures are |
|                      | retained only for positive assertions that         |
|                      | succeed.                                           |

## Option Setting
n Julia, the settings of the CASELESS, MULTILINE, DOTALL, EXTENDED, and/or EXTENDED_MORE
flags can be raised by adding them after the pattern delimiter (e.g. `r"..."i`, `r"..."ix`)
or by using a sequence of letters enclosed between `(?` and `)` (e.g. `(?i)`, `(?x)`). These
options can also be combined (e.g., `(?im)`), unset using a hyphen (e.g. `(?-im)`), or
combined setting and unsetting such as `(?im-sx)`.

It is also possible to unset all options, except DUPNAMES and UNGREEDY, using a circumflex
(e.g., `(?^)` is equivalent to `(?-imnsx)`), and letters can be used to reinstate some
options, but a hyphen may not appear (e.g., `(?^in)`). The two "extended" options
(`x` and `xx`) are not independent, and unsetting either of them cancels the effects of
both.

The options changes affects the remainder of the pattern that follows it or that part of the
group that follows it (e.g., `"(a(?i)b)c"` matches `"abc"` and `"aBc"` and no other
strings). Any changes made in one alternative do carry on into subsequent branches within
the same group as the effects of option settings happen at compile time. For example, the
pattern `"(a(?i)b|c)"` matches `"ab"`, `"aB"`, `"c"`, and `"C"`, even though when matching
`"C"`, the first branch is abandoned before the option setting.

As a shorthand, if any option settings are required at the start of a non-capturing group,
the option letters may appear between the `?` and the `:`. Thus, the two patterns,
`"(?i:sat|sun)"` and `"(?:(?i)sat|sun)"`, match exactly the same set of strings.

| Character | Interpretation                                                |
|:----------|:--------------------------------------------------------------|
| `(?i)`    | CASELESS: allow case-insensitive matching.                    |
|           |                                                               |
| `(?m)`    | MULTILINE: treat string as multiple lines i.e. subsequent     |
|           | characters after a "newline" character is read as a new line. |
|           |                                                               |
| `(?n)`    | NO_AUTO_CAPTURE: treat all groups as non-capture groups.      |
|           |                                                               |
| `(?s)`    | DOTALL: treat string as single line i.e a "newline" character |
|           | is not regarded any special meaning.                          |
|           |                                                               |
| `(?x)`    | EXTENDED: ignore white space except those backslashed or in   |
|           | classes. When this mode is turned on, the `#` character is    |
|           | treated as a metacharacter introducing a comment, just as in  |
|           | ordinary code. To match the `#` character in this mode,       |
|           | escape it with a backslash i.e. `\#`.                         |
|           |                                                               |
| `(?xx)`   | EXTENDED_MORE: as `(?x)` but also ignore space and tab in     |
|           | classes.                                                      |
|           |                                                               |
| `(?J)`    | DUPNAMES: allow duplicate named groups.                       |
|           |                                                               |
| `(?U)`    | UNGREEDY: Default ungreedy (lazy).                            |
|           |                                                               |
| `(?-...)` | Unset option(s).                                              |
|           |                                                               |
| `(?^)`    | Unset `imnsx` options.                                        |

## Comment
It is possible to include comments in a pattern by using the inline comment syntax
`(?#comment)`, where the `comment` cannot be in the middle of any other sequence or in a
character class. The EXTENDED or EXTENDED_MORE mode can also be used to add comments to a
long regex (that should possibly span multiple lines to make it more readable).

| Character | Interpretation                                                |
|:----------|:--------------------------------------------------------------|
| `(?#`     | Comment (not nestable), terminated by `)`.                    |
|           |                                                               |
|           | For instance, in the pattern                                  |
|           | `(?#Year)\d{4}(?#Separator)-(?#Month)\d{2}-(?#Day)\d{2}`,     |
|           | `(?#Year)`, `(?#Separator)`, `(?#Month)` and `(?#Day)` tells  |
|           | us what the characters after the comments are trying to       |
|           | match in our pattern.                                         |
|           |                                                               |
|           | The sequence `(?#` marks the start of a comment that          |
|           | continues up to the next closing parenthesis. Nested          |
|           | parentheses are not permitted. If the EXTENDED or             |
|           | EXTENDED_MORE option is set, an unescaped `#` character also  |
|           | introduces a comment, which in this case continues to         |
|           | immediately after the next "newline" character or character   |
|           | sequence in the pattern. Note that the end of this type of    |
|           | comment is a literal newline sequence in the pattern; escape  |
|           | sequences that happen to represent a "newline" do not count.  |
|           | For example, consider this pattern when EXTENDED is set, and  |
|           | the default newline convention (a single linefeed character)  |
|           | is in force: `"abc #comment \n still comment"`.               |
|           | On encountering the `#` character, the engine skips along,    |
|           | looking for a "newline" in the pattern. The sequence `\n` is  |
|           | still literal at this stage, so it does not terminate the     |
|           | comment. Only an actual character with the code value `0x0a`  |
|           | (the default newline) does so.                                |
"""
function regexes()
    header1 = "General Types & Constructor"
    printstyled(header1, '\n', '≡'^(length(header1) + 2), '\n'; bold=true)
    println("""
    AbstractPattern    Regex    RegexMatch\n""")

    header2= "Macros"
    printstyled(header2, '\n', '≡'^(length(header2) + 2), '\n'; bold=true)
    println("""
    @isdefined    @r_str\n""")

    header3 = "Match Functions"
    printstyled(header3, '\n', '≡'^(length(header3) + 2), '\n'; bold=true)
    println("""
    count    eachmatch    findall    findfirst    findlast    findnext    match\n""")

    header4 = "General Functions"
    printstyled(header4, '\n', '≡'^(length(header4) + 2), '\n'; bold=true)
    println("""
    convert       getfield         replace        supertypes
    dump          getproperty      repr           swapfield!
    fieldcount    hash             sizeof         typeassert
    fieldindex    modifyfield!     string         typeintersect
    fieldname     methodswith      subtypes       typejoin
    fieldnames    nfields          summary        typeof
    fieldtype     objectid         summarysize    varinfo
    fieldtypes    propertynames    supertype\n""")

    header5 = "True/False Functions"
    printstyled(header5, '\n', '≡'^(length(header5) + 2), '\n'; bold=true)
    println("""
    applicable    hasproperty       isdefined          isstructtype
    contains      isa               isequal            occursin
    endswith      isabstracttype    ismutable          startswith
    hasmethod     isconcretetype    ismutabletype
    hasfield      isconst           isprimitivetype\n""")

    header6 = "Non-Alphanumeric Operators"
    printstyled(header6, '\n', '≡'^(length(header6) + 2), '\n'; bold=true)
    println("""
    ^    *\n""")
end

#=
TO DO
## Script Run
## Callouts
## Backtracking Control
=#