function! themes#angr#hi() abort
	let cg = has('unix') ? "cterm" : "gui"
	let bc01 = {"cterm" : "17" , "gui" : "#90AE74"}
	let bc02 = {"cterm" : "23" , "gui" : "#7E9DBC"}
	let bc03 = {"cterm" : "163", "gui" : "#B395B3"}
	let bc04 = {"cterm" : "166", "gui" : "#C88686"}
	let bc05 = {"cterm" : "235", "gui" : "#303030"}
	let bc06 = {"cterm" : "237", "gui" : "#505050"}
	let bc07 = {"cterm" : "222", "gui" : "moccasin"}

	let fc01 = {"cterm" : "27" , "gui" : "#90AE74"}
	let fc02 = {"cterm" : "36" , "gui" : "#7E9DBC"}
	let fc03 = {"cterm" : "207", "gui" : "#B395B3"}
	let fc04 = {"cterm" : "172", "gui" : "#C88686"}
	let fc05 = {"cterm" : "251", "gui" : "#303030"}
	let fc06 = {"cterm" : "0"  , "gui" : "black"}
	let fc07 = {"cterm" : "134", "gui" : "#556b2f"}
	let fc08 = {"cterm" : "251", "gui" : "silver"}

"=======================================================================================================
" Statusline
"=======================================================================================================
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
"	 | NORMAL | master | /home/hogehoge.txt                            | utf-8[dos] | 10% 1/30 :1 | [3] |
"	 |   S1   |   S2   |          S3                                   |     S2     |     S1      | S4  |
"	 +--------+--------+-----------------------------------------------+------------+-------------+-----+
	" Statusline S1
	exec "highlight STLineS1_N ".cg."bg=".bc01[cg]." ".cg."fg=".fc05[cg]." ".cg."=bold"
	exec "highlight STLineS1_I ".cg."bg=".bc02[cg]." ".cg."fg=".fc05[cg]." ".cg."=bold"
	exec "highlight STLineS1_V ".cg."bg=".bc03[cg]." ".cg."fg=".fc05[cg]." ".cg."=bold"
	exec "highlight STLineS1_R ".cg."bg=".bc04[cg]." ".cg."fg=".fc05[cg]." ".cg."=bold"

	" Statusline S2
	exec "highlight STLineS2 ".cg."bg=".bc06[cg]." ".cg."fg=".fc08[cg]

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
	exec "highlight STLineCur    ".cg."bg=".bc01[cg]." ".cg."fg=".fc05[cg]
	exec "highlight STLineCurMod ".cg."bg=".bc02[cg]." ".cg."fg=".fc05[cg]
	exec "highlight STLineNml    ".cg."bg=".bc05[cg]." ".cg."fg=".fc08[cg]
	exec "highlight STLineNmlMod ".cg."bg=".bc05[cg]." ".cg."fg=".fc02[cg]
endfunction

function! themes#angr#hi2() abort
	exec 'highlight STLineNML   guibg=#90AE74          guifg=#3D3D3D gui=bold'
	exec 'highlight STLineINS   guibg=#7E9DBC          guifg=#3D3D3D gui=bold'
	exec 'highlight STLineVIS   guibg=#B395B3          guifg=#3D3D3D gui=bold'
	exec 'highlight STLineREP   guibg=#C88686          guifg=#3D3D3D gui=bold'

	exec 'highlight STLineWRN   guibg=#E5C07B          guifg=#3D3D3D'
	exec 'highlight STLineINF   guibg=#505050          guifg=#AAAAAA'

	exec 'highlight STLineNML_R guibg=#303030          guifg=#90AE74'
	exec 'highlight STLineINS_R guibg=#303030          guifg=#7E9DBC'
	exec 'highlight STLineVIS_R guibg=#303030          guifg=#B395B3'
	exec 'highlight STLineREP_R guibg=#303030          guifg=#C88686'

	exec 'highlight STLineC     guibg=#90AE74          guifg=#3D3D3D'
	exec 'highlight STLineN     guibg=#303030          guifg=#9199A2'
	exec 'highlight STLineCM    guibg=#7E9DBC          guifg=#3D3D3D'
	exec 'highlight STLineNM    guibg=#303030          guifg=lightskyblue'
endfunction
