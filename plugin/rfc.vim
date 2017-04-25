" Vim plugin file for rfc-reader
" {{{ setup
if !has('lambda')
	echo 'feature +lambda is required for this plugin'
	finish
endif

let s:cpo_save = &cpo
set cpo&vim
" }}}
augroup filetypedetect
	au! BufRead,BufNewFile rfc\d\+.txt		set ft=rfc
	au! BufRead,BufNewFile draft\-*.txt		set ft=rfc
augroup END

function! s:skipToLine(lnum, foreward, stop_op)
	if a:foreward != 0
		let Next = { lnum -> lnum + 1} " move forward
		let bound = line('$') + 1
	else
		let Next = { lnum -> lnum - 1} " move backward
		let bound = 0
	endif
	let Stop_at = { lnum -> eval('getline(lnum) ' . a:stop_op)}
	let lnum = a:lnum
	while lnum != bound
		let lnum = Next(lnum)
		if Stop_at(lnum)
			break
		endif
	endwhile
	return lnum
endfunction

function! s:determinePageHeaderMargin(lnum)
	" cursor is now at the  line
	let lnum = a:lnum
	let lnum = s:skipToLine(lnum, 1, '!~ "^\s*$"') " next non-black line
	let lnum = s:skipToLine(lnum, 1, '=~ "^\s*$"') " next blank line
	let lnum = s:skipToLine(lnum, 1, '!~ "^\s*$"') " next non-black line
	if getline(lnum) =~ '^\S' " the line doesn't start with space
		let lnum -= 2
	else
		let lnum -= 1
	endif
	return lnum
endfunction

function! s:determinePageFooterMargin(lnum)
	" cursor is now at the  line
	let lnum = a:lnum
	let lnum = s:skipToLine(lnum, 0, '!~ "^\s*$"') " previous non-black line
	let lnum = s:skipToLine(lnum, 0, '=~ "^\s*$"') " previous blank line
	let lnum = s:skipToLine(lnum, 0, '!~ "^\s*$"') " previous non-black line
	" wind back a little
	let lnum += 1
	return lnum
endfunction

function! s:createFoldAtPageBreak()
	" prerequisite:  cursor at the  line
	let lnum = line('.')

	" return if current line is in a fold
	if foldlevel(lnum) > 0
		return
	endif

	let fold_begin = s:determinePageFooterMargin(lnum)
	let fold_close = s:determinePageHeaderMargin(lnum)

	exe fold_begin . ',' . fold_close . 'fold'
endfunction

function! s:globalCreateFoldAtPageBreak()
	if !exists('b:did_globalCreateFoldAtPageBreak')
		let b:did_globalCreateFoldAtPageBreak = 0
	else
		let b:did_globalCreateFoldAtPageBreak += 1
	endif

	let saved_pos = [line('.'), col('.')]
	global//call s:createFoldAtPageBreak()
	call cursor(saved_pos)
endfunction

autocmd! FileType rfc  nested call s:globalCreateFoldAtPageBreak()

nnoremap <buffer> <silent> <leader>fc :call <SID>globalCreateFoldAtPageBreak()<CR>

" {{{ teardown
let b:current_syntax = "rfc"

let &cpo = s:cpo_save
unlet s:cpo_save
" }}}
" vim: ts=2 sw=2 fdm=marker ff=unix
