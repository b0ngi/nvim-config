-- treesitter
require('nvim-treesitter').setup {
    indent = true,
}

-- set completion behaviour
vim.cmd[[set completeopt+=menuone,noselect,popup]]


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
            vim.lsp.buf.document_highlight()
        end,
    })
end


-- enable language servers
for _, server_name in ipairs({
    'rust_analyzer',
    'clangd',
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
require('telescope').setup()
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
