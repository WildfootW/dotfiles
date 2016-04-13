"Settings
set expandtab
set tabstop=4
set shiftwidth=4
set relativenumber
set number
set cursorline
set autoindent
set smartindent
set t_Co=256
set ignorecase
set backspace=indent,eol,start
set mouse=nicr
"fix E484:Can't open file /tmp
"set shell=/bin/sh
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
Plugin 'azdkj532/nerdcommenter' 
"Class/Module browser
Plugin 'majutsushi/tagbar'
" File tree
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
" Code and files fuzzy finder
Plugin 'kien/ctrlp.vim'
" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
" Move Around
Plugin 'Lokaltog/vim-easymotion'
" Tab manage
Plugin 'mkitt/tabline.vim'


"JS 
Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs.vim'

" Python and other languages code checker
Plugin 'scrooloose/syntastic'
"" Better autocompletion 
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'davidhalter/jedi-vim'

Plugin 'justmao945/vim-clang'
" Django
Plugin 'azdkj532/vim-pony'

"Plugin 'matchit.zip'
"Color scheme
Plugin 'fisadev/fisa-vim-colorscheme'

if iCanHazVundle == 0
    echo "Installing Plugins..."
    :PluginInstall
endif
"==================================
" NeoComplete 
" Enable AutoComplete
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" Enable auto delimeter
let g:neocomplete#enable_auto_delimiter = 0
" Set length of complete menu list
let g:neocomplete#max_list = 10
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " For no inserting <CR> key.
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.python = '\h\w*\|[^. \t]\.\w*'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" End neocomplete ====


" neosnippet ===
" Plugin key-mappings.
imap <C-\>     <Plug>(neosnippet_expand_or_jump)
smap <C-\>     <Plug>(neosnippet_expand_or_jump)
xmap <C-\>     <Plug>(neosnippet_expand_target)

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Disable preview window
set completeopt-=preview
" End neosnippet ===

" vim-clang
let g:clang_auto = 0
let g:clang_c_completeopt = 'longest,menuone'
let g:clang_cpp_completeopt = 'longest,menuone'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
let g:clang_sh_exec = 'zsh'


" Emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css,htmldjango EmmetInstall
let g:user_emmet_expandabbr_key = '<C-y>'

" Pony.vim for Django
let g:pony_open_in_new_tab = 1

" Syntastic 
" show list of errors and warnings on the current file
let g:errorStat=0
function! ToggleErrors()
    if g:errorStat == 0
        :Errors
    else
        :lclose
    endif
    let g:errorStat = 1-g:errorStat
endfunction

nnoremap <silent> <leader>e :call ToggleErrors()<CR>
"nmap <leader>e :Errors<CR>
"jump to next error
nmap <leader>l :lnext<CR>
nmap <leader>p :lprevious<CR>

let g:syntastic_check_on_open = 1
" don't put icons on the sign column (it hides the vcs status icons of
" signify)
let g:syntastic_enable_signs = 1
" custom icons (enable them if you use a patched font, and enable the previous 
" setting)
let g:syntastic_error_symbol = 'X'
let g:syntastic_warning_symbol = '!'
let g:syntastic_style_error_symbol = '>>'
let g:syntastic_style_warning_symbol = '>'
let g:syntastic_enable_balloons = 1
let syntastic_check_on_wq = 1

let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_cpplint_exec = "/usr/local/bin/cpplint"
let g:syntastic_cpp_checkers = ["cpplint"]

let g:syntastic_python_python_exec = '/usr/local/bin/python3'
let g:syntastic_python_checkers = ["flake8"]
let syntastic_check_on_open = 1
let syntastic_check_on_wq = 0
let g:syntastic_python_flake8_args = "--ignore=E501" 

" EasyMotion
nmap <Leader>s <Plug>(easymotion-s2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion"

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
" Use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1
" type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1
highlight link EasyMotionMoveHL Search


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
highlight LineNr ctermbg=none
highlight Search cterm=none ctermbg=green ctermfg=black
highlight NonText cterm=none ctermbg=none
highlight VertSplit ctermbg=none ctermfg=gray
highlight SignColumn ctermbg=none

"Airline
set laststatus=2
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_close_button = 0
let g:airline_powerline_fonts = 1

let g:airline#extensions#ctrlp#color_template = 'insert'
let g:airline#extensions#ctrlp#color_template = 'normal'
let g:airline#extensions#ctrlp#color_template = 'visual'
let g:airline#extensions#ctrlp#color_template = 'replace'
let g:airline#extensions#ctrlp#show_adjacent_modes = 1

" Theme
let g:airline_theme='kolor'

" TabSelect
map <leader>1 1gt
map <leader>2 2gt
map <leader>3 3gt
map <leader>4 4gt
map <leader>5 5gt
map <leader>6 6gt
map <leader>7 7gt
map <leader>8 8gt
map <leader>9 9gt
map <Leader><Tab> :tabnext<CR>
map <Leader><S-Tab> :tabprevious<CR>


"folding
set foldenable 
set foldmethod=syntax 
set foldcolumn=0 


"Run files
autocmd filetype c   nnoremap <F8> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cpp nnoremap <F8> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
autocmd BufRead *.py nmap <F8> :w !python3 % <CR>

autocmd FileType python setlocal et sta sw=4 sts=4

" use absolute line number when commandline window
autocmd CmdwinEnter * set norelativenumber

"nerdtree

"key binding

"Run files
nmap <F3> :tabnew<CR>
nmap <F4> :TagbarToggle<CR>
"nmap <F5> :NERDTreeToggle<CR>
map <F5> <plug>NERDTreeTabsToggle<CR>
let hlstate=0
nnoremap <silent> <F6> :if (hlstate == 0) \| set hlsearch \| else \| nohlsearch \| endif \| let hlstate=1-hlstate<cr>
nnoremap <space> za
noremap <c-j> <c-e>
noremap <c-k> <c-y>
inoremap <c-]> <esc>A
nmap K kJ


"paste setting
nnoremap <F9> :set invpaste paste?<CR>
set pastetoggle=<F9>
set showmode


"NERDCommenter
nmap <C-c> <plug>NERDCommenterToggle


"save file as sudo
cmap w!! w !sudo tee > /dev/null %


cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab QA qa
cab Qa qa
cab Set set
