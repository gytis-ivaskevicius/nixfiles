"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#fnamemod = ':t'
"let g:airline_powerline_fonts = 1

   let g:airline#extensions#tabline#enabled = 1
   let g:airline#extensions#tabline#left_sep = ''
   let g:airline#extensions#tabline#left_alt_sep = '  '
   let g:airline#extensions#tabline#formatter = 'unique_tail'
   let g:airline#extensions#tabline#show_tab_count = 0
   let g:airline#extensions#tabline#show_tab_type = 0
   let g:airline#extensions#tabline#show_close_button = 0
   let g:airline#extensions#tabline#tab_nr_type = 0 " # of splits (default)
   "let g:airline_theme='zoe'

      let g:airline_left_sep = "\uE0B8 "
   let g:airline_right_sep = "\uE0BA "
   let g:airline_section_warning = ''
   let g:airline_section_error = ''
   let g:airline_section_z = airline#section#create_right(['%l/%L ☰ %c'])



