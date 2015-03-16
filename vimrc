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

"JS 
Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs.vim'

" Python and other languages code checker
Plugin 'scrooloose/syntastic'
" Code and files fuzzy finder
Plugin 'kien/ctrlp.vim'
"" Better autocompletion 
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Pydiction'

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
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions',
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
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" End neocomplete ====


" neosnippet ===
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" End neosnippet ===

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


"Airline
set laststatus=2


"Pydiction plugin settings
filetype plugin on
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'
let g:pydiction_menu_height = 5


"snimate


"folding
set foldenable 
set foldmethod=syntax 
set foldcolumn=0 


"Run files
autocmd filetype c   nnoremap <F8> :w <bar> exec '!gcc '.shellescape('%').' -O2 && ./a.out'<CR>
autocmd filetype cpp nnoremap <F8> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -O2 && ./a.out'<CR>
autocmd BufRead *.py nmap <F8> :w !python3 % <CR>

"autocmd FileType python setlocal et sta sw=4 sts=4
"nmap <F8> :SCCompile<cr>
"nmap <F8> :SCCompileRun<cr>


"nerdtree
let NERDTreeQuitOnOpen=1


"key binding
"nmap <Tab> gt
"nmap <S-Tab> gT
nmap <F3> :tabnew<CR>
nmap <F4> :TagbarToggle<CR>
nmap <F5> :NERDTreeToggle<CR>
"paste setting
nnoremap <F9> :set invpaste paste?<CR>
set pastetoggle=<F9>
set showmode


"NERDCommenter
nmap <C-c> <plug>NERDCommenterToggle


"save file as sudo
cmap w!! w !sudo tee > /dev/null %


"set leader key
let mapleader=","


"Key Mapping
cab Q q
cab W w
cab X x
cab WQ wq
cab Wq wq
cab wQ wq
cab Set set
