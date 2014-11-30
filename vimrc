"Settings
set expandtab
set tabstop=4
set shiftwidth=4
set number
set autoindent
set smartindent
set t_Co=256
set ignorecase
set backspace=indent,eol,start

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
"Run file
Plugin 'SingleCompile'

Plugin 'Pydiction'

Plugin 'vim-scripts/HTML5-Syntax-File'

Plugin 'mileszs/ack.vim'

Plugin 'tpope/vim-surround'
"Class/Module browser
Plugin 'scrooloose/nerdcommenter' 
" Python and other languages code checker
Plugin 'scrooloose/syntastic'
"tag bar
Plugin 'majutsushi/tagbar'
" Auto complete tag pair
Plugin 'othree/xml.vim'
"Auto Complete
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" File tree
Plugin 'scrooloose/nerdtree'

"Plugin 'matchit.zip'
"Zen coding
Plugin 'emmet.vim'

" Color schema
Plugin 'fisadev/fisa-vim-colorscheme'


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

"Pydiction plugin settings
filetype plugin on
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'
let g:pydiction_menu_height = 3

"folding
set foldenable 
set foldmethod=syntax 
set foldcolumn=0 

"Run files

"autocmd filetype c   nnoremap <F8> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
"autocmd filetype cpp nnoremap <F8> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
"autocmd BufRead *.py nmap <F8> :w !python3 % <CR>

"autocmd FileType python setlocal et sta sw=4 sts=4
"nmap <F8> :SCCompile<cr>
nmap <F8> :SCCompileRun<cr>

"nerdtree
let NERDTreeQuitOnOpen=1

"key binding
"nmap <Tab> gt
"nmap <S-Tab> gT
nmap <F3> :tabnew<CR>
nmap <F4> :TagbarToggle<CR>
nmap <F5> :NERDTreeToggle<CR>

set pastetoggle=<F9>
nnoremap <F9> :set invpaste paste?<CR>
set pastetoggle=<F9>
set showmode

nmap h <C-W>h
nmap j <C-W>j
nmap k <C-W>k
nmap l <C-W>l

cmap w!! w !sudo tee > /dev/null %

"Key Mapping
cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set

