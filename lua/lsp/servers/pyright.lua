local M = {}

function M.launch()
        vim.lsp.start({
                name = "pyright",
                cmd = {"pyright-langserver", "--stdio"},
                root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true})[1]),
                on_init = function (client, results)
                        if results.offsetEncoding then
                                client.offset_encoding = results.offsetEncoding
                        end

                        if client.config.settings then
                                client.notify('workspace/didChangeConfiguration', {
                                        settings = client.config.settings
                                })
                        end

                        -- Disable the ones I don't want to have, in combination with Jedi.
                        local capabilities = client.server_capabilities
                        capabilities.hoverProvider = false
                        capabilities.signatureHelpProvider = false
                        capabilities.completionProvider = false
                end,
        })
end

return M
