import times, strutils


type HumanFriendlyTimeUnits* = tuple[
  seconds: int, minutes: int, hours: int, days: int, weeks: int,
  months: int, years: int, decades: int, centuries: int, millenniums: int]  ## Tuple of Human Friendly Time Units.

type HumanTimes* = tuple[
  human: string, short: string, iso: string, units: HumanFriendlyTimeUnits] ## Tuple of Human Friendly Time Units as strings.


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


runnableExamples:
  import times
  echo datetime2human(now())
  echo now2human()
  echo datetime2human(now(), isoSep='X', lower=true)
  echo now2human(isoSep='X', lower=true)
