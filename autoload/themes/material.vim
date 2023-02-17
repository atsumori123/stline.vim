function! themes#material#hi() abort
	let cg = (has('termguicolors') && &termguicolors) || has('gui_running') ? "gui" : "cterm"
	let bc01 = {"cterm" : "116", "gui" : "#80CBC4"}
	let bc02 = {"cterm" : "113", "gui" : "#8BD649"}
	let bc03 = {"cterm" : "171", "gui" : "#C792EA"}
	let bc04 = {"cterm" : "209", "gui" : "#f6937e"}
	let bc05 = {"cterm" : "238", "gui" : "#263238"}
	let bc06 = {"cterm" : "66" , "gui" : "#37474f"}
	let bc07 = {"cterm" : "222", "gui" : "moccasin"}

	let fc01 = {"cterm" : "0"  , "gui" : "Black"}
	let fc02 = {"cterm" : "255", "gui" : "white"}


"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt                            | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |   S1   |   S2   |          S3                                   |     S2     |     S1      | S4  |
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec "highlight STLineS1_N ".cg."bg=".bc01[cg]." ".cg."fg=".fc01[cg]." ".cg."=bold"
	exec "highlight STLineS1_I ".cg."bg=".bc02[cg]." ".cg."fg=".fc01[cg]." ".cg."=bold"
	exec "highlight STLineS1_V ".cg."bg=".bc03[cg]." ".cg."fg=".fc01[cg]." ".cg."=bold"
	exec "highlight STLineS1_R ".cg."bg=".bc04[cg]." ".cg."fg=".fc01[cg]." ".cg."=bold"

	" Statusline S2
	exec "highlight STLineS2 ".cg."bg=".bc06[cg]." ".cg."fg=".fc02[cg]

	" Statusline S3
	exec "highlight STLineS3_N ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]
	exec "highlight STLineS3_I ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]
	exec "highlight STLineS3_V ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]
	exec "highlight STLineS3_R ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]

	" Statusline S4
	exec "highlight STLineS4 ".cg."bg=".bc07[cg]." ".cg."fg=".fc01[cg]

"=======================================================================================================
" Tabline
"=======================================================================================================
	exec "highlight STLineCur    ".cg."bg=".bc01[cg]." ".cg."fg=".fc01[cg]
	exec "highlight STLineCurMod ".cg."bg=".bc01[cg]." ".cg."fg=".fc01[cg]." ".cg."=bold"
	exec "highlight STLineNml    ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]
	exec "highlight STLineNmlMod ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]." ".cg."=bold"
endfunction
