# History and Utility of Decimal Time

Decimal time is the representation of the time of day using units which are decimally related. This concept has been proposed and implemented in various forms throughout history, most notably during the French Revolution.

## French Revolutionary Decimal Time

The most famous implementation of decimal time was during the French Revolution. The National Convention issued a decree on October 5, 1793 (revised November 24, 1793), which stated:

> "The day, from midnight to midnight, is divided into ten parts or hours, each part into ten others, so on until the smallest measurable portion of the duration. The hundredth part of the hour is called decimal minute; the hundredth part of the minute is called decimal second."

This created a system where:
- 1 day = 10 decimal hours
- 1 decimal hour = 100 decimal minutes
- 1 decimal minute = 100 decimal seconds
- Total: 100,000 decimal seconds per day (vs. 86,400 SI seconds in standard time)

Thus, midnight was called "ten hours," noon was called "five hours," and so on. This system was officially used in France from 1794 to 1800, though it never gained widespread adoption among the general population.

## Why Decimal Time?

Decimal time offers several advantages:

1. **Simplified calculations**: Since all units are powers of 10, converting between units becomes trivial (just move the decimal point).
   - Example: 1.2345 decimal hours = 123.45 decimal minutes = 12345 decimal seconds

2. **Unified representation**: Time can be represented as a single decimal number rather than separate hours, minutes, and seconds.

3. **Easier to compute with**: Particularly useful in scientific calculations, astronomy, and computing where fractional days are commonly used.

## Modern Applications

While the French Revolutionary decimal time didn't catch on for everyday use, decimal representations of time are widely used in specialized fields:

- **Astronomy**: Astronomers use fractional days (where 0.5 = noon) for precise timekeeping
- **Computing**: Many systems represent time as seconds since an epoch (like Unix time)
- **Aviation**: Decimal hours are used for flight planning and logbooks
- **Accounting**: Time is often tracked in decimal hours for payroll

## Swatch Internet Time

In 1998, Swatch introduced "Internet Time," dividing the day into 1,000 ".beats" (each 86.4 standard seconds), with @000 being midnight in Biel, Switzerland. Though not widely adopted, it demonstrates continued interest in decimal time systems.

## Scientific Decimal Time

Scientists often use decimal representations of time:

- **Fractional days**: Time of day represented as a fraction of a day (0.0 = midnight, 0.5 = noon)
- **Julian days**: Used in astronomy, counting days (including fractional parts) since a fixed epoch

## Why Universal Decimal Time?

Our implementation extends the decimal concept to the full calendar:

- 1 UDT year = 10 UDT months
- 1 UDT month = 10 UDT weeks
- 1 UDT week = 10 UDT days
- 1 UDT day = 10 UDT hours
- 1 UDT hour = 100 UDT minutes
- 1 UDT minute = 100 UDT seconds

This creates a consistent decimal system where all time units are powers of 10 relative to each other, making time calculations exceptionally straightforward.

## Conversion Table

| Unit | Seconds (SI) | Minutes | Hours | h:mm:ss.sss |
|------|--------------|---------|-------|-------------|
| 1 UDT second | 0.420768 | 0.0070128 | 0.00011688 | 0:00:00.421 |
| 1 UDT minute | 42.0768 | 0.70128 | 0.011688 | 0:00:42.077 |
| 1 UDT hour | 420.768 | 7.0128 | 0.11688 | 0:07:00.768 |
| 1 UDT day | 4207.68 | 70.128 | 1.1688 | 1:10:07.680 |

## Historical Context

Decimal time was part of a larger attempt at decimalization in revolutionary France (which also included decimalization of currency and metrication). Though the mandatory use of decimal time was suspended in 1795, the concept has resurfaced periodically throughout history as people recognize the practical benefits of a decimal time system for scientific and computational purposes.

The Universal Decimal Time package implements this concept in a modern, consistent way that's optimized for computational use while maintaining historical connections to previous decimal time systems.