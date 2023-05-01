"""
"""
function systems(; extmod = false)
    constants = ["ARGS", "DL_LOAD_PATHˣ", "ENV", "PROGRAM_FILE", "VERSION", "devnull"]
    macros = ["Macros" => ["@cmd", "@show", "@showtime"]]
    methods = [
        "Methods" => [
            "True/False" => ["isa", "isdebugbuildˣ", "isinteractive"],
            "Others" => [
                "addenv",
                "clipboard",
                "compilerbarrierˣ",
                "define_editorˣ",
                "donotdeleteˣ",
                "escape_microsoft_c_argsˣ",
                "editorˣ",
                "exit",
                "exit_on_sigintˣ",
                "gc_live_bytesˣ",
                "gethostname",
                "jit_total_bytesˣ",
                "julia_cmdˣ",
                "peakflops",
                "popdisplay",
                "print",
                "println",
                "printstyled",
                "retry_load_extensionsˣ",
                "run",
                "runtestsˣ",
                "setcpuaffinity",
                "setenv",
                "shell_escape_cshˣ",
                "shell_escape_posixlyˣ",
                "shell_escape_wincmdˣ",
                "shell_escapeˣ",
                "sleep",
                "success",
                "systemerror",
                "time",
                "time_ns",
                "timedwait",
            ],
        ],
    ]
    types = ["Types" => ["Cmd", "LibuvServerˣ", "RawFD"]]
    _print_names(constants, macros, methods, types)
end
