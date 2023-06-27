local M = {}

-- Settings found from the pyright repo and the visual studio extension docs.
local settings = {
    pyright = {
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

local function extract_variable()
  local pos_params = vim.lsp.util.make_given_range_params()
  local params = {
    command = "pylance.extractVariable",
    arguments = {
      vim.api.nvim_buf_get_name(0),
      pos_params.range,
    },
  }
  vim.lsp.buf.execute_command(params)
end

local function extract_method()
  local pos_params = vim.lsp.util.make_given_range_params()
  local params = {
    command = "pylance.extractMethod",
    arguments = {
      vim.api.nvim_buf_get_name(0),
      pos_params.range,
    },
  }
  vim.lsp.buf.execute_command(params)
end


function M.launch()
        vim.lsp.start({
                name = "pylance",
                cmd = {"node", "/home/kev/Builds/pylance/extension/dist/server.bundle.js", "--stdio"},
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

                end,
                on_attach = function(code, signal, client_id)
                    vim.api.nvim_buf_create_user_command(0, "PylanceExtractVariable", extract_variable, {
                        range = true, desc = "Extract variable"
                    })
                    vim.api.nvim_buf_create_user_command(0, "PylanceExtractMethod", extract_method, {
                        range = true, desc = "Extract method"
                    })
                end
        })
end

return M
