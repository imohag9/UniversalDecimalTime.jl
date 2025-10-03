module UniversalDecimalTime

using Dates
using Printf

# Core functionality
include("core.jl")
include("constants.jl")




# Functionality modules
include("conversions.jl")
include("arithmetic.jl")
include("accessors.jl")
include("parsing.jl")
include("ranges.jl")


export UDT, UDTDate, UDTPeriod, UDTTimeType,
       UDTYear, UDTMonth, UDTWeek, UDTDay, UDTHour, UDTMinute, UDTSecond,
       udt_year, udt_month, udt_week, udt_day, udt_hour, udt_minute, udt_second,
       udt_yearmonth, udt_yearmonthweek,
       value,
       udt_now, udt_today


end 
