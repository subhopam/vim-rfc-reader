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

setlocal textwidth=70

setlocal smartindent

setlocal shiftwidth=3 tabstop=3 expandtab

"}}}
"{{{ mappings

" ref jumps
let b:re_ref = '\[\S\+\]'
" move to next ref
nnoremap <silent> ]r :call search(b:re_ref)<CR>
" move to previous ref
nnoremap <silent> [r :call search(b:re_ref, 'b')<CR>

" header jumps
nnoremap <silent> ]h :call SearchRfcHeader(0)<CR>
nnoremap <silent> [h :call SearchRfcHeader(1)<CR>

" preview reference
nnoremap <silent> <C-W>p :call PreviewRfcReference()<CR>

function! SearchRfcHeader(reverse)
	if a:reverse
		let next = search('^\S', 'b')
	else
		let next = search('^\S')
	endif

	if next != 0 && foldlevel(next) != 0
		call SearchRfcHeader(a:reverse)
	end
endfunction

function! PreviewRfcReference()
	let cword = expand('<cWORD>')
	let match = matchstr(cword, '\[.\+\]')
	if match == ""
		echo cword . ' is not a reference'
		return
	endif
	let pattern = '/^\V   ' . match . '/'
	let command = 'psearch ' . pattern
	echo command
	execute command
endfunction


"}}}
" vim: ts=2 sw=2 fdm=marker ff=unix
