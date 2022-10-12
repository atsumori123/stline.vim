let s:modes = {
  \  'n':      [' NORMAL '  , '%#STLineNormal#' , '%#STLineNormalR#'],
  \  'i':      [' INSERT '  , '%#STLineInsert#' , '%#STLineInsertR#'],
  \  'r':      [' REPLACE ' , '%#STLineReplace#', '%#STLineReplaceR#'],
  \  'v':      [' VISUAL '  , '%#STLineVisual#' , '%#STLineVisualR#'],
  \  'V':      [' V-LINE '  , '%#STLineVisual#' , '%#STLineVisualR#'],
  \  "\<C-v>": [' V-BLOCK ' , '%#STLineVisual#' , '%#STLineVisualR#'],
  \  'c':      [' COMMAND ' , '%#STLineNormal#' , '%#STLineNormalR#'],
  \  's':      [' SELECT '  , '%#STLineVisual#' , '%#STLineVisualR#'],
  \  'S':      [' S-LINE '  , '%#STLineVisual#' , '%#STLineVisualR#'],
  \  "\<C-s>": [' S-BLOCK ' , '%#STLineVisual#' , '%#STLineVisualR#'],
  \  't':      [' TERMINAL ', '%#STLineNormal#' , '%#STLineNormalR#'],
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
		let statusline .= ' %{&fileencoding}[%{&fileformat}] %*'

		" line. column
		let statusline .= s:get_highlight_from_mode(mode, 0)
		let statusline .= ' %p%% %l/%L :%c %*'

		" warnning
"		if has_key(b:, 'tail_space') && b:tail_space
		let tail_space = s:get_warnning_tail_space()
		if tail_space
			let statusline .= '%#STLineWarn#'
			let statusline .= ' ['.tail_space.'] %*'
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

"---------------------------------------------------------------
" s:get_user_buffers
"---------------------------------------------------------------
function! s:get_user_buffers() abort
	return filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
endfunction

"---------------------------------------------------------------
" stline#tabline
"---------------------------------------------------------------
let s:centerbuf = winbufnr(0)
function! stline#tabline() abort
	let lpad    = '| '
	let bufnums = s:get_user_buffers()
	let centerbuf = s:centerbuf " prevent tabline jumping around when non-user buffer current (e.g. help)

	let tabs = []
	let currentbuf = winbufnr(0)
	let screen_num = 0
	for bufnum in bufnums
		let screen_num += 1
		if currentbuf == bufnum | let [centerbuf, s:centerbuf] = [bufnum, bufnum] | endif

		let tab = {}
		let tab.number  = bufnum
		let tab.hilite  = getbufvar(bufnum, '&mod') ? 'Modified' : ''
		let tab.hilite .= currentbuf == bufnum ? 'Current' : 'Active'
		let bufpath = bufname(bufnum)
		let tab.label  = screen_num
		let tab.label .= strlen(bufpath) ? ' '.fnamemodify(bufpath, ':t') : '[No Name]'
		let tabs += [tab]
	endfor

	" 1. setup
	let lft = { 'lasttab':  0, 'cut':  '.', 'indicator': '<', 'width': 0, 'half': &columns / 2 }
	let rgt = { 'lasttab': -1, 'cut': '.$', 'indicator': '>', 'width': 0, 'half': &columns - lft.half }

	" 2. sum the string lengths for the left and right halves
	let currentside = lft
	let lpad_width = strwidth(lpad)
	for tab in tabs
		let tab.width = lpad_width + strwidth(tab.label) + 1
		let tab.label = lpad.substitute(strtrans(tab.label), '%', '%%', 'g').' '
		if centerbuf == tab.number
			let halfwidth = tab.width / 2
			let lft.width += halfwidth
			let rgt.width += tab.width - halfwidth
			let currentside = rgt
		else
			let currentside.width += tab.width
		endif
	endfor
	if currentside is lft " centered buffer not seen?
		" then blame any overflow on the right side, to protect the left
		let [lft.width, rgt.width] = [0, lft.width]
	endif

	" 3. toss away tabs and pieces until all fits:
	if (lft.width + rgt.width) > &columns
		let oversized
			\ = lft.width < lft.half ? [ [ rgt, &columns - lft.width ] ]
			\ : rgt.width < rgt.half ? [ [ lft, &columns - rgt.width ] ]
			\ :                        [ [ lft, lft.half ], [ rgt, rgt.half ] ]
		for [side, budget] in oversized
			let delta = side.width - budget
			" toss entire tabs to close the distance
			while delta >= tabs[side.lasttab].width
				let delta -= remove(tabs, side.lasttab).width
			endwhile
			" then snip at the last one to make it fit
			let endtab = tabs[side.lasttab]
			while delta > (endtab.width - strwidth(strtrans(endtab.label)))
				let endtab.label = substitute(endtab.label, side.cut, '', '')
			endwhile
			let endtab.label = substitute(endtab.label, side.cut, side.indicator, '')
		endfor
	endif

	if len(tabs) | let tabs[0].label = substitute(tabs[0].label, lpad, ' ', '') | endif
	let swallowclicks = '%'.(1 + tabpagenr('$')).'X'
	return swallowclicks.join(map(tabs,'"%#STLine".v:val.hilite."#".strtrans(v:val.label)'),'').'%#STLineFill#'
endfunction

"---------------------------------------------------------------
" stline#tabline
"---------------------------------------------------------------
function! stline#tabline_update()
"	set guioptions-=e
	set showtabline=2
	set tabline=%!stline#tabline()
endfunction

"===========================================================
" stline#generate_highlight_groups
"===========================================================
function! stline#generate_highlight_groups() abort
	exec 'highlight STLineNormal     ctermbg=17  ctermfg=white cterm=bold guibg=midnightblue     guifg=lightskyblue gui=bold'
	exec 'highlight STLineInsert     ctermbg=22  ctermfg=white cterm=bold guibg=darkgreen        guifg=palegreen    gui=bold'
	exec 'highlight STLineVisual     ctermbg=134 ctermfg=white cterm=bold guibg=mediumvioletred  guifg=pink         gui=bold'
	exec 'highlight STLineReplace    ctermbg=202 ctermfg=white cterm=bold guibg=tomato           guifg=mistyrose    gui=bold'

	exec 'highlight STLineWarn       ctermbg=17  ctermfg=white            guibg=pink             guifg=red'
	exec 'highlight STLineInfo       ctermbg=237 ctermfg=255              guibg=#505050          guifg=white'

	exec 'highlight STLineNormalR  ctermbg=235 ctermfg=26               guibg=#303030          guifg=royalblue'
	exec 'highlight STLineInsertR  ctermbg=235 ctermfg=34               guibg=#303030          guifg=mediumseagreen'
	exec 'highlight STLineVisualR  ctermbg=235 ctermfg=171              guibg=#303030          guifg=hotpink'
	exec 'highlight STLineReplaceR ctermbg=235 ctermfg=172              guibg=#303030          guifg=coral'

	exec 'highlight STLineCurrent     ctermbg=17  ctermfg=255'
	exec 'highlight STLineActive      ctermbg=235 ctermfg=255'
	exec 'highlight STLineFill        ctermbg=235'
	exec 'highlight STLineModifiedCurrent ctermbg=17  ctermfg=134'
	exec 'highlight STLineModifiedActive ctermbg=235 ctermfg=134'
endfunction

