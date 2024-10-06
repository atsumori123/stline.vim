function! s:style(bg, fg, opt) abort
	let style = "ctermbg=".a:bg[0]." ctermfg=".a:fg[0]." guibg=".a:bg[1]." guifg=".a:fg[1]
	if !empty(a:opt) | let style .= " cterm=".a:opt." gui=".a:opt | endif
	return style
endfunction

function! themes#monochrome#hi() abort
	let bc01 = ["0"  , "black"	 ]
	let bc05 = ["235", "#303030" ]
	let bc06 = ["238", "#444444" ]
	let bc07 = ["222", "moccasin"]

	let fc01 = ["247", "darkgray"]
	let fc02 = ["12" , "#61AFEF" ]
	let fc03 = ["207", "#C678DD" ]
	let fc04 = ["172", "#E06C75" ]
	let fc06 = ["0"  , "black"	 ]
	let fc07 = ["255", "white"	 ]

"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt							   | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |	 S1   |   S2   |		  S3								   |	 S2		|	  S1	  | S4	|
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec 'highlight STLineS1_N '.s:style(bc01, fc01, 'bold')
	exec 'highlight STLineS1_I '.s:style(bc01, fc02, 'bold')
	exec 'highlight STLineS1_V '.s:style(bc01, fc03, 'bold')
	exec 'highlight STLineS1_R '.s:style(bc01, fc04, 'bold')

	" Statusline S2
	exec 'highlight STLineS2 '.s:style(bc06, fc01, '')

	" Statusline S3
	exec 'highlight STLineS3_N '.s:style(bc05, fc01, '')
	exec 'highlight STLineS3_I '.s:style(bc05, fc02, '')
	exec 'highlight STLineS3_V '.s:style(bc05, fc03, '')
	exec 'highlight STLineS3_R '.s:style(bc05, fc04, '')

	" Statusline S4
	exec 'highlight STLineS4 '.s:style(bc07, fc06, '')

"=======================================================================================================
" Tabline
"=======================================================================================================
	exec 'highlight STLineCur	 '.s:style(bc01, fc07, '')
	exec 'highlight STLineCurMod '.s:style(bc01, fc02, '')
	exec 'highlight STLineNml	 '.s:style(bc06, fc01, '')
	exec 'highlight STLineNmlMod '.s:style(bc06, fc02, '')
endfunction

