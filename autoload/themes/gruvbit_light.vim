function! s:style(bg, fg, opt) abort
	let style = "ctermbg=".a:bg[0]." ctermfg=".a:fg[0]." guibg=".a:bg[1]." guifg=".a:fg[1]
	if !empty(a:opt) | let style .= " cterm=".a:opt." gui=".a:opt | endif
	return style
endfunction

function! themes#gruvbit_light#hi() abort
	let bc01 = ["229", "#fbf1c7" ]
	let bc02 = ["223", "#ebdbb2" ]
	let bc03 = ["250", "#d5c4a1" ]
	let bc04 = ["243", "#7c6f64" ]
	let bc05 = ["24" , "#076678" ]
	let bc07 = ["2"  , "DarkGreen" ]
	let bc08 = ["88" , "#9d0006" ]

	let fc02 = ["243", "#7c6f64" ]
	let fc03 = ["229", "#fbf1c7" ]
	let fc04 = ["24" , "#076678" ]
	let fc08 = ["246", "#a89984" ]

"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt                            | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |   S1   |   S2   |          S3                                   |     S2     |     S1      | S4  |
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec 'highlight STLineS1_N '.s:style(bc04, fc03, 'bold')
	exec 'highlight STLineS1_I '.s:style(bc05, fc03, 'bold')
	exec 'highlight STLineS1_V '.s:style(bc07, fc03, 'bold')
	exec 'highlight STLineS1_R '.s:style(bc08, fc03, 'bold')

	" Statusline S2
	exec 'highlight STLineS2 '.s:style(bc03, fc02, '')

	" Statusline S3
	exec 'highlight STLineS3_N '.s:style(bc02, fc02, '')
	exec 'highlight STLineS3_I '.s:style(bc02, fc02, '')
	exec 'highlight STLineS3_V '.s:style(bc02, fc02, '')
	exec 'highlight STLineS3_R '.s:style(bc02, fc02, '')

	" Statusline S4
	exec 'highlight STLineS4 '.s:style(bc05, fc03, '')

"=======================================================================================================
" Tabline
"=======================================================================================================
	exec 'highlight STLineCur	 '.s:style(bc04, fc03, '')
	exec 'highlight STLineCurMod '.s:style(bc04, fc03, 'bold')
	exec 'highlight STLineNml	 '.s:style(bc03, fc02, '')
	exec 'highlight STLineNmlMod '.s:style(bc03, fc04, '')
endfunction

