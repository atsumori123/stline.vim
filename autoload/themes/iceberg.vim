function! s:style(bg, fg, opt) abort
	let style = "ctermbg=".a:bg[0]." ctermfg=".a:fg[0]." guibg=".a:bg[1]." guifg=".a:fg[1]
	if !empty(a:opt) | let style .= " cterm=".a:opt." gui=".a:opt | endif
	return style
endfunction

function! themes#iceberg#hi() abort
	let bc01 = ["247", "#828595"]
	let bc02 = ["39" , "#89A0C3"]
	let bc03 = ["158", "#B6BD89"]
	let bc04 = ["217", "#D9A67F"]
	let bc05 = ["237", "#2E313E"]
	let bc06 = ["237", "#0F1116"]

	let fc01 = ["0"  , "#000000"]
	let fc02 = ["247", "#686D85"]
	let fc04 = ["255", "#BBBBEE"]

"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt							   | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |	 S1   |   S2   |		  S3								   |	 S2		|	  S1	  | S4	|
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec 'highlight STLineS1_N '.s:style(bc01, fc01, 'bold')
	exec 'highlight STLineS1_I '.s:style(bc02, fc01, 'bold')
	exec 'highlight STLineS1_V '.s:style(bc03, fc01, 'bold')
	exec 'highlight STLineS1_R '.s:style(bc04, fc01, 'bold')

	" Statusline S2
	exec 'highlight STLineS2   '.s:style(bc05, fc02, '')

	" Statusline S3
	exec 'highlight STLineS3_N '.s:style(bc06, fc02, '')
	exec 'highlight STLineS3_I '.s:style(bc06, fc02, '')
	exec 'highlight STLineS3_V '.s:style(bc06, fc02, '')
	exec 'highlight STLineS3_R '.s:style(bc06, fc02, '')

	" Statusline S4
	exec 'highlight STLineS4   '.s:style(bc01, fc01, '')

"=======================================================================================================
" Tabline
"=======================================================================================================
	exec 'highlight STLineCur  '.s:style(bc06, fc04, '')
	exec 'highlight STLineNml  '.s:style(bc06, fc02, '')
endfunction

