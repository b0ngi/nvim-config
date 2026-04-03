return {
    settings = {
        ['clangd'] = {
            diagnostics = {
                enable = false;
            },
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
            add_return_type = {
                enable = true
            },
            inlayHints = {
                enable = true,
                showParameterNames = true,
                parameterHintsPrefix = "<- ",
                otherHintsPrefix = "=> ",
            },
        }
    },
    inlay_hint = true,
}
