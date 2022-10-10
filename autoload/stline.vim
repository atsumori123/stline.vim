let s:modes = {
  \  'n':      [' NORMAL '  , '%#STLineNormal#' , '%#STLineNormalRev#'],
  \  'i':      [' INSERT '  , '%#STLineInsert#' , '%#STLineInsertRev#'],
  \  'r':      [' REPLACE  ', '%#STLineReplace#', '%#STLineReplaceRev#'],
  \  'v':      [' VISUAL '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  'V':      [' V-LINE '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  "\<C-v>": [' V-BLOCK ' , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  'c':      [' COMMAND ' , '%#STLineCommand#', '%#STLineCommandRev#'],
  \  's':      [' SELECT '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  'S':      [' S-LINE '  , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  "\<C-s>": [' S-BLOCK ' , '%#STLinevisual#' , '%#STLineVisualRev#'],
  \  't':      [' TERMINAL ', '%#STLineNormal#' , '%#STLineNormalRev#'],
  \}

"===========================================================
" Utilities
"===========================================================
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
	return len(git_branch_name) ? '  '.git_branch_name : ''
endfunction

"---------------------------------------------------------------
" stline#plugins_status
"---------------------------------------------------------------
function! stline#plugins_status() abort
    let l:status = ''
    let l:errors = 0
    let l:warnings = 0

    " Display errors and warnings from any of the previous diagnostic or linting
    " systems.
    if l:errors > 0 && l:warnings > 0
        let l:status .= ' %#MistflyDiagnosticError#' . g:stlineErrorSymbol
        let l:status .= ' ' . l:errors . '%* %#MistflyDiagnosticWarning#'
        let l:status .= g:stlineWarningSymbol. ' ' . l:warnings . '%* '
    elseif l:errors > 0
        let l:status .= ' %#MistflyDiagnosticError#' . g:stlineErrorSymbol
        let l:status .= ' ' . l:errors . '%* '
    elseif l:warnings > 0
        let l:status .= ' %#MistflyDiagnosticWarning#' . g:stlineWarningSymbol
        let l:status .= ' ' . l:warnings . '%* '
    endif

    return l:status
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

		" Git branch
		let git_branch = s:get_git_branch()
		if len(git_branch) > 0
			let statusline .= '%#STLineInfo#'
			let statusline .= git_branch.' %*'
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
		let statusline .= ' %p%%  %l/%L :%c %*'
      
		" warnning
		let lnum = search('[\t| ]$', 'nw')
		if lnum
			let statusline .= s:get_highlight_from_mode(mode, 1)
			let statusline .= ' ('.lnum.') %*'
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
" stline#no_file_statusline
"---------------------------------------------------------------
function! stline#no_file_statusline() abort
    return pathshorten(fnamemodify(getcwd(), ':~:.'))
endfunction

"---------------------------------------------------------------
" stline#statusline
"---------------------------------------------------------------
function! stline#statusline(active) abort
    if &buftype ==# 'nofile' || &filetype ==# 'netrw'
        " Likely a file explorer or some other special type of buffer. Set a
        " blank statusline for these types of buffers.
        setlocal statusline=%!stline#NoFileStatusLine()
        if g:stlineWinBar && exists('&winbar')
            setlocal winbar=
        endif

    elseif &buftype ==# 'nowrite'
        " Don't set a custom status line for certain special windows.
        return

    elseif a:active == v:true
		echo localtime()
        setlocal statusline=%!stline#active_statusline()

    elseif a:active == v:false
        setlocal statusline=%!stline#inactive_statusline()
    endif
endfunction

"===========================================================
" stline#generate_highlight_groups
"===========================================================
function! stline#generate_highlight_groups() abort
    exec 'highlight STLineNormal  ctermbg=17   ctermfg=white'
    exec 'highlight STLineInsert  ctermbg=28   ctermfg=white'
    exec 'highlight STLineVisual  ctermbg=128  ctermfg=white'
    exec 'highlight STLineCommand ctermbg=17   ctermfg=white'
    exec 'highlight STLineReplace ctermbg=202  ctermfg=white'
    exec 'highlight STLineInfo    ctermbg=239  ctermfg=252'

    exec 'highlight STLineNormalRev  ctermbg=237 ctermfg=33'
    exec 'highlight STLineInsertRev  ctermbg=237 ctermfg=41'
    exec 'highlight STLineVisualRev  ctermbg=237 ctermfg=171'
    exec 'highlight STLineCommandRev ctermbg=237 ctermfg=33'
    exec 'highlight STLineReplaceRev ctermbg=237 ctermfg=172'
endfunction

"===========================================================
" Git utilities
"===========================================================

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
