
let g:signify_mapping_toggle_highlight = '<leader>gh'
let g:signify_sign_add                 = ''
let g:signify_sign_change              = ''
let g:signify_sign_changedelete        = g:signify_sign_change
let g:signify_sign_delete              = ''
let g:signify_sign_delete_first_line   = g:signify_sign_delete
let g:signify_sign_show_count          = 0
let g:signify_vcs_list = [ 'git' ]

highlight SignColumn                                     guibg=none
highlight SignifySignAdd                  ctermbg=green  guibg=#76B639
highlight SignifySignDelete ctermfg=black ctermbg=red    guibg=#D81765
highlight SignifySignChange ctermfg=black ctermbg=yellow guibg=#E1A126
highlight SignifyLineAdd                  ctermbg=green  guibg=#76B639
highlight SignifyLineDelete ctermfg=black ctermbg=red    guibg=#D81765
highlight SignifyLineChange ctermfg=black ctermbg=yellow guibg=#E1A126
