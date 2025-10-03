# ===========================================================================
# Conversion to/from standard time
# ===========================================================================

"""
    UDT(u::UDTDate)

Convert a `UDTDate` to a `UDT`.
"""
UDT(u::UDTDate) = UDT(value(u) * SECONDS_PER_DAY)



"""
    UDTDate(u::UDT)

Convert a `UDT` to a `UDTDate`.
"""
UDTDate(u::UDT) = UDTDate(value(u) ÷ SECONDS_PER_DAY)

"""
    UDT(dt::Dates.DateTime)

Convert a `Dates.DateTime` to a `UDT`.
"""
function UDT(dt::Dates.DateTime)
    si_seconds = Dates.datetime2unix(dt)
    udt_seconds = round(Int64, (si_seconds - UNIX_EPOCH_2000) / UDT_SECOND_IN_SI)
    return UDT(udt_seconds)
end

"""
    Base.convert(::Type{Dates.DateTime}, u::UDT)

Convert a `UDT` to a `Dates.DateTime`.
"""
function Base.convert(::Type{Dates.DateTime}, u::UDT)
    si_seconds = value(u) * UDT_SECOND_IN_SI + UNIX_EPOCH_2000
    return Dates.unix2datetime(si_seconds)
end

"""
    UDTDate(dt::Dates.Date)

Convert a `Dates.Date` to a `UDTDate`.
"""
function UDTDate(dt::Dates.Date)
    standard_time = DateTime(dt)
    udt_seconds = UDT(standard_time)
    return UDTDate(udt_seconds)
end

"""
    Base.convert(::Type{UDTDate}, u::Dates.Date)

Convert a `UDTDate` to a `Dates.Date`.
"""
function Base.convert(::Type{Dates.Date}, u::UDTDate)
    udt_time = UDT(u)
    standard_time = convert(Dates.DateTime, udt_time)
    return Dates.Date(standard_time)
end


_udt_period_to_seconds(p::UDTYear)   = p.value * SECONDS_PER_YEAR
_udt_period_to_seconds(p::UDTMonth)  = p.value * SECONDS_PER_MONTH
_udt_period_to_seconds(p::UDTWeek)   = p.value * SECONDS_PER_WEEK
_udt_period_to_seconds(p::UDTDay)    = p.value * SECONDS_PER_DAY
_udt_period_to_seconds(p::UDTHour)   = p.value * SECONDS_PER_HOUR
_udt_period_to_seconds(p::UDTMinute) = p.value * SECONDS_PER_MINUTE
_udt_period_to_seconds(p::UDTSecond) = p.value

_udt_date_period_to_days(p::UDTYear)  = p.value * 1000
_udt_date_period_to_days(p::UDTMonth) = p.value * 100
_udt_date_period_to_days(p::UDTWeek)  = p.value * 10
_udt_date_period_to_days(p::UDTDay)   = p.value

function Base.convert(::Type{UDT}, u::UDTPeriod)

    return UDT(_udt_period_to_seconds(u) )
end