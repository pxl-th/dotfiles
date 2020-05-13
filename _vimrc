call plug#begin('C:\Users\tonys\vimfiles\pluggins') " Load plugins

Plug 'scrooloose/nerdtree' " File browser
Plug 'airblade/vim-gitgutter' " Show git modifications
Plug 'tpope/vim-commentary' " Comment-stuff-out plugin
Plug 'nathanaelkane/vim-indent-guides' " Visualize indents
Plug 'majutsushi/tagbar' " View file structure
Plug 'vim-airline/vim-airline' " Pretty status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive' " Git integration

Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'} " Julia lang support
Plug 'prabirshrestha/async.vim', {'for': 'julia'}
Plug 'prabirshrestha/asyncomplete.vim', {'for': 'julia'}
Plug 'prabirshrestha/asyncomplete-lsp.vim', {'for': 'julia'}
Plug 'prabirshrestha/vim-lsp', {'for': 'julia'}

Plug 'levelone/tequila-sunrise.vim' " Theme

Plug 'w0rp/ale', {'for': 'python'} " Linting
Plug 'davidhalter/jedi-vim', {'for': 'python'} " Autocompletion
Plug 'SirVer/ultisnips', {'for': ['python', 'cpp']} " Snippets
Plug 'honza/vim-snippets', {'for': ['python', 'cpp']}

call plug#end()

set backupdir=C:\Users\tonys\vimfiles\backup
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
filetype plugin indent on
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

autocmd Filetype vim setlocal ts=2 sw=2 st=2
autocmd Filetype tex setlocal ts=2 sw=2 st=2
autocmd Filetype plaintex setlocal ts=2 sw=2 st=2

" Plugins configurations
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 10
let g:indent_guides_enable_on_vim_startup = 1
let s:grep_available=0
let g:NERDTreeWinSize = 40

let g:ale_linters = {'python': ['flake8']}
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"

let g:airline#extensions#default#layout = [[ 'a', 'b', 'c', 'y', 'z' ], []]
let g:airline_detect_spell=0
let g:airline_theme='minimalist'

" Configure snippets commands
let g:UltiSnipsSnippetDirectories = ["C:/Users/tonys/vimfiles/custom-snippets"]
let g:UltiSnipsSnippetsDir = "C:/Users/tonys/vimfiles/custom-snippets"
let g:UltiSnipsExpandTrigger="<C-s>"
let g:UltiSnipsJumpForwardTrigger="<C-a>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsEditSplit="vertical"

let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vimfiles/logs/vim-lsp.log')
if executable('julia')
  let g:julia_lsp = '
  \ using LanguageServer;
  \ using Pkg;
  \ import StaticLint;
  \ import SymbolServer;
  \ env_path = dirname(Pkg.Types.Context().env.project_file);
  \ server = LanguageServer.LanguageServerInstance(stdin, stdout, env_path);
  \ server.runlinter = true;
  \ run(server);
  \'
  autocmd User lsp_setup call lsp#register_server({
  \ 'name': 'julia',
  \ 'cmd': {server_info->['julia', '--startup-file=no', '--history-file=no', '-e', g:julia_lsp]},
  \ 'whitelist': ['julia'],
  \ })
endif

nnoremap <F6> :LspRename<CR>
nnoremap <F9> :LspStatus<CR>
nnoremap P :LspDefinition<CR>

let g:asyncomplete_auto_popup = 0
imap <c-space> <Plug>(asyncomplete_force_refresh)

" F3 to open file browser
nnoremap <silent> <F3> :NERDTreeToggle<CR>
" Reset search highlight
nnoremap <F4> :noh<CR>
" F8 to view file structure
nnoremap <F8> :TagbarToggle<CR>

command! FixWhitespace :%s/\s\+$//e " Remove trailing whitespaces
