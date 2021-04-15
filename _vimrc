set backup
let &backupdir = expand("~/vimfiles/backup")
let &directory = expand('~/vimfiles/swap//')
let g:snippets_dir = expand("~/vimfiles/custom-snippets")
let g:pluggins_dir = expand("~/vimfiles/pluggins")

call plug#begin(g:pluggins_dir) " Load plugins

Plug 'scrooloose/nerdtree' " File browser
Plug 'airblade/vim-gitgutter' " Show git modifications
Plug 'tpope/vim-commentary' " Comment-stuff-out plugin
Plug 'nathanaelkane/vim-indent-guides' " Visualize indents
Plug 'vim-airline/vim-airline' " Pretty status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive' " Git integration
Plug 'dstein64/vim-startuptime'
Plug 'godlygeek/tabular'

" Julia
Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'}
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
Plug 'prabirshrestha/async.vim', {'for': 'julia'}
Plug 'prabirshrestha/asyncomplete.vim', {'for': 'julia'}
Plug 'prabirshrestha/asyncomplete-lsp.vim', {'for': 'julia'}
Plug 'prabirshrestha/vim-lsp', {'for': 'julia'}
" Python
Plug 'w0rp/ale', {'for': 'python'} " Linting
Plug 'davidhalter/jedi-vim', {'for': 'python'} " Autocompletion
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins', 'for': 'python'}
Plug 'zchee/deoplete-jedi', {'for': 'python'}

Plug 'SirVer/ultisnips', {'for': ['python', 'cpp', 'julia']} " Snippets
" Plug 'honza/vim-snippets', {'for': ['python', 'cpp']}

call plug#end()

set completeopt=longest,menuone
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
let s:grep_available=0
let g:NERDTreeWinSize = 40

let g:python3_host_prog = expand("~/projects/python/nvim-venv/Scripts/python.exe")
let g:ale_linters = {'python': ['flake8']}
let g:jedi#completions_enabled = 0  " Using deoplete instead
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#popup_select_first = 0
let g:deoplete#enable_at_startup = 1

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

" Julia stuff.
" let g:latex_to_unicode_tab = 0
let g:julia_indent_align_brackets = 0

let g:asyncomplete_auto_popup = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_signs_enabled = 1
let g:lsp_preview_max_width = 79
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vimfiles/logs/vim-lsp.log')

imap <c-space> <Plug>(asyncomplete_force_refresh)
nnoremap <F6> :LspRename<CR>
nnoremap <F7> :LspDefinition<CR>
nnoremap <F8> :LspDocumentDiagnostics<CR>
nnoremap <F9> :LspStatus<CR>

if executable('julia')
  let g:julia_lsp = 'using LanguageServer, LanguageServer.SymbolServer; runserver()'
  autocmd User lsp_setup call lsp#register_server({
  \ 'name': 'julia',
  \ 'cmd': { server_info -> ['julia', '--startup-file=no', '--history-file=no', '-e', g:julia_lsp] },
  \ 'whitelist': ['julia'],
  \ })
endif

" Beta native LSP (crashes server for now)
" Print logfile
" :lua print(vim.lsp.get_log_path())
" Print current omnifunc
" :set omnifunc?

"lua << EOF
"  local lspconfig = require 'lspconfig'
"  local configs = require 'lspconfig/configs'
"  local util = require 'lspconfig/util'

"  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
"    vim.lsp.diagnostic.on_publish_diagnostics, {
"      underline = false,
"      virtual_text = false,
"      signs = true,
"      update_in_insert = false,
"    }
"  )

"  configs.julia_lsp = {
"    default_config = {
"      cmd = {
"        "julia", "--startup-file=no", "--history-file=no", "-e", [[
"          using LanguageServer, LanguageServer.SymbolServer; runserver()
"        ]]
"      };
"      filetypes = {'julia'};
"      root_dir = function(fname)
"        return util.find_git_ancestor(fname) or vim.loop.os_homedir()
"      end;
"    };
"  }

"  lspconfig.julia_lsp.setup{on_attach=require'completion'.on_attach}
"EOF

"nnoremap <F9> <cmd>lua print(vim.lsp.buf.server_ready())<CR>

"if has("nvim-0.5")
"  autocmd Filetype julia setlocal omnifunc=v:lua.vim.lsp.omnifunc
"end

" F3 to open file browser
nnoremap <silent> <F3> :NERDTreeToggle<CR>
" Reset search highlight
nnoremap <F4> :noh<CR>
" F8 to view file structure
nnoremap <F5> :TagbarToggle<CR>

command! FixWhitespace :%s/\s\+$//e " Remove trailing whitespaces

" SHIFT-Del are Cut
vnoremap <S-Del> "+x
" CTRL-Insert are Copy
vnoremap <C-Insert> "+y
" SHIFT-Insert are Paste
map <S-Insert> "+gP
inoremap <S-Insert> <C-R><C-O>+
vnoremap <S-Insert> <C-R>+
" Next/prev tab
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
