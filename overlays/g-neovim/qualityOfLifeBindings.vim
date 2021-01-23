
" Common
set mouse=a
set nowrap
set number
set scrolloff=15
set smartcase ignorecase hlsearch
set splitbelow splitright
set termguicolors
set undofile
set updatetime=100
set visualbell
set wildignore+=*/tmp/*,*.so,*.swp,*.pyc,*.db,*.sqlite,*.class,*/node_modules/*,*/.git/*
set wildmode=longest,list " bash like completion


set expandtab
set shiftwidth=4
set smartindent
set softtabstop=4
set tabstop=4

if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Clear highlight
map <leader>/ :noh<cr>

" Ctrl + hjkl - in insert to move between characters
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Ctrl + hjkl - in normal mode to move betwen splits,
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" q to quit, Q to record macro
nnoremap Q q
nnoremap q :q<cr>

" Preserve visual highlighting when changing identation
vnoremap < <gv
vnoremap > >gv

" Make Y consistent with commands like D,C
nmap Y y$

" Ctrl+C/Ctrl+V to copy/paste to/from system clipboard
nmap <C-C> "+yy
vmap <C-C> "+y
imap <C-V> <Esc>"+pa

" Ctrl+S to save
nmap <C-s> :w<cr>
imap <C-s> <esc>:w<cr>a

" Ctrl+Backspace to delete previous word. https://vi.stackexchange.com/questions/16139/s-bs-and-c-bs-mappings-not-working
imap <C-BS> <C-W>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
