" --------------- "
" --- Plugins --- "
" --------------- "

call plug#begin('~/.local/share/nvim/plugged')

	Plug 'scrooloose/nerdtree'
  Plug 'mileszs/ack.vim'
  Plug 'dracula/vim', { 'name': 'dracula' }
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'luochen1990/rainbow'
  Plug 'neovim/nvim-lspconfig'
  Plug 'kyazdani42/nvim-web-devicons'
	Plug 'folke/trouble.nvim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'
  Plug 'mg979/vim-visual-multi'

call plug#end()

" ------------------------------- "
" --- Vim Plug--------------- --- "
" ------------------------------- "

color dracula

" ------------------------------- "
" --- Leader key alternatives --- "
" ------------------------------- "

" They preserve the native leader key.

nmap , \
vmap , \

nmap <space> \
vmap <space> \

" ---------------------- "
" --- Visual options --- "
" ---------------------- "

set number " show line numbers

set cursorline
set showmatch " highlight matching parentheses
set matchtime=0 " ...but stay out of the way (do not jump around)

filetype plugin indent on " automatically detect file types.
syntax on " syntax highlighting

set noshowcmd                     " showcmd (on by default) is very noisy when running long commands, such as Ack
set noerrorbells visualbell t_vb= " disable all bells
set backspace=indent,eol,start    " allow extended backspace behaviour
set virtualedit=block             " allow placing the cursor after the last char in visual block
set scrolloff=3                   " number of lines visible when scrolling
set sidescroll=3
set sidescrolloff=3
set splitright                    " position of the new split panes
set splitbelow

if exists('+colorcolumn')
  set colorcolumn=81,101 " display vertical rulers for line length
  autocmd FileType qf set colorcolumn=
endif

" ---------------------- "
" --- Search options --- "
" ---------------------- "

set ignorecase  " ignore case when searching...
set smartcase   " ...unless one upper case letter is present in the word
set gdefault    " replace all the occurences in the line by default
set incsearch   " start searching without pressing enter
set hlsearch    " highlight results
" normalise the search highlight colours
" This black text/bright yellow background works really well with Tango Light
" and most other terminal themes, but might require tweaking in the
" ~/.vimrc.local for some unconventional terminal themes (Solarized Light,
" Pastel...)
" See the README/TODO for more options.
hi Search term=reverse cterm=reverse ctermfg=11 ctermbg=0
hi Todo term=reverse cterm=reverse,bold ctermfg=7 ctermbg=0
hi Visual term=reverse cterm=reverse ctermfg=7 ctermbg=0

" search and replace current word
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" highlight current word without jumping to the next occurrence
map <Leader>h :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>

"" ----------------------------------- "
"" --- Search for visual selection --- "
"" ----------------------------------- "

" Search for selected text, forwards or backwards. It is case insensitive, and
" any whitespace is matched ('hello\nworld' matches 'hello world')
" makes * and # work on visual mode too.
"
" - http://vim.wikia.com/wiki/Search_for_visually_selected_text
" - http://vim.wikia.com/wiki/VimTip171
" - http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
" - https://github.com/nelstrom/vim-visual-star-search
" - http://vimcasts.org/episodes/search-for-the-selected-text/
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" ------------------------------------------- "
" --- Search and replace visual selection --- "
" ------------------------------------------- "

" Start the find and replace command across the entire file
vnoremap <Leader>r <Esc>:%s/<c-r>=GetVimEscapedVisual()<cr>//c<Left><Left>
vnoremap <C-r> <Esc>:%s/<c-r>=GetVimEscapedVisual()<cr>//c<Left><Left>

" ---------------------------- "
" --- Tabs and indentation --- "
" ---------------------------- "

" Use 2-space soft tabs by defaults
" (it's overridden for languages with different conventions).
set autoindent  	" remember indent level after going to the next line.
set expandtab 		" replace tabs with spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2

autocmd FileType python
	\ setlocal tabstop=4
	\ | setlocal softtabstop=4
	\ | setlocal shiftwidth=4

" --------------------------- "
" --- Indenting shortcuts --- "
" --------------------------- "

" Indent/Unindent visually selected lines without losing the selection.
vnoremap > >gv
vnoremap < <gv
" Indent single lines with a single keystroke. The ability to specify a motion
" is lost, but this caters for the more common use case, indent until the
" desired level is obtained.
nnoremap > >>
nnoremap < <<

" -------------------------- "
" --- Formatting options --- "
" -------------------------- "

" Ensure some formatting options, some of which may already be enabled by
" default, depending on the version of Vim.
"
" * Wrap text automatically both for text (t) and comments (c).
" * Auto-add current comment leader on new lines both in insert mode (r) and
" * normal mode (o).
" * Remove the comment characters when joining lines (j).
" * Allow formatting of comments with 'gq' (q).
set formatoptions+=jtcroq
" For auto-formatting of text (not just comments) to work, textwidth must be
" explicitly set (it's 0 by default).
set textwidth=79
" Also wrap existing long lines when adding text to it (-l).
" Respect new lines with a paragraph (-a).
set formatoptions-=la

" Disabling auto formatting for the following file types because the wrapping
" also seems to be applied to code.
autocmd FileType swift,erb,sh set formatoptions-=t

" Use only one space after punctuation:
" http://en.wikipedia.org/wiki/Sentence_spacing#Typography
set nojoinspaces

" I - When moving the cursor up or down just after inserting indent for i
" 'autoindent', do not delete the indent. (cpo-I)
set cpoptions+=I

" ------------------------- "
" --- Buffer management --- "
" ------------------------- "

" Reuse buffers: if a buffer is already open in another window, jump to it
" instead of opening a new window.
set switchbuf=useopen

" Allow to open a different buffer in the same window of a modified buffer
set hidden

" position of the new split panes
set splitbelow
set splitright

" Close the current buffer without closing the window
" <http://stackoverflow.com/a/8585343/417375>
nnoremap <Leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
"
" ------------------------- "
" --- Vim Commentary -- "
" ------------------------- "

nmap <Leader>c gcc
vmap <Leader>c gc

" ---------------- "
" --- Wrapping --- "
" ---------------- "

set nowrap " Do not visually wrap lines by default.

set breakindent " Align visually wrapped lines with the original indentation.
set linebreak " Break between words when wrapping (don't break within words).
" toggle wrapping with leader-ww
nmap <silent> <leader>ww :set wrap!<CR>
" allow navigating 'visual lines' with j/k and up/down, instead of actual lines
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

" ------------------------------------------------------------------- "
" --- Support vim options in individual files with magic comments --- "
" ------------------------------------------------------------------- "

set modeline

" --------------------------------------------------------- "
" --- Remember cursor position (when re-opening a file) --- "
" --------------------------------------------------------- "

" Exclude git commit messages.
let cursorRestoreExclusions = ['gitcommit']

autocmd BufReadPost *
  \ if index(cursorRestoreExclusions, &ft) < 0
	\ && line("'\"") > 1
  \ && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" ------------------------------ "
" --- Move lines up and down --- "
" ------------------------------ "

" Move lines up and down with Ctrl-arrowup/down and Ctrl-j/k (in normal, visual and insert mode)
" NOTE: only meant for small selections and small movements, will break moving
" multiple lines down beyond the bottom.
nnoremap <C-Down> :m .+1<CR>
nnoremap <C-Up> :m .-2<CR>
vnoremap <C-Down> :m '>+1<CR>gv
vnoremap <C-Up> :m '<-2<CR>gv
inoremap <C-Down> <ESC>:m .+1<CR>gi
inoremap <C-Up> <ESC>:m .-2<CR>gi
" For terminals where Ctrl-arrows are captured by the system.
nnoremap <C-j> :m .+1<CR>
nnoremap <C-k> :m .-2<CR>
vnoremap <C-j> :m '>+1<CR>gv
vnoremap <C-k> :m '<-2<CR>gv
inoremap <C-j> <ESC>:m .+1<CR>gi
inoremap <C-k> <ESC>:m .-2<CR>gi

" ------------------ "
" --- Whitespace --- "
" ------------------ "

" --- Visualise whitespace ---
set listchars=tab:▸·,trail:·,extends:>,precedes:<
" toggle hidden characters highlighting:
nmap <silent> <Leader>w :set nolist!<CR>

" --- highlight unwanted trailing whitespace --- "
" <https://vim.fandom.com/wiki/Highlight_unwanted_spaces#Highlighting_with_the_match_command>
"
" only in normal mode
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" --- Strip whitespace ---

function! <SID>StripExtraWhitespace()
  " store the original position
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e " end of lines
  %s/\n\{3,}/\r\r/e " multiple blank lines
  silent! %s/\($\n\s*\)\+\%$// " end of file
  call cursor(l, c) " back to the original position
endfun

autocmd FileType Dockerfile,make,c,coffee,cpp,css,eruby,eelixir,elixir,html,java,javascript,json,markdown,php,puppet,ruby,scss,sh,sql,text,tmux,typescript,vim,yaml,zsh,bash,dircolors autocmd BufWritePre <buffer> :call <SID>StripExtraWhitespace()

" StripTrailingWhitespace will not remove multiple blank lines, for langagues
" where that is the desired style.
function! <SID>StripTrailingWhitespace()
  " store the original position
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e " end of lines
  silent! %s/\($\n\s*\)\+\%$// " end of file
  call cursor(l, c) " back to the original position
endfun

autocmd FileType python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespace()

" ---------------------- "
" --- Copy and Paste --- "
" ---------------------- "

set pastetoggle=<F3>

" --- Paste over visual selection preserving the content of the paste buffer
" p   -> paste normally
" gv  -> reselect the pasted text
" y   -> copy it again
" `>  -> jump to the last character of the visual selection (built-in mark)
vnoremap <Leader>p pgvy`>

" --- Make shift-Y consistent with shift-C and shift-D --- "
" shift-C changes till the end of line, and shift-D deletes till the of the line.
" shift-Y breaks the pattern, and it's an alias for `yy'.
" This was once in vim-sensible but then removed.
nnoremap Y y$

" 'borrowed' from
" <https://github.com/zonk1024/vim_stuffs/blob/281b4dfe92d4883550659989c71ec72350f3dd10/vimrc#L129>
" Turns on paste mode, puts you in insert mode then autocmds the cleanup
function! InsertPaste() range
  set paste
  startinsert
  augroup PasteHelper
    autocmd InsertLeave * call LeavePaste()
  augroup END
endfunction

function! InsertPasteNewLine() range
  set paste
  call append(line("."), "")
  exec line(".")+1
	startinsert
  augroup PasteHelper
    autocmd InsertLeave * call LeavePaste()
  augroup END
endfunction

" Cleanup by turning off paste mode and unbinding itself from InsertLeave
function! LeavePaste() range
  set nopaste
  augroup PasteHelper
    autocmd!
  augroup END
endfunction

nnoremap <Leader>i :call InsertPaste()<CR>
nnoremap <Leader>o :call InsertPasteNewLine()<CR>

" ------------------- "
" --- Real delete --- "
" ------------------- "
"
" Delete without yanking, send the deleted content to the 'black hole' register.
" https://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
" http://vim.wikia.com/wiki/Get_Alt_key_to_work_in_terminal
if !has('nvim') && has('linux')
  set <M-d>=d
elseif has('osxdarwin')
  set <M-d>=∂
end

" ...then, the actual mapping:
" current line in normal and insert mode
nnoremap <M-d> "_dd
nnoremap <Leader>d "_dd
" selection in visual mode
vnoremap <M-d> "_d
vnoremap <Leader>d "_d

" ---------------------- "
" --- Spell checking --- "
" ---------------------- "

" toggle spell checking with <F6>
nnoremap <F6> :setlocal spell!<CR>
vnoremap <F6> :setlocal spell!<CR>
inoremap <F6> <Esc>:setlocal spell!<CR>

" Automatically enable spell checking for some filetypes.
" <http://robots.thoughtbot.com/vim-spell-checking>
" autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" ---------------------------------------- "
" --- Fix arrow key combos inside tmux --- "
" ---------------------------------------- "

" this enables to use native and custom key combos inside tmux,
" as well as in standalone vim;
" relies on the term being correctly set inside tmux
if &term =~ '^screen'
  exec "set <xUp>=\e[1;*A"
  exec "set <xDown>=\e[1;*B"
  exec "set <xRight>=\e[1;*C"
  exec "set <xLeft>=\e[1;*D"
endif

" ------------------------------------------------ "
" --- Navigate within and between vim and tmux --- "
" ------------------------------------------------ "

" Also see the corresponding tmux configuration in these dotfiles.

function! TmuxWinCmd(direction)
  let wnr = winnr()
  " try to move...
  silent! execute 'wincmd ' . a:direction
  " ...and if does nothing it means that it was the last vim pane,
  " so we forward the command back to tmux
  if wnr == winnr()
    call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
  end
endfunction

nmap <M-Up>     :call TmuxWinCmd('k')<CR>
nmap <M-Down>   :call TmuxWinCmd('j')<CR>
nmap <M-Left>   :call TmuxWinCmd('h')<CR>
nmap <M-Right>  :call TmuxWinCmd('l')<CR>

nmap <M-k> :call TmuxWinCmd('k')<CR>
nmap <M-j> :call TmuxWinCmd('j')<CR>
nmap <M-h> :call TmuxWinCmd('h')<CR>
nmap <M-l> :call TmuxWinCmd('l')<CR>

" ---------------- "
" --- agignore --- "
" ---------------- "

let s:agignore =
      \' --ignore="_quarantine"'.
      \' --ignore="bitbucket.org"'.
      \' --ignore="cloud.google.com"'.
      \' --ignore="code.google.com"'.
      \' --ignore="github.com"'.
      \' --ignore="golang.org"'.
      \' --ignore="gopkg.in"'.
      \' --ignore="launchpad.net"'.
      \' --ignore="speter.net"'.
      \' --ignore=".bin"'.
      \' --ignore=".bundle"'.
      \' --ignore="bundle"'.
      \' --ignore=".git"'.
      \' --ignore=".hg"'.
      \' --ignore=".svn"'.
      \' --ignore="log"'.
      \' --ignore="node_modules"'.
      \' --ignore="vendor"'.
      \' --ignore="*.class"'.
      \' --ignore="*.dll"'.
      \' --ignore="*.exe"'.
      \' --ignore="*.pyc"'.
      \' --ignore="*.so"'.
      \' --ignore="tags"'

" ---------------- "
" --- rgignore --- "
" ---------------- "

let s:rgignore =
      \ " --glob='!**/.bin/'".
      \ " --glob='!**/.bundle/'".
      \ " --glob='!**/.git/'".
      \ " --glob='!**/.hg/'".
      \ " --glob='!**/.svn/'".
      \ " --glob='!**/_quarantine/'".
      \ " --glob='!**/bitbucket.org/'".
      \ " --glob='!**/bundle/'".
      \ " --glob='!**/cloud.google.com/'".
      \ " --glob='!**/code.google.com/'".
      \ " --glob='!**/git/'".
      \ " --glob='!**/github.com/'".
      \ " --glob='!**/google.golang.org/'".
      \ " --glob='!**/golang.org/'".
      \ " --glob='!**/gopkg.in/'".
      \ " --glob='!**/launchpad.net/'".
      \ " --glob='!**/log/'".
      \ " --glob='!**/node_modules/'".
      \ " --glob='!**/speter.net/'".
      \ " --glob='!**/vendor/'".
      \ " --glob='!*.class'".
      \ " --glob='!*.dll'".
      \ " --glob='!*.exe'".
      \ " --glob='!*.pyc'".
      \ " --glob='!*.so'".
      \ " --glob='!tags'"

let s:rg_base_grepprg = 'rg --vimgrep --hidden --no-heading --line-number --follow --smart-case --trim --no-ignore-vcs' . s:rgignore

" ----------------------- "
" --- Search with Ack --- "
" ----------------------- "

if executable('rg')
  let g:ackprg = s:rg_base_grepprg
elseif executable('ag')
  let g:ackprg = 'ag --hidden --follow --smart-case --skip-vcs-ignores' . s:agignore
endif
" do no jump to the first result
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
" highlight the searched term
let g:ackhighlight = 1

" Search for visual selection (rudimental, only works in basic scenarios)
vnoremap <Leader>a y:Ack <C-r>=GetShellEscapedVisual()<CR>

" Run in the background with the help of tpope/vim-dispatch
" only appears to work in tmux
" if $TMUX != ""
"   let g:ack_use_dispatch = 1
" endif

" ---------------- "
" --- NERDTree --- "
" ---------------- "

" Shortcut to open/close
map <Leader>n :NERDTreeToggle<CR>
" Highlight the current buffer (think of 'find')
map <Leader>f :NERDTreeFind<CR>

let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeNaturalSort=1
let NERDTreeIgnore = ['\.pyc$', '\.class$'] " http://superuser.com/questions/184844/hide-certain-files-in-nerdtree
let NERDTreeAutoDeleteBuffer=1 " automatically replace/close the corresponding buffer when a file is moved/deleted
let NERDTreeCascadeSingleChildDir=0 " do not collapse on the same line directories that have only one child directory

" ----------------------------------- "
" --- fzf and fzf.vim integration --- "
" ----------------------------------- "

" See also https://github.com/junegunn/fzf/blob/master/README-VIM.md

" NOTE: Most of the options set with envars in the shell will also apply when
" fzf is invoked in Vim. Check those options in case of unwanted behaviour.

" run in a less intrusive terminal buffer at the bottom
let g:fzf_layout = { 'down': '~30%' }
" command to generate tags file
let g:fzf_tags_command = 'ctags -R'
" disable the preview window
let g:fzf_preview_window = ''
" do not jump to the existing window if the buffer is already visible
let g:fzf_buffers_jump = 0

" same keybindings used for CtrlP
nmap <C-p> :Files<CR>
noremap <Leader>b :Buffers<CR>

lua << EOF
  local lsp_config = require 'lspconfig'
  lsp_config.gopls.setup{
    cmd = {"gopls"};
    filetypes = {"go", "gomod"};
    root_dir = lsp_config.util.root_pattern("go.mod", ".git");
    log_level = vim.lsp.protocol.MessageType.Log;
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      }
    }
  }

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

		-- Enable completion triggered by <c-x><c-o>
		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
	end

	function goimports(timeoutms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local method = "textDocument/codeAction"
    local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)
    if resp and resp[1] then
      local result = resp[1].result
      if result and result[1] then
        local edit = result[1].edit
        vim.lsp.util.apply_workspace_edit(edit)
      end
    end

    vim.lsp.buf.formatting()
  end

  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    }
EOF

autocmd BufWritePre *.go lua goimports(1000)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
set completeopt-=preview
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>

autocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc

" ---------------------------------------------------- "
" --- copy and paste straight onto system clipboard--- "
" ---------------------------------------------------- "
set clipboard=unnamedplus

nnoremap <leader>t <cmd>TroubleToggle<cr>
