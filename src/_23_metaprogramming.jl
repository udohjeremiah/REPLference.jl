@doc raw"""
# METAPROGRAMMING
Metaprogramming is a widely used technique in software engineering, but it can be difficult
to comprehend due to the multiple interpretations associated with the term and the varying
viewpoints from which it can be approached. As a result, the term "metaprogramming" is
frequently used to describe different but interconnected software engineering concepts.
Therefore, to fully comprehend the term and its contents, it is essential to approach it
systematically and incrementally, starting with the fundamentals and progressively building
on them.

## What is metaprogramming?
Metaprogramming is a higher-order programming technique that involves writing computer
programs, known as "metaprograms," in a programming language called a "metalanguage."

It is considered a higher-order technique because it involves programming at a higher level
of abstraction, where the code is written to manipulate or generate other code.

## What are metaprograms?
Metaprograms are higher-level computer programs that treat their inputs, which are usually
computer programs, as data. This enables them to analyze and transform such programs and
even generate new ones. As such, the statement "one man's program is another program's data"
holds true for metaprograms.

On the other hand, regular computer programs developed from conventional programming are
typically designed to work with data. However, the data they take in as input are not
programs but rather numbers, characters, strings, data structures, or user-defined types.
These programs produce output that can be used by other programs or users.

Metaprograms are different because they focus on working with computer programs themselves
rather than just data. They take computer programs as input and produce new programs or
modified versions of existing ones as output.

As mentioned above, programs that can:

- Examine other programs are metaprograms. Examples include profilers, debuggers, code
  linters, code coverage tools, static analysis tools, test frameworks, theorem provers,
  etc.

- Change one form of a program into another are metaprograms. Examples include assemblers,
  compilers, linkers, loaders, interpreters, transpilers, lexers, parsers, etc.

- Write and generate new programs are metaprograms. Examples include macros, code
  generators, compiler generators, term rewriters, etc.

- Transform a specific domain component into a generic component that is more widely usable
  and reusable than the original one are metaprograms. Examples include generic templates
  (e.g., C++'s STL), domain-specific templates (DSTs) (e.g., Java's JUnit), domain-specific
  languages (DSLs) (e.g., LaTeX), embedded domain-specific languages (EDSLs)
  (e.g., JavaScript's jQuery), etc.

## What is a metalanguage?
Metalanguages, in general, are languages or symbolic systems used to discuss, describe,
analyze, and manipulate other languages or symbolic systems.

In relation to metaprogramming, a metalanguage is simply the language used to write a
metaprogram. The program that a metaprogram analyzes and manipulates is called the
"target-program" or "object-program", and the language of the target-program or
object-program is called the "target-language" or "object-language". However, the
metalanguage and object-language can both be the same i.e., the object-language supports
metaprogramming. Such an ability for a programming language to be a metalanguage and an
object language at the same time is called "homoiconicity", because it treats its own code
as data.

## Classification of metaprogramming

- **Language** : This asks the question, "Which language is the metaprogram written in?"
    - Homogeneous metaprogramming: The metalanguage and object-language are the same.
    - Heterogeneous metaprogramming: The metalanguage and object-language are different.

- **Goal**: This asks the question, "What does the metaprogram do?"
    - Analysis: The metaprogram only examines the object-program to draw conclusions from
      it.
    - Transformation: The metaprogram transforms the object-program from one form to
      another.
    - Generation: The metaprogram generates a new object-program.
    - Reflection: The metaprogram observes and modifies itself.
    - Generalization: The metaprogram creates generic software templates that can be
      automatically instantiated to produce new software components.

- **Representation**: This asks the question, "How are object-programs represented?"
    - Textually (as strings)
    - Lexically (as tokens)
    - Structurally (as ASTs)
    - Semantically (using various structures)

- **Execution**: This asks the question, "When is the metaprogram executed?"
    - Compile-time metaprogramming (static): The metaprogram is executed during the
      compilation process, before the program is run.
    - Run-time metaprogramming (dynamic): The metaprogram is executed during program
      execution, which allows for the modification or creation of programs at runtime.

# What are some benefits of metaprogramming?

- Code reuse: Metaprogramming can be used to generate code or modify existing code, enabling
  developers to reuse code across different parts of an application or across different
  applications.

- Increased productivity: Metaprogramming can automate repetitive tasks, such as recurring
  code patterns, and reduce the amount of manual coding required, thus increasing developer
  productivity.

- Flexibility: Metaprogramming enables programs to modify other programs or their own
  behavior or structure at runtime, making them more adaptable and flexible to efficiently
  handle changing requirements without recompilation.

- Code optimization: Metaprogramming can be used to optimize code by generating more
  efficient or specialized code for specific use cases.

- Performance optimization: Metaprogramming can be used to generate specialized code that is
  optimized for specific hardware architectures or performance requirements, improving the
  overall performance of the application.

- Domain-specific languages: Metaprogramming can be used to create domain-specific languages
  (DSLs) that are tailored to specific problem domains, making it easier to express
  solutions to complex problems.

- Improved code quality: Metaprogramming can enable developers to write more concise,
  expressive, and maintainable code by automating repetitive tasks, reducing code
  duplication, and enforcing consistent coding standards.

!!! warning
    Metaprogramming is a very powerful software engineering method that requires a
    systematic application to use properly, rather than to resort to its use at every
    opportunity. Ad hoc application of metaprogramming tends to make programs harder to
    read, understand, validate, and maintain. It's considered bad style to use
    metaprogramming when they're not necessary. Therefore, every metaprogram in a program
    should be used because it has to be, and not for ad hoc reasons, as this tends to make
    programs harder to read, understand, validate, and maintain.

## Metaprogramming in Julia
"""
function metaprogramming(; extmod=false)
    macros = [
        "Macros" => [
            "@MIME_str",
            "@NamedTuple",
            "@__DIR__",
            "@__FILE__",
            "@__LINE__",
            "@__MODULE__",
            "@__doc__ˣ",
            "@__dot__",
            "@_inline_metaˣ",
            "@_noinline_metaˣ",
            "@allocated",
            "@allocations",
            "@assert",
            "@assume_effectsˣ",
            "@async",
            "@atomic",
            "@atomicreplace",
            "@atomicswap",
            "@b_str",
            "@big_str",
            "@boundscheck",
            "@ccall",
            "@cfunction",
            "@code_llvm",
            "@code_lowered",
            "@code_native",
            "@code_typed",
            "@code_warntype",
            "@cmd",
            "@coalesce",
            "@constpropˣ",
            "@debug",
            "@deprecate",
            "@doc",
            "@elapsed",
            "@edit",
            "@enum",
            "@eval",
            "@evalpoly",
            "@fastmath",
            "@gensym",
            "@goto",
            "@html_str",
            "@inbounds",
            "@info",
            "@int128_str",
            "@invoke",
            "@invokelatest",
            "@irrationalˣ",
            "@isdefined",
            "@kwdef",
            "@label",
            "@lazy_str",
            "@less",
            "@localsˣ",
            "@lock",
            "@lock_nofailˣ",
            "@macroexpand",
            "@macroexpand1",
            "@noinline",
            "@nospecialize",
            "@polly",
            "@propagate_inboundsˣ",
            "@pureˣ",
            "@r_str",
            "@raw_str",
            "@s_str",
            "@show",
            "@showtime",
            "@simd",
            "@something",
            "@specialize",
            "@static",
            "@sync",
            "@task",
            "@text_str",
            "@time",
            "@timed",
            "@timev",
            "@uint128_str",
            "@v_str",
            "@view",
            "@views",
            "@warn",
            "@which",
            "Meta.@dump",
            "Meta.@lowerˣ",
        ],
    ]
    methods = [
        "Methods" => [
            "True/False" => [
                "is_exprˣ",
                "isbinaryoperatorˣ",
                "isexprˣ",
                "isidentifierˣ",
                "isoperatorˣ",
                "ispostfixoperatorˣ",
                "isunaryoperatorˣ",
                "print",
                "println",
                "recursive_dotcalls!ˣ",
                "replace_ref_begin_end!ˣ",
                "repr",
                "show",
            ],
            "Others" => [
                "Meta.lowerˣ",
                "Meta.parseˣ",
                "Meta.partially_inline!ˣ",
                "Meta.quot",
                "Meta.replace_sourceloc!",
                "Meta.show_sexpr",
                "ccall_macro_parseˣ",
                "esc",
                "eval",
                "gensym",
                "macroexpand",
            ],
        ],
    ]
    types = ["Types" => ["DataType", "Expr", "Meta.ParseErrorˣ", "QuoteNode", "Symbol"]]
    operators = ["Operators" => [":"]]
    stdlib => ["Stdlib" => ["Printf.@printf", "Printf.@sprintf"]]
    _print_names(macros, methods, types, operators)
    if extmod == true
        _print_names(stdlib)
    end
end
