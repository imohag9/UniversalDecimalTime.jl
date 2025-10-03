# ===========================================================================
# Type Definitions
# ===========================================================================

"""
    UDTTimeType
Abstract type for Universal Decimal Time types.
"""
abstract type UDTTimeType end

"""
    UDTPeriod
Abstract type for Universal Decimal Time period types.
"""
abstract type UDTPeriod <: Dates.Period end

"""
    UDTInstant{T <: UDTPeriod} <: Dates.Instant
Represents an instant in Universal Decimal Time, parameterized by a `UDTPeriod` type.
"""
struct UDTInstant{T <: UDTPeriod} <: Dates.Instant
    value::Int64
end

# ===========================================================================
# Period Types
# ===========================================================================

struct UDTYear   <: UDTPeriod; value::Int64; end
struct UDTMonth  <: UDTPeriod; value::Int64; end
struct UDTWeek   <: UDTPeriod; value::Int64; end
struct UDTDay    <: UDTPeriod; value::Int64; end
struct UDTHour   <: UDTPeriod; value::Int64; end
struct UDTMinute <: UDTPeriod; value::Int64; end
struct UDTSecond <: UDTPeriod; value::Int64; end

# Constructors from Integer
UDTYear(v::Integer) = UDTYear(Int64(v))
UDTMonth(v::Integer) = UDTMonth(Int64(v))
UDTWeek(v::Integer) = UDTWeek(Int64(v))
UDTDay(v::Integer) = UDTDay(Int64(v))
UDTHour(v::Integer) = UDTHour(Int64(v))
UDTMinute(v::Integer) = UDTMinute(Int64(v))
UDTSecond(v::Integer) = UDTSecond(Int64(v))

value(p::UDTPeriod) = p.value

# ===========================================================================
# UDT and UDTDate
# ===========================================================================

"""
    UDT <: UDTTimeType
Represents a specific moment in Universal Decimal Time.
"""
struct UDT <: UDTTimeType
    instant::UDTInstant{UDTSecond}
end

"""
    UDTDate <: UDTTimeType
Represents a date in Universal Decimal Time.
"""
struct UDTDate <: UDTTimeType
    instant::UDTInstant{UDTDay}
end

# Constructors from raw counts
UDT(sec::Int64) = UDT(UDTInstant{UDTSecond}(sec))
UDTDate(day::Int64) = UDTDate(UDTInstant{UDTDay}(day))

value(u::UDT) = u.instant.value
value(u::UDTDate) = u.instant.value

# ===========================================================================
# Required Base Methods
# ===========================================================================

Base.:(==)(x::T, y::T) where {T<:UDTTimeType} = value(x) == value(y)
Base.isless(x::T, y::T) where {T<:UDTTimeType} = value(x) < value(y)

# Zero must return a Period (not a TimeType) to satisfy range machinery
Base.zero(::Type{UDT}) = UDTSecond(0)
Base.zero(::Type{UDTDate}) = UDTDay(0)


# ===========================================================================
# Core Constructors
# ===========================================================================

function UDT(y::Integer, mo::Integer = 0, w::Integer = 0, d::Integer = 0,
             h::Integer = 0, mint::Integer = 0, s::Integer = 0)
    @assert 0 <= mo <= 9 "Month must be 00–09"
    @assert 0 <= w <= 9 "Week must be 00–09"
    @assert 0 <= d <= 9 "Day must be 00–09"
    @assert 0 <= h <= 9 "Hour must be 00–09"
    @assert 0 <= mint <= 99 "Minute must be 00–99"
    @assert 0 <= s <= 99 "Second must be 00–99"
    total = Int64(y) * SECONDS_PER_YEAR +
            Int64(mo) * SECONDS_PER_MONTH +
            Int64(w) * SECONDS_PER_WEEK +
            Int64(d) * SECONDS_PER_DAY +
            Int64(h) * SECONDS_PER_HOUR +
            Int64(mint) * SECONDS_PER_MINUTE +
            Int64(s)
    return UDT(total)
end

function UDTDate(y::Integer, mo::Integer = 0, w::Integer = 0, d::Integer = 0)
    @assert 0 <= mo <= 9 "Month must be 00–09"
    @assert 0 <= w <= 9 "Week must be 00–09"
    @assert 0 <= d <= 9 "Day must be 00–09"
    total = Int64(y) * 1000 +
            Int64(mo) * 100 +
            Int64(w) * 10 +
            Int64(d)
    return UDTDate(total)
end

function UDT(periods::UDTPeriod...)
    y = mo = w = d = h = mint = s = 0
    for p in periods
        if p isa UDTYear;       y += value(p)
        elseif p isa UDTMonth;  mo += value(p)
        elseif p isa UDTWeek;   w += value(p)
        elseif p isa UDTDay;    d += value(p)
        elseif p isa UDTHour;   h += value(p)
        elseif p isa UDTMinute; mint += value(p)
        elseif p isa UDTSecond; s += value(p)
        end
    end
    return UDT(y, mo, w, d, h, mint, s)
end

function UDTDate(periods::Union{UDTYear, UDTMonth, UDTWeek, UDTDay}...)
    y = mo = w = d = 0
    for p in periods
        if p isa UDTYear;       y += value(p)
        elseif p isa UDTMonth;  mo += value(p)
        elseif p isa UDTWeek;   w += value(p)
        elseif p isa UDTDay;    d += value(p)
        end
    end
    return UDTDate(y, mo, w, d)
end