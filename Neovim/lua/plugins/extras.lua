-- Copilot and focus/zen modes.
return {
  -- copilot.vim -> copilot.lua (lighter, Lua-native)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = { accept = "<C-l>" },
      },
      panel = { enabled = false },
    },
  },

  -- goyo -> zen-mode, limelight -> twilight
  { "folke/zen-mode.nvim", cmd = "ZenMode", opts = {} },
  { "folke/twilight.nvim", cmd = { "Twilight", "TwilightEnable" }, opts = {} },
}
