# ===========================================================================
# Formatting & Parsing
# ===========================================================================
function Base.string(u::UDT)
    y, mo, w, d, h, m, s = _decompose_udt_seconds(value(u))
    year_str = y < 0 ? @sprintf("-%04d", -y) : @sprintf("%04d", y)
    return @sprintf("%s-%02d-%02d-%02d:UDT:%02d:%02d:%02d", year_str, mo, w, d, h, m, s)
end

function Base.string(u::UDTDate)
    y, mo, w, d = _decompose_udt_days(value(u))
    year_str = y < 0 ? @sprintf("-%04d", -y) : @sprintf("%04d", y)
    return @sprintf("%s-%02d-%02d-%02d:UDT", year_str, mo, w, d)
end

Base.show(io::IO, u::UDT) = print(io, string(u))
Base.show(io::IO, u::UDTDate) = print(io, string(u))

# Parser for UDTDate
function UDTDate(s::AbstractString)
    # Remove the trailing ":UDT"
    if !endswith(s, ":UDT")
        throw(ArgumentError("Invalid UDTDate format. Expected YYYY-MM-WW-DD:UDT"))
    end
    core = s[1:(end - 4)]  # remove last 5 chars (":UDT")
    # Handle negative year
    if startswith(core, '-')
        parts = split(core[2:end], '-')
        y = -parse(Int64, lpad(parts[1], 4, '0'))
        rest = parts[2:end]
    else
        parts = split(core, '-')
        y = parse(Int64, lpad(parts[1], 4, '0'))
        rest = parts[2:end]
    end
    if length(rest) != 3
        throw(ArgumentError("Invalid UDTDate format. Expected YYYY-MM-WW-DD:UDT"))
    end
    mo, w, d = parse.(Int64, rest)
    @assert 0 ≤ mo ≤ 9 "Month must be 00–09"
    @assert 0 ≤ w ≤ 9 "Week must be 00–09"
    @assert 0 ≤ d ≤ 9 "Day must be 00–09"
    return UDTDate(y, mo, w, d)
end

# Parser for UDT
function UDT(s::AbstractString)
    if !occursin(r":UDT:\d\d:\d\d:\d\d$", s)
        throw(ArgumentError("Invalid UDT format. Expected YYYY-MM-WW-DD:UDT:HH:MM:SS"))
    end
    # Split into date and time parts at ":UDT:"
    if !contains(s, ":UDT:")
        throw(ArgumentError("Invalid UDT format. Missing ':UDT:' delimiter"))
    end
    date_part, time_part = split(s, ":UDT:", limit = 2)
    time_components = split(time_part, ':')
    if length(time_components) != 3
        throw(ArgumentError("Invalid time part in UDT string"))
    end
    h, min, sec = parse.(Int64, time_components)
    # Parse date_part (YYYY-MM-WW-DD)
    if startswith(date_part, '-')
        parts = split(date_part[2:end], '-')
        y = -parse(Int64, lpad(parts[1], 4, '0'))
        rest = parts[2:end]
    else
        parts = split(date_part, '-')
        y = parse(Int64, lpad(parts[1], 4, '0'))
        rest = parts[2:end]
    end
    if length(rest) != 3
        throw(ArgumentError("Invalid UDT format. Expected YYYY-MM-WW-DD:UDT:HH:MM:SS"))
    end
    mo, w, d = parse.(Int64, rest)
    @assert 0 ≤ mo ≤ 9 "Month must be 00–09"
    @assert 0 ≤ w ≤ 9 "Week must be 00–09"
    @assert 0 ≤ d ≤ 9 "Day must be 00–09"
    @assert 0 ≤ h ≤ 9 "Hour must be 00–09"
    @assert 0 ≤ min ≤ 99 "Minute must be 00–99"
    @assert 0 ≤ sec ≤ 99 "Second must be 00–99"
    return UDT(y, mo, w, d, h, min, sec)
end

