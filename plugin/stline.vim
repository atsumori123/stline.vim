if exists('g:loaded_stline')
	finish
endif
let g:loaded_stline = 1

augroup stline_events
	autocmd!
	autocmd ColorScheme          * call stline#generate_highlight_groups()
"	autocmd VimEnter,ColorScheme * call stline#generate_highlight_groups()
	autocmd WinEnter,BufWinEnter * call stline#statusline(v:true)
	autocmd WinLeave             * call stline#statusline(v:false)
	autocmd BufWritePost         * call stline#update_statusline()

	autocmd VimEnter             * call stline#tabline_update()
	autocmd TabEnter             * call stline#tabline_update()
	autocmd BufAdd               * call stline#tabline_update()
	autocmd FileType            qf call stline#tabline_update()
	autocmd BufDelete            * call stline#tabline_update()
augroup END
