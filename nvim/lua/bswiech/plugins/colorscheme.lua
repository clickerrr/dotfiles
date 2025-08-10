return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			transparent_background = false,
			integrations = {
				nvimtree = true,
				treesitter = true,
				lsp_saga = true,
				native_lsp = { enabled = true },
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
