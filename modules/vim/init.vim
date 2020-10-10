
call plug#begin('~/.cache/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'WithoutCaps/vim-base'


call plug#end()

"""""""""""""""""""""""""""""""""""""
" Function to Clean trailing Spaces "
"""""""""""""""""""""""""""""""""""""

function! CleanExtraSpaces() "Function to clean unwanted spaces
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

autocmd BufWritePre * :call CleanExtraSpaces()


if exists("loaded_HLNext")
    finish
endif
let loaded_HLNext = 1

nnoremap           /   :call HLNextSetTrigger()<CR>/
nnoremap           ?   :call HLNextSetTrigger()<CR>?
nnoremap  <silent> n  n:call HLNext()<CR>
nnoremap  <silent> N  N:call HLNext()<CR>

highlight default HLNext ctermfg=white ctermbg=darkred

let g:HLNext_matchnum = 0

function! HLNext ()
    call HLNextOff()
    let target_pat = '\c\%#'.@/
    let g:HLNext_matchnum = matchadd('HLNext', target_pat)
endfunction

function! HLNextOff ()
    if (g:HLNext_matchnum > 0)
        call matchdelete(g:HLNext_matchnum)
        let g:HLNext_matchnum = 0
    endif
endfunction

function! HLNextSetTrigger ()
    augroup HLNext
        autocmd!
        autocmd  CursorMoved  *  :call HLNextMovedTrigger()
    augroup END
endfunction

function! HLNextMovedTrigger ()
    augroup HLNext
        autocmd!
    augroup END
    call HLNext()
endfunction

au BufNewFile,BufRead /*.rasi setf css

