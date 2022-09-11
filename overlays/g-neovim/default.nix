{ stdenv
, lib
, vimPlugins
, universal-ctags
, neovim-unwrapped
, wrapNeovim
, enableAirline ? true
, enableClap ? false
, enableCoc ? true
, enableNerdtree ? true
, enableSignify ? true
, enableTagbar ? true
, highlightSearch ? true
, preserveCursorLocation ? true
, qualityOfLifeBindings ? true
, trimSpacesOnWrite ? true
, vimUtils
, srcs
}:
let
  inherit (lib) optionals optional optionalString;
  vim-camelsnek = vimUtils.buildVimPluginFrom2Nix {
    pname = "vim-camelsnek";
    version = "master";
    src = srcs.vim-camelsnek;
  };
in
wrapNeovim neovim-unwrapped {
  viAlias = true;
  vimAlias = true;
  withNodeJs = true;
  withPython3 = true;
  withRuby = false;

  configure = {

    customRC = ''
      ${optionalString enableAirline (builtins.readFile ./airline.vim)}
      ${optionalString enableCoc (builtins.readFile ./coc.vim)}
      ${optionalString enableNerdtree (builtins.readFile ./nerdtree.vim)}
      ${optionalString enableSignify (builtins.readFile ./signify.vim)}
      ${optionalString highlightSearch (builtins.readFile ./highlightSearch.vim)}
      ${optionalString preserveCursorLocation (builtins.readFile ./preserveCursor.vim)}
      ${optionalString qualityOfLifeBindings (builtins.readFile ./qualityOfLifeBindings.vim)}
      ${optionalString trimSpacesOnWrite (builtins.readFile ./trimSpacesOnWrite.vim)}

      nmap <leader>c :CamelB
      highlight Pmenu             guibg=#222222
      map <space> <leader>
      au BufNewFile,BufRead /*.rasi setf css  " Add rofi config file highlighting
      au FocusLost * stopinsert | wall!       " Back to normal mode on focus lost
      let g:tagbar_ctags_bin = "${universal-ctags}/bin/ctags"
    '';

    packages.myVimPackage = with vimPlugins; {

      start = [
        vim-camelsnek
        vim-devicons
        vim-nix
      ]
      ++ optional enableClap vim-clap
      ++ optional enableNerdtree nerdtree
      ++ optional enableSignify vim-signify
      ++ optional enableTagbar tagbar
      ++ optionals enableAirline [ vim-airline vim-airline-themes ]
      ++ optionals enableCoc [
        #coc-actions
        #coc-cmake
        #coc-cssmodules
        #coc-xml
        #coc-css
        #coc-emmet
        #coc-eslint
        #coc-highlight
        #coc-html
        #coc-java
        #coc-json
        ##coc-prettier
        #coc-python
        #coc-rls
        #coc-snippets
        #coc-tslint-plugin
        #coc-tsserver
        #coc-vimlsp
        #coc-yaml
        #coc-yank
      ];

      opt = [ ];
    };
  };
}
