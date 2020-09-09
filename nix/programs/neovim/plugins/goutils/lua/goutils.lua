module = {}

-- Temporarily switch to directory of current buffer and call "go test" This
-- solves the problem of having to figure out the correct path to the current
-- package.
function module.run_tests(testname)
    local cwd = vim.fn.getcwd()
    -- current buffer directory
    local cbd = vim.fn.expand('%:p:h')

    vim.cmd("silent cd " .. cbd)

    local cmd = testname and ("go test -run " .. testname) or "go test"

    -- make it transparent what we're doing
    print("running: ", cmd)
    local handle = io.popen(cmd)

    for line in handle:lines() do
        -- > gsub also returns, as its second value, the total number 
        -- > of matches that occurred
        -- We don't need that
        local l = string.gsub(line, "\t", "")
        print(l)
    end

    handle:close()

    -- restore original cwd
    vim.cmd("silent cd " .. cwd)
end

return module
