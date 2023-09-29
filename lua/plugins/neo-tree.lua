local conf = {
    enable_diagnostics = false,
    filesystem = {
        window = {
            mappings = {
                -- disable fuzzy finder
                ["/"] = "noop"
            }
        },
        filtered_items = {
            show_hidden_count = false
        }
    },
    default_component_configs = {
        git_status = {
            symbols = {
                -- Change type
                added     = "",
                deleted   = "",
                modified  = "",
                renamed   = "",
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "",
                staged    = "",
                conflict  = "",
            }
        }
    },
    renderers = {
        file = {
            { "indent" },
            {
                "container",
                content = {
                    {
                        "name",
                        zindex = 10
                    },
                    { "clipboard", zindex = 10 },
                    { "bufnr", zindex = 10 },
                    { "modified", zindex = 20, align = "right" },
                    { "diagnostics",  zindex = 20, align = "right" },
                    { "git_status", zindex = 20, align = "right" },
                },
            },
        },
    }
}


local build_function = function (command, manager)
    return function ()
        args = {
            action = "focus",
            source = "filesystem",
            position = "left",
            toggle = true
        }

        local windows = vim.api.nvim_tabpage_list_wins(0)

        if #windows <= 1 then
            command.execute(args)
        else
            local is_neo_tree_open = false
            local bufnr_if_open = 0

            for index, winid in ipairs(windows) do
                local bufnr = vim.api.nvim_win_get_buf(winid)
                local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                if filetype == "neo-tree" then
                    is_neo_tree_open = true
                    bufnr_if_open = bufnr
                    break
                end
            end

            if is_neo_tree_open then
                -- Always close no matter, since its open.
                local position = vim.api.nvim_buf_get_var(bufnr_if_open, "neo_tree_position")
                manager.close_all(position)



                -- Hack. I pressume that the event "window_close" does not fire in current.
                -- vim.opt.laststatus = 3
            else
                -- I open in current buffer.
                args.position = "current"
                args.toggle = false
                -- I also want full statusline in current mode.
                command.execute(args)



                --- Aca no reenderiza por que digo a feline, si estoy en neo-tree
                -- disable. y como estoy en full statusline me disable todo.
                -- vim.opt.laststatus = 3
            end
        end
    end
end


return {
   "nvim-neo-tree/neo-tree.nvim",
   lazy = false,
   branch = "v3.x",
   dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim"
   },
   config = function ()
       require("neo-tree").setup(conf)
       local command = require("neo-tree.command")
       local manager = require("neo-tree.sources.manager")
       local func = build_function(command, manager)
       vim.keymap.set('n', "<leader>nn", func, {noremap = true, silent = true})
   end
}
