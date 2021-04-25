local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local b = vim.b
local fn = vim.fn

local M = {
    properties = {
        force_inactive = {
            filetypes = {},
            buftypes = {},
            bufnames = {}
        }
    },
    components = {
        left = {
            active = {},
            inactive = {}
        },
        mid = {
            active = {},
            inactive = {}
        },
        right = {
            active = {},
            inactive = {}
        }
    }
}

M.properties.force_inactive.filetypes = {
    'NvimTree',
    'dbui',
    'packer',
    'startify',
    'fugitive',
    'fugitiveblame'
}

M.properties.force_inactive.buftypes = {
    'terminal'
}

M.components.left.active[1] = {
    provider = '▊ ',
    hl = {
        fg = 'black'
    }
}

M.components.left.active[2] = {
    provider = 'vi_mode',
    hl = function()
        local val = {}

        val.name = "ViMode"
        val.bg = 'black'
        val.style = 'bold'

        return val
    end,
    right_sep = ' ',
    icon = ''
}

M.components.left.active[3] = {
    provider = 'file_info',
    hl = {
        fg = 'white',
        bg = 'black',
        style = 'bold'
    },
    left_sep = '',
    right_sep = ' ',
    icon = ''
}

M.components.left.active[4] = {
    provider = 'file_size',
    enabled = function() return fn.getfsize(fn.expand('%:p')) > 0 end,
    right_sep = {
        ' ',
        {
            str = 'vertical_bar_thin',
            hl = {
                fg = 'fg',
                bg = 'bg'
            }
        },
        ' '
    }
}

M.components.left.active[5] = {
    provider = 'position',
    right_sep = {
        ' ',
        {
            str = 'vertical_bar_thin',
            hl = {
                fg = 'fg',
                bg = 'bg'
            }
        }
    }
}

M.components.left.active[6] = {
    provider = ' ⏻ ',
    enabled = function() return not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) end,
    hl = { fg = 'white' },
}

M.components.left.active[7] = {
    provider = 'diagnostic_errors',
    enabled = function() return lsp.diagnostics_exist('Error') end,
    hl = {
        fg = 'red_foreground',
        bg = 'red_background'
    },
    right_sep = function()
        return {hl = {bg = 'red_background'}, str = ' '}
    end,
    icon = ' E-'
}

M.components.left.active[8] = {
    provider = 'diagnostic_warnings',
    enabled = function() return lsp.diagnostics_exist('Warning') end,
    hl = {
        fg = 'yellow_foreground',
        bg = 'yellow_background'
    },
    right_sep = function()
        return {hl = {bg = 'yellow_background'}, str = ' '}
    end,
    icon = ' W-'
}

M.components.left.active[9] = {
    provider = 'diagnostic_hints',
    enabled = function() return lsp.diagnostics_exist('Hint') end,
    right_sep = function() return {str = ' '} end,
    icon = ' H-'
}

M.components.left.active[10] = {
    provider = 'diagnostic_info',
    enabled = function() return lsp.diagnostics_exist('Information') end,
    right_sep = function() return {str = ' '} end,
    icon = ' I-'
}

M.components.left.active[11] = {
    provider = ' ',
    hl = { fg = 'white' },
}

M.components.right.active[1] = {
    provider = 'git_branch',
    hl = {
        fg = 'white',
        bg = 'black',
        style = 'bold'
    },
    left_sep = function()
        local val = {hl = {fg = 'white', bg = 'black'}}
        if b.gitsigns_status_dict then val.str = '⎇ ' else val.str = '' end
        return val
    end,
    right_sep = function()
        local val = {hl = {fg = 'NONE', bg = 'black'}}
        if b.gitsigns_status_dict then val.str = ' ' else val.str = '' end

        return val
    end,
    icon = ' '
}

M.components.right.active[2] = {
    provider = 'git_diff_added',
    icon = ' +'
}

M.components.right.active[3] = {
    provider = 'git_diff_changed',
    icon = ' ~'
}

M.components.right.active[4] = {
    provider = 'git_diff_removed',
    icon = ' -'
}

M.components.right.active[5] = {
    provider = 'line_percentage',
    hl = {
        style = 'bold'
    },
    left_sep = '  ',
    right_sep = ' '
}

M.components.right.active[6] = {
    provider = 'scroll_bar',
    hl = {
        fg = 'orange',
        style = 'bold'
    }
}

M.components.left.inactive[1] = {
    provider = 'file_type',
    hl = {
        fg = 'white',
        bg = 'black',
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = 'NONE',
            bg = 'black'
        }
    },
    right_sep = {
        {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'black'
            }
        },
        ' '
    }
}

local colors = {
    black = '#635954',
    white = '#efeae5',
    white2 = '#fbfaf9',
    orange = '#E44C22',
    green_background = '#e8ffd1',
    green_foreground = '#408000',
    red_background    = '#ffe0e0',
    red_foreground    = '#a7111d',
    yellow_background = '#f9ffa3',
    yellow_foreground = '#7b6a3d'
}

require('feline').setup({
  colors = colors,
  -- Can't use names from "colors" here
  default_bg = '#635954',
  default_fg = '#efeae5',
  -- vi_mode_colors = vi_mode_colors,
  components = M.components,
  properties = M.properties,
})
