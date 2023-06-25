local api = vim.api

local function create_buffer_string(bufnr, highlight)
    local filename = api.nvim_buf_get_name(bufnr)
    local basename = vim.fn.fnamemodify(filename, ':t')
    local ismodified = api.nvim_buf_get_option(bufnr, 'modified')
    local modified_sign = ''
    local right_separator = '  '
    local left_separator = '  '

    -- For empty buffer set a different name.
    if filename == '' then
        basename = "No Name"
    end

    if ismodified then
        modified_sign = '+'
        right_separator = ' '
    end

    -- Margins and all that stuff must be set here, separators.
    return table.concat {
        '',
        highlight,
        left_separator,
        bufnr,
        ':',
        basename,
        modified_sign,
        right_separator
    }
end

-- Check tips and tricks for the actual if it does not work.
local function get_buffers_string(inactive)
    local callback = function()
        local api = vim.api
        local buffer = api.nvim_get_current_buf()
        local string = ""
        local highlight_current = "%#Visual#"
        
        if inactive then
            highlight_current = "%#StatusLineNC#"
        end

        for index, bufnr in ipairs(api.nvim_list_bufs()) do
            if vim.fn.buflisted(bufnr) == 1 and api.nvim_buf_is_loaded(bufnr) then
                if buffer == bufnr then
                    string = string .. create_buffer_string(bufnr, highlight_current)
                else
                    string = string .. create_buffer_string(bufnr, '%#StatusLineNC#')
                end
            end
        end

        -- -- print(vim.inspect(api.nvim_list_bufs()))
        return string .. '%*'
    end
    return callback
end

local components = {
    active = {},
    inactive = {}
}

table.insert(components.active, {})
table.insert(components.active, {})

table.insert(components.inactive, {})
table.insert(components.inactive, {})

components.active[1][1] = {
    provider = get_buffers_string(false),
    hl = "StatusLine",
}

components.active[2][1] = {
    provider = "git_branch",
    hl = "Visual",
    right_sep = {
        str = ' | ',
        hl = 'Visual'
    },
    left_sep = {
        str = ' ',
        hl = 'Visual'
    }
}
components.active[2][2] = {
    provider = {
        name = "file_type",
        opts = {
            case = "lowercase"
        }
    },
    icon = "",
    hl = "Visual",
    -- left_sep = "slant_left",
}
components.active[2][3] = {
    provider = "position",
    hl = "Visual",
    left_sep = {
        str = ' | ',
        hl = 'Visual'
    },
    right_sep = {
        str = ' ',
        hl = 'Visual'
    }
}

components.inactive[1][1] = {
    provider = get_buffers_string(true),
    hl = "StatusLine"
}
components.inactive[2][1] = components.active[2][1]
components.inactive[2][2] = components.active[2][2]
components.inactive[2][3] = components.active[2][3]



return {
    "feline-nvim/feline.nvim",
    lazy = false,
    config = function ()
        require("feline").setup({
            components = components,
            disable = {
                filetypes = {
                    '^neo%-tree$',
                    '^help'
                },
                buftypes = {
                    '^terminal$',
                }
            }
        })

    end
}
