local lint = {}

lint.lint = function ()
  print "Linting..."

  local ns = vim.api.nvim_create_namespace("rpgle_diagnostics")

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local diagnostics = {}

  local if_stack = 0

  for i, line in ipairs(lines) do
    if line:match("^%s*if%s") then
      if_stack = if_stack + 1
    elseif line:match("^%s*endif%s*$") then
      if_stack = if_stack - 1
    end

    if not line:lower():match("dcl%-s") and
       (line:lower():match("char%(%d+%);") or line:lower():match("packed%(%d+%);") or line:lower():match("zoned%(%d+%);")) then
      table.insert(diagnostics, {
        lnum = i - 1,
        col = 0,
        message = "Possible missing dcl-s declaration",
        severity = vim.diagnostic.severity.WARN,
      })
    end
  end

  if if_stack ~= 0 then
    table.insert(diagnostics, {
      lnum = 0,
      col = 0,
      message = "Unmatched IF/ENDIF block",
      severity = vim.diagnostic.severity.ERROR,
    })
  end

  vim.diagnostic.set(ns, vim.api.nvim_get_current_buf(), diagnostics, {} )

end

return lint
