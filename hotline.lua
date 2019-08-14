local _ = {}

_.add = function (augend, addend)
    return augend + addend
end

_.aggregate = function (...)
    if select('#', ...) >= 2 then
        return _.pack(...)
    end

    return ...
end

_.apply = function (subroutine, ...)
    local subroutine = subroutine or _.get_identity
    if _.is_function(subroutine) == false then return nil end

    return subroutine(...)
end

_.bind = function (subroutine, ...)
    local subroutine = subroutine or _.discard
    if _.is_function(subroutine) == false then return _.discard end

    local bound_arguments = _.tabulate(_.aggregate(...))

    return function (...)
        local arguments = _.clone(bound_arguments)

        _.iterate(_.tabulate(_.aggregate(...)),
            function (value) table.insert(arguments, value) end)

        return _.apply(subroutine, table.unpack(arguments))
    end
end

_.clamp = function (value, minimum, maximum)
    return value < minimum and minimum or (value > maximum and maximum or value)
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

_.cluster = function (table, subroutine, ...)
    if _.is_function(subroutine) == false then return {} end

    local image = {}

    for key, value in _.get_iterator(table) do
        cluster, key = _.apply(subroutine, value, key, ...)

        if _.is_nil(cluster) == false then
            image[cluster] = image[cluster] or {}

            key = _.is_nil(key) == true and #image[cluster] + 1 or key
            image[cluster][key] = value
        end
    end

    return image
end

_.convert_to_sequence = function (table)
    if _.is_table(table) == false then return table end

    local image = {}

    for key, value in _.get_iterator(table) do
        image[#image + 1] = _.convert_to_sequence(value)
    end

    return image
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
    local index = 1

    for key, value in _.get_iterator(table) do
        is_accepted, key = _.apply(subroutine, value, key, ...)
        key = _.is_nil(key) == true and index or key

        if is_accepted == true then
            image[key] = value
            index = index + 1
        end
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

_.get_sequential_iterator = function (...)
    return ipairs(_.tabulate(_.aggregate(...)))
end

_.get_sign = function (number)
    if _.is_number(number) == false then return nil end
    return number == 0 and 0 or (number > 0 and 1 or -1)
end

_.ignore = function (...)
end

_.interpolate = function (from, to, weight)
    return from + (to - from) * _.saturate(weight)
end

_.is_boolean = function (value)
    return type(value) == 'boolean'
end

_.is_empty = function (table)
    if _.is_nil(table) == true then return true end
    return _.is_table(table) == true and next(table) == nil
end

_.is_equal_to = function (left_hand_side, right_hand_side)
    return left_hand_side == right_hand_side
end

_.is_function = function (value)
    return type(value) == 'function'
end

_.is_greater_than = function (left_hand_side, right_hand_side)
    return left_hand_side > right_hand_side
end

_.is_less_than = function (left_hand_side, right_hand_side)
    return left_hand_side < right_hand_side
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

_.is_thread = function (value)
    return type(value) == 'thread'
end

_.is_userdata = function (value)
    return type(value) == 'userdata'
end

_.iterate = function (table, subroutine, ...)
    for key, value in _.get_iterator(table) do
        _.apply(subroutine, value, key, ...)
    end
end

_.locate = function (table, value, ...)
    if _.is_table(table) == false then return nil end

    local predicate = _.is_function(value) == true and value or
        _.bind(_.is_equal_to, value)

    for key, value in _.get_iterator(table) do
        if predicate(value, ...) == true then return key end
    end

    return nil
end

_.map = function (table, subroutine, ...)
    local image = {}
    local index = 1

    for key, value in _.get_iterator(table) do
        value, key = _.apply(subroutine, value, key, ...)
        key = _.is_nil(key) == true and index or key

        image[key] = value
        index = index + 1
    end

    return image
end

_.multiply = function (multiplier, multiplicand)
    return multiplier * multiplicand
end

_.negate = function (value)
    return -value
end

_.pack = function (...)
    return { ... }
end

_.reduce = function (table, subroutine, seed, ...)
    local accumulator = seed

    for key, value in _.get_iterator(table) do
        if _.is_nil(accumulator) == true then accumulator = value
        else accumulator = _.apply(subroutine, accumulator, value, key, ...) end
    end

    return accumulator
end

_.saturate = function (value)
    return _.clamp(value, 0, 1)
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
