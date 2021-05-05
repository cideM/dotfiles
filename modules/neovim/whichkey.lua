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
    operators = {
        ["<leader>sa"] = "add surrounds",
        ["<leader>sd"] = "delete surrounds",
        ["<leader>sr"] = "replace surrounds",
    },
}

wk.register({
    ["<leader>s"] = {
        a = {"<Plug>(operator-sandwich-add)", "add"},
        d = {"<Plug>(operator-sandwich-delete)", "delete"},
        r = {"<Plug>(operator-sandwich-replace)", "replace"},
    }
}, { mode = "x"})

wk.register({
    ["<leader>F"] = {
        name = "+Formatting",
        c = {":<C-u>call ReflowComment(visualmode())<cr>", "reflow comment"},
    }},
    {mode = "v"}
)

wk.register({
    ["<leader>f"] = {
        o = {"<Plug>(GrepperOperator)", "operator"},
    }},{mode="x"}
)

wk.register {
    ["<leader>F"] = {
        name = "+Formatting",
        c = {":set operatorfunc=ReflowComment<cr>g@", "reflow comment"},
    },
    ["<leader>g"] = {
        name = "+Git",
        m = {"open Git messenger"},
        s = {":G<cr>", "status"},
        l = {":G log -p<cr>", "log with -p"},
        b = {":G blame<cr>", "blame"},
        e = {":Gedit ", "edit", silent=false},
        E = {":Gvsplit master:%<cr>", "edit on master"},
        d = {
            name = "+DiffView",
            o = {":DiffViewOpen ", "open diff view, can pass arguments", silent = false},
            f = {":DiffviewFocusFiles<cr>", "focus and open file panel"},
            c = {":DiffviewClose<cr>", "close file panel"},
        },
        h = {
            name = "+Hunk",
            n = {"<cmd>lua require'gitsigns'.next_hunk()<CR>", "next hunk"},
            p = {"<cmd>lua require'gitsigns'.prev_hunk()<CR>", "prev hunk"},
            s = {"<cmd>lua require'gitsigns'.stage_hunk()<CR>", "stage"},
            u = {"<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>", "undo stage"},
            r = {"<cmd>lua require'gitsigns'.reset_hunk()<CR>", "reset"},
            o = {"<cmd>lua require'gitsigns'.preview_hunk()<CR>", "preview"},
            b = {"<cmd>lua require'gitsigns'.blame_line()<CR>", "blame"},
        },
        f = {
            name = "+Flog",
            o = {":Flog<cr>", "open"},
            O = {":Flog ", "open with args", silent=false},
        }
    },
    ["<leader>s"] = {
        name = "+Sandwich",
        d = {"<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", "delete"},
        r = {"<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", "replace"},
        D = {"<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", "delete auto"},
        R = {"<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", "replace auto"},
    },
    ["<leader>f"] = {
        name = "+Find",
        g = {":GreppgerRg ", "string", silent=false},
        i = {":GrepperGit ", "string in Git files", silent=false},
        f = {"<cmd>Files<cr>", "file"},
        l = {"<cmd>Lines<cr>", "line"},
        L = {"<cmd>BLines<cr>", "line in buffer"},
        c = {"<cmd>Commits<cr>", "commit"},
        b = {"<cmd>Buffers<cr>", "buffer"},
        o = {"<Plug>(GrepperOperator)", "operator"},
        F = {"<cmd>GFiles<cr>", "file among Git files"},
        m = {"<cmd>Marks<cr>", "mark"},
        t = {"<cmd>Tags<cr>", "tag"},
    },
    ["<localleader>l"] = {
        name = "+LSP",
        k = {"<cmd>lua vim.lsp.buf.hover()<cr>", "show documentation"},
        i = {"<cmd>lua vim.lsp.buf.signature_help()<cr>", "show signature"},
        e = {"<cmd>lua vim.lsp.buf.rename()<cr>", "rename"},
        r = {"<cmd>lua vim.lsp.buf.references()<cr>", "show references"},
        h = {"<cmd>lua vim.lsp.buf.implementation()<cr>", "go to implementation"},
        j = {"<cmd>lua vim.lsp.buf.definition()<cr>", "go to definition"},
        k = {"<cmd>lua vim.lsp.buf.type_definition()<cr>", "go to type definition"},
        l = {"<cmd>lua vim.lsp.buf.declaration()<cr>", "go to type declaration"},
        d = {"<cmd>lua vim.lsp.buf.show_line_diagnostics({ border = 'single' })<cr>", "show line diagnostics"},
        w = {"<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", "workspace symbol"},
        u = {"<cmd>lua vim.lsp.buf.document_symbol()<cr>", "document symbol"},
        R = {"<cmd>lua vim.lsp.buf.server_ready()<cr>", "server ready?"},
        p = {"<cmd>lua vim.lsp.buf.document_highlight()<cr>", "highlight stuff...?"},
        n = {"<cmd>lua vim.lsp.buf.diagnostic.diagnostic.goto_next({ popup_opts = { border = 'single' }})<cr>", "next diagnostic"},
        b = {"<cmd>lua vim.lsp.buf.diagnostic.diagnostic.goto_prev({ popup_opts = { border = 'single' }})<cr>", "prev diagnostic"},
        L = {"<cmd>lua vim.lsp.buf.diagnostic.set_loclist()<cr>", "populate location list"},
    }
}
