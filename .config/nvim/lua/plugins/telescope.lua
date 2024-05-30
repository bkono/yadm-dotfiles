return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- Default configuration for Telescope
        -- config_key = value,
      },
      pickers = {
        find_files = {
          -- Picker-specific configuration
          hidden = true,
        },
        live_grep = {
          -- Picker-specific configuration
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
      },
      extensions = {
        -- Extension-specific configuration
      },
    })
  end,
}
