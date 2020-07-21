-- [[
-- TODO: Maybe use global variables to communicate the fg and bg stuff
-- TODO: With the above change I could define a state close handler which I can then
-- TODO: Extract the zen mode function into a floating padded window. It should take a buffer and return just a window handle.
-- It should automatically do the close stuff on new buffer that's not the focused window
-- Adding the background is then what zen mode does by adding a BG. It can use WinClose to also close the BG if
-- the closed win handle is the same as the one it got back from the loating padded window func.
-- use to close the current zen mode window BEFORE opening FZF
-- ]]
function createCloseHandler(foreground, windows)
    -- Create the close callback which closes over the background window ID
    local zenCloseBackgroundWindow = function () 
        -- Remove the WinLeave autocommand, otherwise the following happens
        -- User is looking at buffer 1
        -- StartZenMode -> buffer 1 gets the autocmd WinLeave
        -- :q           -> WinLeave is triggered, but **buffer 1 still has the autocmd**
        -- StartZenMode -> Triggers WinLeave which immediately closes the BG window
        -- ^^^ this part is prevented by clearing the autocmd when closing the window

        -- The currently focused window is not the zen mode window
        if foreground ~= vim.api.nvim_get_current_win() then
            vim.api.nvim_command('augroup ZEN')
            vim.api.nvim_command('autocmd!')
            vim.api.nvim_command('augroup END')

            for k,v in pairs(windows) do
                -- Foreground may still be active, user just focused something else
                if vim.api.nvim_win_is_valid(v) then
                    vim.api.nvim_win_close(v, true) 
                end
            end
        end
    end

    return zenCloseBackgroundWindow
end

function openBackground()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    -- Create the background window and a callback for closing it later on
    local bg_opts = {
        relative = "editor",
        width = width,
        height = height,
        style = "minimal",
        focusable = false,
        row = 0,
        col = 0,
    }

    local bg_buf = vim.api.nvim_create_buf(false, true)
    local bg = vim.api.nvim_open_win(bg_buf, false, bg_opts)
    vim.api.nvim_win_set_option(bg, 'winhl', 'Normal:Normal,EndOfBuffer:EndOfBufferFloat')

    return bg
end

function openForeground(buf)
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local new_width = math.min(math.ceil(width * 0.8), 120)
    local new_height = math.ceil(height * 0.8)
    local top = math.ceil((height - new_height)/2)
    local left = math.ceil((width - new_width)/2)

    -- TODO: Extract padded border stuff into separate func
    local border_win_width = new_width + 6
    local border_win_height = new_height + 2
    local topLine = "╭" .. string.rep("─", border_win_width-2 ) .. "╮"
    local midLine = "│" .. string.rep(" ", border_win_width-2 ) .. "│"
    local botLine = "╰" .. string.rep("─", border_win_width-2 ) .. "╯"

    local lines = {}
    lines[1] = topLine
    lines[border_win_height] = botLine

    local i = 2
    while(i<border_win_height)
    do
        lines[i] = midLine
        i = i+1
    end

    local borderBuf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(borderBuf, 0, -1, true, lines)

    local borderOpts = {
        relative = "editor",
        width = border_win_width,
        height = border_win_height,
        style = "minimal",
        row = top - 1,
        col = left - 3,
    }
    local borderWindow = vim.api.nvim_open_win(borderBuf, false, borderOpts)
    vim.api.nvim_win_set_option(borderWindow, 'winhl', 'Normal:Conceal,EndOfBuffer:EndOfBufferFloat')

    -- Take the current buffer and open it in a Zen mode floating window Set up
    -- the autocommand for closing the background when closing the Zen mode
    -- window
    local opts = {
        relative = "editor",
        width = new_width,
        height = new_height,
        row = top,
        col = left,
    }

    local fg = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_win_set_option(fg, 'winhl', 'Normal:Normal,EndOfBuffer:EndOfBufferFloat')

    local windows = {}
    -- fg must come first
    table.insert(windows, fg)
    table.insert(windows, borderWindow)

    return windows
end

function initCloseHandler(handlerName)
    -- Set up autocmd for closing background when leaving the floating buffer
    vim.api.nvim_command('augroup ZEN')
    vim.api.nvim_command('autocmd!')
    vim.api.nvim_command('autocmd WinEnter * lua ' .. handlerName .. '()')
    vim.api.nvim_command('augroup END')
end
    function sleep(n)
        os.execute("sleep " .. tonumber(n))
    end

function startZenMode()
    -- TODO: Investigate how the vim.api batches calls. I'm currently reversing the order
    -- because it looks as if the last API call is executed first (?) and I need these windows
    -- to be on top, so opened after background
    local windows = openForeground(vim.api.nvim_get_current_buf())
    local bg = openBackground()
    table.insert(windows, bg)

    zenCloseBackgroundWindow = createCloseHandler(windows[1], windows)

    initCloseHandler('zenCloseBackgroundWindow')
end

return {
    start_zen_mode = startZenMode,
    -- Temporary, extract into own module
    openForeground = openForeground,
    createCloseHandler = createCloseHandler,
    initCloseHandler = initCloseHandler,
}
