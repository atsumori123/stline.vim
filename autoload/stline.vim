let s:modes = {
  \  'n':      ['  NORMAL  '  , '%#STLineNormal#' , '%#STLineNormalRev#'],
  \  'i':      ['  INSERT  '  , '%#STLineInsert#' , '%#STLineInsertRev#'],
  \  'r':      ['  REPLACE   ', '%#STLineReplace#', '%#STLineReplaceRev#'],
  \  'v':      ['  VISUAL  '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  'V':      ['  V-LINE  '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  "\<C-v>": ['  V-BLOCK  ' , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  'c':      ['  COMMAND  ' , '%#STLineNormal#' , '%#STLineNormalRev#'],
  \  's':      ['  SELECT  '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  'S':      ['  S-LINE  '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  "\<C-s>": ['  S-BLOCK  ' , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  't':      ['  TERMINAL  ', '%#STLineNormal#' , '%#STLineNormalRev#'],
  \}

"---------------------------------------------------------------
" get_highlight_from_mode
"---------------------------------------------------------------
function! s:get_highlight_from_mode(mode, reverse) abort
    return get(s:modes, a:mode, s:modes['n'])[a:reverse==0 ? 1 : 2]
endfunction

"---------------------------------------------------------------
" get_git_branch
"---------------------------------------------------------------
function! s:get_git_branch() abort
"	if !exists('*fugitive#statusline') | return '' | endif
	let branch = fugitive#statusline()
	return len(branch) ? '  '.branch[5:-3] : ''
endfunction

"---------------------------------------------------------------
" get_tail_space
"---------------------------------------------------------------
function! s:get_warnning_tail_space() abort
	if !has_key(b:, 'tail_space')
		call stline#update_statusline()
	endif
	return b:tail_space
endfunction

"---------------------------------------------------------------
" stline#active_statusline
"---------------------------------------------------------------
function! stline#active_statusline() abort
	let mode = mode()
	if mode !=# 't'
		" NORMAL/INSERT/VISUAL ...
		let statusline = s:get_highlight_from_mode(mode, 0)
		let statusline .= get(s:modes, mode, s:modes['n'])[0]
		let statusline .= '%*'

		" git branch
		let git_branch = s:get_git_branch()
		if len(git_branch)
   				let statusline .= '%#STLineInfo#'
				let statusline .= git_branch.' %+'
		endif

		" filename, modify, readonly
		let statusline .= s:get_highlight_from_mode(mode, 1)
		let statusline .= ' %<%F %m'."%{&readonly ? '[RO]' : ''}"

		" filetype
		let statusline .= '%=%y %*'

		" fileencoding, fileformat
		let statusline .= '%#STLineInfo#'
		let statusline .= '  %{&fileencoding}[%{&fileformat}]  %*'

		" line. column
		let statusline .= s:get_highlight_from_mode(mode, 0)
		let statusline .= '  %p%%  %l/%L :%c %*'

		" warnning
"		if has_key(b:, 'tail_space') && b:tail_space
		let tail_space = s:get_warnning_tail_space()
		if tail_space
			let statusline .= '%#STLineWarn#'
			let statusline .= ' ('.tail_space.') %*'
		endif
	else
		" NORMAL/INSERT/VISUAL ...
		let statusline = s:get_highlight_from_mode(mode, 0)
		let statusline .= s:modes['t'][0]
		let statusline .= '%*'

		" filename, modify, readonly
		let statusline .= s:get_highlight_from_mode(mode, 1)
		let statusline .= ' %<'
		let statusline .= expand('%:t')
		let statusline .= '%=%*'
	endif
    return statusline
endfunction

"---------------------------------------------------------------
" stline#inactive_statusline
"---------------------------------------------------------------
function! stline#inactive_statusline() abort
	let statusline = ' %*%<%F %m'
	let statusline .= "%{&readonly?'[RO]' : ''}"
	let statusline .= ' %p%%  %l/%L :%c '
    return statusline
endfunction

"---------------------------------------------------------------
" stline#statusline
"---------------------------------------------------------------
function! stline#statusline(active) abort
    if &buftype ==# 'nofile' || &filetype ==# 'netrw'
        return

    elseif &buftype ==# 'nowrite'
        " Don't set a custom status line for certain special windows.
        return

    elseif a:active == v:true
        setlocal statusline=%!stline#active_statusline()

    elseif a:active == v:false
        setlocal statusline=%!stline#inactive_statusline()
    endif
endfunction

"---------------------------------------------------------------
" stline#update_statusline
"---------------------------------------------------------------
function! stline#update_statusline() abort
	let b:tail_space = search('[\t| ]$', 'nw')
endfunction

"===========================================================
" stline#generate_highlight_groups
"===========================================================
function! stline#generate_highlight_groups() abort
    exec 'highlight STLineNormal     ctermbg=17  ctermfg=white cterm=bold guibg=midnightblue     guifg=lightskyblue gui=bold'
    exec 'highlight STLineInsert     ctermbg=28  ctermfg=white cterm=bold guibg=darkgreen        guifg=palegreen    gui=bold'
    exec 'highlight STLineVisual     ctermbg=128 ctermfg=white cterm=bold guibg=mediumvioletred  guifg=pink         gui=bold'
    exec 'highlight STLineReplace    ctermbg=202 ctermfg=white cterm=bold guibg=tomato           guifg=mistyrose    gui=bold'

    exec 'highlight STLineWarn       ctermbg=17  ctermfg=white            guibg=pink             guifg=red'
    exec 'highlight STLineInfo       ctermbg=239 ctermfg=252              guibg=#505050          guifg=white'

    exec 'highlight STLineNormalRev  ctermbg=237 ctermfg=33               guibg=#303030          guifg=royalblue'
    exec 'highlight STLineInsertRev  ctermbg=237 ctermfg=41               guibg=#303030          guifg=mediumseagreen'
    exec 'highlight STLineVisualRev  ctermbg=237 ctermfg=171              guibg=#303030          guifg=hotpink'
    exec 'highlight STLineReplaceRev ctermbg=237 ctermfg=172              guibg=#303030          guifg=coral'
endfunction

