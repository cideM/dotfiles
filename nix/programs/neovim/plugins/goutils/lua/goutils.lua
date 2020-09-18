local a = vim.api

module = {}

local test_options = {
    height = 75,
    width = 100,
    relative = "win",
    win = 0,
    anchor = "SW",
    style = "minimal",
    focusable = true
}

local function render_floating_window(options)
    local opts = options or test_options

    -- Get editor dimensions (not window/pane!)
    local width = a.nvim_get_option("columns")
    local height = a.nvim_get_option("lines")

    local buf = a.nvim_create_buf(false, true)
    a.nvim_buf_set_option(buf, 'bufhidden', 'delete')
    opts.width = width
    opts.height = height / 2
    opts.row = width-1
    opts.col = 0
    local win = a.nvim_open_win(buf, 0, opts)

    return buf, win 
end

-- Temporarily switch to directory of current buffer and call "go test" This
-- solves the problem of having to figure out the correct path to the current
-- package.
function module.run_tests(testname)
    local cwd = vim.fn.getcwd()
    -- current buffer directory
    local cbd = vim.fn.expand('%:p:h')

    vim.cmd("silent cd " .. cbd)

    local buf, win = render_floating_window()

    local cmd = testname and ("go test -run " .. testname) or "go test"

    local stdio = vim.loop.new_pipe(false)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    local out = {"running: " .. cmd}

    local handle
    local pid
    handle, pid = vim.loop.spawn("go", {
            args = {"test"},
            stdio = {stdio, stdout, stderr}
        }, 
        vim.schedule_wrap(function()
            stdout:read_stop()
            stderr:read_stop()
            stdout:close()
            stderr:close()
            handle:close()

            for _ , line in ipairs(out) do
                local l = string.gsub(line, "\t", ": ")
                local last_line = vim.fn.line('$')-1
                a.nvim_buf_set_lines(buf, last_line, last_line, false, {l})
            end
        end))

    vim.loop.read_start(stderr, function(err, data)
        assert(not err, err)
        if data then
            print("read_start stdout", data)
            for line in vim.gsplit(data, "\n") do
                table.insert(out, line)
            end
        end
    end)

    vim.loop.read_start(stdout, function(err, data)
        assert(not err, err)
        if data then
            print("read_start stdout", data)
            for line in vim.gsplit(data, "\n") do
                table.insert(out, line)
            end
        end
    end)


    -- restore original cwd
    vim.cmd("silent cd " .. cwd)
end

    return module
