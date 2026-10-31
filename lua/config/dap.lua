require("mason-nvim-dap").setup({
  ensure_installed = { "codelldb" },
  automatic_installation = true,
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

-- Compiles the CURRENT buffer with gcc/g++ and returns the output binary path.
-- Used for quick DSA-style single-file debugging — no Makefile needed.
local function compile_current_file()
  local filepath = vim.fn.expand("%:p")
  local filedir  = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t:r")
  local ext      = vim.fn.expand("%:e")
  local outpath  = filedir .. "/" .. filename .. ".out"
  local compiler = (ext == "cpp" or ext == "cc" or ext == "cxx") and "g++" or "gcc"
  local std      = (compiler == "g++") and "c++17" or "c11"

  local cmd = string.format(
    "%s -g -O0 -std=%s %s -o %s",
    compiler, std,
    vim.fn.shellescape(filepath),
    vim.fn.shellescape(outpath)
  )

  vim.notify("Compiling: " .. cmd)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Compile failed:\n" .. result, vim.log.levels.ERROR)
    return nil
  end
  return outpath
end

-- Runs `make` in the project root, then lets you pick the built binary.
local function build_project_and_pick_binary()
  vim.notify("Running make...")
  local result = vim.fn.system("make")
  if vim.v.shell_error ~= 0 then
    vim.notify("make failed:\n" .. result, vim.log.levels.ERROR)
    return nil
  end
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

local cpp_configs = {
  {
    name = "Build & debug current file (DSA / single file)",
    type = "codelldb",
    request = "launch",
    program = function()
      local out = compile_current_file()
      if not out then error("compilation failed") end
      return out
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Build project (make) & debug",
    type = "codelldb",
    request = "launch",
    program = function()
      local out = build_project_and_pick_binary()
      if not out then error("build failed or cancelled") end
      return out
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Debug already-built binary (no build step)",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.c   = cpp_configs
dap.configurations.cpp = cpp_configs

-- Keymaps
vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Start/Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Conditional Breakpoint" })
vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "DAP: Terminate" })
vim.keymap.set("n", "<Leader>dc", dap.run_to_cursor, { desc = "DAP: Run to cursor" })
