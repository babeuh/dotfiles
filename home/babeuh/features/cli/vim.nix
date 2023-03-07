{ config, ... }: {
  home.sessionVariables.EDITOR = "nvim";
  programs.fish.shellAliases = {
    vim = "nvim";
    vimdiff = "nvim -d";
  };
  programs.nixvim = {
    enable = true;
    colorschemes.base16 = {
      enable = true;
      useTruecolor = true;
      colorscheme = config.colorscheme.slug;
    };

    options = {
      number = true;

      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 0;
      autoindent = true;
      smarttab = true;
    };
    
    globals = {
      mapleader = "<Space>";
    };

    plugins = {
      # Languages
      nix.enable = true;

      # Utility
      nvim-autopairs = {
        enable = true;
        # check_ts uses treesitter, have not configured yet so todo
      };

      # UI
      barbar = {
        enable = true;

        closable = false;
        tabpages = false;
        # TODO: DIAGONOSTICS
      };

      # Autocomplete
      luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      cmp-git.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-cmdline.enable = true;
      cmp-calc.enable = true;
      nvim-cmp = {
        enable = true;
        snippet.expand = ''function(args)
          require('luasnip').lsp_expand(args.body)
        end,
        '';
        preselect = "None";
        completion.keyword_length = 1;
        mapping =  {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                luasnip = require('luasnip')
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end
            '';
          };
          "<Esc>" = {
            action = ''{i = cmp.mapping.abort(),
              c = function()
                if cmp.visible() then
                  cmp.close()
                else
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'n', true)
                end
              end
            }'';
          };
        };
        sources = [
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "git"; }
          { name = "buffer"; }
          { name = "path"; }
          { name = "cmdline"; }
          { name = "calc"; }
        ];
      };
    };
  };
}
