local M = {}

local _config = {}

function M.hello()
  print "Hello World!"
end

function M.setup(config)
  _config = config
end

return M
