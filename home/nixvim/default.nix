{ ... }: {
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox = {
      enable = true;
      settings = {
        transparent_mode = true;
        dim_inactive = true;
      };
    };

    #highlight = { Normal.bg = "none"; };

    options = {
      number = true;
      relativenumber = true;
      incsearch = true;
      scrolloff = 3;
      textwidth = 100;
      cursorline = true;
      cursorcolumn = true;
      title = true;
      termguicolors = true;
      background = "dark";
      showmode = false;
    };

    plugins = {
      nix.enable = true;

      typst-vim.enable = true;

      lualine = {
        enable = true;
        iconsEnabled = false;
      };

      lsp = {
        enable = true;

        servers = {
          clangd.enable = true;
          gopls.enable = true;
          hls.enable = true;

          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          pylsp = {
            enable = true;
            settings.plugins = {
              pylint.enabled = true;
              pycodestyle.enabled = true;
              yapf.enabled = true;
            };
          };

          nil_ls = {
            enable = true;
            settings = {
              formatting.command = [ "nixpkgs-fmt" ];
            };
          };

          texlab = {
            enable = true;
            extraOptions.settings = {
              texlab = {
                build = {
                  onSave = true;
                  forwardSearchAfter = true;
                  args = [ "-xelatex" ];
                };
                forwardSearch = {
                  executable = "zathura";
                  args = [ "%p" "--synctex-forward=%l:1:%f" ];
                };
                chktex = {
                  onOpenAndSave = true;
                };
              };
            };
          };

          typst-lsp = {
            enable = true;
            rootDir = "function() return vim.fn.getcwd() end";
            extraOptions.settings = {
              exportPdf = "onSave";
            };
          };
        };

        keymaps = {
          diagnostic = {
            "<space>e" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<space>q" = "setloclist";
          };

          lspBuf = {
            K = "hover";
            gD = "declaration";
            gd = "definition";
            gi = "implementation";
            gr = "references";
            "<C-k>" = "signature_help";
            "<space>wa" = "add_workspace_folder";
            "<space>wr" = "remove_workspace_folder";
            #"<space>wl" = ''
            #  function()
            #    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            #  end;
            #'';
            "<space>D" = "type_definition";
            "<space>rn" = "rename";
            "<space>ca" = "code_action";
            "<space>f" = "format";
          };
        };
      };

      nvim-cmp = {
        enable = true;

        snippet.expand = "luasnip";

        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "treesitter"; }
        ];

        mapping = {
          "<CR>" = "cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace }";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require'luasnip'.expand_or_jumpable() then
                  require'luasnip'.expand_or_jump()
                else
                  fallback()
                end
              end
            '';
          };
          "<S-Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require'luasnip'.jumpable(-1) then
                  require'luasnip'.jump(-1)
                else
                  fallback()
                end
              end
            '';
          };
          "<C-e>" = "cmp.mapping.abort()";
          "<C-Space>" = "cmp.mapping.complete";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f" = "cmp.mapping.scroll_docs(4)";
        };
      };

      luasnip.enable = true;
      treesitter.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      illuminate.enable = true;
    };
  };
}
