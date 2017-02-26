string.split=function(str,split,id)
    local list={}
    for val in string.gmatch(str,id and (id==0 and '[^'..(split or '%s')..']+' or string.rep('.',id)) or split) do
        table.insert(list,val)
    end
    return list
end
