local _ = {}

_.add = function (augend, addend)
    return augend + addend
end

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

_.clear = function (table)
    if _.is_table(table) == false then return nil end

    for key in _.get_iterator(table) do
        table[key] = nil
    end

    return table
end

_.clone = function (table, cache)
    if _.is_table(table) == false then return table end
    if _.is_nil(cache) == false and _.is_nil(cache[table]) == false then return cache[table] end

    local clone = setmetatable({}, getmetatable(table))

    local cache = cache or {}
    cache[table] = clone

    for key, value in _.get_iterator(table) do
        clone[_.clone(key, cache)] = _.clone(value, cache)
    end

    return clone
end

_.count = function (table)
    return _.reduce(table, function (accumulator) return accumulator + 1 end, 0)
end

_.discard = function (...)
    return nil
end

_.divide = function (dividend, divisor)
    return dividend / divisor
end

_.exponentiate = function (factor, exponent)
    return factor ^ exponent
end

_.fill = function (table, value)
    if _.is_table(table) == false then return value end

    for key in _.get_iterator(table) do
        table[key] = value
    end

    return table
end

_.filter = function (table, subroutine, ...)
    local image = {}

    for key, value in _.get_iterator(table) do
        if _.apply(subroutine, value, key, ...) == true then image[key] = value end
    end

    return image
end

_.generate = function (count, subroutine, ...)
    if _.is_number(count) == false then return nil end

    local image = {}

    for index = 1, count do
        value, key = _.apply(subroutine, index, ...)

        key = key or index
        image[key] = value
    end

    return image
end

_.get_identity = function (...)
    return ...
end

_.get_iterator = function (...)
    return pairs(_.tabulate(_.aggregate(...)))
end

_.get_sign = function (number)
    if _.is_number(number) == false then return nil end
    return number == 0 and 0 or (number > 0 and 1 or -1)
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

_.iterate = function (table, subroutine, ...)
    for key, value in _.get_iterator(table) do
        _.apply(subroutine, value, key, ...)
    end
end

_.map = function (table, subroutine, ...)
    local image = {}

    for key, value in _.get_iterator(table) do
        image[key] = _.apply(subroutine, value, key, ...)
    end

    return image
end

_.multiply = function (multiplier, multiplicand)
    return multiplier * multiplicand
end

_.negate = function (value)
    return -value
end

_.reduce = function (table, subroutine, seed, ...)
    local accumulator = seed

    for key, value in _.get_iterator(table) do
        if _.is_nil(accumulator) == true then accumulator = value
        else accumulator = _.apply(subroutine, accumulator, value, key, ...) end
    end

    return accumulator
end

_.subtract = function (minuend, subtrahend)
    return minuend - subtrahend
end

_.tabulate = function (value)
    if _.is_nil(value) then return {}
    elseif _.is_table(value) == false then return { value } end

    return value
end

_.test = function (table, subroutine, ...)
    for key, value in _.get_iterator(table) do
        if _.apply(subroutine, value, key, ...) == false then return false end
    end

    return true
end

return _
