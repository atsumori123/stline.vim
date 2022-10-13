"https://github.com/ap/vim-buftabline
"

let s:modes = {
  \  'n':      [' NORMAL '  , '%#STLineNML#' , '%#STLineNML_R#'],
  \  'i':      [' INSERT '  , '%#STLineINS#' , '%#STLineINS_R#'],
  \  'r':      [' REPLACE ' , '%#STLineREP#' , '%#STLineREP_R#'],
  \  'v':      [' VISUAL '  , '%#STLineVIS#' , '%#STLineVIS_R#'],
  \  'V':      [' V-LINE '  , '%#STLineVIS#' , '%#STLineVIS_R#'],
  \  "\<C-v>": [' V-BLOCK ' , '%#STLineVIS#' , '%#STLineVIS_R#'],
  \  'c':      [' COMMAND ' , '%#STLineNML#' , '%#STLineNML_R#'],
  \  's':      [' SELECT '  , '%#STLineVIS#' , '%#STLineVIS_R#'],
  \  'S':      [' S-LINE '  , '%#STLineVIS#' , '%#STLineVIS_R#'],
  \  "\<C-s>": [' S-BLOCK ' , '%#STLineVIS#' , '%#STLineVIS_R#'],
  \  't':      [' TERMINAL ', '%#STLineNML#' , '%#STLineNML_R#'],
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
	return len(branch) ? ' '.branch[5:-3] : ''
endfunction

"---------------------------------------------------------------
" get_tail_space
"---------------------------------------------------------------
function! s:check_tail_space() abort
	if !has_key(b:, 'tail_space')
		call stline#update_statusline()
	endif
	return b:tail_space
endfunction

"---------------------------------------------------------------
" stlien#get_user_buffers
"---------------------------------------------------------------
function! stline#get_user_buffers() abort
	return filter(range(1, bufnr('$')), 'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
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
			let statusline .= '%#STLineINF#'
			let statusline .= git_branch.' %+'
		endif

		" filename, modify, readonly
		let statusline .= s:get_highlight_from_mode(mode, 1)
		let statusline .= ' %<%F %m'."%{&readonly ? '[RO]' : ''}"

		" filetype
		let statusline .= '%=%y %*'

		" fileencoding, fileformat
		let statusline .= '%#STLineINF#'
		let statusline .= ' %{&fileencoding}[%{&fileformat}] %*'

		" line. column
		let statusline .= s:get_highlight_from_mode(mode, 0)
		let statusline .= ' %p%% %l/%L :%c %*'

		" warnning
		let tail_space = s:check_tail_space()
		if tail_space
			let statusline .= '%#STLineWRN#'
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
	if &buftype ==# 'nofile' || &buftype ==# 'nowrite' || &filetype ==# 'netrw'
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
" stline#tabline
"---------------------------------------------------------------
let s:centerbuf = winbufnr(0)
function! stline#tabline() abort
	let lpad    = ' '
	let bufnums = stline#get_user_buffers()
	let centerbuf = s:centerbuf " prevent tabline jumping around when non-user buffer current (e.g. help)

	let tabs = []
	let currentbuf = winbufnr(0)
	let screen_num = 0
	for bufnum in bufnums
		let screen_num += 1
		let bufpath = bufname(bufnum)
		if currentbuf == bufnum
			let [centerbuf, s:centerbuf] = [bufnum, bufnum]
		endif
		let tab = {}
		let tab.hl  = currentbuf == bufnum ? 'C' : 'N'
		let tab.hl .= getbufvar(bufnum, '&mod') ? 'M' : ''
		let tab.label  = lpad.screen_num
		let tab.label .= strlen(bufpath) ? ' '.fnamemodify(bufpath, ':t') : '[No Name]'
		let tab.width  = strwidth(tab.label) + 1
		let tab.label  = substitute(strtrans(tab.label), '%', '%%', 'g').' '
		let tabs += [tab]
	endfor

	" 1. setup
	let lft = { 'lasttab':  0, 'cut':  '.', 'indicator': '<', 'width': 0, 'half': &columns / 2 }
	let rgt = { 'lasttab': -1, 'cut': '.$', 'indicator': '>', 'width': 0, 'half': &columns - lft.half }

	" 2. sum the string lengths for the left and right halves
	let currentside = lft
	let lpad_width = strwidth(lpad)
	for tab in tabs
		if tab.hl[0] == "C"
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

	if len(tabs)
		let tabs[0].label = substitute(tabs[0].label, lpad, ' ', '')
	endif

	let swallowclicks = '%'.(1 + tabpagenr('$')).'X'
	return swallowclicks.join(map(tabs,'"%#STLine".v:val.hl."#".strtrans(v:val.label)'),'').'%#STLineNML_R#'
endfunction

"---------------------------------------------------------------
" stline#tabline
"---------------------------------------------------------------
function! stline#tabline_update()
	set showtabline=2
	set tabline=%!stline#tabline()
endfunction

"===============================================================
" stline#generate_highlight_groups
"===============================================================
function! stline#generate_highlight_groups() abort
	exec 'highlight STLineNML   ctermbg=17  ctermfg=255 cterm=bold guibg=midnightblue     guifg=lightskyblue gui=bold'
	exec 'highlight STLineINS   ctermbg=22  ctermfg=255 cterm=bold guibg=darkgreen        guifg=palegreen    gui=bold'
	exec 'highlight STLineVIS   ctermbg=134 ctermfg=255 cterm=bold guibg=mediumvioletred  guifg=pink         gui=bold'
	exec 'highlight STLineREP   ctermbg=202 ctermfg=255 cterm=bold guibg=tomato           guifg=mistyrose    gui=bold'

	exec 'highlight STLineWRN   ctermbg=17  ctermfg=255            guibg=pink             guifg=red'
	exec 'highlight STLineINF   ctermbg=237 ctermfg=255            guibg=#505050          guifg=white'

	exec 'highlight STLineNML_R ctermbg=235 ctermfg=26             guibg=#303030          guifg=royalblue'
	exec 'highlight STLineINS_R ctermbg=235 ctermfg=34             guibg=#303030          guifg=mediumseagreen'
	exec 'highlight STLineVIS_R ctermbg=235 ctermfg=171            guibg=#303030          guifg=hotpink'
	exec 'highlight STLineREP_R ctermbg=235 ctermfg=172            guibg=#303030          guifg=coral'

	exec 'highlight STLineC     ctermbg=17  ctermfg=255'
	exec 'highlight STLineN     ctermbg=235 ctermfg=255'
	exec 'highlight STLineCM    ctermbg=17  ctermfg=134'
	exec 'highlight STLineNM    ctermbg=235 ctermfg=134'
endfunction

