set runtimepath+=~/vimfiles
set packpath+=~/vimfiles

set backup
let &backupdir = expand("~/vimfiles/backup")
let &directory = expand('~/vimfiles/swap//')
let g:pluggins_dir = expand("~/vimfiles/pluggins")

call plug#begin(g:pluggins_dir)

" --Neovim specifics--
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

" Telescope & Treesitter
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Neovim LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'kdheepak/cmp-latex-symbols'
Plug 'lukas-reineke/indent-blankline.nvim', {'tag': 'v3.5.4'} " newer versions require nvim 0.10

Plug 'shortcuts/no-neck-pain.nvim', { 'tag': '*' }

" Snippets.
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'

" --Any Vim--
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'

Plug 'kvrohit/mellow.nvim'

Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'}
call plug#end()

set background=dark
colorscheme mellow

set completeopt=menuone,noinsert,noselect
set fileencoding=utf-8
set encoding=utf-8
set updatetime=250
set autochdir
set clipboard+=unnamedplus

set colorcolumn=80
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

let g:julia_indent_align_brackets = 0

" Hightlight text on yank.
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

lua << EOF
local telescope = require 'telescope'
local telescope_builtin = require 'telescope.builtin'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
local cmp = require 'cmp'
local snippy = require 'snippy'

-- Show indentation lines.
require("ibl").setup()

-- LSP: Custom attach function with defined mappings.
local custom_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.keymap.set('n', '<leader><F2>', vim.diagnostic.goto_prev, {buffer = true})
  vim.keymap.set('n', '<F2>', vim.diagnostic.goto_next, {buffer = true})

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = true})
  vim.keymap.set('n', '<F6>', vim.lsp.buf.rename, {buffer = true})
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = true})
  vim.keymap.set('n', '<leader>rf', vim.lsp.buf.references, {buffer = true})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

  vim.keymap.set('n', '<leader>f', telescope_builtin.lsp_dynamic_workspace_symbols, {buffer = true})
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
-- configs.julia_lsp = {
--   default_config = {
--     cmd = {
--       "julia", "--startup-file=no", "--history-file=no", "-e", [[
--         using LanguageServer, LanguageServer.SymbolServer; runserver()
--       ]]
--     },
--     filetypes = {'julia'},
--     root_dir = function(fname)
--       return util.find_git_ancestor(fname) or vim.loop.os_homedir()
--     end,
--   },
-- }

-- Completion engine setup.
cmp.setup({
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    },
    ['<C-s>'] = cmp.mapping(
      function(fallback)
        snippy.expand_or_advance(fallback)
      end
    ),
  }),
  sources = {
    {name = "latex_symbols"},
    {name = "nvim_lsp"},
    {name = "snippy"},
    {name = "buffer"},
  },
})

-- Communicate support for capabilities to LSP servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lsp = require'lspconfig'

-- lsp.julia_lsp.setup{on_attach=custom_attach, capabilities=capabilities}
lsp.pyright.setup{on_attach=custom_attach, capabilities=capabilities}

require'nvim-treesitter.configs'.setup{highlight = {enable = true}}

local actions = require "telescope.actions"
local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup{
  extensions = {
    file_browser = {
      disable_devicons = true,
      mappings = {
        i = {
          ["<C-t>"] = actions.select_tab
        },
      },
    },
  }
}
telescope.load_extension "file_browser"
require'gitsigns'.setup()

vim.g.lightline = {
  active = {
    left = {{'mode', 'paste'}, {'gitbranch', 'readonly', 'absolutepath', 'modified'}}
  },
  inactive = {
    left = {{'gitbranch', 'absolutepath', 'modified'}},
    right = {{}}
  },
  component_function = {gitbranch = 'FugitiveStatusline'},
}

-- Set keybindings.
vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser)
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)

-- Use treesitter for folding.
vim.opt.foldmethod = "expr"
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
EOF

" Reset search highlight
nnoremap <F4> :noh<CR>
nnoremap <F7> :NoNeckPain<CR>

command! FixWhitespace :%s/\s\+$//e " Remove trailing whitespaces
