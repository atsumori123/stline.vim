function! themes#gruvbit#hi() abort
	let cg = has('unix') ? "cterm" : "gui"
	let bc01 = {"cterm" : "0 " , "gui" : "black"}
	let bc02 = {"cterm" : "208", "gui" : "#fe8019"}
	let bc05 = {"cterm" : "235", "gui" : "#303030"}
	let bc06 = {"cterm" : "237", "gui" : "#484848"}
	let bc07 = {"cterm" : "222", "gui" : "moccasin"}

	let fc01 = {"cterm" : "247", "gui" : "#83A598"}
	let fc02 = {"cterm" : "12" , "gui" : "#61AFEF"}
	let fc03 = {"cterm" : "207", "gui" : "#C678DD"}
	let fc04 = {"cterm" : "172", "gui" : "#E06C75"}
	let fc05 = {"cterm" : "247", "gui" : "darkgray"}
	let fc06 = {"cterm" : "0"  , "gui" : "black"}
	let fc07 = {"cterm" : "255", "gui" : "white"}
	let fc08 = {"cterm" : "0"  , "gui" : "black"}


"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt                            | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |   S1   |   S2   |          S3                                   |     S2     |     S1      | S4  |
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec "highlight STLineS1_N ".cg."bg=".bc01[cg]." ".cg."fg=".fc01[cg]." ".cg."=bold"
	exec "highlight STLineS1_I ".cg."bg=".bc01[cg]." ".cg."fg=".fc02[cg]." ".cg."=bold"
	exec "highlight STLineS1_V ".cg."bg=".bc01[cg]." ".cg."fg=".fc03[cg]." ".cg."=bold"
	exec "highlight STLineS1_R ".cg."bg=".bc01[cg]." ".cg."fg=".fc04[cg]." ".cg."=bold"

	" Statusline S2
	exec "highlight STLineS2 ".cg."bg=".bc06[cg]." ".cg."fg=".fc05[cg]

	" Statusline S3
	exec "highlight STLineS3_N ".cg."bg=".bc05[cg]." ".cg."fg=".fc01[cg]
	exec "highlight STLineS3_I ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]
	exec "highlight STLineS3_V ".cg."bg=".bc05[cg]." ".cg."fg=".fc03[cg]
	exec "highlight STLineS3_R ".cg."bg=".bc05[cg]." ".cg."fg=".fc04[cg]

	" Statusline S4
	exec "highlight STLineS4 ".cg."bg=".bc07[cg]." ".cg."fg=".fc06[cg]

"=======================================================================================================
" Tabline
"=======================================================================================================
	exec "highlight STLineCur    ".cg."bg=".bc02[cg]." ".cg."fg=".fc08[cg]
	exec "highlight STLineCurMod ".cg."bg=".bc02[cg]." ".cg."fg=".fc08[cg]." ".cg."=bold"
	exec "highlight STLineNml    ".cg."bg=".bc05[cg]." ".cg."fg=".fc01[cg]
	exec "highlight STLineNmlMod ".cg."bg=".bc05[cg]." ".cg."fg=".fc01[cg]." ".cg."=bold"
endfunction

