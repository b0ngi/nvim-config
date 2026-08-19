set number
set relativenumber
set tabstop=4
set shiftwidth=0 "use tabstop 
set smarttab
set expandtab
"set autoindent
set smartindent
set mouse=a
set nowrap
set autoread

syntax enable
filetype plugin indent on

" unindent in insert mode on shift+tab
inoremap <S-Tab> <C-d>
" insert selected completion match with ctrl-enter
inoremap <expr> <CR> pumvisible() ? '<c-y>' : '<CR>'
" insert top completion match with shift-enter
inoremap <expr> <S-CR> pumvisible() ? '<down><c-y>' : '<S-CR>'
" insert top completion match with ctrl-enter
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-h> <left>
inoremap <c-l> <right>
"
" refresh completion menu on backspace
inoremap <expr> <BS> pumvisible() ? '<BS><c-x><c-o>' : '<BS>'
inoremap . .<c-x><c-o>
" open lsp actions on ctl-.
noremap <c-.> gra
inoremap <c-.> <Esc>gra


" insert matching braces single line
inoremap { {}<Esc>i
inoremap {<Space> {<Space><Space>}<Esc>hi
inoremap {} {}
inoremap ( ()<Esc>i
inoremap (<Space> (<Space><Space>)<Esc>hi
inoremap () ()
inoremap [ []<Esc>i
inoremap [<Space> [<Space><Space>]<Esc>hi
inoremap [] []
inoremap {<BS> {<BS> 
inoremap (<BS> (<BS> 
inoremap [<BS> [<BS> 
inoremap "" ""<Esc>i
inoremap '' ''<Esc>i
" insert matching braces multiline
inoremap {<cr> {<cr>}<Esc>ko
inoremap (<cr> (<cr>)<Esc>ko<tab>
inoremap [<cr> [<cr>]<Esc>ko


" open/focus neotree on E
noremap E <Cmd>Neotree toggle<CR>
" map go-to-definition to <control 9>
noremap <c-9> <c-]>

" highlight symbol with Flh
noremap Flh <Cmd>lua vim.lsp.buf.document_highlight()<CR>

" debugger commands
noremap Fu <Cmd>lua require("dapui").open()<CR><Cmd>DapNew<CR>
noremap Fq <Cmd>lua require("dapui").close()<CR><Cmd>DapTerminate<CR>
noremap <c-p> <Cmd>DapToggleBreakpoint<CR>
noremap <c-s>n <Cmd>DapStepOver<CR>
noremap <c-s>i <Cmd>DapStepInto<cr>
noremap <c-s>o <Cmd>DapStepOut<cr>
noremap <c-s>c <Cmd>DapContinue<cr>

" plugins
call plug#begin()

" tree sitter
Plug 'nvim-treesitter/nvim-treesitter'

" neo-tree
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" nvim-surround
Plug 'kylechui/nvim-surround'

" default lsp configs
Plug 'neovim/nvim-lspconfig'

" diff/merge
Plug 'sindrets/diffview.nvim'

" colorscheme
Plug 'https://github.com/scottmckendry/cyberdream.nvim'
" highlight active window
Plug 'nvim-zh/colorful-winsep.nvim'

" telescope
Plug 'nvim-telescope/telescope.nvim'

" session manager
Plug 'rmagatti/auto-session'

" debugger
Plug 'https://codeberg.org/mfussenegger/nvim-dap'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'

" Markdown
Plug 'meanderingprogrammer/render-markdown.nvim'

" run tests
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-neotest/neotest'
Plug 'mrcjkb/rustaceanvim'

call plug#end()


" source lua init script
lua require('init')

" let g:vimspector_enable_mappings = 'HUMAN'
" packadd! vimspector

colorscheme cyberdream
