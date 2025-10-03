# ===========================================================================
# Ranges for Universal Decimal Time
# ===========================================================================

# Prevent ambiguous or default step ranges (like a:b)
function Base.:(:)(start::T, stop::T) where {T<:UDTTimeType}
    throw(ArgumentError("UDT ranges require an explicit step. Use start:step:stop"))
end

# Main range constructor
function Base.:(:)(start::T, step::P, stop::T) where {T<:UDTTimeType, P<:UDTPeriod}
    return StepRange(start, step, stop)
end

# Compute number of steps between start and stop for UDT
function _udt_range_len(start::UDT, stop::UDT, step::UDTPeriod)
    total_step = _udt_period_to_seconds(step)
    if total_step == 0
        throw(ArgumentError("Step cannot be zero"))
    end
    diff = value(stop) - value(start)
    if sign(diff) != sign(total_step)
        return 0
    end
    n = fld(diff, total_step)
    return n >= 0 ? n + 1 : 0
end

function _udt_range_len(start::UDTDate, stop::UDTDate, step::Union{UDTYear,UDTMonth,UDTWeek,UDTDay})
    total_step = _udt_date_period_to_days(step)
    if total_step == 0
        throw(ArgumentError("Step cannot be zero"))
    end
    diff = value(stop) - value(start)
    if sign(diff) != sign(total_step)
        return 0
    end
    n = fld(diff, total_step)
    return n >= 0 ? n + 1 : 0
end



# Range length
Base.length(r::StepRange{T,P}) where {T<:UDTTimeType, P<:UDTPeriod} = _udt_range_len(r.start, r.stop, r.step)

# Range iteration
Base.iterate(r::StepRange{T,P}) where {T<:UDTTimeType, P<:UDTPeriod} =
    length(r) == 0 ? nothing : (r.start, 1)

function Base.iterate(r::StepRange{T,P}, state::Int) where {T<:UDTTimeType, P<:UDTPeriod}
    if state >= length(r)
        return nothing
    end
    next_val = r.start + r.step * state
    return (next_val, state + 1)
end

# Indexing
Base.getindex(r::StepRange{T,P}, i::Int) where {T<:UDTTimeType, P<:UDTPeriod} =
    (1 <= i <= length(r)) ? (r.start + r.step * (i - 1)) : throw(BoundsError(r, i))

# First and last
Base.first(r::StepRange) = r.start
Base.last(r::StepRange{T,P}) where {T<:UDTTimeType, P<:UDTPeriod} =
    length(r) == 0 ? throw(ArgumentError("Range is empty")) : r.start + r.step * (length(r) - 1)

# Reverse
Base.reverse(r::StepRange{T,P}) where {T<:UDTTimeType, P<:UDTPeriod} =
    StepRange(last(r), -r.step, first(r))

# Membership
function Base.in(x::T, r::StepRange{T,P}) where {T<:UDTTimeType, P<:UDTPeriod}
    if length(r) == 0
        return false
    end
    # Compute how many steps from start to x
    if x isa UDT
        step_size = _udt_period_to_seconds(r.step)
        diff = value(x) - value(r.start)
    else  # UDTDate
        step_size = _udt_date_period_to_days(r.step)
        diff = value(x) - value(r.start)
    end
    if step_size == 0 || sign(diff) != sign(step_size)
        return false
    end
    if diff % step_size != 0
        return false
    end
    n = fld(diff, step_size) + 1
    return 1 <= n <= length(r)
end

Base.rem(u::UDT, ud ::P)  where { P<:UDTPeriod}= P(value(u) % value(ud))

Base.rem(u::UDTDate, ud ::UDTDay)  = UDTDate(u.instant.value % ud.value)

Base.rem(u::UDTDate, ud ::UDTPeriod)  = rem(u,UDTDay(_udt_date_period_to_days(ud)))
# Broadcasting support
Base.Broadcast.broadcastable(x::StepRange{T}) where {T<:UDTTimeType} = collect(x)