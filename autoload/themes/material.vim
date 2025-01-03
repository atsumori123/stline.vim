function! s:style(bg, fg, opt) abort
	let style = "ctermbg=".a:bg[0]." ctermfg=".a:fg[0]." guibg=".a:bg[1]." guifg=".a:fg[1]
	if !empty(a:opt) | let style .= " cterm=".a:opt." gui=".a:opt | endif
	return style
endfunction

function! themes#material#hi() abort
	let bc01 = ["116", "#80CBC4" ]
	let bc02 = ["113", "#8BD649" ]
	let bc03 = ["171", "#C792EA" ]
	let bc04 = ["209", "#f6937e" ]
	let bc05 = ["238", "#263238" ]
	let bc06 = ["66" , "#37474f" ]
	let bc07 = ["222", "moccasin"]

	let fc01 = ["0"  , "Black"   ]
	let fc02 = ["255", "white"   ]

"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt                            | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |   S1   |   S2   |          S3                                   |     S2     |     S1      | S4  |
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec 'highlight STLineS1_N '.s:style(bc01, fc01, 'bold')
	exec 'highlight STLineS1_I '.s:style(bc02, fc01, 'bold')
	exec 'highlight STLineS1_V '.s:style(bc03, fc01, 'bold')
	exec 'highlight STLineS1_R '.s:style(bc04, fc01, 'bold')

	" Statusline S2
	exec 'highlight STLineS2 '.s:style(bc06, fc02, '')

	" Statusline S3
	exec 'highlight STLineS3_N '.s:style(bc05, fc02, '')
	exec 'highlight STLineS3_I '.s:style(bc05, fc02, '')
	exec 'highlight STLineS3_V '.s:style(bc05, fc02, '')
	exec 'highlight STLineS3_R '.s:style(bc05, fc02, '')

	" Statusline S4
	exec 'highlight STLineS4 '.s:style(bc07, fc01, '')

"=======================================================================================================
" Tabline
"=======================================================================================================
	exec 'highlight STLineCur	 '.s:style(bc01, fc01, '')
	exec 'highlight STLineCurMod '.s:style(bc01, fc01, 'bold')
	exec 'highlight STLineNml	 '.s:style(bc05, fc02, '')
	exec 'highlight STLineNmlMod '.s:style(bc05, fc02, 'bold')
endfunction