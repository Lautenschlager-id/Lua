system = {}
system.sleep = function(time)
    local timer = os.time() + time
    while timer > os.time() do
    end
    -- os.execute("ping localhost >nul -n "..time)
end
