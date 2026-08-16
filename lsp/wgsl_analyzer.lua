
---@brief
---
--- https://github.com/wgsl-analyzer/wgsl-analyzer
---
--- `wgsl-analyzer` can be installed via `cargo`:
--- ```sh
--- cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl-analyzer
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'wgsl-analyzer' },
  filetypes = { 'wgsl' },
  root_markers = { '.git' },
  settings = {
      diagnostics = {
          enable = false,
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
      inlay_hint = true,
  },
}
