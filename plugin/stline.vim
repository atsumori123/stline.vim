if exists('g:loaded_stline')
	finish
endif
let g:loaded_stline = 1

" The symbol used to indicate the presence of errors in the current buffer. By
" default the x character will be used.
let g:stlineErrorSymbol = get(g:, 'stlineErrorSymbol', 'x')

" The symbol used to indicate the presence of warnings in the current buffer. By
" default the exclamation symbol will be used.
let g:stlineWarningSymbol = get(g:, 'stlineWarningSymbol', '!')

" By default do not enable tabline support.
"let g:mistflyTabLine = get(g:, 'mistflyTabLine', v:false)

" By default do not enable Neovim's winbar support.
let g:stlineWinBar = get(g:, 'stlineWinBar', v:false)

"
" This is needed when starting Vim with multiple splits, for example 'vim -O
" file1 file2', otherwise all statuslines/winbars will be rendered as if they
" are active. Inactive statuslines/winbar are usually rendered via the WinLeave
" and BufLeave events, but those events are not triggered when starting Vim.
"
" Note - https://jip.dev/posts/a-simpler-vim-statusline/#inactive-statuslines
function! s:UpdateInactiveWindows() abort
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', '%!mistfly#InactiveStatusLine()')
            if g:mistflyWinBar && exists('&winbar') && winheight(0) > 1
                call setwinvar(winnum, '&winbar', '%!mistfly#InactiveWinBar()')
            endif
        endif
    endfor
endfunction

augroup stline_events
    autocmd!
    autocmd VimEnter,ColorScheme * call stline#generate_highlight_groups()
    autocmd VimEnter             * call s:UpdateInactiveWindows()
    autocmd WinEnter,BufWinEnter * call stline#statusline(v:true)
    autocmd WinLeave             * call stline#statusline(v:false)
augroup END
