call plug#begin('~/.local/share/nvim/plugged')
Plug 'ayu-theme/ayu-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'
Plug 'adam-r-kowalski/vim-test'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-dispatch'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/coc-vimlsp', {'do': 'yarn install --frozen-lockfile'}
Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}
Plug 'liuchengxu/vim-which-key'
Plug 'ziglang/zig.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-abolish'
Plug 'edkolev/tmuxline.vim'
Plug 'easymotion/vim-easymotion'
call plug#end()

syntax enable
set incsearch
filetype plugin indent on

set termguicolors

set shell=bash

set number
set relativenumber

let ayucolor="mirage"
colorscheme ayu

set noswapfile

set clipboard=unnamed

set mouse=a

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype cpp setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2


" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" set leader key
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>


" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <localleader>r <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <localleader>a  <Plug>(coc-codeaction-selected)
nmap <localleader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <localleader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <localleader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <leader>e  :<C-u>CocList extensions<cr>
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>f  :<C-u>CocList files<cr>
nnoremap <silent> <leader>g  :<C-u>CocList grep<cr>
nnoremap <silent> <leader>j  :<C-u>CocNext<CR>
nnoremap <silent> <leader>k  :<C-u>CocPrev<CR>
nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>

nmap <expr> <silent> <C-d> <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>
nmap <leader>tv :TestVisit<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>
nmap <leader>d :Dispatch<CR>
nmap <leader>D :Focus
nmap <leader>n :CocCommand explorer<CR>
nnoremap <localleader>b <C-O>
xmap <localleader>e <Plug>SlimeRegionSend
nmap <localleader>e <Plug>SlimeParagraphSend
nmap <localleader>E <Plug>SlimeConfig

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}
let g:slime_dont_ask_default = 1

nnoremap <M-s> :wa <cr>
vnoremap <M-s> :wa <cr>
inoremap <M-s> <C-o>:wa <cr>

let test#strategy = "dispatch"
let test#python#runner = 'pytest'
let test#python#pytest#options = '-p no:warnings'

let g:airline_theme='ayu'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

let g:markdown_fenced_languages = [
      \ 'vim',
      \ 'help'
      \]

let g:zig_fmt_autosave = 1
let test#custom_runners = {'zig': ['ZigTest']}
autocmd FileType zig let b:dispatch = 'zig build run'

let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'


" play macro stored in q register
nnoremap <leader>m @q

" enable transparancy
hi Normal guibg=NONE ctermbg=NONE

" terminal mode
tnoremap <ESC> <C-\><C-n>
