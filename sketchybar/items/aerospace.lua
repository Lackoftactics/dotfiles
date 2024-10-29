function parse_string_to_table(s)
    local result = {}
    for line in s:gmatch("([^\n]+)") do
        table.insert(result, line)
    end
    return result
end

function get_workspaces()
    local file = io.popen("aerospace list-workspaces --all")
    local result = file:read("*a")
    file:close()

    return parse_string_to_table(result)
end

function get_current_workspace()
    local file = io.popen("aerospace list-workspaces --focused")
    local result = file:read("*a")
    file:close()

    return parse_string_to_table(result)[1]
end
