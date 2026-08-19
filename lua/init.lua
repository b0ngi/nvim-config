-- disable vim modelines
vim.o.modeline = false
-- treesitter
require('nvim-treesitter').setup({
    ensure_installed = {
        'rust',
        'wgsl',
        'bash',
        'c',
        'lua',
        'vim',
        'markdown',
        'python',
    },
    sync_install = true,
    auto_install = true,
    indent = {
        enable = true,
    },
    highlight = {
        enable = true,
    },
})
require('nvim-treesitter').install {
    'rust',
    'wgsl',
    'bash',
    'c',
    'lua',
    'vim',
    'markdown',
    'python',
}
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'wgsl', 'py', 'rs' },
  callback = function() vim.treesitter.start() end,
})

-- set completion behaviour
vim.cmd[[set completeopt+=menuone,noselect,popup]]


require("colorful-winsep").setup()

-- disable hover highlight
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'LspReferenceTarget', {})
  end,
})


-- lsp default on attach function
local global_on_attach = function(client, bufnr)
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr })
    end
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
      end,
    })
    vim.diagnostic.config({ virtual_text = true })
    vim.api.nvim_create_autocmd({ 'InsertCharPre' }, {
        callback = function()
            vim.lsp.completion.get()
        end,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI'}, {
        callback = function()
            vim.lsp.buf.clear_references()
            -- -- wgsl does not support this
            -- vim.lsp.buf.document_highlight()
        end,
    })
end

-- enable language servers
for _, server_name in ipairs({
    'rust_analyzer',
    'wgsl_analyzer',
    'clangd',
    'pyright',
    'tinymist',
    'lua_ls',
}) do
  local existing_on_attach = (vim.lsp.config[server_name] or {}).on_attach
  vim.lsp.config(server_name, {
    on_attach = function(...)
      if existing_on_attach then existing_on_attach(...) end
      global_on_attach(...)
    end
  })
  vim.lsp.enable(server_name)
end

-- telescope
local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--no-ignore-vcs")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.svn/*")

telescope.setup({
    defaults = {
        -- `hidden = true` is not supported in text grep commands.
        vimgrep_arguments = vimgrep_arguments,
    },
    pickers = {
        find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--no-ignore-vcs", "--glob", "!**/.git/*", "--glob", "!**/.svn/*" },
        },
    }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', 'Ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', 'Fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', 'Fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', 'Fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', 'Fd', builtin.diagnostics, { desc = 'Telescope lsp show diagnostics' })
vim.keymap.set('n', 'Fld', builtin.lsp_definitions, { desc = 'Telescope lsp go to definitions' })
vim.keymap.set('n', 'Flt', builtin.lsp_type_definitions, { desc = 'Telescope lsp go to type definition' })
vim.keymap.set('n', 'Flr', builtin.lsp_references, { desc = 'Telescope lsp show references' })
vim.keymap.set('n', 'Fli', builtin.lsp_implementations, { desc = 'Telescope lsp show implementations' })


-- auto session
require("auto-session").setup({})

-- borders
vim.o.winborder = 'rounded'


-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- resize vim panes better
vim.keymap.set('n', '<c-a-j>', ':horizontal resize +5<cr>')
vim.keymap.set('n', '<c-a-k>', ':horizontal resize -5<cr>')
vim.keymap.set('n', '<c-a-h>', ':vertical resize -5<cr>')
vim.keymap.set('n', '<c-a-l>', ':vertical resize +5<cr>')

local autocmd = vim.api.nvim_create_autocmd


autocmd("VimLeavePre", {
  command = ":Neotree close",
})

-- debugger
local dap = require("dap")
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}
dap.configurations.cpp = dap.configurations.c


dap.adapters["rust-gdb"] = {
  type = "executable",
  command = "rust-gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
dap.configurations.rust = {
  {
    name = "Launch",
    type = "rust-gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "rust-gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = "${workspaceFolder}"
  },
  {
    name = "Attach to gdbserver :1234",
    type = "rust-gdb",
    request = "attach",
    target = "localhost:1234",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}


require("nvim-dap-virtual-text").setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
    all_references = true,                -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, buf, stackframe, node, options)
    -- by default, strip out new line characters
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value:gsub("%s+", " ")
      else
        return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
      end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos =  'eol',

    -- experimental features:
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

require("dapui").setup()



if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono Nerd Font:h11"
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00
end


require("neotest").setup({
    adapters = {
        require("rustaceanvim.neotest"),
    },
    diagnostic = {
        enabled = false,
    },
    status = {
        enabled = true,
        virtual_text = true,
    },
    output = {
        open_on_run = true,
    },
})

local neotest = require("neotest")
vim.keymap.set('n', 'tt', function() neotest.run.run() end, { desc = 'test nearest' })
vim.keymap.set('n', 'tl', function() neotest.run.run_last() end, { desc = 'test last' })
vim.keymap.set('n', 'tf', function() neotest.run.run(vim.fn.expand("%")) end, { desc = 'test file' })
vim.keymap.set('n', 'td', function() neotest.run.run({strategy = "dap"}) end, { desc = 'debug test' })
vim.keymap.set('n', 'ta', function() neotest.run.attach() end, { desc = 'attach test' })
vim.keymap.set('n', 'to', function() neotest.output.open({enter = true, short = true}) end, { desc = 'open test output' })
vim.keymap.set('n', 'tp', function() neotest.output_panel.open({enter = true}) end, { desc = 'open test output panel' })
vim.keymap.set('n', 'tk', function() neotest.run.stop() end, { desc = 'stop nearest test' })
vim.keymap.set('n', 'ts', function() neotest.summary.toggle() end, { desc = 'test summary toggle' })


