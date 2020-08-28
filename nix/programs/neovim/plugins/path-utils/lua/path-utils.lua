local module = {}

-- Inspired by https://github.com/Guergeiro/clean-path.vim/blob/master/plugin/clean-path.vim
function module.set_path()
    -- Run system command and read result without newlines
    -- Careful if command returns a newline delimited list
    local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
    local result = string.gsub(handle:read("*a"), "\n", "")

    if result ~= "" then
      -- Same procedure but keep newlines, we'll split the result on them
      -- Use -d for max depth otherwise we can exceed the max number of
      -- paths we can set in vim
      local fd_handle = io.popen("fd . -t d " .. result)
      local fd_result = fd_handle:read("*a")

      -- Create a list of all directories fd found
      local paths = {}
      -- Split string by matching all non-whitespace character groups
      for v in string.gmatch(fd_result, "%S+") do
        if v ~= "" then
          table.insert(paths, v)
        end
      end

      -- Add current path as well, we're gonna make this unique
      -- Split string by matching all consecutive non-comma chars
      if vim.o.path ~= nil then
          for v in string.gmatch(vim.o.path, "[^,]+") do
            if v ~= "" then
              table.insert(paths, v)
            end
          end
      end

      -- Make list of directories unique
      -- Includes both current path and new directories
      local seen = {}
      local unique = {}
      for _, v in ipairs(paths) do
        if not seen[v] then
          table.insert(unique, v)
          seen[v] = true
        end
      end

      -- Set path and clean up
      vim.o.path = table.concat(unique, ",")
      fd_handle:close()
    end

    handle:close()
end

return module
