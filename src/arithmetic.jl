# ===========================================================================
# Arithmetic
# ===========================================================================
function Base.:+(u::UDT, p::UDTPeriod)
    delta = if p isa UDTYear
        value(p) * SECONDS_PER_YEAR
    elseif p isa UDTMonth
        value(p) * SECONDS_PER_MONTH
    elseif p isa UDTWeek
        value(p) * SECONDS_PER_WEEK
    elseif p isa UDTDay
        value(p) * SECONDS_PER_DAY
    elseif p isa UDTHour
        value(p) * SECONDS_PER_HOUR
    elseif p isa UDTMinute
        value(p) * SECONDS_PER_MINUTE
    elseif p isa UDTSecond
        value(p)
    else
        throw(ArgumentError("Unsupported period"))
    end
    return UDT(value(u) + delta)
end

function Base.:+(u::UDTDate, p::Union{UDTYear, UDTMonth, UDTWeek, UDTDay})
    delta = if p isa UDTYear
        value(p) * 1000
    elseif p isa UDTMonth
        value(p) * 100
    elseif p isa UDTWeek
        value(p) * 10
    elseif p isa UDTDay
        value(p)
    else
        throw(ArgumentError("Unsupported period for UDTDate"))
    end
    return UDTDate(value(u) + delta)
end

# Prevent fallback to Dates.CompoundPeriod
function Base.:+(u::UDT, p1::UDTPeriod, p2::UDTPeriod, periods::UDTPeriod...)
    result = u + p1
    result += p2
    for p in periods
        result += p
    end
    return result
end

function Base.:+(u::UDTDate, p1::Union{UDTYear, UDTMonth, UDTWeek, UDTDay},
                 p2::Union{UDTYear, UDTMonth, UDTWeek, UDTDay}, 
                 periods::Union{UDTYear, UDTMonth, UDTWeek, UDTDay}...)
    result = u + p1
    result += p2
    for p in periods
        result += p
    end
    return result
end
Base.:+(u::UDT, p::UDT) = UDT(u.instant.value + p.instant.value)
Base.:-(u::UDT, p::UDTPeriod) = u + p * (-1)
Base.:-(u::UDTDate, p::UDTDate) = UDTDate(u.instant.value - p.instant.value)
Base.:-(u::UDT, p::UDT) = UDT(u.instant.value - p.instant.value)
Base.:-(u::UDTDate, p::Union{UDTYear, UDTMonth, UDTWeek, UDTDay}) = u + p * (-1)
