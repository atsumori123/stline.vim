if exists('g:loaded_stline')
	finish
endif
let g:loaded_stline = 1

augroup stline_events
	autocmd!
	autocmd VimEnter,ColorScheme * call stline#generate_highlight_groups()
	autocmd WinEnter,BufWinEnter * call stline#statusline(v:true)
	autocmd WinLeave             * call stline#statusline(v:false)
	autocmd BufWritePost         * call stline#update_statusline()

	autocmd TabEnter             * call stline#tabline_update()
	autocmd BufAdd               * call stline#tabline_update()
	autocmd BufDelete            * call stline#tabline_update()
augroup END

for s:n in range(1, 10)
	execute printf("noremap <silent> <Plug>STLine.Go(%d) :<C-U>exe 'b'.get(stline#get_user_buffers(),%d,'')<cr>", s:n, s:n-1)
endfor
unlet! s:n
