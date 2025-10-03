using UniversalDecimalTime
using Dates
using Test
using Aqua

const CONVERSION_TOLERANCE::Float64 = 0.22

@testset "UniversalDecimalTime Tests" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(UniversalDecimalTime;
            ambiguities = false, # the period types
            project_extras = true,
            deps_compat = true,
            stale_deps = true,
            piracies = false, # only the StepRange type 
            unbound_args = true
        )
    end
    # Check UDT components
    function check_udt(u::UDT, y, mo, w, d, h, min, s)
        @test udt_year(u) == y
        @test udt_month(u) == mo
        @test udt_week(u) == w
        @test udt_day(u) == d
        @test udt_hour(u) == h
        @test udt_minute(u) == min
        @test udt_second(u) == s
    end

    # Check UDTDate components
    function check_udtdate(ud::UDTDate, y, mo, w, d)
        @test udt_year(ud) == y
        @test udt_month(ud) == mo
        @test udt_week(ud) == w
        @test udt_day(ud) == d
    end

    @testset "Types and Construction" begin
        @test UDT(0) isa UDT
        @test UDTDate(0) isa UDTDate

        u = UDT(2025, 3, 1, 1, 5, 30, 75)
        check_udt(u, 2025, 3, 1, 1, 5, 30, 75)

        ud = UDTDate(2025, 3, 1, 1)
        check_udtdate(ud, 2025, 3, 1, 1)

        # Period constructors
        u1 = UDT(UDTYear(1), UDTMonth(2), UDTWeek(3), UDTDay(4),
            UDTHour(5), UDTMinute(6), UDTSecond(7))
        u2 = UDT(UDTSecond(7), UDTHour(5), UDTDay(4), UDTWeek(3),
            UDTMonth(2), UDTYear(1), UDTMinute(6))
        @test u1 == u2
        check_udt(u1, 1, 2, 3, 4, 5, 6, 7)
    end

    @testset "Boundary values" begin
        max_values = UDT(9999, 9, 9, 9, 9, 99, 99)
        @test udt_year(max_values) == 9999
        @test udt_second(max_values) == 99

        @test_throws AssertionError UDT(0, 10, 0, 0, 0, 0, 0)
        @test_throws AssertionError UDT(0, 0, 0, 0, 0, 0, 100)
    end

    @testset "Arithmetic" begin
        u0 = UDT(0)

        @test u0 + UDTDay(1) == UDT(0, 0, 0, 1)
        @test u0 + UDTHour(1) == UDT(0, 0, 0, 0, 1)

        # Boundary cases
        @test UDT(0, 0, 0, 0, 0, 0, 99) + UDTSecond(1) == UDT(0, 0, 0, 0, 0, 1, 0)
        @test UDT(0, 0, 0, 0, 9, 0, 0) + UDTHour(1) == UDT(0, 0, 0, 1, 0, 0, 0)
    end

    @testset "Conversion to/from DateTime" begin
        dt_epoch = DateTime(2000, 1, 1)
        @test UDT(dt_epoch) == UDT(0)
        @test convert(DateTime, UDT(0)) == dt_epoch

        # Round-trip test
        for _ in 1:100
            dt = DateTime(rand(0:4999), rand(1:12), rand(1:28),
                rand(0:23), rand(0:59), rand(0:59))
            u = UDT(dt)
            dt_back = convert(DateTime, u)
            @test abs(datetime2unix(dt_back) - datetime2unix(dt)) <= CONVERSION_TOLERANCE
        end
    end

    @testset "Parsing and Formatting" begin
        test_cases = [
            "0000-00-00-00:UDT:00:00:00",
            "0001-05-03-07:UDT:09:45:99",
            "-0001-00-00-00:UDT:00:00:00"
        ]

        for str in test_cases
            u = UDT(str)
            str_back = string(u)
            @test str_back == str
            u_back = UDT(str_back)
            @test u_back == u
        end
    end

    @testset "Current Time" begin
        u = udt_now()
        ud = udt_today()
        @test u isa UDT
        @test ud isa UDTDate
        @test UDTDate(u) == ud
    end

    @testset "UDT Ranges" begin
        @testset "Basic range construction" begin
            # Basic range with positive step
            start = UDT(0, 0, 0, 0, 0, 0, 0)
            stop = UDT(0, 0, 0, 2, 0, 0, 0)
            r = start:UDTDay(1):stop
            @test length(r) == 3
            @test collect(r) == [UDT(0, 0, 0, 0), UDT(0, 0, 0, 1), UDT(0, 0, 0, 2)]

            # Basic range with UDTDate
            d_start = UDTDate(0, 0, 0, 0)
            d_stop = UDTDate(0, 0, 0, 3)
            dr = d_start:UDTDay(1):d_stop
            @test length(dr) == 4
            @test collect(dr) == [UDTDate(0, 0, 0, 0), UDTDate(0, 0, 0, 1),
                UDTDate(0, 0, 0, 2), UDTDate(0, 0, 0, 3)]

            # Error on missing step
            @test_throws ArgumentError UDT(0, 0, 0, 0):UDT(0, 0, 0, 2)
        end

        @testset "Range properties" begin
            start = UDT(0, 0, 0, 0, 0, 0, 0)
            stop = UDT(0, 0, 0, 5, 0, 0, 0)

            # Length calculations with different steps
            @test length(start:UDTDay(1):stop) == 6
            @test length(start:UDTDay(2):stop) == 3
            @test length(start:UDTDay(3):stop) == 2
            @test length(start:UDTDay(6):stop) == 1
            @test length(start:UDTDay(7):stop) == 1

            # Empty ranges
            @test length(stop:UDTDay(1):start) == 0
            @test isempty(stop:UDTDay(1):start)

            @test_throws ArgumentError last(stop:UDTDay(1):start)

            # Negative steps
            r = stop:(-UDTDay(1)):start
            @test length(r) == 6
            @test collect(r) == [UDT(0, 0, 0, 5), UDT(0, 0, 0, 4), UDT(0, 0, 0, 3),
                UDT(0, 0, 0, 2), UDT(0, 0, 0, 1), UDT(0, 0, 0, 0)]
        end

        @testset "Range iteration" begin
            start = UDT(0, 0, 0, 0, 0, 0, 0)
            stop = UDT(0, 0, 0, 2, 0, 0, 0)
            r = start:UDTDay(1):stop

            # Basic iteration
            i = 0
            for (idx, udt) in enumerate(r)
                @test udt == start + UDTDay(idx - 1)
                i += 1
            end
            @test i == 3

            # Empty range iteration
            empty_r = stop:UDTDay(1):start
            count = 0
            for _ in empty_r
                count += 1
            end
            @test count == 0
        end

        @testset "Range indexing" begin
            start = UDT(0, 0, 0, 0, 0, 0, 0)
            stop = UDT(0, 0, 0, 5, 0, 0, 0)
            r = start:UDTDay(1):stop

            # Valid indices
            @test r[1] == start
            @test r[3] == UDT(0, 0, 0, 2)
            @test r[6] == stop
            @test r[end] == stop

            # Out of bounds
            @test_throws BoundsError r[0]
            @test_throws BoundsError r[7]

            # Slicing (if supported via collect)
            @test r[2:4] == [UDT(0, 0, 0, 1), UDT(0, 0, 0, 2), UDT(0, 0, 0, 3)]
        end

        @testset "Range membership" begin
            start = UDT(0, 0, 0, 0, 0, 0, 0)
            stop = UDT(0, 0, 0, 5, 0, 0, 0)
            r = start:UDTDay(1):stop
            r2 = start:UDTDay(2):stop

            # Basic membership
            @test start == r[1]
            @test stop in r
            @test UDT(0, 0, 0, 3) in r
            @test UDT(0, 0, 0, 7) ∉ r
            @test UDT(0, 0, 0, 3) ∉ r2
            @test UDT(0, 0, 0, 4) in r2

            # Empty range membership
            empty_r = stop:UDTDay(1):start
            @test start ∉ empty_r
            @test stop ∉ empty_r
            @test UDT(0, 0, 0, 3) ∉ empty_r
        end

        @testset "Range reversal" begin
            start = UDT(0, 0, 0, 0, 0, 0, 0)
            stop = UDT(0, 0, 0, 5, 0, 0, 0)
            r = start:UDTDay(1):stop
            rev = reverse(r)

            # Basic reversal
            @test rev == stop:(-UDTDay(1)):start
            @test collect(rev) == reverse(collect(r))
            @test first(rev) == stop
            @test last(rev) == start
            @test length(rev) == 6
        end

        @testset "Different period types" begin
            start = UDT(0, 0, 0, 0, 0, 0, 0)
            stop = UDT(0, 0, 0, 0, 5, 0, 0)

            # Hour ranges
            r_hour = start:UDTHour(1):stop
            @test length(r_hour) == 6
            @test collect(r_hour) == [
                UDT(0, 0, 0, 0, 0, 0, 0),
                UDT(0, 0, 0, 0, 1, 0, 0),
                UDT(0, 0, 0, 0, 2, 0, 0),
                UDT(0, 0, 0, 0, 3, 0, 0),
                UDT(0, 0, 0, 0, 4, 0, 0),
                UDT(0, 0, 0, 0, 5, 0, 0)
            ]

            # Minute ranges
            r_min = UDT(0, 0, 0, 0, 0, 0, 0):UDTMinute(10):UDT(0, 0, 0, 0, 0, 50, 0)
            @test length(r_min) == 6
            @test collect(r_min) == [
                UDT(0, 0, 0, 0, 0, 0, 0),
                UDT(0, 0, 0, 0, 0, 10, 0),
                UDT(0, 0, 0, 0, 0, 20, 0),
                UDT(0, 0, 0, 0, 0, 30, 0),
                UDT(0, 0, 0, 0, 0, 40, 0),
                UDT(0, 0, 0, 0, 0, 50, 0)
            ]

            # Second ranges
            r_sec = UDT(0, 0, 0, 0, 0, 0, 0):UDTSecond(10):UDT(0, 0, 0, 0, 0, 0, 50)
            @test length(r_sec) == 6
            @test collect(r_sec) == [
                UDT(0, 0, 0, 0, 0, 0, 0),
                UDT(0, 0, 0, 0, 0, 0, 10),
                UDT(0, 0, 0, 0, 0, 0, 20),
                UDT(0, 0, 0, 0, 0, 0, 30),
                UDT(0, 0, 0, 0, 0, 0, 40),
                UDT(0, 0, 0, 0, 0, 0, 50)
            ]
        end

        @testset "Date ranges" begin
            # Year ranges
            y_start = UDTDate(0, 0, 0, 0)
            y_stop = UDTDate(2, 0, 0, 0)
            y_r = y_start:UDTYear(1):y_stop
            @test length(y_r) == 3
            @test collect(y_r) ==
                  [UDTDate(0, 0, 0, 0), UDTDate(1, 0, 0, 0), UDTDate(2, 0, 0, 0)]

            # Month ranges
            m_start = UDTDate(0, 0, 0, 0)
            m_stop = UDTDate(0, 2, 0, 0)
            m_r = m_start:UDTMonth(1):m_stop
            @test length(m_r) == 3
            @test collect(m_r) ==
                  [UDTDate(0, 0, 0, 0), UDTDate(0, 1, 0, 0), UDTDate(0, 2, 0, 0)]

            # Week ranges
            w_start = UDTDate(0, 0, 0, 0)
            w_stop = UDTDate(0, 0, 2, 0)
            w_r = w_start:UDTWeek(1):w_stop
            @test length(w_r) == 3
            @test collect(w_r) ==
                  [UDTDate(0, 0, 0, 0), UDTDate(0, 0, 1, 0), UDTDate(0, 0, 2, 0)]
        end

        @testset "Conversion testing" begin
            dt = DateTime(2024, 1, 1, 12, 0, 0)
            udt = UDT(dt)
            @test convert(DateTime, udt) isa DateTime

            date = Date(2024, 1, 1)
            udt_date = UDTDate(date)
            @test convert(Date, udt_date) isa Date
        end
    end
end