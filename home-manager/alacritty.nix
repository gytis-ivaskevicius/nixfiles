{ pkgs, lib, config, ... }:

{
  programs.alacritty = {
    enable = true;
    
    settings = {
      general.live_config_reload = true;
      
      colors = {
        draw_bold_text_with_bright_colors = true;
        
        bright = {
          black = "#38252C";
          blue = "#289CD5";
          cyan = "#0A9B81";
          green = "#76B639";
          magenta = "#FF2491";
          red = "#FF0000";
          white = "#F8F8F8";
          yellow = "#E1A126";
        };
        
        footer_bar = {
          background = "#D81765";
          foreground = "#FFFFFF";
        };
        
        normal = {
          black = "#171717";
          blue = "#16B1FB";
          cyan = "#0FDCB6";
          green = "#97D01A";
          magenta = "#FF2491";
          red = "#D81765";
          white = "#EBEBEB";
          yellow = "#FFA800";
        };
        
        primary = {
          background = "#171717";
          foreground = "#F8F8F8";
        };
        
        search = {
          focused_match = {
            background = "CellForeground";
            foreground = "CellBackground";
          };
          matches = {
            background = "#D81765";
            foreground = "#EBEBEB";
          };
        };
      };
      
      keyboard.bindings = [
        {
          chars = "\\u0017";
          key = "Back";
          mods = "Control";
        }
      ];
      
      scrolling = {
        history = 100000;
      };
    };
  };
} 