"Settings
set expandtab
set tabstop=4
set shiftwidth=4
set number
set cursorline
set autoindent
set smartindent
set t_Co=256
set ignorecase
set backspace=indent,eol,start
set mouse=nicr
"set leader key
let mapleader=","

" autocompletion of files and commands behaves like shell
" " (complete only the common part, list the options that match)
set wildmode=list:longest"

syntax on

"Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

"Setting up vundle"
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
let iCanHazVundle=1
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle --depth 1
    let iCanHazVundle=0
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
"-----------------

" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

filetype plugin indent on     " required

"Plugin (Bundles)

"auto add corresponse quote
Plugin 'Auto-pairs'
" Auto complete tag pair
Plugin 'othree/xml.vim'
"Zen coding
Plugin 'emmet.vim'
"Command Tool for code searching 
Plugin 'mileszs/ack.vim'
"vim command tools
Plugin 'tpope/vim-surround'
"Air line
Plugin 'bling/vim-airline'
"Commenter
Plugin 'scrooloose/nerdcommenter' 
"Class/Module browser
Plugin 'majutsushi/tagbar'
" File tree
Plugin 'scrooloose/nerdtree'
" Code and files fuzzy finder
Plugin 'kien/ctrlp.vim'

"JS 
Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs.vim'

" Python and other languages code checker
Plugin 'scrooloose/syntastic'
"Color scheme
Plugin 'fisadev/fisa-vim-colorscheme'

" auto completion
Plugin 'ervandew/supertab'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

"Plugin 'rkulla/pydiction'

"let g:pydiction_location = '/home/user/.vim/bundle/pydiction/complete-dict'


if iCanHazVundle == 0
    echo "Installing Plugins..."
    :PluginInstall
endif
"==================================
" Emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_expandabbr_key = '<C-y>'

" Syntastic 
" show list of errors and warnings on the current file
nmap <leader>e :Errors<CR>
let g:syntastic_check_on_open = 1
" don't put icons on the sign column (it hides the vcs status icons of
" signify)
let g:syntastic_enable_signs = 1
" custom icons (enable them if you use a patched font, and enable the previous 
" setting)
let g:syntastic_error_symbol = 'x'
let g:syntastic_warning_symbol = '!'
let g:syntastic_enable_balloons = 1
let syntastic_check_on_wq = 1

let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_checkers = ["cppcheck"]

let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_checkers = ["pep8", "pyflakes"]

" use 256 colors when possible
if &term =~? 'mlterm\|xterm\|xterm-256\|screen-256'
    let &t_Co = 256
        colorscheme fisa
    else
        colorscheme delek
endif

" nicer colors
highlight DiffAdd cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete cterm=bold ctermbg=none ctermfg=167
highlight DiffChange cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd cterm=bold ctermbg=237 ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237 ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237 ctermfg=227
highlight LineNr ctermfg=yellow
"Airline
set laststatus=2

"folding
set foldenable 
set foldmethod=syntax 
set foldcolumn=0 

"nerdtree
let NERDTreeQuitOnOpen=1

"key binding

"Run files
nmap <F3> :tabnew<CR>
nmap <F4> :TagbarToggle<CR>
nmap <F5> :NERDTreeToggle<CR>
autocmd filetype c   nnoremap <F8> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cpp nnoremap <F8> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
autocmd BufRead *.py nmap <F8> :w !python3 % <CR>

"paste setting
nnoremap <F9> :set invpaste paste?<CR>
set pastetoggle=<F9>
set showmode

"NERDCommenter
nmap <C-c> <plug>NERDCommenterToggle

"save file as sudo
cmap w!! w !sudo tee > /dev/null %

"jump to next error
nmap <leader>l :lnext<CR>

cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set

