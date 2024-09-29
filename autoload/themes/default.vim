function! s:style(bg, fg, opt) abort
	let style = "ctermbg=".a:bg[0]." ctermfg=".a:fg[0]." guibg=".a:bg[1]." guifg=".a:fg[1]
	if !empty(a:opt) | let style .= " cterm=".a:opt." gui=".a:opt | endif
	return style
endfunction

function! themes#default#hi() abort
	let bc01 = ["17" , "midnightblue"   ]
	let bc02 = ["23" , "darkgreen"      ]
	let bc03 = ["163", "mediumvioletred"]
	let bc04 = ["166", "tomato"         ]
	let bc05 = ["235", "#303030"        ]
	let bc06 = ["237", "#505050"        ]
	let bc07 = ["222", "moccasin"       ]

	let fc01 = ["27" , "blue"           ]
	let fc02 = ["36" , "mediumseagreen" ]
	let fc03 = ["207", "hotpink"        ]
	let fc04 = ["172", "coral"          ]
	let fc05 = ["251", "silver"         ]
	let fc06 = ["0"  , "black"          ]
	let fc07 = ["134", "lightskyblue"   ]
	let fc08 = ["251", "silver"         ]

"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt                            | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |   S1   |   S2   |          S3                                   |     S2     |     S1      | S4  |
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec 'highlight STLineS1_N '.s:style(bc01, fc05, 'bold')
	exec 'highlight STLineS1_I '.s:style(bc02, fc05, 'bold')
	exec 'highlight STLineS1_V '.s:style(bc03, fc05, 'bold')
	exec 'highlight STLineS1_R '.s:style(bc04, fc05, 'bold')

	" Statusline S2
	exec 'highlight STLineS2 '.s:style(bc06, fc08, '')

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
	exec 'highlight STLineCur	 '.s:style(bc01, fc05, '')
	exec 'highlight STLineCurMod '.s:style(bc01, fc07, '')
	exec 'highlight STLineNml	 '.s:style(bc05, fc05, '')
	exec 'highlight STLineNmlMod '.s:style(bc05, fc07, '')
endfunction
