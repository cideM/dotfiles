wk = require("which-key")

wk.setup {
    plugins = {
        marks = true,
        registers = true,
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
        },
    },
}

wk.register {
    ["<leader>g"] = {
        name = "+search",
        w = {"<cmd>Grepper -tool rg -open -switch -cword -noprompt<cr>", "Search word under cursor"},
        g = {"<cmd>GreppgerRg<space>", "Search for something"},
        i = {":GrepperGit", "Search for something in Git files"},
    }
}
