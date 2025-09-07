-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    -- JSON Schema support
    'b0o/schemastore.nvim',
  },

  {
    -- Astro support
    'wuelnerdotexe/vim-astro',
    ft = 'astro',
  },

  {
    -- Enhanced TypeScript support
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  },

  {
    -- Ansible support
    'pearofducks/ansible-vim',
    ft = { 'yaml', 'yaml.ansible' },
    config = function()
      -- Configure ansible-vim
      vim.g.ansible_unindent_after_newline = 1
      vim.g.ansible_attribute_highlight = 'ob'
      vim.g.ansible_name_highlight = 'd'
      vim.g.ansible_extra_keywords_highlight = 1
      
      -- Auto-detect Ansible files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          "*/playbooks/*.yml",
          "*/playbooks/*.yaml",
          "*/roles/*/tasks/*.yml",
          "*/roles/*/tasks/*.yaml",
          "*/roles/*/handlers/*.yml",
          "*/roles/*/handlers/*.yaml",
          "*/roles/*/vars/*.yml",
          "*/roles/*/vars/*.yaml",
          "*/roles/*/defaults/*.yml",
          "*/roles/*/defaults/*.yaml",
          "*/group_vars/*.yml",
          "*/group_vars/*.yaml",
          "*/host_vars/*.yml",
          "*/host_vars/*.yaml",
          "*/inventory/*.yml",
          "*/inventory/*.yaml",
          "playbook*.yml",
          "playbook*.yaml",
          "site.yml",
          "site.yaml",
        },
        callback = function()
          vim.bo.filetype = "yaml.ansible"
        end,
      })
    end,
  },

  {
    -- Terraform support
    'hashivim/vim-terraform',
    ft = { 'terraform', 'hcl' },
    config = function()
      vim.g.terraform_align = 1
      vim.g.terraform_fold_sections = 1
      vim.g.terraform_fmt_on_save = 1
      
      -- Auto-detect Terraform files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.tf", "*.tfvars", "*.hcl" },
        callback = function()
          vim.bo.filetype = "terraform"
        end,
      })
    end,
  },

  {
    -- Go tools (enhanced gopls integration)
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
  },

  {
    -- Ruff integration for Python
    'dense-analysis/ale',
    ft = 'python',
    config = function()
      -- Configure ALE for Ruff
      vim.g.ale_linters = {
        python = {'ruff'},
      }
      vim.g.ale_fixers = {
        python = {'ruff_format', 'ruff'},
      }
      vim.g.ale_fix_on_save = 1
      vim.g.ale_python_ruff_format_options = '--line-length=88'
      vim.g.ale_python_ruff_options = '--line-length=88'
    end,
  },
}
