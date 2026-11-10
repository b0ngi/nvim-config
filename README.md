# nvim config

## Entry Point

the current entry point of the nvim configuration is currently `./init.vim`.
After the this, `./lua/init.lua` is loaded, which includes
the new-style lua configurations.

### init.vim

the `init vim` contains basic vim configurations like `set`s, syntax enable,
input mappings and plugins to install. 
further configurations should be included in `./lua/init.lua`
since it is the newstyle config.


### init.lua

`./lua/init.lua` is sourced by `init.vim`.
it contains plugin settings, enables and configures LSPs and makes additional
configurations to the `init.vim` configurations.

## Setup

Some manual initial setup is needed for the config to work:
1. install [vim-plug](https://github.com/junegunn/vim-plug)
2. install [ripgrep](https://ripgrep.dev/)
    (available in most linux distribution package repos).
    This is required by the telescope live grep.
3. install [fd](https://github.com/sharkdp/fd)
    (available in most linux distribution package repos).
    This is required for the telescope finder.
4. open nvim and type `:PlugInstall` to download and install the plugins
    from this config
5. reopen nvim and type `:TSInstall` to install tree-sitter parsers
6. install required language servers if you intend to use them.
    the enabled list is in `./lua/init.lua:49`
6. tell me if setup steps are missing in this list

## Cheat Sheet

### [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter)

`Fd`    Show diagnostics
`Fh`    Help tags
`Ff`    Find file
`Fb`    Find buffer
`Fg`    Live grep

### [DAP](https://codeberg.org/mfussenegger/nvim-dap) -- Debugger UI

`Fq`    Terminate DAP UI
`Fu`    Open DAP UI
`<C-P>` Tobble breakpoints
`<C-S>c` Continue
`<C-S>o` Step out
`<C-S>i` Step into
`<C-S>n` Step over

### [UFO](https://github.com/kevinhwang91/nvim-ufo) -- block folding

`F4`    Collapse all folds
`<CR>`  Open all folds

### [Spider](https://github.com/chrisgrieser/nvim-spider) -- jump sub-words

`w`     Jump to begin of next subword
`b`     Jump to begin of previous subword
`e`     Jump to end of next subword
`ge`     Jump to end of previous subword

### [Comment](https://github.com/numToStr/Comment.nvim) -- comment/uncomment code

`gc`    Tobble single line comment
`gb`    Toggle block comment

### Neogen -- anotation generator

`Fc`    Comment signature
`<C-l>` Jump to next comment entry
`<C-h>` Jump to previous comment entry
