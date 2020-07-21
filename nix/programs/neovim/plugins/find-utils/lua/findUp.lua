function findUp(query, start, stop)
    -- Define earlier otherwise we can't use it for recursion
    local go

    go = function(path)
        if path == stop then
            return false
        end

        if path == "/" then
            -- Safeguard against infinite recursion in case something with
            -- stop goes wrong
            print("Path is '/' which it probably shouldn't be. Did you use 'stop' parameter correctly?")
            return false
        end

        local full_path = string.format("%s/%s", path, query)

        local f = io.open(full_path,"r")

        if f ~= nil
           then 
               io.close(f)
               return full_path
           else
               -- Everything until final /, equivalent of "dirname"
               local p = path:match("(.*/)")
               if p == stop or p == "" or p == nil then
                   return false
               end

               -- Recurse into parent folder but remove trailing slash so all
               -- paths inside this function assume no trailing slash
               return go(p:gsub("/$", ""))
        end
    end

    return go(string.format("%s/%s", start:gsub("/$", ""), query:gsub("/$", "")))
end

return {
    findUp = findUp
}
