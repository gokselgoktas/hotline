local _ = {}

_.is_nil = function (value)
    return value == nil
end

_.is_string = function (value)
    return type(value) == 'string'
end

_.is_table = function (value)
    return type(value) == 'table'
end

return _
