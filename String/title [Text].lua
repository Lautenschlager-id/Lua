string.title = function(t)
  return t:lower():gsub("%S+",function(v) return v:gsub("%a",string.upper,1) end)
 end
