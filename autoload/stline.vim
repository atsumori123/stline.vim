"===============================================================
" Reference plugins
"
" tabline:
" https://github.com/ap/vim-buftabline
"
" statusline:
" https://github.com/bluz71/vim-mistfly-statusline
"
" git branch name:
" https://github.com/itchyny/vim-gitbranch
"===============================================================

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
	let git_branch_name = s:GitBranchName()
	return len(git_branch_name) ? ' '.git_branch_name : ''
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
		let statusline .= '%=%*'

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

"   ---------------------------------------------------------------
" stline#inactive_statusline
"---------------------------------------------------------------
function! stline#inactive_statusline() abort
	let statusline  = ' %*%<%F %m'
	let statusline .= "%{&readonly?'[RO]' : ''}"
	let statusline .= ' %=%p%% %l/%L :%c '
    return statusline
endfunction

"---------------------------------------------------------------
" stline#statusline
"---------------------------------------------------------------
function! stline#statusline(active) abort
	if a:active == v:true
		setlocal statusline=%!stline#active_statusline()
	else
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
"	let centerbuf = s:centerbuf " prevent tabline jumping around when non-user buffer current (e.g. help)
	let lft = { 'lasttab':  0, 'cut':  '.', 'indicator': '<', 'width': 0, 'half': &columns / 2 }
	let rgt = { 'lasttab': -1, 'cut': '.$', 'indicator': '>', 'width': 0, 'half': &columns - lft.half }
	let currentside = lft

	let tabs = []
	let currentbuf = winbufnr(0)
	let screen_num = 0
	for bufnum in bufnums
		let screen_num += 1
		let bufpath = bufname(bufnum)
		let tab = {}
		let tab.hl  = currentbuf == bufnum ? 'C' : 'N'
		let tab.hl .= getbufvar(bufnum, '&mod') ? 'M' : ''
		let tab.label  = lpad.screen_num
		let tab.label .= strlen(bufpath) ? ' '.fnamemodify(bufpath, ':t') : ' [No Name]'
		let tab.width  = strwidth(tab.label) + 1
		let tab.label  = substitute(strtrans(tab.label), '%', '%%', 'g').' '
		let tabs += [tab]

		if currentbuf == bufnum
"			let [centerbuf, s:centerbuf] = [bufnum, bufnum]
			let lft.width = tab.width / 2
			let rgt.width = tab.width - lft.width
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
	set guioptions-=e
	set showtabline=2
	set tabline=%!stline#tabline()
endfunction

"---------------------------------------------------------------
" stline#generate_highlight_groups
"---------------------------------------------------------------
function! stline#generate_highlight_groups() abort
	if has_key(g:, 'stline_theme')
		exe "ru autoload/themes/".g:stline_theme.".vim"
		if !exists('*themes#{g:stline_theme}#hi')
			exe "ru autoload/themes/default.vim"
			let g:stline_theme = 'default'
		endif
	endif
	call themes#{g:stline_theme}#hi()
endfunction

"===============================================================
" Git utilities
"===============================================================

" The following Git branch name functionality derives from:
"   https://github.com/itchyny/vim-gitbranch
"
" MIT Licensed Copyright (c) 2014-2017 itchyny
"
function! s:GitBranchName() abort
	if get(b:, 'gitbranch_pwd', '') !=# expand('%:p:h') || !has_key(b:, 'gitbranch_path')
		call s:GitDetect()
	endif

	if has_key(b:, 'gitbranch_path') && filereadable(b:gitbranch_path)
		let l:branchDetails = get(readfile(b:gitbranch_path), 0, '')
		if l:branchDetails =~# '^ref: '
			return substitute(l:branchDetails, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', '', '')
		elseif l:branchDetails =~# '^\x\{20\}'
			return l:branchDetails[:6]
		endif
	endif

	return ''
endfunction

function! s:GitDetect() abort
	unlet! b:gitbranch_path
	let b:gitbranch_pwd = expand('%:p:h')
	let l:dir = s:GitDir(b:gitbranch_pwd)

	if l:dir !=# ''
		let l:path = l:dir . '/HEAD'
		if filereadable(l:path)
			let b:gitbranch_path = l:path
		endif
	endif
endfunction

function! s:GitDir(path) abort
	let l:path = a:path
	let l:prev = ''

	while l:path !=# prev
		let l:dir = path . '/.git'
		let l:type = getftype(l:dir)
		if l:type ==# 'dir' && isdirectory(l:dir . '/objects')
					\ && isdirectory(l:dir . '/refs')
					\ && getfsize(l:dir . '/HEAD') > 10
			" Looks like we found a '.git' directory.
			return l:dir
		elseif l:type ==# 'file'
			let l:reldir = get(readfile(l:dir), 0, '')
			if l:reldir =~# '^gitdir: '
				return simplify(l:path . '/' . l:reldir[8:])
			endif
		endif
		let l:prev = l:path
		" Go up a directory searching for a '.git' directory.
		let path = fnamemodify(l:path, ':h')
	endwhile

	return ''
endfunction

