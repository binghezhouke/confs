" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'nsf/gocode', { 'rtp': 'nvim' }

Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'powerline/powerline'
Plug 'Valloric/YouCompleteMe'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-scripts/mru.vim'

" Initialize plugin system
call plug#end()

set number
set relativenumber
set autochdir
set tags=tags,./tags;
let g:ycm_global_ycm_extra_conf = "~/.binghe/ycm_extra_conf.py"
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_invoke_completion = '<C-_>'
let g:ycm_python_binary_path = 'python3'
let g:ycm_collect_identifiers_from_tags_files = 0
set completeopt-=preview
syntax enable
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set cursorline
"set cursorcolumn
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType vue AutoFormatBuffer prettier
augroup END

if ! has("gui_running")
    set t_Co=256
endif
" feel free to choose :set background=light for a different style
"set background=dark
colorscheme dracula
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" key mapping
map <leader>nn :NERDTreeToggle<cr>
map <leader>f :MRU<CR>

try
    set undodir=~/.local/share/nvim/temp_dirs/undodir
    set undofile
catch
endtry
