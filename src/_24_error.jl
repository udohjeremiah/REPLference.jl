"""
"""
function errors(; extmod=false)
    constants = ["Constants" => ["stderr"]]
    macros = ["Macros" => ["@debug", "@error", "@info", "@warn"]]
    methods = [
        "Methods" => [
            "capture_exceptionˣ",
            "catch_backtrace",
            "current_exceptions",
            "error",
            "errormonitor",
            "identity",
            "redirect_stderr",
            "redirect_stdio",
            "rethrow",
            "retry",
            "showerror",
            "stacktrace",
            "systemerror",
            "throw",
            "windowserrorˣ",
        ],
    ]
    types = [
        "Types" => [
            "ArgumentError",
            "AssertionError",
            "BoundsError",
            "CompositeException",
            "DimensionMismatch",
            "DivideError",
            "DomainError",
            "EOFError",
            "ErrorException",
            "InexactError",
            "InitError",
            "InterruptException",
            "KeyError",
            "LoadError",
            "MethodError",
            "MissingException",
            "OutOfMemoryError",
            "OverflowError",
            "ProcessFailedException",
            "ReadOnlyMemoryError",
            "StackOverflowError",
            "StringIndexError",
            "SystemError",
            "TaskFailedException",
            "TypeError",
            "UndefKeywordError",
            "UndefRefError",
            "UndefVarError",
            "WrappedExceptionˣ",
        ],
    ]
    return _print_names(constants, macros, methods, types)
end
