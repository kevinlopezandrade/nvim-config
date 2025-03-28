local M = {}

-- Settings found from the pyright repo and the visual studio extension docs.
local settings = {
    basedpyright = {
        disableOrganizeImports = true
    },
    python = {
        analysis = {
            useLibraryCodeForTypes = true, -- I can test this manually.
            typeCheckingMode = "strict"
        }
    },
    telemetry = {
        telemetryLevel = "off",
    }
}

function M.launch()
        vim.lsp.start({
                name = "basedpyright",
                cmd = {"basedpyright-langserver", "--stdio"},
                settings = settings,
                root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml', "environment.yml"}, { upward = true})[1]),
                before_init = function(initialize_params, config)
                    cmp_capabilities = require("cmp_nvim_lsp").default_capabilities().textDocument.completion
                    initialize_params.capabilities.textDocument.completion = cmp_capabilities

                    -- Check LSP protocol specification for understanding the following line.
                    initialize_params.capabilities.textDocument.publishDiagnostics.tagSupport = {2}
                end,
                on_init = function (client, results)
                        if results.offsetEncoding then
                                client.offset_encoding = results.offsetEncoding
                        end

                        if client.config.settings then
                                client.notify('workspace/didChangeConfiguration', {
                                        settings = client.config.settings
                                })
                        end

                end
        })
end

return M
