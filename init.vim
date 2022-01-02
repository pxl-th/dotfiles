set runtimepath+=~/vimfiles,~/vimfiles/after
set packpath+=~/vimfiles

set backup
let &backupdir = expand("~/vimfiles/backup")
let &directory = expand('~/vimfiles/swap//')
let g:snippets_dir = expand("~/vimfiles/custom-snippets")
let g:pluggins_dir = expand("~/vimfiles/pluggins")

call plug#begin(g:pluggins_dir)

" --Neovim specifics--
Plug 'nvim-lua/plenary.nvim' " Neovim-specific dev-packages.
Plug 'lewis6991/gitsigns.nvim'
" Telescope & Treesitter
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Neovim LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'kdheepak/cmp-latex-symbols'

Plug 'lukas-reineke/indent-blankline.nvim'

" --Any Vim--
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'

Plug 'arzg/vim-colors-xcode'

Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'}
Plug 'SirVer/ultisnips', {'for': ['python', 'cpp', 'julia', 'javascript']}

call plug#end()

set background=dark
colorscheme xcodedarkhc

set completeopt=menuone,noinsert,noselect
set fileencoding=utf-8
set encoding=utf-8
set updatetime=250
set autochdir

set colorcolumn=80 " Set guideline at 80 characters
set cursorline
set showmatch
set wildmenu " Display completion matches
set nospell
set nowrap
set number relativenumber
set nu rnu
set switchbuf=vsplit
set mouse=a " Enable mouse

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
autocmd Filetype vim,tex,plaintex,json setlocal ts=2 sw=2
autocmd Filetype javascript,typescript,typescriptreact setlocal ts=2 sw=2

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

" Configure snippets commands.
let g:UltiSnipsSnippetDirectories = [g:snippets_dir]
let g:UltiSnipsSnippetsDir = g:snippets_dir
let g:UltiSnipsExpandTrigger="<C-s>"
let g:UltiSnipsJumpForwardTrigger="<C-a>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsEditSplit="vertical"

let g:julia_indent_align_brackets = 0

let g:python3_host_prog = expand("~/projects/nvim-venv/bin/python")

" Hightlight text on yank.
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

lua << EOF
-- LSP: Custom attach function with defined mappings.
local custom_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap = true, silent = true}
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader><F2>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F2>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F7>', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F6>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', opts)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

-- Julia custom LSP config.
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

configs.julia_lsp = {
  default_config = {
    cmd = {
      "julia", "--startup-file=no", "--history-file=no", "-e", [[
        using LanguageServer, LanguageServer.SymbolServer; runserver()
      ]]
    },
    filetypes = {'julia'},
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end,
  },
}

-- Completion engine setup.
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
  },
  sources = {
    {name = "latex_symbols"},
    {name = "nvim_lsp"},
    {name = "vsnip"},
  },
})
-- {name = "buffer"},

-- Communicate support for capabilities to LSP servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lsp = require'lspconfig'
lsp.julia_lsp.setup{on_attach=custom_attach, capabilities=capabilities}
lsp.tsserver.setup{on_attach=custom_attach, capabilities=capabilities}
lsp.pylsp.setup{on_attach=custom_attach, capabilities=capabilities}

require'nvim-treesitter.configs'.setup{highlight = {enable = true}}
require'telescope'.setup{
  extensions = {
    file_browser = {
      disable_devicons = true,
    },
  }
}
require'telescope'.load_extension "file_browser"
require'gitsigns'.setup()

vim.api.nvim_set_keymap(
  "n", "<leader>fb",
  "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
  {noremap = true})
vim.api.nvim_set_keymap(
  "n", "<leader>ff",
  "<cmd>Telescope find_files disable_devicons=true<CR>",
  {noremap = true})

vim.g.lightline = {
  colorscheme = 'one',
  active = {left = {{'mode', 'paste'}, {'gitbranch', 'readonly', 'filename', 'modified'}}},
  component_function = {gitbranch = 'FugitiveStatusline'}}
EOF

" Reset search highlight
nnoremap <F4> :noh<CR>
" Copy & Paste to system clipboard. Need xclip to be installed.
vnoremap <C-c> :w !xclip -sel c<CR><CR>
noremap <S-C-v> :r !xsel -b<CR><CR>
" Next/prev tab
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT

" Fold/unfold.
nnoremap <space> za
vnoremap <space> zf

command! FixWhitespace :%s/\s\+$//e " Remove trailing whitespaces
