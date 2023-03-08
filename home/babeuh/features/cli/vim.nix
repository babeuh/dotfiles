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
      gitsigns = {
        enable = true;
        showDeleted = true;
        currentLineBlame = true;
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
        completion.autocomplete = "false"; 
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif has_words_before() then
                  cmp.complete()
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
    extraConfigLuaPre = ''
      local luasnip = require('luasnip')
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end'';
  };
}
