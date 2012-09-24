" KEYBINDINGS
" I tend to stick to the following F keys for all languages :
"   F1 : Help page
"   F2 : Change colorscheme
"   F3 : Debug colorscheme
"   F4 : Clean and reformat automatically
"   F5 : Run the current file
"   F6 : Debug the file
"   F7 : Launch test files
"   F8 : Display hidden chars
"   F9 : Toggle wrap
"
" -----------------------------------------------------------------------------
" DEFAULT {{{
" Defining leader key
let mapleader=','
" Using the Space as a repeat key
nnoremap <Space> .
" }}}
" CAPS LOCK KEY {{{
" Note: Xmodmap maps Caps Lock to F13 ([25~)
" - Cancels autocomplete, search, command, visual
" - Toggle normal / insert mode
function! MultiPurposeCapsLock()
	return pumvisible() ? "\<C-E>" : "\<Esc>l"
endfunction
inoremap [25~ <C-R>=MultiPurposeCapsLock()<CR>
vnoremap [25~ <Esc>
cnoremap [25~ <C-C>
nnoremap [25~ i
" }}}
" TAB KEY {{{
" - Insert Tabs when at start of line, for indenting
" - Insert Spaces when after a space, for aligning
" - Maj-Tab always insert a Tab
" - Autocomplete words and autoselect first result
" - Cycle through autocomplete result, Maj-Tab to cycle backward
" - Default to buffer-based autocomplete
" - Use omnicomplete if defined or filepath if relevant
" - Indent text in normal and visual mode. Maj-Tab unindent
function! MultiPurposeTab(...)
	let isMaj = (a:0 > 0 && a:1 == 'Maj') ? 1 : 0

	" Autocomplete menu already open, we cycle through the results
	if pumvisible()
		return isMaj == 1 ? "\<C-P>" : "\<C-N>"
	endif

	" Maj-Tab is pressed, this always insert a Tab
	if isMaj == 1
		return "\<Tab>"
	endif

	" Cursor in indentation, keep indenting with simple Tab
	if (virtcol(".") - 1) <= indent(".")
		return "\<Tab>"
	endif

	let columnIndex = col(".")
	let line = getline(".")

	" Align with spaces afters chars that clearly can't be autocompleted
	let previousChar = strpart(line, columnIndex - 2, 1)
	let previousCharPatterns = ['\s', '"', "'", ",", "#"]
	for pattern in previousCharPatterns
		if previousChar =~ pattern
			let tabwidth = &softtabstop > 0 ? &softtabstop : &tabstop
			return repeat(" ", tabwidth - (columnIndex % tabwidth))
		endif
	endfor

	" If looks like a filepath, launch file name autocomplete
	if line =~ '.*/\w*\%' . columnIndex . 'c'
		return "\<C-X>\<C-F>\<C-N>"
	endif

	" Launch Omnicomplete if defined
	if &omnifunc != ''
		return "\<C-X>\<C-O>\<C-N>"
	endif

	" Launch buffer completion otherwise
	return "\<C-X>\<C-N>\<C-N>"
endfunction
inoremap <Tab> <C-R>=MultiPurposeTab()<CR>
inoremap <S-Tab> <C-R>=MultiPurposeTab('Maj')<CR>
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" }}}
" RETURN KEY {{{
" Note: Xmodmap maps Shift-Enter to Keypad Enter
" - Creates new lines below in all modes
" - Creates new lines above in all modes with Shift
" - Accept autocompletion suggestion
" - Trigger endwise completion
function! MultiPurposeReturn()
	return pumvisible() ? "\<C-Y>" : "\<CR>"
endfunction
inoremap <CR> <C-R>=MultiPurposeReturn()<CR>
inoremap <kEnter> <Esc>mzO<Esc>`za
nnoremap <CR> mzo<Esc>`z
nnoremap <kEnter> mzO<Esc>`z
vnoremap <CR> <Esc>g`>o<Esc>gv
vnoremap <kEnter> <Esc>g`<O<Esc>g
" }}}
" MOTIONS {{{
" Move down/up including wrapped lines
nnoremap j gj
nnoremap k gk
" Go to start and end of line with H and L
nnoremap H ^
vnoremap H ^
nnoremap L g_
vnoremap L g_
" Go back to first non blank character with home
nnoremap <Home> ^
inoremap <Home> <Esc>^i
" }}}
" MUSCLE MEMORY {{{
" Ctrl+S saves the file, as in most apps
nnoremap <silent> <C-S> :w<CR>
inoremap <silent> <C-S> <Esc>:w<CR>
" Ctrl+D is save and exit, as in the term.
nnoremap <silent> <C-D> :x<CR>
inoremap <silent> <C-D> <Esc>:x<CR>
" Select all
nnoremap <C-A> GVgg
vnoremap <C-A> <Esc>GVgg
" }}}
" KEYBOARD {{{
" F1 is easier to type than Ctrl+] to navigate between help tags.
nnoremap <F1> <C-]>
" Those keys are useless in vim but are easily accessible on a french
" keyboard. We'll remap them to switch the maj version to the non-maj version.
nnoremap ù %
vnoremap ù %
nnoremap à 0
vnoremap à 0
" }}}
" OPTIONS {{{
" Toggle non-printable chars
nnoremap <silent> <F8> :set list!<CR>
vnoremap <silent> <F8> :set list!<CR>
inoremap <silent> <F8> <Esc>:set list!<CR>li
" Toggle wrapping
nnoremap <silent> <F9> :set wrap!<CR>
vnoremap <silent> <F9> :set wrap!<CR>
inoremap <silent> <F9> <Esc>:set wrap!<CR>li
" }}}
" NICETIES {{{
" Move a line below with _ and up with -, keeping indentation
nnoremap - "zddk"zP==
nnoremap _ "zdd"zp==
vnoremap - "zdkmz"zPV`zk=gv
vnoremap _ "zdjmzk"zpV`zk=gv
" appending a missing ; at the end of line
function! AppendMissingSemicolon()
	if getline(".") !~ ';$'
		execute "normal mzA;\<Esc>`z"
	endif
endfunction
nnoremap <silent> ; :call AppendMissingSemicolon()<CR>
" Comment whole paragraph
nnoremap gcp vip:TComment<CR>
" Open Url under cursor in browser
nnoremap <C-F5> :call OpenUrlInBrowser(GetUrlUnderCursor())<CR>
inoremap <C-F5> :call OpenUrlInBrowser(GetUrlUnderCursor())<CR>
" md will convert the selection to markdown
vnoremap <silent> md :!markdown<CR>
" }}}
" PLUGINS {{{
" Strangely, ï seems to be equal to <M-o> and endwise remaps it. I need to
" force its mapping so it is not overwritten.
inoremap <M-o> ï
" }}}