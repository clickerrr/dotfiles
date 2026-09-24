return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			require("nvim-dap-virtual-text").setup({
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)

					if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
						return "*****"
					end

					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end

					return " " .. variable.value
				end,
			})

			------------------------------------------------------------
			-- JavaScript debug adapter
			------------------------------------------------------------

			local js_debug_path = vim.fn.stdpath("data")
				.. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

			local function js_adapter()
				return {
					type = "server",
					host = "127.0.0.1",
					port = "${port}",
					executable = {
						command = "node",
						args = {
							js_debug_path,
							"${port}",
							"127.0.0.1",
						},
					},
				}
			end

			dap.adapters["pwa-node"] = js_adapter()
			dap.adapters["pwa-chrome"] = js_adapter()

			------------------------------------------------------------
			-- Bun backend debugging
			------------------------------------------------------------

			for _, language in ipairs({
				"typescript",
				"javascript",
			}) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Bun Backend",

						runtimeExecutable = "bun",

						-- Change this to your backend entrypoint
						program = "${workspaceFolder}/src/index.ts",

						cwd = "${workspaceFolder}",
						sourceMaps = true,

						skipFiles = {
							"<node_internals>/**",
							"node_modules/**",
						},
					},

					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File With Bun",

						runtimeExecutable = "bun",
						program = "${file}",

						cwd = "${workspaceFolder}",
						sourceMaps = true,

						skipFiles = {
							"<node_internals>/**",
							"node_modules/**",
						},
					},
				}
			end

			------------------------------------------------------------
			-- React / Vite frontend debugging
			------------------------------------------------------------

			for _, language in ipairs({
				"typescriptreact",
				"javascriptreact",
			}) do
				dap.configurations[language] = {
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch React Frontend",

						url = "http://localhost:5173",
						webRoot = "${workspaceFolder}",

						sourceMaps = true,
					},
				}
			end

			------------------------------------------------------------
			-- Keymaps
			------------------------------------------------------------

			vim.keymap.set("n", "<leader>Db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

			vim.keymap.set("n", "<leader>DB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, {
				desc = "Debug: Set Conditional Breakpoint",
			})

			vim.keymap.set("n", "<leader>Dgb", dap.run_to_cursor, { desc = "Debug: Run To Cursor" })

			vim.keymap.set("n", "<leader>D?", function()
				dapui.eval(nil, { enter = true })
			end, {
				desc = "Debug: Evaluate Variable",
			})

			vim.keymap.set("n", "<leader>Dc", dap.continue, { desc = "Debug: Continue" })

			vim.keymap.set("n", "<leader>Dsi", dap.step_into, { desc = "Debug: Step Into" })

			vim.keymap.set("n", "<leader>Dso", dap.step_over, { desc = "Debug: Step Over" })

			vim.keymap.set("n", "<leader>DsO", dap.step_out, { desc = "Debug: Step Out" })

			vim.keymap.set("n", "<leader>Dsb", dap.step_back, { desc = "Debug: Step Back" })

			vim.keymap.set("n", "<leader>Dr", dap.restart, { desc = "Debug: Restart" })

			------------------------------------------------------------
			-- Automatically open/close DAP UI
			------------------------------------------------------------

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end

			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
