set nocompatible

" Recommended by Pathogen to improve its support for Vim session
set sessionoptions-=options
let g:pathogen_disabled = ['pydiction']
execute pathogen#infect()

" Hide the splash message
set shortmess+=I

set background=dark
colorscheme vividchalk

" Status Line
set statusline=%F%m%r%h%w\ [T=%Y\ %{&ff}]\ [A/H=\%03.3b/\%02.2B]\ [P=%04l/%04L,%04v][%p%%]

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
:set pastetoggle=<F10>

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
set spelllang=en_us,fr

" Make backspace more powerful
set backspace=indent,eol,start

" Set up default spacing and tabs (8 for hard tabs, 4 for what we use, insert
" spaces instead of hard tabs)
set tabstop=8 shiftwidth=4 expandtab

set smarttab

" Reasonable defaults for indentation
set autoindent nocindent nosmartindent
"
" Jump to last position in file
:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

highlight OverLength ctermbg=black ctermfg=220 guibg=black guifg=#ffd700
match OverLength /\%81v.\+/

" Color customizations
highlight Comment ctermfg=100 guifg=#878700
highlight Normal ctermfg=white ctermbg=black

" Inform sh syntax that /bin/sh is actually bash
let is_bash=1

" Enable mouse support in text terminals (using smarter mouse protocol, xterm2)
set mouse=a
set ttymouse=xterm2

" Create a reStructuredText HTML document from current buffer and open it in the browser
:com RP :exec "Vst html" | w! /tmp/reST_test.html | :q | !google-chrome /tmp/temp_vim_rest.html

" Viewport Controls, i.e. moving between split panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Increase/decrease window size by sane amounts
nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

" Compile every Perl file after saving
au BufWritePost {*.pm,*.pl,*.inc,*.cgi} !perl -c %

" HTML
autocmd Filetype html setlocal ts=2 sts=2 sw=2

" JavaScript
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

" Python
au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79 " PEP-8 Friendly

" Enable VIM 7.3+ native column indicator support if possible
if exists("+colorcolumn")
  " Use the textwidth value as the column length indicator
  set colorcolumn=+1,+21,+41
else
  " No native support, I can't stand using overlength
endif

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
let g:ctrlp_extensions = ['funky']
nnoremap <Leader>f :CtrlPFunky<Cr>
nnoremap <Leader>F :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

" accelerated-jk
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

" github-issues.vim
let g:github_same_window = 1

" minibufexpl
noremap gt :MBEbf<CR>
noremap gT :MBEbb<CR>
let g:miniBufExplUseSingleClick = 1

" pydiction
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

" rainbow-parentheses.vim
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au VimEnter * RainbowParenthesesToggle

" rainbow-parentheses.vim breaks vim-css-color, needs to set syntax after
syntax on

" searchfold
let g:searchfold_foldlevel = 1

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
nnoremap <Leader>y :YRShow<CR>

" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction

" Find a file and pass it to cmd
function! DmenuOpen(cmd)
  let fname = Chomp(system("find . | dmenu -i -l 20 -p " . a:cmd))
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction

" Open dmenu fuzzy search
map <c-t> :call DmenuOpen("tabe")<cr>
map <c-f> :call DmenuOpen("e")<cr>

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

