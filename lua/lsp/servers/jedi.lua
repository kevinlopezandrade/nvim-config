local M = {}

function M.launch()
        vim.lsp.start({
                name ="jedi",
                cmd = { "jedi-language-server" },
                init_options = {
                        diagnostics = {
                                enable = false
                        }
                },
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
                        local capabilities = client.server_capabilities
                        capabilities.documentSymbolProvider = false
                        capabilities.documentHighlightProvider = false
                        capabilities.definitionProvider = false
                        capabilities.typeDefinitionProvider = false
                        capabilities.renameProvider = false
                        capabilities.workspaceSymbolProvider = false
                        capabilities.referencesProvider = false
                        -- TODO: Research what workspace is in server_capabilities
                end
        })
end

return M
