call plug#begin('C:\Users\tonys\vimfiles\pluggins') " Load plugins

Plug 'scrooloose/nerdtree' " File browser
Plug 'airblade/vim-gitgutter' " Show git modifications
Plug 'tpope/vim-commentary' " Comment-stuff-out plugin
Plug 'nathanaelkane/vim-indent-guides' " Visualize indents
Plug 'majutsushi/tagbar' " View file structure
Plug 'vim-airline/vim-airline' " Pretty status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive' " Git integration
Plug 'levelone/tequila-sunrise.vim'

Plug 'w0rp/ale', {'for': ['python']} " Linting
Plug 'davidhalter/jedi-vim', {'for': 'python'} " Autocompletion
Plug 'ycm-core/YouCompleteMe', {'for': 'cpp'}
Plug 'SirVer/ultisnips', {'for': ['python', 'cpp']} " Snippets
Plug 'honza/vim-snippets', {'for': ['python', 'cpp']}

call plug#end()

set updatetime=750
set backupdir=C:\Users\tonys\vimfiles\backup
set encoding=utf-8
set fileencoding=utf-8
set autochdir
set completeopt=longest,menuone

set number
set cursorline
set nowrap
set showmatch
set nospell
set wildmenu " Display completion matches
set colorcolumn=80 " Set guideline at 80 characters

set backspace=indent,eol,start " Allow regular usage of backspace
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list
set scrolloff=5

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


autocmd Filetype haskell setlocal ts=2 sw=2 st=2
autocmd Filetype vim setlocal ts=2 sw=2 st=2
autocmd Filetype tex setlocal ts=2 sw=2 st=2
autocmd Filetype plaintex setlocal ts=2 sw=2 st=2

" Highlight search results and start searching on typing
set incsearch
set hlsearch

set foldmethod=indent
set nofoldenable
set foldnestmax=10
set foldlevel=2
nnoremap <space> za
vnoremap <space> zf


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

let g:ycm_max_num_candidates = 20

" ale linter configuration
let g:ale_linters = {'python': ['flake8']}

" F3 to open file browser
nnoremap <silent> <F3> :NERDTreeToggle<CR>
" Reset search highlight
nnoremap <F4> :noh<CR>
" F8 to view file structure
nnoremap <F8> :TagbarToggle<CR>

" New commands
command! FixWhitespace :%s/\s\+$//e " Remove trailing whitespaces
