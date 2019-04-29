local _ = {}

_.is_table = function (value)
    return type(value) == 'table'
end

return _
