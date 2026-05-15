return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-mini/mini.icons",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 200,
    },
  },
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = false },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "┊",
      },
      scope = {
        enabled = true,
        char = "┃",
        show_start = true,
        show_end = false,
        show_exact_scope = true,
        include = {
          node_type = {
            php = {
              "if_statement",
              "else_if_clause",
              "else_clause",
              "for_statement",
              "foreach_statement",
              "while_statement",
              "do_statement",
              "switch_statement",
              "case_statement",
              "match_expression",
              "parenthesized_expression",
              "array_creation_expression",
              "subscript_expression",
              "arguments",
            },
          },
        },
        highlight = {
          "IblScopeRed",
          "IblScopeYellow",
          "IblScopeBlue",
          "IblScopeOrange",
          "IblScopeGreen",
          "IblScopeViolet",
          "IblScopeCyan",
        },
      },
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "notify",
          "oil",
          "snacks_dashboard",
          "snacks_picker_input",
          "snacks_terminal",
          "Trouble",
        },
        buftypes = {
          "terminal",
          "nofile",
          "quickfix",
          "prompt",
        },
      },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")
      local builtin = hooks.builtin

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblIndentRed", { fg = "#503b45", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndentYellow", { fg = "#544636", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndentBlue", { fg = "#364a68", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndentOrange", { fg = "#5a4033", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndentGreen", { fg = "#3f513e", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndentViolet", { fg = "#4a3d58", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndentCyan", { fg = "#35535c", nocombine = true })

        vim.api.nvim_set_hl(0, "IblScopeRed", { fg = "#f7768e", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "IblScopeYellow", { fg = "#e0af68", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "IblScopeBlue", { fg = "#7aa2f7", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "IblScopeOrange", { fg = "#ff9e64", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "IblScopeGreen", { fg = "#9ece6a", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "IblScopeViolet", { fg = "#bb9af7", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "IblScopeCyan", { fg = "#7dcfff", bold = true, nocombine = true })
      end)

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, builtin.scope_highlight_from_extmark)

      opts.indent.highlight = {
        "IblIndentRed",
        "IblIndentYellow",
        "IblIndentBlue",
        "IblIndentOrange",
        "IblIndentGreen",
        "IblIndentViolet",
        "IblIndentCyan",
      }
      require("ibl").setup(opts)
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow = require("rainbow-delimiters")

      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#f7768e" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#e0af68" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#ff9e64" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#9ece6a" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#bb9af7" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#7dcfff" })

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow.strategy["global"],
          vim = rainbow.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-mini/mini.icons",
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-h>"] = "actions.select_split",
        ["<C-l>"] = "actions.select_vsplit",
        ["<C-p>"] = "actions.preview",
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      bar = {
        enable = function(buf, win, _)
          if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
            return false
          end

          local filetype = vim.bo[buf].filetype
          local buftype = vim.bo[buf].buftype

          return buftype == ""
            and filetype ~= "help"
            and filetype ~= "lazy"
            and filetype ~= "mason"
            and filetype ~= "oil"
            and not filetype:match("^snacks")
        end,
      },
    },
    config = function(_, opts)
      local dropbar_api = require("dropbar.api")

      require("dropbar").setup(opts)

      vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to context start" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "diff",
        "git_config",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "query",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest", "NeotestOutputPanel", "NeotestSummary" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-phpunit",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-phpunit")({
            phpunit_cmd = function()
              return vim.fn.expand("~/.local/bin/phpunit-neotest")
            end,
            root_files = { "composer.json", "phpunit.xml", "phpunit.xml.dist", "artisan" },
            filter_dirs = { ".git", "node_modules", "vendor" },
          }),
        },
        quickfix = {
          enabled = false,
        },
        output = {
          open_on_run = false,
        },
        summary = {
          mappings = {
            attach = "<CR>",
            clear_marked = "M",
            expand = { "l", "<Right>" },
            expand_all = "L",
            jumpto = "i",
            mark = "m",
            next_failed = "]t",
            output = "o",
            prev_failed = "[t",
            run = "r",
            short = "O",
            stop = "u",
            target = "t",
          },
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapContinue", "DapToggleBreakpoint", "DapStepInto", "DapStepOver", "DapStepOut", "DapTerminate", "DapREPLToggle" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js"

      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#f7768e", bold = true })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#ff9e64", bold = true })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#e0af68", bold = true })
      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "", numhl = "" })

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { mason_path },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
      }

      dapui.setup({})

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      PATH = "prepend",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "intelephense",
        "php-debug-adapter",
        "phpactor",
        "typos-lsp",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "bashls",
        "gopls",
        "intelephense",
        "jsonls",
        "lua_ls",
        "marksman",
        "phpactor",
        "pyright",
        "rust_analyzer",
        "taplo",
        "typos_lsp",
        "yamlls",
      },
    },
  },
  {
    "Saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
              { "source_name" },
            },
          },
        },
      },
      signature = {
        enabled = true,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false,
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local php_root = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(
          vim.fs.root(fname, { "composer.json", "artisan", ".phpactor.json", ".phpactor.yml" })
            or vim.fs.root(fname, { ".git" })
        )
      end
      local servers = {
        bashls = {},
        gopls = {},
        intelephense = {
          root_dir = php_root,
        },
        jsonls = {},
        marksman = {},
        phpactor = {
          root_dir = php_root,
          init_options = {
            ["indexer.exclude_patterns"] = {
              "/vendor/**/*",
              "/vendor/**/Tests/**/*",
              "/vendor/**/tests/**/*",
              "/vendor/composer/**/*",
              "/vendor/rector/rector/stubs-rector",
              "/bootstrap/cache/**/*",
              "/storage/framework/**/*",
              "/storage/logs/**/*",
              "/node_modules/**/*",
              "/public/build/**/*",
            },
            ["indexer.reference_finder.deep"] = false,
            ["indexer.implementation_finder.deep"] = false,
            ["language_server.file_events"] = false,
            ["language_server.diagnostics_on_update"] = false,
            ["language_server.diagnostics_on_open"] = false,
            ["language_server.diagnostics_on_save"] = false,
            ["language_server.diagnostic_providers"] = {},
            ["language_server_worse_reflection.diagnostics.enable"] = false,
            ["language_server_highlight.enabled"] = false,
          },
          on_new_config = function(new_config, root_dir)
            local ide_helper = root_dir .. "/_ide_helper.php"
            local ide_helper_models = root_dir .. "/_ide_helper_models.php"
            local stub_paths = {}

            if vim.fn.filereadable(ide_helper) == 1 then
              table.insert(stub_paths, ide_helper)
            end

            if vim.fn.filereadable(ide_helper_models) == 1 then
              table.insert(stub_paths, ide_helper_models)
            end

            new_config.init_options = vim.tbl_deep_extend("force", new_config.init_options or {}, {
              ["indexer.stub_paths"] = stub_paths,
              ["worse_reflection.additive_stubs"] = stub_paths,
            })
          end,
          on_attach = function(client)
            client.server_capabilities.completionProvider = nil
          end,
        },
        pyright = {},
        rust_analyzer = {},
        taplo = {},
        typos_lsp = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              telemetry = {
                enable = false,
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
      }

      for name, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    opts = function()
      local util = require("conform.util")

      return {
        formatters = {
          pint = {
            command = util.find_executable({ "vendor/bin/pint" }, "pint"),
            cwd = util.root_file({ "pint.json", "composer.json", "artisan" }),
            require_cwd = true,
            args = function(self, ctx)
              local root = self.cwd and self.cwd(self, ctx)
              local config_path = root and (root .. "/pint.json") or nil

              if config_path and vim.fn.filereadable(config_path) == 1 then
                return { "--config", config_path, "$FILENAME" }
              end

              return { "$FILENAME" }
            end,
            stdin = false,
          },
        },
        formatters_by_ft = {
          bash = { "shfmt" },
          css = { "prettier" },
          go = { "gofmt" },
          html = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier" },
          php = { "pint" },
          python = { "ruff_format" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          toml = { "taplo" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          yaml = { "prettier" },
          zsh = { "shfmt" },
        },
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          if vim.bo[bufnr].filetype == "php" then
            return {
              timeout_ms = 10000,
              lsp_format = "never",
            }
          end
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end,
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local php_root_markers = { "composer.json", "artisan" }
      local phpstan = lint.linters.phpstan

      if phpstan then
        lint.linters.phpstan = function()
          local linter = type(phpstan) == "function" and phpstan() or vim.deepcopy(phpstan)
          local bufname = vim.api.nvim_buf_get_name(0)
          local root = vim.fs.root(bufname, php_root_markers) or vim.fn.getcwd()
          local local_bin = root .. "/vendor/bin/phpstan"

          if vim.fn.executable(local_bin) == 1 then
            linter.cmd = local_bin
          end

          linter.cwd = root
          return linter
        end
      end

      lint.linters_by_ft = {
        php = { "phpstan" },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, {
            buffer = bufnr,
            silent = true,
            desc = desc,
          })
        end

        map("]h", gs.next_hunk, "Next hunk")
        map("[h", gs.prev_hunk, "Previous hunk")
      end,
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
  },
  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      pre_hook = function()
        vim.opt.cursorline = false
      end,
      post_hook = function()
        vim.opt.cursorline = true
      end,
    },
  },
}
