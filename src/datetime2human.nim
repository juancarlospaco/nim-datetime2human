import times, strutils


type HumanFriendlyTimeUnits* = tuple[
  seconds: int, minutes: int, hours: int, days: int, weeks: int,
  months: int, years: int, decades: int, centuries: int, millenniums: int] ## Tuple of Human Friendly Time Units.

type HumanTimes* = tuple[
  human: string, short: string, iso: string, units: HumanFriendlyTimeUnits] ## Tuple of Human Friendly Time Units as strings.


template divmod(a, b: SomeInteger): array[0..1, int] =
  [int(a / b), int(a mod b)]

func datetime2human*(datetimeObj: DateTime, isoSep: char = ' ', lower = false): HumanTimes =
  ## Calculate date & time, with precision from seconds to millenniums.

  var
    timeParts: seq[string]
    humanTimeAuto, thisTime: string
    seconds, minutes, hours, days, weeks, months, years, decades, centuries, millenniums: int

  (minutes, seconds) = divmod(int(toUnix(datetimeObj.toTime)), 60)
  (hours, minutes) = divmod(minutes, 60)
  (days, hours) = divmod(hours, 24)
  (weeks, days) = divmod(days, 7)
  (months, weeks) = divmod(weeks, 4)
  (years, months) = divmod(months, 12)
  (decades, years) = divmod(years, 10)
  (centuries, decades) = divmod(decades, 10)
  (millenniums, centuries) = divmod(centuries, 10)

  # Build a tuple with all named time units and all its integer values.
  let timeUnits: HumanFriendlyTimeUnits = (
    seconds: seconds, minutes: minutes, hours: hours, days: days,
    weeks: weeks, months: months, years: years, decades: decades,
    centuries: centuries, millenniums: millenniums)

  # Build a human friendly time string with frequent time units.
  if millenniums > 0:
    thisTime = $millenniums & " Millenniums"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if centuries > 0:
    thisTime = $centuries & " Centuries"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if decades > 0:
    thisTime = $decades & " Decades"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if years > 0:
    thisTime = $years & " Years"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if months > 0:
    thisTime = $months & " Months"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if weeks > 0:
    thisTime = $weeks & " Weeks"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if days > 0:
    thisTime = $days & " Days"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if hours > 0:
    thisTime = $hours & " Hours"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if minutes > 0:
    thisTime = $minutes & " Minutes"
    if humanTimeAuto.len == 0:
      humanTimeAuto = thisTime
    timeParts.add(thisTime)
  if humanTimeAuto.len == 0:
    humanTimeAuto = $seconds & " Seconds"
  timeParts.add($seconds & " Seconds")

  # Get a Human string ISO-8601 representation.
  let isoDatetime = replace($datetimeObj, "T", $isoSep)

  result = (
    human: if lower: timeParts.join(" ").toLowerAscii else: timeParts.join(" "),
    short: if lower: humanTimeAuto.toLowerAscii else: humanTimeAuto,
    iso: isoDatetime, units: timeUnits)


template now2human*(isoSep: char = ' ', lower = false): HumanTimes =
  ## Now expressed as human friendly time units string.
  datetime2human(now(), isoSep, lower) # Just a shortcut :)


# Migrated from NimWC to clean out code.


template currentDatetime*(formatting: string): string =
  ## Getting the current local time
  case formatting
  of "full": format(local(getTime()), "yyyy-MM-dd HH:mm:ss")
  of "date": format(local(getTime()), "yyyy-MM-dd")
  of "year": format(local(getTime()), "yyyy")
  of "month": format(local(getTime()), "MM")
  of "day": format(local(getTime()), "dd")
  of "time": format(local(getTime()), "HH:mm:ss")
  else: format(local(getTime()), "yyyyMMdd")


template getDaysInMonthU*(month: range[1..12], year: Positive): int =
  ## Gets the number of days in the month and year
  getDaysInMonth(Month(month), year)


template dateEpoch*(date, format: string): int =
  ## Transform a date in user format to epoch. Does not utilize timezone.
  assert date.len > 0, "date must not be empty string"
  assert format.len > 0, "format must not be empty string"
  assert format in ["YYYYMMDD", "YYYY-MM-DD", "YYYY-MM-DD HH:mm", "DD-MM-YYYY"]
  case format
  of "YYYYMMDD": toUnix(toTime(parse(date, "yyyyMMdd"))).int
  of "YYYY-MM-DD": toUnix(toTime(parse(date, "yyyy-MM-dd"))).int
  of "YYYY-MM-DD HH:mm": toUnix(toTime(parse(date, "yyyy-MM-dd HH:mm"))).int
  of "DD-MM-YYYY": toUnix(toTime(parse(date, "dd-MM-yyyy"))).int
  else: 0


template epochDate*(epochTime, format: string, timeZone: Natural = 0): string =
  ## Transform epoch to user formatted date
  assert epochTime.len > 0, "epochTime must not be empty string"
  const monthNames = [
    "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ]
  let t = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(hours = timeZone))
  case format
  of "YYYY":
    t.substr(0, 3)
  of "YYYY_MM_DD-HH_mm":
    t.substr(0, 3) & "_" & t.substr(5, 6) & "_" & t.substr(8, 9) & "-" & t.substr(11, 12) & "_" & t.substr(14, 15)
  of "YYYY MM DD":
    t.substr(0, 3) & " " & t.substr(5, 6) & " " & t.substr(8, 9)
  of "YYYY-MM-DD":
    t.substr(0, 9)
  of "YYYY-MM-DD HH:mm":
    t.substr(0, 9) & " - " & t.substr(11, 15)
  of "DD MM YYYY":
    t.substr(8, 9) & " " & t.substr(5, 6) & " " & t.substr(0, 3)
  of "DD":
    t.substr(8, 9)
  of "MMM DD":
    monthNames[parseInt(t.substr(5, 6))] & " " & t.substr(8, 9)
  of "MMM":
    monthNames[parseInt(t.substr(5, 6))]
  else:
    t.substr(0, 9)


# Migrated from NimWC to clean out code.


runnableExamples:
  import times
  echo datetime2human(now())
  echo now2human()
  echo datetime2human(now(), isoSep = 'X', lower = true)
  echo now2human(isoSep = 'X', lower = true)
  echo currentDatetime("full")

  doAssert getDaysInMonthU(02, 2018) == 28
  doAssert getDaysInMonthU(10, 2020) == 31
  doAssert epochDate("1522995050", "YYYY-MM-DD HH:mm", 2) == "2018-04-06 - 08:10"
  doAssert dateEpoch("2018-02-18", "YYYY-MM-DD") == 1518922800
