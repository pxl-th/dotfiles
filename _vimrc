" Plugins configurations
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 10
let g:indent_guides_enable_on_vim_startup = 1
let s:grep_available=0
let g:NERDTreeWinSize = 50

let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"

" ale linter configuration
let g:ale_linters = {}
:call extend(g:ale_linters, {'python': ['flake8'], })

" F3 to open file browser
nnoremap <silent> <F3> :NERDTreeToggle<CR>
" Reset search highlight
nnoremap <F4> :noh<CR>

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
set laststatus=2
set statusline=%F%m%r%h%w\ [format=%{&ff}]\ [type=%Y]\ [position=%l,%v][%p%%]\ [buffer=%n]\ %{strftime('%c')}
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
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
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
" Linting
Plug 'w0rp/ale'
" Themes
"Plug 'https://github.com/davidosomething/vim-colors-meh.git'
Plug 'huyvohcmc/atlas.vim'

call plug#end()

