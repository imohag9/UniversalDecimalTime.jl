# Conversions



## Converting from `Dates.DateTime` to `UDT`

```julia
using Dates
using UniversalDecimalTime

dt = DateTime(2024, 1, 1, 12, 0, 0)
udt = UDT(dt)

println(udt)
```

## Converting from `UDTDate` to `UDT`

```julia
using UniversalDecimalTime

udt_date = UDTDate(200)
udt = UDT(udt_date)

println(udt)
```

## Converting from `Dates.Date` to `UDTDate`

```julia
using Dates
using UniversalDecimalTime

date = Date(2024, 1, 1)
udt_date = UDTDate(date)

println(udt_date)
```

## Converting from `UDT` to `UDTDate`

```julia
using UniversalDecimalTime

udt = UDT(10000)
udt_date = UDTDate(udt)

println(udt_date)
```

## Converting from `UDT` to `Dates.DateTime`

```julia
using Dates
using UniversalDecimalTime

udt = UDT(10000)
datetime = convert(DateTime, udt)

println(datetime)
```

## Converting from `Dates.Date` to `UDTDate`

```julia
using Dates
using UniversalDecimalTime

date = Date(2024, 1, 1)
udt_date = UDTDate(date)

println(udt_date)
```

## Converting from `UDTDate` to `Dates.Date`

```julia
using Dates
using UniversalDecimalTime

udt_date = UDTDate(200)
date = convert(Date, udt_date)

println(date)
```

## Converting from `UDTPeriod` to `UDT`

```julia
using UniversalDecimalTime

year = UDTYear(1)
udt = convert(UDT, year)

println(udt)