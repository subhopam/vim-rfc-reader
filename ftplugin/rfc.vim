" Vim ftplugin file for rfc-reader
"{{{ plugin setup
" Only do this when not done yet for this buffer
if exists("b:rfc_ftplugin_loaded") && !exists("g:rfc_ftplugin_debug")
endif
let b:rfc_ftplugin_loaded = 1
" when debugging,
" 	set g:rfc_ftplugin_debug=1,
" or
" 	:e +unlet\ rfc_ftplugin_loaded
"}}}
"{{{ options

" set folding method to manual, so folds can be created by scripts
setlocal foldmethod=manual

" search won't open the fold
setlocal foldopen-=search

setlocal textwidth=72

setlocal smartindent

setlocal shiftwidth=3 tabstop=3 expandtab

"}}}

" vim: ts=2 sw=2 fdm=marker ff=unix
