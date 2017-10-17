" Vim syntax file for rfc-reader
" {{{ setup
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim
" }}}
" {{{  syntax

" rfcEndPeriod is to match the end period of a sentence inside a paragraph
" 	It is an apple. I like it.
" 	              ^
" 	              rfcEndPeriod
"
" XXX: rfcSectionNr might not be necessary
" rfcSectionNr is to match the last period of a section number, so the
" highlight of it can be skipped.
"		3.2.1.  Sider Brewry
" 	     ^
" 	     rfcSectionNr
" NOTE: match bullet number
syn match rfcSectionNr	/\v^\s+(\d|\.)+/ display containedin=NONE
"syn match rfcEndPeriod	/\v\zs\.\ze ( | ?\n)\u@=/

" BCP14 keywords defined in RFC2119
syn keyword rfcBcp14a	REQUIRED RECOMMENDED OPTIONAL
syn keyword rfcBcp14v	MUST SHALL SHOULD MAY nextgroup=rfcBcp14not skipwhite skipempty
syn keyword rfcBcp14not	NOT
syn cluster rfcBcp14 contains=rfcBcp14a,rfcBcp14v,rfcBcp14not

" rfcRFCxxxx matches patterns like BCP 14, RFC 2119
syn match rfcRFCxxxx	/\v<(RFC|BCP|STD)[ -]\d+>/

" match content in double quotes. Nesting is not allowed.
syn region rfcInDoubleQuotes start='"' end='"' contains=@rfcBcp14

" match content in single quotes, exluding the case of I'm, It's, etc.
syn match rfcInSingleQuotes	/\v\_W'[^']+'\_W/ms=s+1,me=e-1

"  rfcInBrackets matches [xxx] with xxx begins with an alphabetic character
"  and follows by a serise of characters. It can span over two lines.
syn match rfcInBrackets	/\v\[[[:alnum:]-_ .]{-}(\n\s+[[:alnum:]-_ ]+)?\]/
syn match rfcSectionRef	/\v<Section\n? +[0-9.]+>/
syn region rfcDoubleBrackets start='\[\[' end='\]\]'

" Table of Contents
" rfcTocRegion confines a Table of Contents secion to a syntax region
syn region rfcTocRegion start='\v(^Table of Contents\n)@<=' end="^\d"me=e-1 transparent 

" XXX

syn match SectionHeader	/\v^(\u|\d)\S\_.*\n\@=$/

syn match rfcPageFooter	/^\S.*\ze\n/
syn match rfcPageHeader	/^\v(\n)@2<=(RFC|Internet-Draft).*$/


syn region rfcDocHeader	start='\%^\n*' end='\d\+$'

syn region  rfcLineComment start="//" skip="\\$" end="$" keepend
syn region	rfcBlockComment	start='/\*' end='\*/' extend

" }}}
" {{{ highlight

hi link rfcBcp14a	Keyword
hi link rfcBcp14v	Keyword
hi link rfcBcp14not	Keyword
hi link rfcRFCxxxx	String
hi link rfcEndPeriod	Conceal

hi link rfcInDoubleQuotes	String
hi link rfcInSingleQuotes String
hi link rfcInBrackets	String
hi link rfcDoubleBrackets Comment
hi link rfcSectionRef	String

hi link SectionHeader	PreProc

hi link rfcPageFooter	Comment
hi link rfcPageHeader	Comment
hi link rfcDocHeader	Define

hi link rfcLineComment	Comment
hi link rfcBlockComment	Comment

hi link rfcAdhocKw	Keyword
" }}}
" {{{ teardown
let b:current_syntax = "rfc"

let &cpo = s:cpo_save
unlet s:cpo_save
" }}}
" vim:ts=2 fdm=marker ff=unix
