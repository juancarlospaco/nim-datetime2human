import times, strutils


type HumanFriendlyTimeUnits* = tuple[
  seconds: int, minutes: int, hours: int, days: int, weeks: int,
  months: int, years: int, decades: int, centuries: int, millenniums: int]  ## Tuple of Human Friendly Time Units.

type HumanTimes* = tuple[
  human: string, short: string, iso: string, units: HumanFriendlyTimeUnits] ## Tuple of Human Friendly Time Units as strings.


const monthNames = [
    "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ]


func divmod(a, b: SomeInteger): array[0..1, int] {.inline.} =
  [int(a / b), int(a mod b)]

func datetime2human*(datetimeObj: DateTime, isoSep: char=' ', lower=false): HumanTimes =
  ## Calculate date & time, with precision from seconds to millenniums.

  var
    timeParts: seq[string]
    humanTimeAuto, thisTime: string
    seconds, minutes, hours, days, weeks, months, years, decades, centuries, millenniums: int

  (minutes, seconds)       = divmod(int(toUnix(datetimeObj.toTime)), 60)
  (hours, minutes)         = divmod(minutes, 60)
  (days, hours)            = divmod(hours, 24)
  (weeks, days)            = divmod(days, 7)
  (months, weeks)          = divmod(weeks, 4)
  (years, months)          = divmod(months, 12)
  (decades, years)         = divmod(years, 10)
  (centuries, decades)     = divmod(decades, 10)
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


proc now2human*(isoSep: char=' ', lower=false): HumanTimes {.inline.} =  # Just a shortcut :)
  ## Now expressed as human friendly time units string.
  datetime2human(now(), isoSep, lower)


# Migrated from NimWC to clean out code.


proc currentDatetime*(formatting: string): string {.inline.} =
  ## Getting the current local time
  case formatting
  of "full":
    result = format(local(getTime()), "yyyy-MM-dd HH:mm:ss")
  of "date":
    result = format(local(getTime()), "yyyy-MM-dd")
  of "year":
    result = format(local(getTime()), "yyyy")
  of "month":
    result = format(local(getTime()), "MM")
  of "day":
    result = format(local(getTime()), "dd")
  of "time":
    result = format(local(getTime()), "HH:mm:ss")
  else:
    result = format(local(getTime()), "yyyyMMdd")


proc getDaysInMonthU*(month, year: int): int {.inline.} =
  ## Gets the number of days in the month and year
  if unlikely(month notin {1..12}):
    echo("getDaysInMonthU() wrong format input.")
  else:
    result = getDaysInMonth(Month(month), year)


proc dateEpoch*(date, format: string): int =
  ## Transform a date in user format to epoch. Does not utilize timezone.
  try:
    case format
    of "YYYYMMDD":
      return toUnix(toTime(parse(date, "yyyyMMdd"))).int
    of "YYYY-MM-DD":
      return toUnix(toTime(parse(date, "yyyy-MM-dd"))).int
    of "YYYY-MM-DD HH:mm":
      return toUnix(toTime(parse(date, "yyyy-MM-dd HH:mm"))).int
    of "DD-MM-YYYY":
      return toUnix(toTime(parse(date, "dd-MM-yyyy"))).int
    else:
      echo("dateEpoch() wrong format input.")
      return 0
  except:
    echo("dateEpoch() failed.")
    return 0


proc epochDate*(epochTime, format: string, timeZone = "0"): string =
  ## Transform epoch to user formatted date
  if epochTime == "": return ""
  try:
    case format
    of "YYYY":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return toTime.substr(0, 3)

    of "YYYY_MM_DD-HH_mm":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return toTime.substr(0, 3) & "_" & toTime.substr(5,
          6) & "_" & toTime.substr(8, 9) & "-" & toTime.substr(11,
          12) & "_" & toTime.substr(14, 15)

    of "YYYY MM DD":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return toTime.substr(0, 3) & " " & toTime.substr(5,
          6) & " " & toTime.substr(8, 9)

    of "YYYY-MM-DD":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return toTime.substr(0, 9)

    of "YYYY-MM-DD HH:mm":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return toTime.substr(0, 9) & " - " & toTime.substr(11, 15)

    of "DD MM YYYY":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return toTime.substr(8, 9) & " " & toTime.substr(5,
          6) & " " & toTime.substr(0, 3)

    of "DD":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return toTime.substr(8, 9)

    of "MMM DD":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return monthNames[parseInt(toTime.substr(5, 6))] & " " & toTime.substr(
          8, 9)

    of "MMM":
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      return monthNames[parseInt(toTime.substr(5, 6))]

    else:
      let toTime = $(utc(fromUnix(parseInt(epochTime))) + initTimeInterval(
          hours = parseInt(timeZone)))
      echo("epochDate() no input specified.")
      return toTime.substr(0, 9)

  except:
    echo("epochDate() failed.")
    return ""


# Migrated from NimWC to clean out code.


runnableExamples:
  import times
  echo datetime2human(now())
  echo now2human()
  echo datetime2human(now(), isoSep='X', lower=true)
  echo now2human(isoSep='X', lower=true)

  doAssert getDaysInMonthU(02, 2018) == 28
  doAssert getDaysInMonthU(10, 2020) == 31
  doAssert epochDate("1522995050", "YYYY-MM-DD HH:mm", "2") == "2018-04-06 - 08:10"
  doAssert dateEpoch("2018-02-18", "YYYY-MM-DD") == 1518922800
