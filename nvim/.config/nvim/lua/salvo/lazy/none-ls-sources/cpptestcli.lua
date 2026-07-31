local null_ls = require 'null-ls'

-- Convert a SARIF report into a table of diagnostic objects
local function parse_sarif(params)
        local diagnostics = {}
        local output = params.output

        for _, run in ipairs(output.runs) do
                for _, result in ipairs(run.results or {}) do
                        local region = result.locations[1].physicalLocation.region
                        table.insert(diagnostics, {
                                row = region.startLine,
                                col = region.startColumn or 1,
                                end_col = (region.startColumn + 1) or 2,
                                message = result.message.text,
                                severity = ({ error = 1, warning = 2, note = 3 })[result.level] or 2,
                                source = "cpptestcli",
                                code = result.ruleId
                        })
                end
        end

        return diagnostics
end

-- Traverse directories up from a given location, until '.parasoft' is found
local function find_project_root(bufname)
        local project_roots = vim.fs.find('.parasoft', {
                path = bufname,
                upward = true,
                stop = vim.uv.os_homedir(),
        })

        return project_roots[1] and vim.fn.fnamemodify(project_roots[1], ':h') or nil
end

-- Run cpptestcli on the current buffer, output a SARIF report, cat that to stdout
local function cpptestcli_sarif_args(params)
        local project_root = find_project_root(params.bufname)
        local parasoft_config_dir = project_root .. "/.parasoft"
        local build_dir = project_root .. "/build"
        local report_location = build_dir .. "/cpptest/report"

        return {
                "-c",
                "/opt/cpptest/cpptestcli" ..
                " -config " .. parasoft_config_dir .. "/rules.properties" ..
                " -settings " .. parasoft_config_dir .. "/project.properties" ..
                " -input " .. build_dir .. "/compile_commands.json" ..
                " -workspace " .. build_dir ..
                " -report " .. report_location ..
                " -property report.format=sarif" ..
                " -resource " .. vim.fn.substitute(params.bufname, params.cwd .. '/', '', '') ..
                " 2>&1 >/dev/null" ..

                " && cat " .. report_location .. "/report.sarif"
        }
end

local cpptestcli = {
        name = "cpptestcli",
        method = {
                null_ls.methods.DIAGNOSTICS_ON_SAVE,
                null_ls.methods.DIAGNOSTICS_ON_OPEN
        },
        filetypes = { "c" },
        generator = null_ls.generator({
                command = "bash",
                args = cpptestcli_sarif_args,
                format = "json",
                timeout = 60000,
                on_output = parse_sarif
        })
}

return cpptestcli
