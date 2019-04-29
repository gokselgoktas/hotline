local _ = {}

_.aggregate = function (...)
    if select('#', ...) >= 2 then
        return { ... }
    end

    return ...
end

_.apply = function (subroutine, ...)
    local subroutine = subroutine or _.get_identity
    if _.is_function(subroutine) == false then return nil end

    return subroutine(...)
end

_.discard = function (...)
    return nil
end

_.filter = function (table, subroutine, ...)
    local image = {}

    for key, value in _.get_iterator(table) do
        if _.apply(subroutine, value, key, ...) == true then image[key] = value end
    end

    return image
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

_.map = function (table, subroutine, ...)
    local image = {}

    for key, value in _.get_iterator(table) do
        image[key] = _.apply(subroutine, value, key, ...)
    end

    return image
end

_.tabulate = function (value)
    if _.is_nil(value) then return {}
    elseif _.is_table(value) == false then return { value } end

    return value
end

return _
