let g:ycm_global_ycm_extra_conf = "~/.vim_runtime/my_plugins/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_invoke_completion = '<C-_>'
let g:ycm_python_binary_path = 'python3'
set relativenumber
nnoremap <leader>gg :YcmCompleter GoTo<CR>
set clipboard=unnamed
set encoding=utf-8
let g:go_version_warning = 0
