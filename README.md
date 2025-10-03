# UniversalDecimalTime.jl  [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://imohag9.github.io/UniversalDecimalTime.jl/dev/) [![Build Status](https://github.com/imohag9/UniversalDecimalTime.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/imohag9/UniversalDecimalTime.jl/actions/workflows/CI.yml?query=branch%3Amain)[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

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

## Usage

```julia
using UniversalDecimalTime
using Dates
# Create a UDT timestamp
udt = UDT(2025, 3, 1, 1, 5, 30, 75)
# Output: 2025-03-01-01:UDT:05:30:75

# Get current UDT time
now_udt = udt_now()
today_udt = udt_today()

# Access components
udt_year(now_udt)    # Get the UDT year
udt_month(now_udt)   # Get the UDT month
udt_day(now_udt)     # Get the UDT day

# Convert from standard DateTime
dt = DateTime(2023, 10, 15, 14, 30, 25)
udt_time = UDT(dt)

# Convert back to standard DateTime
standard_time = convert(Dates.DateTime, udt_time)

# The round trip doesn't yield the exact value , the margin is estimated as 0.22 SI seconds.

# Arithmetic operations
udt + UDTDay(1)      # Add one UDT day
udt - UDTHour(2)     # Subtract two UDT hours
udt + UDTYear(1) + UDTMonth(2)

# Parse from string
parsed_udt = UDT("2025-03-01-01:UDT:05:30:75")
```

## Time System Details

In Universal Decimal Time:
- 1 UDT second = 0.420768 SI seconds
- 1 UDT minute = 100 UDT seconds
- 1 UDT hour = 100 UDT minutes
- 1 UDT day = 10 UDT hours
- 1 UDT week = 10 UDT days
- 1 UDT month = 10 UDT weeks
- 1 UDT year = 10 UDT months

This creates a consistent decimal system where all time units are powers of 10 relative to each other.

## Documentation

For complete documentation, see the  [development docs](https://imohag9.github.io/UniversalDecimalTime.jl/dev/).



## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This package is distributed under the MIT License. See [LICENSE](LICENSE) for details.
