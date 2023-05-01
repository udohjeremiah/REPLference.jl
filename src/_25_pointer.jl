function pointers(; extmod = false)
    constants = ["Constants" => ["C_NULL"]]
    macros = ["Macros" => [@cfunction, "@assert", "@doc", "@show", "@showtime"]]
    methods = [
        "Methods" => [
            "backtrace",
            "cglobal",
            "pointer",
            "pointer_from_objref",
            "securezero!ˣ",
            "signed",
            "stacktrace",
            "unsafe_convertˣ",
            "unsafe_copyto!",
            "unsafe_load",
            "unsafe_pointer_to_objref",
            "unsafe_store!",
            "unsafe_wrap",
        ],
    ]
    types = ["Types" => ["Cptrdiff_t", "LLVMPtrˣ", "Ptr"]]
    _print_names(constants, macros, methods, types)
end
