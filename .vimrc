set t_Co=256

filetype off                  " required for Vundle

" Necessary  for lots of cool vim things
set nocompatible

"{{{Vundle Plugin Managment
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'tpope/vim-fugitive'

Plugin 'gmarik/Vundle.vim'

Plugin 'DoxygenToolkit.vim'

Plugin 'jcf/vim-latex'

Plugin 'vimwiki'

Plugin 'WolfgangMehner/vim-plugins'

" this needs to be after WolfgangMehner/vim-plugins because
" they have conflict command name Make
Plugin 'tpope/vim-dispatch'

Plugin 'oplatek/Conque-Shell'

" additional steps need to be done so that this works, google it up :-)
Plugin 'wincent/command-t'

Plugin 'scrooloose/syntastic'
let g:syntastic_c_check_header = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" }}}

let g:Tex_GotoError=0

" vimviki projet
let g:vimwiki_list = [{'path': '~/Dropbox/wiki', 'path_html': '~/Dropbox/wiki/html'}]

" This shows what you are typing as a command.  I love this!
set showcmd

" Folding Stuffs
set foldmethod=marker

" this needs template http://www.vim.org/scripts/script.php?script_id=2647 to
" be installed, here is the description
" http://stackoverflow.com/questions/3785320/how-to-use-a-template-in-vim
let g:file_template_default = {}
let g:file_template_default['cpp'] = 'template'

" incremental search
set incsearch

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*
" Who doesn't like autoindent?
set autoindent

set smartindent

" Spaces are better than a tab character
set expandtab
set smarttab

" Who wants an 8 character tab?  Not me!
set shiftwidth=3
set softtabstop=3

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
   set spl=en spell
   set nospell
endif

" Real men use gcc
"compiler gcc

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Got backspace?
set backspace=2

" Line Numbers PWN!
set number

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" Since I use linux, I want this
let g:clipbrdDefaultReg = '+'

" Set off the other paren
highlight MatchParen ctermbg=4

set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 lines left/right
set undolevels=1000           " 1000 undos

" Highlight EOL whitespace,
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkred guibg=#382424
autocmd ColorScheme *.* highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter *.* match ExtraWhitespace /\s\+$/

" The above flashes annoyingly while typing, be calmer in insert mode
autocmd InsertLeave *.* match ExtraWhitespace /\s\+$/
autocmd InsertEnter *.* match ExtraWhitespace /\s\+\%#\@<!$/

" silent make
" TODO this line causes an error similiar to the
" one described in
" http://stackoverflow.com/questions/11733388/how-do-i-prevent-my-vim-autocmd-from-running-in-the-command-line-window
" try to fix this
"nnoremap <C-m> :silent make\|redraw!\|cc<CR>

" man pages in vim :-)
runtime ftplugin/man.vim
nnoremap <silent>K :<C-U>exe "Man" v:count "<cword>"<CR>

" launch conque bash in horizontal / vertical split
nnoremap <C-h> :ConqueTermSplit bash<CR>
nnoremap <C-i> :ConqueTermVSplit bash<CR>

" don't show backup files in explorer
set backupdir=./.backup,.,/tmp
set directory=./.backup,.,/tmp

set history=1000

let mapleader = ","

"{{{Command-T Plugin

" mappings
let g:CommandTCancelMap='<C-[>'
let g:CommandTBackspaceMap='<C-h>'
let g:CommandTCursorLeftMap='Left'

" options
let g:CommandTMatchWindowReverse=1

" }}}

"{{{Look and Feel

set background=dark
colorscheme solarized

"Status line gnarliness
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" }}}
