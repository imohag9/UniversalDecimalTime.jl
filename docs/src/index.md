```
CurrentModule = UniversalDecimalTime
```

# Universal Decimal Time



Universal Decimal Time (UDT) is a decimal time system where time is organized in powers of 10. This package provides a complete implementation of UDT for the Julia programming language.

## Features

- Complete decimal calendar system:
  - 1 year = 10 months
  - 1 month = 10 weeks
  - 1 week = 10 days
  - 1 day = 10 hours
  - 1 hour = 100 minutes
  - 1 minute = 100 seconds
- Epoch set at January 1, 2000, 00:00:00 UTC (UDT year 0)
- Seamless conversion to/from standard DateTime
- Full arithmetic operations
- String parsing and formatting
- Comprehensive test suite

## Installation

To install the package, use the Julia package manager:

```julia
using Pkg
Pkg.add("UniversalDecimalTime")
```

## Quick Example

```julia
using UniversalDecimalTime

# Create a UDT timestamp
udt = UDT(0010, 3, 1, 1, 5, 30, 75)
# Output: 0010-03-01-01:UDT:05:30:75

# Get current UDT time
now_udt = udt_now()
today_udt = udt_today()

# Convert from standard DateTime
dt = DateTime(2023, 10, 15, 14, 30, 25)
udt_time = UDT(dt)

# Arithmetic operations
udt + UDTDay(1)      # Add one UDT day
udt - UDTHour(2)     # Subtract two UDT hours
```


