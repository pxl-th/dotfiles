set backup
let &backupdir = expand("~/vimfiles/backup")
let &directory = expand('~/vimfiles/swap//')
let g:snippets_dir = expand("~/vimfiles/custom-snippets")
let g:pluggins_dir = expand("~/vimfiles/pluggins")

call plug#begin(g:pluggins_dir) " Load plugins

" --Neovim specifics--
Plug 'nvim-lua/plenary.nvim' " Neovim-specific dev-packages.
Plug 'lewis6991/gitsigns.nvim' " Show git signs.
" Telescope & Treesitter
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Neovim LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" --Any Vim--
Plug 'tpope/vim-commentary' " Comment-stuff-out plugin
Plug 'nathanaelkane/vim-indent-guides' " Visualize indents
Plug 'vim-airline/vim-airline' " Pretty status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'arzg/vim-colors-xcode'

" Julia-specific support.
Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'}
" Snippets
Plug 'SirVer/ultisnips', {'for': ['python', 'cpp', 'julia']}

call plug#end()

set background=dark
colorscheme xcodedarkhc

set completeopt=menuone,noinsert,noselect
set fileencoding=utf-8
set encoding=utf-8
set updatetime=750
set autochdir

set colorcolumn=80 " Set guideline at 80 characters
set cursorline
set showmatch
set wildmenu " Display completion matches
set nospell
set nowrap
set number
set switchbuf=vsplit
set mouse=a " Enable selection using mouse

set backspace=indent,eol,start " Allow regular usage of backspace
set listchars=tab:>-,trail:~,extends:>,precedes:<
set scrolloff=5
set list

syntax on
filetype plugin on
set vb t_vb=

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smarttab
set smartindent

" Highlight search results and start searching on typing
set incsearch
set hlsearch

set foldmethod=indent
set nofoldenable
set foldnestmax=10
set foldlevel=2
nnoremap <space> za
vnoremap <space> zf

autocmd Filetype vim setlocal ts=2 sw=2
autocmd Filetype tex setlocal ts=2 sw=2
autocmd Filetype plaintex setlocal ts=2 sw=2

" Plugins configurations
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 10
let g:indent_guides_enable_on_vim_startup = 1
let s:grep_available=1

let g:airline#extensions#default#layout = [[ 'a', 'b', 'c', 'y', 'z' ], []]
let g:airline_detect_spell=0
let g:airline_theme='minimalist'

" Configure snippets commands.
let g:UltiSnipsSnippetDirectories = [g:snippets_dir]
let g:UltiSnipsSnippetsDir = g:snippets_dir
let g:UltiSnipsExpandTrigger="<C-s>"
let g:UltiSnipsJumpForwardTrigger="<C-a>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsEditSplit="vertical"

let g:julia_indent_align_brackets = 0

" LSP configuration.

let g:python3_host_prog = expand("~/projects/python/nvim-venv/bin/python")
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_auto_popup = 1

" let g:python_lsp = expand("~/projects/python/nvim-venv/bin/pyls")

" Use completion-nvim in every buffer.
autocmd BufEnter * lua require 'completion'.on_attach()
" Hightlight text on yank.
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

lua << EOF
local custom_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap = true, silent = true}
  local ns_opts = {noremap = true, silent = false}

  buf_set_keymap('n', '<leader><F2>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  buf_set_keymap('n', '<F6>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<F7>', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<F9>', '<Cmd>lua print(vim.lsp.buf.server_ready())<CR>', ns_opts)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
configs.julia_lsp = {
  default_config = {
    cmd = {
      "julia", "--startup-file=no", "--history-file=no", "-e", [[
        using LanguageServer, LanguageServer.SymbolServer; runserver()
      ]]
    };
    filetypes = {'julia'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
  };
}

local lsp = require 'lspconfig'
lsp.julia_lsp.setup{on_attach=custom_attach}
EOF

" Treesitter & Telescope configs.

lua <<EOF
require'nvim-treesitter.configs'.setup {
 highlight = {
   enable = true,
 },
}
require'telescope'.setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules/*",
      ".git/*",
      "node",
      "stl",
      "stp",
      "gcode",
    }
  }
}
require('gitsigns').setup()
EOF

" Hotkeys & commands.

" Reset search highlight
nnoremap <F4> :noh<CR>
" Copy & Paste to system clipboard. Need xclip to be installed.
vnoremap <C-c> :w !xclip -sel c<CR><CR>
noremap <S-C-v> :r !xsel -b<CR><CR>

" Next/prev tab
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope file_browser<cr>

command! FixWhitespace :%s/\s\+$//e " Remove trailing whitespaces
