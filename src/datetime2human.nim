import times, strutils


type HumanFriendlyTimeUnits* = tuple[
  seconds: int, minutes: int, hours: int, days: int, weeks: int,
  months: int, years: int, decades: int, centuries: int, millenniums: int]  ## Tuple of Human Friendly Time Units.

type HumanTimes* = tuple[
  human: string, short: string, iso: string, units: HumanFriendlyTimeUnits] ## Tuple of Human Friendly Time Units as strings.

func divmod(a, b: SomeInteger): array[0..1, int] {.inline.} =
  [int(a / b), int(a mod b)]

func datetime2human*(datetime_obj: DateTime, iso_sep: char=' ', lower=false): HumanTimes =
  ## Calculate date & time, with precision from seconds to millenniums.

  var
    time_parts: seq[string]
    human_time_auto, this_time: string
    seconds, minutes, hours, days, weeks, months, years, decades, centuries, millenniums: int

  (minutes, seconds)       = divmod(int(toUnix(datetime_obj.toTime)), 60)
  (hours, minutes)         = divmod(minutes, 60)
  (days, hours)            = divmod(hours, 24)
  (weeks, days)            = divmod(days, 7)
  (months, weeks)          = divmod(weeks, 4)
  (years, months)          = divmod(months, 12)
  (decades, years)         = divmod(years, 10)
  (centuries, decades)     = divmod(decades, 10)
  (millenniums, centuries) = divmod(centuries, 10)

  # Build a tuple with all named time units and all its integer values.
  let time_units: HumanFriendlyTimeUnits = (
    seconds: seconds, minutes: minutes, hours: hours, days: days,
    weeks: weeks, months: months, years: years, decades: decades,
    centuries: centuries, millenniums: millenniums)

  # Build a human friendly time string with frequent time units.
  if millenniums > 0:
      this_time = $millenniums & " Millenniums"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if centuries > 0:
      this_time = $centuries & " Centuries"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if decades > 0:
      this_time = $decades & " Decades"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if years > 0:
      this_time = $years & " Years"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if months > 0:
      this_time = $months & " Months"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if weeks > 0:
      this_time = $weeks & " Weeks"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if days > 0:
      this_time = $days & " Days"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if hours > 0:
      this_time = $hours & " Hours"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if minutes > 0:
      this_time = $minutes & " Minutes"
      if human_time_auto.len == 0:
          human_time_auto = this_time
      time_parts.add(this_time)
  if human_time_auto.len == 0:
      human_time_auto = $seconds & " Seconds"
  time_parts.add($seconds & " Seconds")

  # Get a Human string ISO-8601 representation.
  let iso_datetime = replace($datetime_obj, "T", $iso_sep)

  result = (
    human: if lower: time_parts.join(" ").toLowerAscii else: time_parts.join(" "),
    short: if lower: human_time_auto.toLowerAscii else: human_time_auto,
    iso: iso_datetime, units: time_units)


proc now2human*(iso_sep: char=' ', lower=false): HumanTimes {.inline.} =  # Just a shortcut :)
  ## Now expressed as human friendly time units string.
  datetime2human(now(), iso_sep, lower)


runnableExamples:
  import times
  echo datetime2human(now())
  echo now2human()
  echo datetime2human(now(), iso_sep='X', lower=true)
  echo now2human(iso_sep='X', lower=true)
