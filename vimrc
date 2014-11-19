"Settings
set expandtab
set tabstop=4
set shiftwidth=4
set number
set autoindent
set smartindent
set t_Co=256
set ignorecase

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
Plugin 'Auto-pairs'

Plugin 'SingleCompile'

Plugin 'Pydiction'

Plugin 'vim-scripts/HTML5-Syntax-File'

Plugin 'mileszs/ack.vim'

Plugin 'tpope/vim-surround'
"Class/Module browser
Plugin 'scrooloose/nerdcommenter' 
" Python and other languages code checker
Plugin 'scrooloose/syntastic'

Plugin 'majutsushi/tagbar'
" Auto complete tag pair
Plugin 'othree/xml.vim'
"Auto Complete
Plugin 'garbas/vim-snipmate'

Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle 'honza/vim-snippets'

Plugin 'scrooloose/nerdtree'

"Plugin 'matchit.zip'

Plugin 'emmet.vim'



if iCanHazVundle == 0
    echo "Installing Plugins..."
    :PluginInstall
endif

" Emmet
let g:user_emmet_expandabbr_key = '<c-y>'

" Syntastic ------------------------------

" show list of errors and warnings on the current file
nmap <leader>e :Errors<CR>
let g:syntastic_check_on_open = 1

" don't put icons on the sign column (it hides the vcs status icons of
" signify)
let g:syntastic_enable_signs = 1
" custom icons (enable them if you use a patched font, and enable the previous 
" setting)
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '!'
"let g:syntastic_style_warning_symbol = '⚠'")
let g:syntastic_enable_balloons = 1

let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_check_header = 1
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_checkers = ["pyflakes"]
let syntastic_check_on_wq = 1


"Pydiction plugin settings
filetype plugin on
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'
let g:pydiction_menu_height = 3

"folding
set foldenable 
set foldmethod=syntax 
set foldcolumn=0 
nnoremap @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')

"Run files
autocmd filetype c   nnoremap <F8> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cpp nnoremap <F8> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
autocmd BufRead *.py nmap <F8> :w !python3 % <CR>

autocmd FileType python setlocal et sta sw=4 sts=4

"Tagbar
nmap <F4> :Tagbar<CR>
nmap <F5> :NERDTree<CR>
nmap <F9> :set paste<CR>
nmap <F10> :set nopaste<CR>

"Key Mapping
cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set

