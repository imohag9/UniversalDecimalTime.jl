# Range Support

Universal Decimal Time provides comprehensive range support, allowing you to create sequences of UDT timestamps or dates with specified steps. This is particularly useful for time series analysis, batch processing, and generating time-based sequences.

## Basic Range Construction

Ranges in Universal Decimal Time follow Julia's standard range syntax: `start:step:stop`.

```julia
using UniversalDecimalTime

# Create a range of UDT timestamps (daily increments)
daily_range = UDT(0, 0, 0, 0):UDTDay(1):UDT(0, 0, 0, 5)
# 0000-00-00-00:UDT:00:00:00:UDTDay(1):0000-00-00-05

# Create a range of UDT dates (weekly increments)
weekly_range = UDTDate(0, 0, 0, 0):UDTWeek(1):UDTDate(0, 0, 2, 0)
# 0000-00-00-00:UDTWeek(1):0000-00-02-00
```

> **Note**: Unlike standard Julia ranges, UDT ranges **require an explicit step**. The syntax `start:stop` will throw an error.

## Range Properties

### Length

You can determine the number of elements in a range using `length`:

```julia
julia> length(UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5))
6

julia> length(UDT(0,0,0,0):UDTDay(2):UDT(0,0,0,5))
3
```

### Empty Ranges

An empty range is created when the step direction doesn't move from start toward stop:

```julia
julia> r = UDT(0,0,0,5):UDTDay(1):UDT(0,0,0,0)
0000-00-00-05:UDTDay(1):0000-00-00-00

julia> isempty(r)
true

julia> length(r)
0
```

### First and Last Elements

```julia
julia> r = UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)

julia> first(r)
0000-00-00-00:UDT:00:00:00

julia> last(r)
0000-00-00-05:UDT:00:00:00
```

## Range Operations

### Iteration

You can iterate through a range using standard Julia iteration:

```julia
for timestamp in UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)
    println(timestamp)
end
# Prints all timestamps from 0000-00-00-00 to 0000-00-00-05
```

### Indexing

Ranges support 1-based indexing:

```julia
julia> r = UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)

julia> r[1]
0000-00-00-00:UDT:00:00:00

julia> r[3]
0000-00-00-02:UDT:00:00:00

julia> r[end]
0000-00-00-05:UDT:00:00:00
```

### Membership Testing

Check if a timestamp is in a range using `in` (`∈`):

```julia
julia> udt = UDT(0,0,0,3)

julia> udt in UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)
true

julia> udt in UDT(0,0,0,0):UDTDay(2):UDT(0,0,0,5)
true

julia> udt in UDT(0,0,0,0):UDTDay(4):UDT(0,0,0,5)
false
```

### Reversal

Reverse a range using `reverse`:

```julia
julia> r = UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)

julia> reverse(r)
0000-00-00-05:UDTDay(-1):0000-00-00-00
```

### Range Arithmetic

You can add or subtract periods from entire ranges:

```julia
julia> r = UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)

julia> r + UDTDay(2)
0000-00-00-02:UDTDay(1):0000-00-00-07

julia> r - UDTDay(1)
0000-00-00-(-1):UDTDay(1):0000-00-00-04
```

## Range Types

Universal Decimal Time supports ranges with different period types:

### Time-Based Ranges

```julia
# Hourly range
hourly_range = UDT(0,0,0,0,0,0,0):UDTHour(1):UDT(0,0,0,0,5,0,0)

# Minute range
minute_range = UDT(0,0,0,0,0,0,0):UDTMinute(10):UDT(0,0,0,0,0,50,0)

# Second range
second_range = UDT(0,0,0,0,0,0,0):UDTSecond(10):UDT(0,0,0,0,0,0,50)
```

### Date-Based Ranges

```julia
# Year range
year_range = UDTDate(0):UDTYear(1):UDTDate(5)

# Month range
month_range = UDTDate(0,0,0,0):UDTMonth(1):UDTDate(0,2,0,0)

# Week range
week_range = UDTDate(0,0,0,0):UDTWeek(1):UDTDate(0,0,2,0)
```

## Advanced Range Operations

### Range Filtering

You can filter ranges using standard Julia filtering:

```julia
# Get only even days
r = UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,9)
even_days = filter(x -> udt_day(x) % 2 == 0, r)
# [0000-00-00-00, 0000-00-00-02, ..., 0000-00-00-08]
```

### Range Broadcasting

Ranges can be used in broadcasting operations:

```julia
r = UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)
offsets = [UDTDay(1), UDTDay(2)]

result = r .+ offsets
# Two ranges: one offset by 1 day, one by 2 days
```

### Range Sorting

Ranges maintain ordering properties:

```julia
r = UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,5)
neg_r = UDT(0,0,0,5):-UDTDay(1):UDT(0,0,0,0)

issorted(r)         # true
issorted(neg_r)     # false
issorted(reverse(neg_r))  # true
```

## Performance Considerations

UDT ranges are designed to be memory-efficient. They don't store all elements but calculate them on demand:

- **No memory overhead**: A range representing 100 years of timestamps uses the same memory as a range of 2 timestamps
- **Fast operations**: Length calculation and indexing are O(1) operations
- **Type stability**: All range operations are type-stable for performance

When you need to materialize a range into an array, use `collect`:

```julia
timestamp_array = collect(UDT(0,0,0,0):UDTDay(1):UDT(0,0,0,30))
```

## Common Patterns

### Generating a sequence of timestamps

```julia
# Generate hourly timestamps for a UDT day
timestamps = UDT(0,0,0,0,0,0,0):UDTHour(1):UDT(0,0,0,0,9,0,0)
```

### Processing time intervals

```julia
# Process data in weekly intervals
for week_start in UDTDate(0):UDTWeek(1):UDTDate(0,0,9,0)
    week_end = week_start + UDTWeek(1)
    # Process data from week_start to week_end
end
```

### Finding specific time points

```julia
# Find all timestamps where hour is 5
five_oclock = filter(x -> udt_hour(x) == 5, 
                    UDT(0,0,0,0):UDTHour(1):UDT(0,0,0,9,9,99,99))
```

## Limitations

- UDT ranges require explicit steps (no default step values)
- Ranges with zero step throw an `ArgumentError`
- Only integer steps are supported (no fractional periods)