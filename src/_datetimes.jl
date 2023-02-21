@doc raw"""
# DateTime
The `Dates` module provides two types for working with dates: `Date` and `DateTime`,
representing day and millisecond precision, respectively. Both types are subtypes of the
abstract `TimeType`. The motivation for having distinct types is simple: some operations are
much simpler, both in terms of code and mental reasoning, when the complexities of greater
precision are not dealt with. For example, since the `Date` type only resolves to the
precision of a single date (i.e., without hours, minutes, or seconds), normal considerations
for time zones, daylight savings/summer time, and leap seconds are unnecessary.

Both `Date` and `DateTime` are essentially immutable `Int64` wrappers. The single instant
field of either type is actually a `UTInstant{P}` type, which represents a continuously
increasing machine timeline based on the UT second. The `DateTime` type is not aware of time
zones (or 'naive', as referred to in Python), similar to a `LocalDateTime` in Java 8.

The [TimeZones.jl](https://github.com/JuliaTime/TimeZones.jl/) package can add additional
time zone functionality. It compiles the IANA time zone database. Both `Date` and `DateTime`
are based on the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) standard, which follows
the proleptic Gregorian calendar.

One thing to note is that the ISO 8601 standard is specific about BC/BCE dates. In general,
the last day of the BC/BCE era, 31-12-1 BC/BCE, was followed by 1-1-1 AD/CE, so there is no
year zero. The ISO standard, however, states that 1 BC/BCE is year zero, so '0000-12-31' is
the day before `0001-01-01`, and year `-0001` (that's right, negative one for the year) is
2 BC/BCE, year `-0002` is 3 BC/BCE, and so on.

# Type Hierarchy Tree
```julia
AbstractTime
├─ Calendar
│  └─ ISOCalendar
├─ CompoundPeriod
├─ Instant
│  └─ UTInstant
├─ Period
│  ├─ DatePeriod
│  │  ├─ Day
│  │  ├─ Month
│  │  ├─ Quarter
│  │  ├─ Week
│  │  └─ Year
│  └─ TimePeriod
│     ├─ Hour
│     ├─ Microsecond
│     ├─ Millisecond
│     ├─ Minute
│     ├─ Nanosecond
│     └─ Second
└─ TimeType
   ├─ Date
   ├─ AbstractDateTime
   │  └─ DateTime
   └─ Time
```

# Constructors
The `Date` and `DateTime` types can be constructed using integers or `Period` types, by
parsing, or through adjusters (which will be discussed later):

```julia
julia> DateTime(2013)
2013-01-01T00:00:00

julia> DateTime(2013, 7)
2013-07-01T00:00:00

julia> DateTime(2013, 7, 1)
2013-07-01T00:00:00

julia> DateTime(2013, 7, 1, 12)
2013-07-01T12:00:00

julia> DateTime(2013, 7, 1, 12, 30)
2013-07-01T12:30:00

julia> DateTime(2013, 7, 1, 12, 30, 59)
2013-07-01T12:30:59

julia> DateTime(2013, 7, 1, 12, 30, 59, 1)
2013-07-01T12:30:59.001

julia> Date(2013)
2013-01-01

julia> Date(2013,7)
2013-07-01

julia> Date(2013,7,1)
2013-07-01

julia> Date(Dates.Year(2013), Dates.Month(7), Dates.Day(1))
2013-07-01

julia> Date(Dates.Month(7), Dates.Year(2013))
2013-07-01
```

Parsing `Date` or `DateTime` is done using format strings. Format strings define delimited
or fixed-width "slots" that contain a period to parse, which are passed to the `Date` or
`DateTime` constructor. For example, `Date("2015-01-01", dateformat"y-m-d")` or
`DateTime("20150101", dateformat"yyyymmdd")`.

Delimited slots are specified by the delimiter between two consecutive periods, for example,
`"y-m-d"` specifies the delimiter between the first and second slots as `"-"`. The `y`, `m`,
and `d` characters indicate which periods to parse in each slot. If some parts of the date
are missing, they are given default values. For example,
`Date("1981-03", dateformat"y-m-d")` returns `1981-03-01`, and
`Date("31/12", dateformat"d/m/y")` returns `0001-12-31`. (Note that the default year is 1
AD/CE). If the input string is empty, it returns `0001-01-01` for `Dates` and
`0001-01-01T00:00:00.000` for `DateTimes`.

Fixed-width slots are specified by repeating the period character the number of times equal
to the width, with no delimiter between the characters. For example, `dateformat"yyyymmdd"`
corresponds to a date string like `"20140716"`. The parser recognizes the fixed-width slot
by the absence of a delimiter.

Support for parsing text-formatted months is also available using the `u` and `U` characters
for abbreviated and full-length month names, respectively. The default is English month
names, with `u` corresponding to "Jan", "Feb", "Mar", etc. and `U` corresponding to
"January", "February", "March", etc. Similar to other `name=>value` mapping functions
`dayname` and `monthname`, custom locales can be loaded by passing the
`locale => Dict{String, Int}` mapping to the `MONTHTOVALUEABBR` and `MONTHTOVALUE` dicts for
abbreviated and full-name month names, respectively.

The `dateformat""` string macro is used in the above examples. This macro creates a
`DateFormat` object once when the macro is expanded, and uses the same `DateFormat` object
even if the code snippet is run multiple times. For example, the code block below generates
same output on all iterations:

```julia
julia> for i = 1:10^5
           Date("2015-01-01", dateformat"y-m-d")
       end
```

Or you can create the DateFormat object explicitly:

```julia
julia> df = DateFormat("y-m-d");

julia> dt = Date("2015-01-01", df)
2015-01-01

julia> dt2 = Date("2015-01-02", df)
2015-01-02
```

Alternatively, use broadcasting:

```julia
julia> years = ["2015", "2016"];

julia> Date.(years, DateFormat("yyyy"))
2-element Vector{Date}:
 2015-01-01
 2016-01-01
```

For convenience, you can pass the format string directly
(e.g.,`Date("2015-01-01","y-m-d")`), though this form incurs performance costs if you are
parsing the same format repeatedly, as it creates a new `DateFormat` object internally each
time.

In addition to the constructors, a `Date` or `DateTime` can be constructed from strings
using the `parse` and `tryparse` functions, with an optional third argument of type
`DateFormat`, which specifies the format. For example,
`parse(Date, "06.23.2013", dateformat"m.d.y")`, or
`tryparse(DateTime, "1999-12-31T23:59:59")` uses the default format. The difference between
the functions is that `tryparse` does not throw an error if the string is in an invalid
format; instead, it returns `nothing`. Note that, as with the constructors, empty date and
time parts assume default values, and thus an empty string (`""`) is valid for any
`DateFormat`, resulting in a Date of `0001-01-01`, for example. Code that relies on `parse`
or `tryparse` for `Date` and `DateTime` parsing should therefore also check if parsed
strings are empty before using the result.

A comprehensive suite of parsing and formatting tests and examples can be found in
[stdlib/Dates/test/io.jl]
(https://github.com/JuliaLang/julia/blob/master/stdlib/Dates/test/io.jl).

# Durations/Comparisons
Finding the length of time between two `Date` or `DateTime` objects is straightforward due
to their underlying representation as `UTInstant{Day}` and `UTInstant{Millisecond}`,
respectively. The difference between `Date` objects is returned in terms of the number of
`Day`s, and for `DateTime` objects, in terms of the number of `Milliseconds`. Similarly,
comparing `TimeType`` objects is a simple matter of comparing the underlying machine
instants, which in turn compares the internal `Int64` values.

```julia
julia> dt = Date(2012, 2, 29)
2012-02-29

julia> dt2 = Date(2000, 2, 1)
2000-02-01

julia> dump(dt)
Date
  instant: Dates.UTInstant{Day}
    periods: Day
      value: Int64 734562

julia> dump(dt2)
Date
  instant: Dates.UTInstant{Day}
    periods: Day
      value: Int64 730151

julia> dt > dt2
true

julia> dt != dt2
true

julia> dt + dt2
ERROR: MethodError: no method matching +(::Date, ::Date)

julia> dt * dt2
ERROR: MethodError: no method matching *(::Date, ::Date)

julia> dt / dt2
ERROR: MethodError: no method matching /(::Date, ::Date)

julia> dt - dt2
4411 days

julia> dt2 - dt
-4411 days

julia> dt = DateTime(2012,2,29)
2012-02-29T00:00:00

julia> dt2 = DateTime(2000,2,1)
2000-02-01T00:00:00

julia> dt - dt2
381110400000 milliseconds
```

# Accessor Functions
Because the `Date` and `DateTime` types are stored as a single `Int64` value, date parts or
fields can be retrieved through accessor functions. The lowercase accessors return the field
as an integer:

```julia
julia> t = Date(2014, 1, 31)
2014-01-31

julia> Dates.year(t)
2014

julia> Dates.month(t)
1

julia> Dates.week(t)
5

julia> Dates.day(t)
31
```

While the propercase versions return the same value in the corresponding `Period` type:

```julia
julia> Dates.Year(t)
2014 years

julia> Dates.Day(t)
31 days
```

Compound methods are provided because it is more efficient to access multiple fields at the
same time than individually:

```julia
julia> Dates.yearmonth(t)
(2014, 1)

julia> Dates.monthday(t)
(1, 31)

julia> Dates.yearmonthday(t)
(2014, 1, 31)
```

The underlying `UTInstant` or integer value can also be accessed:

```julia
julia> dump(t)
Date
  instant: Dates.UTInstant{Day}
    periods: Day
      value: Int64 735264

julia> t.instant
Dates.UTInstant{Day}(Day(735264))

julia> Dates.value(t)
735264
```

# Query Functions
Query functions provide calendrical information about a `TimeType`, including information
about the day of the week:

```julia
julia> t = Date(2014, 1, 31)
2014-01-31

julia> Dates.dayofweek(t)
5

julia> Dates.dayname(t)
"Friday"

julia> Dates.dayofweekofmonth(t) # 5th Friday of January
5
```

Month of the year:

```julia
julia> Dates.monthname(t)
"January"

julia> Dates.daysinmonth(t)
31
```

As well as information about the `TimeType`'s year and quarter:

```julia
julia> Dates.isleapyear(t)
false

julia> Dates.dayofyear(t)
31

julia> Dates.quarterofyear(t)
1

julia> Dates.dayofquarter(t)
31
```

The `dayname` and `monthname` methods can also take an optional `locale` keyword to return
the name of the day or month in different languages/locales. There are also abbreviated
versions, `dayabbr` and `monthabbr`. First, the mapping is loaded into the `LOCALES`
variable:

```julia
julia> french_months = ["janvier", "février", "mars", "avril", "mai", "juin",
                        "juillet", "août", "septembre", "octobre", "novembre", "décembre"];

julia> french_monts_abbrev = ["janv","févr","mars","avril","mai","juin",
                              "juil","août","sept","oct","nov","déc"];

julia> french_days = ["lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"];

julia> Dates.LOCALES["french"] = Dates.DateLocale(french_months, french_monts_abbrev, french_days, [""]);
```

The functions can then be used to perform the queries:

```julia
julia> Dates.dayname(t; locale="french")
"vendredi"

julia> Dates.monthname(t; locale="french")
"janvier"

julia> Dates.monthabbr(t; locale="french")
"janv"
```

If the abbreviated versions of the days are not loaded, trying to use the `dayabbr` function
will result in an error:

```julia
julia> Dates.dayabbr(t;locale="french")
ERROR: BoundsError: attempt to access 1-element Vector{String} at index [5]
```

# TimeType-Period Arithmetic
It's good practice when using any language/date framework to be familiar with how
date-period arithmetic is handled as there are some [tricky issues]
(https://codeblog.jonskeet.uk/2010/12/01/the-joys-of-date-time-arithmetic/) to deal with
(though much less so for day-precision types).

The `Dates` module approach tries to follow the simple principle of trying to change as
little as possible when doing `Period` arithmetic. This approach is also often known as
calendrical arithmetic or what you would probably guess if someone were to ask you the same
calculation in a conversation. Why all the fuss about this? Let's take a classic example:
add 1 month to January 31st, 2014. What's the answer? Javascript will say March 3
(assumes 31 days). PHP says March 2 (assumes 30 days). The fact is, there is no right
answer. In the `Dates` module, it gives the result of February 28th. How does it figure that
out? Consider the classic 7-7-7 gambling game in casinos.

Now just imagine that instead of 7-7-7, the slots are Year-Month-Day, or in our example,
2014-01-31. When you ask to add 1 month to this date, the month slot is incremented, so now
we have 2014-02-31. Then the day number is checked if it is greater than the last valid day
of the new month; if it is (as in the case above), the day number is adjusted down to the
last valid day (28). What are the ramifications with this approach? Go ahead and add another
month to our date, `2014-02-28 + Month(1) == 2014-03-28`. What? Were you expecting the last
day of March? Nope, sorry, remember the 7-7-7 slots. As few slots as possible are going to
change, so we first increment the month slot by 1, 2014-03-28, and boom, we're done because
that's a valid date. On the other hand, if we were to add 2 months to our original date,
2014-01-31, then we end up with 2014-03-31, as expected. The other ramification of this
approach is a loss in associativity when a specific ordering is forced (i.e. adding things
in different orders results in different outcomes). For example:

```julia
julia> (Date(2014, 1, 29) + Dates.Day(1)) + Dates.Month(1)
2014-02-28

julia> (Date(2014, 1, 29) + Dates.Month(1)) + Dates.Day(1)
2014-03-01
```

What's going on there? In the first line, we're adding 1 day to January 29th, which results
in 2014-01-30; then we add 1 month, so we get 2014-02-30, which then adjusts down to
2014-02-28. In the second example, we add 1 month first, where we get 2014-02-29, which
adjusts down to 2014-02-28, and then add 1 day, which results in 2014-03-01. One design
principle that helps in this case is that, in the presence of multiple Periods, the
operations will be ordered by the Periods' types, not their value or positional order; this
means `Year` will always be added first, then `Month`, then `Week`, etc. Hence the following
does result in associativity and just works:

```julia
julia> Date(2014,1,29) + Dates.Day(1) + Dates.Month(1)
2014-03-01

julia> Date(2014,1,29) + Dates.Month(1) + Dates.Day(1)
2014-03-01
```

Tricky? Perhaps. What is an innocent `Dates` user to do? The bottom line is to be aware that
explicitly forcing a certain associativity, when dealing with months, may lead to some
unexpected results, but otherwise, everything should work as expected. Thankfully, that's
pretty much the extent of the odd cases in date-period arithmetic when dealing with time in
UT (avoiding the "joys" of dealing with daylight savings, leap seconds, etc.).

As a bonus, all period arithmetic objects work directly with ranges:
```julia
julia> dr = Date(2014, 1, 29):Day(1):Date(2014, 2, 3)
Date("2014-01-29"):Day(1):Date("2014-02-03")

julia> collect(dr)
6-element Vector{Date}:
 2014-01-29
 2014-01-30
 2014-01-31
 2014-02-01
 2014-02-02
 2014-02-03

julia> dr = Date(2014, 1, 29):Month(1):Date(2014, 07, 29)
Date("2014-01-29"):Month(1):Date("2014-07-29")

julia> collect(dr)
7-element Vector{Date}:
 2014-01-29
 2014-02-28
 2014-03-29
 2014-04-29
 2014-05-29
 2014-06-29
 2014-07-29
```

# Adjuster Functions
As convenient as date-period arithmetic is, often the kinds of calculations needed on dates
take on a calendrical or temporal nature rather than a fixed number of periods. Holidays are
a perfect example; most follow rules such as "Memorial Day = Last Monday of May", or
"Thanksgiving = 4th Thursday of November". These kinds of temporal expressions deal with
rules relative to the calendar, like first or last of the month, next Tuesday, or the first
and third Wednesdays, etc.

The `Dates` module provides the adjuster API through several convenient methods that aid in
simply and succinctly expressing temporal rules. The first group of adjuster methods deal
with the first and last of weeks, months, quarters, and years. They each take a single
`TimeType` as input and return or adjust to the first or last of the desired period relative
to the input:

```julia
julia> Dates.firstdayofweek(Date(2014,7,16)) # Adjusts the input to the Monday of the input's week
2014-07-14

julia> Dates.lastdayofmonth(Date(2014,7,16)) # Adjusts to the last day of the input's month
2014-07-31

julia> Dates.lastdayofquarter(Date(2014,7,16)) # Adjusts to the last day of the input's quarter
2014-09-30
```

The next two higher-order methods, `tonext`, and `toprev`, generalize working with temporal
expressions by taking a `DateFunction` as first argument, along with a starting `TimeType`.
A `DateFunction` is just a function, usually anonymous, that takes a single `TimeType` as
input and returns a `Bool`, `true` indicating a satisfied adjustment criterion. For example:

```julia
julia> istuesday = x -> Dates.dayofweek(x) == Dates.Tuesday; # Returns true if the day of the week of x is Tuesday

julia> Dates.tonext(istuesday, Date(2014,7,13)) # 2014-07-13 is a Sunday
2014-07-15

julia> Dates.tonext(Date(2014,7,13), Dates.Tuesday) # Convenience method provided for day of the week adjustments
2014-07-15
```

This is useful with the do-block syntax for more complex temporal expressions:

```julia
julia> Dates.tonext(Date(2014, 7, 13)) do x
           # Return true on the 4th Thursday of November (Thanksgiving)
           Dates.dayofweek(x) == Dates.Thursday &&
           Dates.dayofweekofmonth(x) == 4 &&
           Dates.month(x) == Dates.November
       end
2014-11-27
```

The `Base.filter` method can be used to obtain all valid dates/moments in a specified range:

```julia
# Pittsburgh street cleaning; Every 2nd Tuesday from April to November
# Date range from January 1st, 2014 to January 1st, 2015
julia> dr = Dates.Date(2014):Day(1):Dates.Date(2015);

julia> filter(dr) do x
           Dates.dayofweek(x) == Dates.Tue &&
           Dates.April ≤ Dates.month(x) ≤ Dates.Nov &&
           Dates.dayofweekofmonth(x) == 2
       end
8-element Vector{Date}:
 2014-04-08
 2014-05-13
 2014-06-10
 2014-07-08
 2014-08-12
 2014-09-09
 2014-10-14
 2014-11-11
```

Additional examples and tests are available in [stdlib/Dates/test/adjusters.jl]
(https://github.com/JuliaLang/julia/blob/master/stdlib/Dates/test/adjusters.jl).

# Period Types
Periods are a human view of discrete, sometimes irregular durations of time. Consider 1
month; it could represent, in days, a value of 28, 29, 30, or 31 depending on the year and
month context. Or a year could represent 365 or 366 days in the case of a leap year. Period
types are simple `Int64` wrappers and are constructed by wrapping any `Int64` convertible
type, i.e. `Year(1)` or `Month(3.0)`. Arithmetic between `Period` of the same type behave
like integers, and limited `Period-Real` arithmetic is available. You can extract the
underlying integer with `Dates.value`:

```julia
julia> y1 = Dates.Year(1)
1 year

julia> y2 = Dates.Year(2)
2 years

julia> y3 = Dates.Year(10)
10 years

julia> y1 + y2
3 years

julia> div(y3, y2)
5

julia> y3 - y2
8 years

julia> y3 % y2
0 years

julia> div(y3, 3) # mirrors integer division
3 years

julia> Dates.value(Dates.Millisecond(10))
10
```

Representing periods or durations that are not integer multiples of the basic types can be
achieved with the `Dates.CompoundPeriod` type. Compound periods may be constructed manually
from simple `Period` types.

Additionally, the `canonicalize` function can be used to break down a period into a
`Dates.CompoundPeriod`. This is particularly useful to convert a duration, e.g., a
difference of two `DateTime`, into a more convenient representation:

```julia
julia> cp = Dates.CompoundPeriod(Day(1), Minute(1))
1 day, 1 minute

julia> t1 = DateTime(2018, 8, 8, 16, 58, 00)
2018-08-08T16:58:00

julia> t2 = DateTime(2021, 6, 23, 10, 00, 00)
2021-06-23T10:00:00

julia> canonicalize(t2-t1) # creates a CompoundPeriod
149 weeks, 6 days, 17 hours, 2 minutes
```

# Rounding
`Date` and `DateTime` values can be rounded to a specified resolution (e.g., 1 month or 15
minutes) with `floor`, `ceil`, or `round`:

```julia
julia> floor(Date(1985, 8, 16), Dates.Month)
1985-08-01

julia> ceil(DateTime(2013, 2, 13, 0, 31, 20), Dates.Minute(15))
2013-02-13T00:45:00

julia> round(DateTime(2016, 8, 6, 20, 15), Dates.Day)
2016-08-07T00:00:00
```

Unlike the numeric `round` method, which breaks ties toward the even number by default, the
`TimeTyperound` method uses the `RoundNearestTiesUp` rounding mode. (It's difficult to guess
what breaking ties to nearest "even" `TimeType` would entail.) Further details on the
available `RoundingMode`s can be found in the `funcs` reference.

Rounding should generally behave as expected, but there are a few cases in which the
expected behaviour is not obvious.

# Rounding Epoch
In many cases, the resolution specified for rounding (e.g., `Dates.Second(30)`) divides
evenly into the next largest period (in this case, `Dates.Minute(1)`). But rounding
behaviour in cases in which this is not true may lead to confusion. What is the expected
result of rounding a `DateTime` to the nearest 10 hours?

```julia
julia> round(DateTime(2016, 7, 17, 11, 55), Dates.Hour(10))
2016-07-17T12:00:00
```

That may seem confusing, given that the hour (12) is not divisible by 10. The reason that
`2016-07-17T12:00:00` was chosen is that it is 17,676,660 hours after `0000-01-01T00:00:00`,
and 17,676,660 is divisible by 10.

As Julia `Date` and `DateTime` values are represented according to the ISO 8601 standard,
`0000-01-01T00:00:00` was chosen as base (or "rounding epoch") from which to begin the count
of days (and milliseconds) used in rounding calculations. (Note that this differs slightly
from Julia's internal representation of `Date`s using [Rata Die notation]
(https://en.wikipedia.org/wiki/Rata_Die); but since the ISO 8601 standard is most visible to
the end user, `0000-01-01T00:00:00` was chosen as the rounding epoch instead of the
`0000-12-31T00:00:00` used internally to minimize confusion.)

The only exception to the use of `0000-01-01T00:00:00` as the rounding epoch is when
rounding to weeks. Rounding to the nearest week will always return a Monday (the first day
of the week as specified by ISO 8601). For this reason, we use `0000-01-03T00:00:00` (the
first day of the first week of year 0000, as defined by ISO 8601) as the base when rounding
to a number of weeks.

Here is a related case in which the expected behaviour is not necessarily obvious: What
happens when we round to the nearest P(2), where P is a Period type? In some cases
(specifically, when `P <: Dates.TimePeriod)` the answer is clear:

```julia
julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Hour(2))
2016-07-17T08:00:00

julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Minute(2))
2016-07-17T08:56:00
```

This seems obvious, because two of each of these periods still divides evenly into the next
larger order period. But in the case of two months (which still divides evenly into one
year), the answer may be surprising:

```julia
julia> round(DateTime(2016, 7, 17, 8, 55, 30), Dates.Month(2))
2016-07-01T00:00:00
```

Why round to the first day in July, even though it is month 7 (an odd number)? The key is
that months are 1-indexed (the first month is assigned 1), unlike hours, minutes, seconds,
and milliseconds (the first of which are assigned 0).

This means that rounding a `DateTime` to an even multiple of seconds, minutes, hours, or
years (because the ISO 8601 specification includes a year zero) will result in a `DateTime`
with an even value in that field, while rounding a `DateTime` to an even multiple of months
will result in the months field having an odd value. Because both months and years may
contain an irregular number of days, whether rounding to an even number of days will result
in an even value in the days field is uncertain.
"""
function datetime()
    header1 = "Union"
    printstyled(header1, '\n', '≡'^(length(header1) + 2), '\n'; bold=true);
    println("""
    ConvertiblePeriod    GeneralPeriod    OtherPeriod
    FixedPeriod          Locale           TimeTypeOrPeriod\n""")

    header2 = "Constructors"
    printstyled(header2, '\n', '≡'^(length(header2) + 2), '\n'; bold=true);
    println("""
    CompoundPeriod    Date    DateTime    Time    parse    tryparse\n""")

    header3 = "Formatters"
    printstyled(header3, '\n', '≡'^(length(header3) + 2), '\n'; bold=true);
    println("""
    @dateformat_str    ISODateFormat        ISOTimeFormat    format
    DateFormat         ISODateTimeFormat    RFC1123Format\n""")

    header4 = "Epoch & Timezones"
    printstyled(header4, '\n', '≡'^(length(header4) + 2), '\n'; bold=true);
    println("""
    DATEEPOCH        WEEKEPOCH           datetime2rata       julian2datetime
    DATETIMEEPOCH    date2epochdays      datetime2unix       rata2datetime
    JULIANEPOCH      datetime2epochms    epochdays2date      unix2datetime
    UNIXEPOCH        datetime2julian     epochms2datetime\n""")

    header5 = "Constants"
    printstyled(header5, '\n', '≡'^(length(header5) + 2), '\n'; bold=true);
    printstyled("Month (Abbreviation)", '\n'; bold=true)
    println("""
    January  (Jan)    April (Apr)    July      (Jul)    October (Oct)
    February (Feb)    May            August    (Aug)    November (Nov)
    March    (Mar)    June  (Jun)    September (Sep)    December (Dec)\n""")

    printstyled("Day (Abbreviation)", '\n'; bold=true)
    println("""
    Monday  (Mon)    Wednesday (Wed)    Friday   (Fri)    Sunday (Sun)
    Tuesday (Tue)    Thursday  (Thu)    Saturday (Sat)\n""")

    printstyled("Others", '\n'; bold=true)
    println("""
    AM           QUARTERDAYS         TWENTYFOURHOUR    DAYSINMONTH
    AMPM         SHIFTEDMONTHDAYS    TWENTYNINE        TimeZone
    MONTHDAYS    THIRTY              UTC               fixedperiod_conversions
    PM           THIRTYONE           WEEK_INDEX\n""")

    header6 = "Adjusting Functions"
    printstyled(header6, '\n', '≡'^(length(header6) + 2), '\n'; bold=true);
    println("""
    firstdayofmonth      firstdayofyear      lastdayofweek    tolast
    firstdayofquarter    lastdayofmonth      lastdayofyear    tonext
    firstdayofweek       lastdayofquarter    tofirst          toprev\n""")

    header7 = "Accessor Functions"
    printstyled(header7, '\n', '≡'^(length(header7) + 2), '\n'; bold=true);
    println("""
    Year       Hour           Nanosecond      month       minute
    Quarter    Minute         year            monthday    second
    Month      Second         yearmonth       week        millisecond
    Week       Millisecond    yearmonthday    day         microsecond
    Day        Microsecond    quarter         hour        nanosecond\n""")

    header8 = "Query Functions"
    printstyled(header8, '\n', '≡'^(length(header8) + 2), '\n'; bold=true);
    println("""
    monthname    quarterofyear    dayofweek           daysofweekinmonth
    monthabbr    dayofyear        dayofweekofmonth
    dayname      dayofquarter     daysinyear
    dayabbr      dayofmonth       daysinmonth\n""")

    header9 = "General Functions"
    printstyled(header9, '\n', '≡'^(length(header9) + 2), '\n'; bold=true);
    println("""
    DateLocale          today                    methodswith    typeassert
    StepRange           tryparsenext             oftype         typeintersect
    canonicalize        tryparsenext_core        one            typejoin
    eps                 tryparsenext_internal    summary        typemax
    default             validargs                summarysize    typemin
    now                 value                    subtypes       typeof
    parse_components    convert                  supertype
    periods             dump                     supertypes\n""")

    header10 = "True/False Functions"
    printstyled(header10, '\n', '≡'^(length(header10) + 2), '\n'; bold=true);
    println("""
    isleapyear     isthursday    hastypemax        isbits            isdefined
    ismonday       isfriday      in                isbitstype        ismutable
    istuesday      issaturday    isa               isconcretetype    ismutabletype
    iswednesday    issunday      isabstracttype    isconst           isstructtype\n""")

    header11 = "Rounding Functions"
    printstyled(header11, '\n', '≡'^(length(header11) + 2), '\n'; bold=true);
    println("""
    ceil    floor    floorceil    round    trunc\n""")

    header12 = "Non-Alphanumeric Operators"
    printstyled(header12, '\n', '≡'^(length(header12) + 2), '\n'; bold=true);
    println("""
    *    /    ÷    %    +    -    :    >    <    >=    <=\n""")
end