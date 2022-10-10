if exists('g:loaded_stline')
	finish
endif
let g:loaded_stline = 1

augroup stline_events
    autocmd!
    autocmd VimEnter             * call stline#generate_highlight_groups()
    autocmd WinEnter,BufWinEnter * call stline#statusline(v:true)
    autocmd WinLeave             * call stline#statusline(v:false)
	autocmd BufWritePost         * call stline#update_statusline()
augroup END
