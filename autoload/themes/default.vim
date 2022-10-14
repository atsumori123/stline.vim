function! themes#default#hi() abort
	exec 'highlight STLineNML   ctermbg=17  ctermfg=255 cterm=bold guibg=midnightblue     guifg=lightskyblue gui=bold'
	exec 'highlight STLineNML   ctermbg=0   ctermfg=255 cterm=bold guibg=midnightblue     guifg=lightskyblue gui=bold'
	exec 'highlight STLineINS   ctermbg=22  ctermfg=255 cterm=bold guibg=darkgreen        guifg=palegreen    gui=bold'
	exec 'highlight STLineVIS   ctermbg=134 ctermfg=255 cterm=bold guibg=mediumvioletred  guifg=pink         gui=bold'
	exec 'highlight STLineREP   ctermbg=202 ctermfg=255 cterm=bold guibg=tomato           guifg=mistyrose    gui=bold'

	exec 'highlight STLineWRN   ctermbg=17  ctermfg=255            guibg=pink             guifg=red'
	exec 'highlight STLineINF   ctermbg=237 ctermfg=255            guibg=#505050          guifg=white'

	exec 'highlight STLineNML_R ctermbg=235 ctermfg=26             guibg=#303030          guifg=royalblue'
	exec 'highlight STLineINS_R ctermbg=235 ctermfg=34             guibg=#303030          guifg=mediumseagreen'
	exec 'highlight STLineVIS_R ctermbg=235 ctermfg=171            guibg=#303030          guifg=hotpink'
	exec 'highlight STLineREP_R ctermbg=235 ctermfg=172            guibg=#303030          guifg=coral'

	exec 'highlight STLineC     ctermbg=17  ctermfg=255            guibg=midnightblue     guifg=white'
	exec 'highlight STLineN     ctermbg=235 ctermfg=255            guibg=#303030          guifg=white'
	exec 'highlight STLineCM    ctermbg=17  ctermfg=134            guibg=midnightblue     guifg=lightskyblue'
	exec 'highlight STLineNM    ctermbg=235 ctermfg=134            guibg=#303030          guifg=lightskyblue'
endfunction
