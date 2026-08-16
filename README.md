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
