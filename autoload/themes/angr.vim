function! themes#angr#hi() abort
	exec 'highlight STLineNML   ctermbg=17  ctermfg=255 cterm=bold guibg=#90AE74          guifg=#3D3D3D gui=bold'
	exec 'highlight STLineINS   ctermbg=22  ctermfg=255 cterm=bold guibg=#7E9DBC          guifg=#3D3D3D gui=bold'
	exec 'highlight STLineVIS   ctermbg=134 ctermfg=255 cterm=bold guibg=#B395B3          guifg=#3D3D3D gui=bold'
	exec 'highlight STLineREP   ctermbg=202 ctermfg=255 cterm=bold guibg=#C88686          guifg=#3D3D3D gui=bold'

	exec 'highlight STLineWRN   ctermbg=17  ctermfg=255            guibg=#E5C07B          guifg=#3D3D3D'
	exec 'highlight STLineINF   ctermbg=237 ctermfg=255            guibg=#505050          guifg=#AAAAAA'

	exec 'highlight STLineNML_R ctermbg=235 ctermfg=26             guibg=#303030          guifg=#90AE74'
	exec 'highlight STLineINS_R ctermbg=235 ctermfg=34             guibg=#303030          guifg=#7E9DBC'
	exec 'highlight STLineVIS_R ctermbg=235 ctermfg=171            guibg=#303030          guifg=#B395B3'
	exec 'highlight STLineREP_R ctermbg=235 ctermfg=172            guibg=#303030          guifg=#C88686'

	exec 'highlight STLineC     ctermbg=17  ctermfg=255            guibg=#90AE74          guifg=#3D3D3D'
	exec 'highlight STLineN     ctermbg=235 ctermfg=255            guibg=#303030          guifg=#9199A2'
	exec 'highlight STLineCM    ctermbg=17  ctermfg=134            guibg=#7E9DBC          guifg=#3D3D3D'
	exec 'highlight STLineNM    ctermbg=235 ctermfg=134            guibg=#303030          guifg=lightskyblue'
endfunction
