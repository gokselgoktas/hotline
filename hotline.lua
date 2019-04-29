local _ = {}

_.is_boolean = function (value)
    return type(value) == 'boolean'
end

_.is_function = function (value)
    return type(value) == 'function'
end

_.is_nil = function (value)
    return value == nil
end

_.is_number = function (value)
    return type(value) == 'number'
end

_.is_string = function (value)
    return type(value) == 'string'
end

_.is_table = function (value)
    return type(value) == 'table'
end

return _
