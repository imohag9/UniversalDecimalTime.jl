# ===========================================================================
# Component Accessors (udt_ prefixed)
# ===========================================================================
function _decompose_udt_seconds(total_seconds::Int64)
    years, r = fldmod(total_seconds, SECONDS_PER_YEAR)
    months, r = fldmod(r, SECONDS_PER_MONTH)
    weeks, r = fldmod(r, SECONDS_PER_WEEK)
    days, r = fldmod(r, SECONDS_PER_DAY)
    hours, r = fldmod(r, SECONDS_PER_HOUR)
    minutes, seconds = fldmod(r, SECONDS_PER_MINUTE)
    return years, months, weeks, days, hours, minutes, seconds
end

function _decompose_udt_days(total_days::Int64)
    years, r1 = fldmod(total_days, 1000)
    months, r2 = fldmod(r1, 100)
    weeks, days = fldmod(r2, 10)
    return years, months, weeks, days
end

"""
    udt_year(u::UDT)

Get the year component of a `UDT`.
"""
udt_year(u::UDT) = _decompose_udt_seconds(value(u))[1]

"""
    udt_month(u::UDT)

Get the month component of a `UDT`.
"""
udt_month(u::UDT) = _decompose_udt_seconds(value(u))[2]

"""
    udt_week(u::UDT)

Get the week component of a `UDT`.
"""
udt_week(u::UDT) = _decompose_udt_seconds(value(u))[3]

"""
    udt_day(u::UDT)

Get the day component of a `UDT`.
"""
udt_day(u::UDT) = _decompose_udt_seconds(value(u))[4]

"""
    udt_hour(u::UDT)

Get the hour component of a `UDT`.
"""
udt_hour(u::UDT) = _decompose_udt_seconds(value(u))[5]

"""
    udt_minute(u::UDT)

Get the minute component of a `UDT`.
"""
udt_minute(u::UDT) = _decompose_udt_seconds(value(u))[6]

"""
    udt_second(u::UDT)

Get the second component of a `UDT`.
"""
udt_second(u::UDT) = _decompose_udt_seconds(value(u))[7]

"""
    udt_year(u::UDTDate)

Get the year component of a `UDTDate`.
"""
udt_year(u::UDTDate) = _decompose_udt_days(value(u))[1]

"""
    udt_month(u::UDTDate)

Get the month component of a `UDTDate`.
"""
udt_month(u::UDTDate) = _decompose_udt_days(value(u))[2]

"""
    udt_week(u::UDTDate)

Get the week component of a `UDTDate`.
"""
udt_week(u::UDTDate) = _decompose_udt_days(value(u))[3]

"""
    udt_day(u::UDTDate)

Get the day component of a `UDTDate`.
"""
udt_day(u::UDTDate) = _decompose_udt_days(value(u))[4]

"""
    udt_yearmonth(u::T) where {T <: UDTTimeType}

Get the year and month components of a `UDTTimeType` as a tuple.
"""
udt_yearmonth(u::T) where {T <: UDTTimeType} = (udt_year(u), udt_month(u))

"""
    udt_yearmonthweek(u::UDT)

Get the year, month, and week components of a `UDT` as a tuple.
"""
udt_yearmonthweek(u::UDT) = (udt_year(u), udt_month(u), udt_week(u))


# ===========================================================================
# Current Time Functions
# ===========================================================================
"""
    udt_now()

Get the current `UDT` (Universal Decimal Time).
"""
udt_now() = UDT(Dates.now(UTC))

"""
    udt_today()

Get the current `UDTDate` (Universal Decimal Time Date).
"""
udt_today() = UDTDate(udt_now())