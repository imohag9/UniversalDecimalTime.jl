# ===========================================================================
# Constants & Conversion
# ===========================================================================
const UNIX_EPOCH_2000 = 946684800  # Jan 1, 2000 00:00:00 UTC
const UDT_SECOND_IN_SI = 0.420768

# Unit sizes in UDT seconds
const SECONDS_PER_MINUTE = 100
const SECONDS_PER_HOUR = 100 * SECONDS_PER_MINUTE      # 10,000
const SECONDS_PER_DAY = 10 * SECONDS_PER_HOUR         # 100,000
const SECONDS_PER_WEEK = 10 * SECONDS_PER_DAY          # 1,000,000
const SECONDS_PER_MONTH = 10 * SECONDS_PER_WEEK         # 10,000,000
const SECONDS_PER_YEAR = 10 * SECONDS_PER_MONTH        # 100,000,000