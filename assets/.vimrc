set nocompatible

" Recommended by Pathogen to improve its support for Vim sessions
set sessionoptions-=options
" Don't save hidden and unloaded buffers in sessions
set sessionoptions-=buffers

let g:pathogen_disabled = []
execute pathogen#infect()

" Hide the splash message
set shortmess+=I

colorscheme slate
set background=light

" Status Line
set statusline=[%p%%]\ %F%m%r%h%w\ [T=%Y\ %{&ff}]\ [A/H=\%03.3b/\%02.2B]\ [P=%04l/%04L,%04v]\ %{TagInStatusLine()}

" Bufferline
let g:bufferline_fname_mod = ':s?version?main?'

" Always turn on status line
set laststatus=2

set history=100
set undolevels=1000

" Wrap long lines
set wrap

" Don't wrap words
set textwidth=0

" Set find-as-you-type searching
set incsearch

" Highlight search matches in the window.
set hlsearch

" Make the file autocomplete behave like bash's autocomplete
set wildmode=list:longest

" Toggle word-wrap and auto-indent behaviors when pasting
set paste
set pastetoggle=<F10>

" Keep unsaved files open with their changes
set hidden

set wildignore+=*.pyc

" Show a ruler
set ruler

" Display line numbers, and hybrid absolute/relative line numbers for vim >= 7.4
set number
if v:version >= 704
  set relativenumber
endif

" Show partial commands
set showcmd

" Show matching braces
set showmatch

" Write before hiding a buffer
set autowrite

filetype plugin on
filetype plugin indent on
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" Spellcheck
autocmd FileType mail,text,python setlocal spell
set spelllang=en_us

" Make backspace more powerful
set backspace=indent,eol,start

let shiftwidth=4
execute "set shiftwidth=".shiftwidth
execute "set softtabstop=".shiftwidth
set expandtab
function! TabToggle()
  if &expandtab
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
  else
    execute "set shiftwidth=".g:shiftwidth
    execute "set softtabstop=".g:shiftwidth
    set expandtab
  endif
endfunction
nmap <C-t> mz:execute TabToggle()<CR>'z

set smarttab

" Reasonable defaults for indentation
set autoindent nocindent nosmartindent
"
" Jump to last position in file
:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Color customizations
highlight Comment ctermfg=100 guifg=#878700
highlight Normal ctermfg=white ctermbg=black

" vim-lengthmatters
call lengthmatters#highlight('ctermbg=60') "ctermfg=yellow
let g:lengthmatters_start_at_column=101

" Inform sh syntax that /bin/sh is actually bash
let is_bash=1

" Enable mouse support in text terminals (using smarter mouse protocol, xterm2)
set mouse=a
set ttymouse=xterm2

" Copy current line number into clipboard
map <Leader>n <Esc>:let @*=line(".")<CR>

" Create a reStructuredText HTML document from current buffer and open it in the browser
:com RP :exec "Vst html" | w! /tmp/reST_test.html | :q | !google-chrome /tmp/temp_vim_rest.html

" Viewport Controls, i.e. moving between split panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-w>w :ZoomToggle<CR>

" Kill the buffer if it's visible from only one window, otherwise close the
" window without killing the buffer
function! CloseWindowOrKillBuffer() "{{{
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  " Never close a nerd tree if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif
  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
  endfunction "}}}
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

" Increase/decrease window size by sane amounts
nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

" Copy current filename to the clipboard
nmap <Leader>c :call system("pbcopy", expand("%:p"))<CR>

" Compile every Perl file after saving
au BufWritePost {*.pm,*.pl,*.inc,*.cgi} !perl -c %

" HTML
autocmd Filetype html setlocal ts=2 sts=2 sw=2

" JavaScript
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

" Markdown
" The following line makes vim-markdown useless on recent vim builds
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Python
au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=99 " PEP-8 Friendly
au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
au FileType python map <silent> <leader>B Oimport pdb; pdb.set_trace()<esc>

" Show flake8 signs in file and gutter
let g:flake8_show_in_file=1
let g:flake8_show_in_gutter=1
" Run flake8 on save
autocmd BufWritePost *.py call Flake8()

let g:jedi#popup_select_first=0

" Display vertical line at 100 characters
set colorcolumn=80

" http://vim.wikia.com/wiki/Highlight_cursor_line_after_cursor_jump
function s:Cursor_Moved()
  if bufname ('%') =~ '^NERD_tree_'
    return
  endif
  let cur_pos = winline()
  if g:last_pos == 0
    set cul
    let g:last_pos = cur_pos
    return
  endif
  let diff = g:last_pos - cur_pos
  if diff > 1 || diff < -1
    set cul
  else
    set nocul
  endif
  let g:last_pos = cur_pos
endfunction
autocmd CursorMoved,CursorMovedI * call s:Cursor_Moved()
let g:last_pos = 0

" Tell vim to remember certain things when we exit
" "  '10  :  marks will be remembered for up to 10 previously edited files
" "  "100 :  will save up to 100 lines for each register
" "  :20  :  up to 20 lines of command-line history will be remembered
" "  %    :  saves and restores the buffer list
" "  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" Change cursor when in insert mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Main function that restores the cursor position and its autocmd so
" that it gets triggered:
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Name our backup directory .vimbak-hostname
let $HOST=hostname()
let $MYBACKUPDIR=$HOME . '/.vimbak-' . $HOST

" Make sure the backup directory exists first.
if !isdirectory(fnameescape($MYBACKUPDIR))
  silent! execute '!mkdir -p ' . shellescape($MYBACKUPDIR)
  silent! execute '!chmod 700 ' . shellescape($MYBACKUPDIR)
endif

" Set directory for swap files
set directory=$MYBACKUPDIR

" Set to only keep one (current) backup
set backup writebackup

" Set directory for backup files
set backupdir=$MYBACKUPDIR

" Sensible list of files we don't want backed up
set backupskip=/tmp/*,/private/tmp/*,/var/tmp/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*

let g:ctrlp_custom_ignore = {
    \ 'dir': 'components/'
    \ }
let g:ctrlp_map = '<c-\>'
let g:ctrlp_extensions = ['funky']
nnoremap <Leader>f :CtrlPFunky<Cr>
nnoremap <Leader>F :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
let g:ctrlp_funky_sort_by_mru = 1
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_funky_use_cache = 1

" accelerated-jk
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

" github-issues.vim
let g:gissues_lazy_load = 1
let g:github_same_window = 1

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "5s"
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_highlight_build_constraints = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1

" vim-pydocstring
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
" pydocstring overrides expandtab setting, set it back.
nmap <silent> <C-_> <Plug>(pydocstring)<CR>:set expandtab<CR>

" minibufexpl
noremap gt :MBEbf<CR>
noremap gT :MBEbb<CR>
let g:miniBufExplUseSingleClick = 1

" pydiction
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'
" Remap snipmate's trigger key from tab to <C-J>
imap <C-J> <Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger

" rainbow-parentheses.vim
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au VimEnter * RainbowParenthesesToggle

let g:terraform_align=1
let g:terraform_fmt_on_save=1

" rainbow-parentheses.vim breaks vim-css-color, needs to set syntax after
syntax on

" Disable vim-diminactive because it's counter-productive with my current tmux color scheme.
let g:diminactive=0

" searchfold
let g:searchfold_foldlevel = 1

" swapit
" nmap <Plug>SwapItFallbackIncrement <Plug>SpeedDatingUp
" nmap <Plug>SwapItFallbackDecrement <Plug>SpeedDatingDown
" vmap <Plug>SwapItFallbackIncrement <Plug>SpeedDatingUp
" vmap <Plug>SwapItFallbackDecrement <Plug>SpeedDatingDown
nnoremap <silent><c-A> :<c-u>call SwapWord(expand("<cword>"), v:count, 'forward', 'no')<cr>
nnoremap <silent><c-X> :<c-u>call SwapWord(expand("<cword>"), v:count, 'backward','no')<cr>
vnoremap <silent><c-A> :<c-u>let swap_count = v:count<Bar>call SwapWord(<SID>GetSelection(), swap_count, 'forward', 'yes')<Bar>unlet swap_count<cr>
vnoremap <silent><c-X> :<c-u>let swap_count = v:count<Bar>call SwapWord(<SID>GetSelection(), swap_count, 'backward','yes')<Bar>unlet swap_count<cr>

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" vim-instant-markdown
let g:instant_markdown_slow = 1

" Gundo
nnoremap <Leader>U :GundoToggle<CR>

" NERDTree
map <Leader>t :NERDTreeToggle<CR>
" Open a NERDTree automatically when vim starts up if no files were specified
autocmd vimenter * if !argc() | NERDTree | endif
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Tagbar
nmap <Leader>k :TagbarToggle<CR>

" TaskList
map <Leader>T <Plug>TaskList

let g:session_autosave_periodic = 5

" YankRing
let g:yankring_max_history = 500
nnoremap <Leader>y :YRShow<CR>

" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction

" Format JSON
map <Leader>j !python -m json.tool<CR>

" Format XML
map <Leader>x !tidy -xml -q -i<CR>

" Sudo save
cmap w!! w !sudo dd of=%

" http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
nnoremap <Leader>l :call NumberToggle()<CR>

if filereadable($HOME . "/.vimrc_local")
  source $HOME/.vimrc_local
endif

