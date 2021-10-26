TableCount = function(t)
    local i = 0
    for k, v in pairs(t) do
      i = i + 1
    end 
    return i
end

TimeFormat = function(milli)
    local mn = math.floor( milli / 60000 )
    local sec = math.floor((milli - (60000 * mn))  / 1000)
  
    if string.len(mn) == 1 then
        mn = "0"..mn
    end
  
    if string.len(sec) == 1 then
        sec = "0"..sec
    end
  
    return mn..":"..sec
end
