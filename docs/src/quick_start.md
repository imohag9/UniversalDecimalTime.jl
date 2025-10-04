# Quick Start Guide

This tutorial will help you get started with Universal Decimal Time in Julia.

## Installation

First, install the package:

```julia
using Pkg
Pkg.add("UniversalDecimalTime")
```

## Basic Usage

```julia
using UniversalDecimalTime

# Create a UDT timestamp for year 2025, month 3, week 1, day 1, hour 5, minute 30, second 75
udt = UDT(2025, 3, 1, 1, 5, 30, 75)
# Output: 2025-03-01-01:UDT:05:30:75

# Get current UDT time
@show udt_now()
# Example output: 0019-03-01-08:UDT:06:75:75

# Get today's UDT date
@show udt_today()
# Example output: 0019-03-01-08:UDT
```

## Accessing Components

You can access individual components of a UDT timestamp:

```julia
udt = UDT(2025, 3, 1, 1, 5, 30, 75)

udt_year(udt)    # Returns 2025
udt_month(udt)   # Returns 3
udt_week(udt)    # Returns 1
udt_day(udt)     # Returns 1
udt_hour(udt)    # Returns 5
udt_minute(udt)  # Returns 30
udt_second(udt)  # Returns 75

# Get multiple components at once
udt_yearmonth(udt)     # Returns (2025, 3)
udt_yearmonthweek(udt) # Returns (2025, 3, 1)
```

## Converting Between Time Systems

```julia
# Convert from standard DateTime to UDT
dt = DateTime(2025, 10, 2, 14, 30, 25)
udt_time = UDT(dt)

# Convert back to standard DateTime
standard_time = DateTime(udt_time)

# Convert between UDT and UDTDate
udt = UDT(10, 3, 1, 1, 5, 30, 75)
udt_date = UDTDate(udt)  # Keeps only date components
udt_full = UDT(udt_date) # Sets time components to zero
```

## Time Arithmetic

```julia
udt = UDT(10, 3, 1, 1, 5, 30, 75)

# Add time
udt + UDTYear(1)       # Add one UDT year
udt + UDTMonth(2)      # Add two UDT months
udt + UDTDay(5)        # Add five UDT days
udt + UDTHour(3)       # Add three UDT hours
udt + UDTMinute(150)   # Add 150 UDT minutes (will carry over)

# Multiple additions
udt + UDTYear(1) + UDTMonth(2) + UDTDay(5)

# Subtraction
udt - UDTYear(1)
udt - UDTMonth(2)
```

## Parsing and Formatting

```julia
# Parse from string
udt_str = "0010-03-01-01:UDT:05:30:75"
udt = UDT(udt_str)

# Format as string
string(udt)  # Returns "0010-03-01-01:UDT:05:30:75"

# Parse UDTDate
udt_date_str = "0010-03-01-01:UDT"
udt_date = UDTDate(udt_date_str)
```
