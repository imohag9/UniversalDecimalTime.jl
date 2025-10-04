# Constructors

This document describes the constructors available for the `UDT` and `UDTDate` types.

## UDT Constructors

### `UDT(sec::Int64)`

Constructs a `UDT` from a raw UDT second count.

### `UDT(y::Integer, mo::Integer = 0, w::Integer = 0, d::Integer = 0, h::Integer = 0, mint::Integer = 0, s::Integer = 0)`

Constructs a `UDT` from individual components: year, month, week, day, hour, minute, and second.

*   `y`: Year
*   `mo`: Month (0-9)
*   `w`: Week (0-9)
*   `d`: Day (0-9)
*   `h`: Hour (0-9)
*   `mint`: Minute (0-99)
*   `s`: Second (0-99)

### `UDT(periods::UDTPeriod...)`

Constructs a `UDT` from a variable number of `UDTPeriod` arguments.

## UDTDate Constructors

### `UDTDate(day::Int64)`

Constructs a `UDTDate` from a raw UTD day count.

### `UDTDate(y::Integer, mo::Integer = 0, w::Integer = 0, d::Integer = 0)`

Constructs a `UDTDate` from individual components: year, month, week, and day.

*   `y`: Year
*   `mo`: Month (0-9)
*   `w`: Week (0-9)
*   `d`: Day (0-9)

### `UDTDate(periods::Union{UDTYear, UDTMonth, UDTWeek, UDTDay}...)`

Constructs a `UDTDate` from a variable number of `UDTPeriod` arguments.