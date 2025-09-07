-- LSP Configuration for kickstart.nvim
-- Add this to your init.lua or create a separate lua/lsp.lua file

-- Install LSP servers using mason.nvim (kickstart should have this)
-- The servers will be automatically installed when you start nvim

-- At the top of ~/.config/nvim/lua/custom/lsp.lua
local ok, schemastore = pcall(require, 'schemastore')
if not ok then
  print 'LSP config will load after plugins are installed'
  return
end

print 'DEBUG: Loading custom LSP configuration'

local servers = {
  -- YAML
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
          ['https://json.schemastore.org/github-action.json'] = '/action.yml',
          ['https://json.schemastore.org/ansible-stable-2.9.json'] = '/playbooks/*.yml',
          ['https://json.schemastore.org/docker-compose.json'] = '/docker-compose*.yml',
          ['https://json.schemastore.org/kustomization.json'] = '/kustomization.yaml',
        },
        validate = true,
        completion = true,
        hover = true,
      },
    },
  },

  -- JSON
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },

  -- Astro
  astro = {},

  -- Python
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
          typeCheckingMode = 'basic',
        },
      },
    },
  },

  -- Ruff LSP (fast Python linter/formatter)
  -- ruff_lsp = {
  --   init_options = {
  --    settings = {
  -- Any extra CLI arguments for `ruff` go here.
  --      args = {},
  --    }
  --  }
  -- },

  -- Alternative Python LSP (choose one)
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         pycodestyle = { enabled = false },
  --         mccabe = { enabled = false },
  --         pyflakes = { enabled = false },
  --         flake8 = { enabled = true },
  --         autopep8 = { enabled = false },
  --         yapf = { enabled = false },
  --         black = { enabled = true },
  --         isort = { enabled = true },
  --       },
  --     },
  --   },
  -- },

  -- Bash
  bashls = {},

  -- Go
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },

  -- Rust
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = {
          command = 'clippy',
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },

  -- C/C++
  clangd = {
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  },

  -- Markdown
  marksman = {},

  -- TypeScript/JavaScript
  ts_ls = {
    settings = {
      typescript = {
        preferences = {
          disableSuggestions = false,
        },
      },
    },
  },

  -- Alternative TypeScript LSP
  -- vtsls = {},

  -- Lua (for Neovim configuration)
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  },

  -- Ansible
  ansiblels = {
    settings = {
      ansible = {
        ansible = {
          path = 'ansible',
        },
        executionEnvironment = {
          enabled = false,
        },
        python = {
          interpreterPath = 'python3',
        },
        validation = {
          enabled = true,
          lint = {
            enabled = true,
            path = 'ansible-lint',
          },
        },
      },
    },
    filetypes = { 'yaml.ansible' },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern(
        'ansible.cfg',
        '.ansible-lint',
        'playbook.yml',
        'playbooks/',
        'roles/',
        'inventory/',
        'group_vars/',
        'host_vars/'
      )(fname)
    end,
  },

  -- Terraform
  terraformls = {
    settings = {
      terraform = {
        validate = {
          enable = true,
        },
        format = {
          enable = true,
        },
      },
    },
    filetypes = { 'terraform', 'terraform-vars' },
  },
}

-- Ensure the servers above are installed
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- Setup LSP servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

-- Instead of setup_handlers, do this:
for server_name, server_config in pairs(servers) do
  local ok, lspconfig = pcall(require, 'lspconfig')
  if ok and lspconfig[server_name] then
    lspconfig[server_name].setup {
      capabilities = capabilities,
      settings = server_config.settings or {},
      cmd = server_config.cmd,
      init_options = server_config.init_options,
      filetypes = server_config.filetypes,
      root_dir = server_config.root_dir,
    }
  end
end
