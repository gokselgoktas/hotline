local _ = {}

_.aggregate = function (...)
    if select('#', ...) >= 2 then
        return { ... }
    end

    return ...
end

_.discard = function (...)
    return nil
end

_.get_identity = function (...)
    return ...
end

_.get_iterator = function (...)
    return pairs(_.tabulate(_.aggregate(...)))
end

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

_.tabulate = function (value)
    if _.is_nil(value) then return {}
    elseif _.is_table(value) == false then return { value } end

    return value
end

return _
