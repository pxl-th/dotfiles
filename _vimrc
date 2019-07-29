" Plugins configurations
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 10
let g:indent_guides_enable_on_vim_startup = 1
let s:grep_available=0
let g:NERDTreeWinSize = 40

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

" ale linter configuration
let g:ale_linters = {}
:call extend(g:ale_linters, {'python': ['flake8'], })

" F3 to open file browser
nnoremap <silent> <F3> :NERDTreeToggle<CR>
" Reset search highlight
nnoremap <F4> :noh<CR>
" F8 to view file structure
nnoremap <F8> :TagbarToggle<CR>

" New commands
" Remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e


set updatetime=100
set backupdir=C:\Users\tonys\vimfiles\backup
set encoding=utf-8
set fileencoding=utf-8
set autochdir
set completeopt=longest,menuone

set number
set cursorline
set nowrap
set showmatch
set spell
" Display completion matches
set wildmenu
" Set status line display
set colorcolumn=80

" Allow regular usage of backspace
set backspace=indent,eol,start
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list

set autoindent
set expandtab
set smarttab
set smartindent
set shiftwidth=4
set softtabstop=4
set scrolloff=5

" Highlight search results and start searching on typing
set incsearch
set hlsearch

set foldmethod=syntax
set nofoldenable
set foldnestmax=10
set foldlevel=2
nnoremap <space> za

syntax on
filetype plugin indent on

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif


" Load plugins

call plug#begin('C:\Users\tonys\vimfiles\pluggins')

" File browser
Plug 'scrooloose/nerdtree'
" Show git modifications
Plug 'airblade/vim-gitgutter'
" Comment plugin
Plug 'tpope/vim-commentary'
" Visualize indents
Plug 'nathanaelkane/vim-indent-guides'
" Python autocompletion
Plug 'davidhalter/jedi-vim', {'for': 'python'}
" View file structure
Plug 'https://github.com/majutsushi/tagbar.git'
" Linting
Plug 'w0rp/ale'
" Pretty status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Git integration
Plug 'https://github.com/tpope/vim-fugitive.git'
" Themes
Plug 'https://github.com/neutaaaaan/blaaark.git'
" Snippets
Plug 'SirVer/ultisnips', {'for': 'python'}
Plug 'honza/vim-snippets', {'for': 'python'}

call plug#end()

