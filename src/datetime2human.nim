import times, strformat, strutils, pylib


type HumanFriendlyTimeUnits* = tuple[
  seconds: int, minutes: int, hours: int, days: int, weeks: int,
  months: int, years: int, decades: int, centuries: int, millenniums: int]  ## Tuple of Human Friendly Time Units.

type HumanTimes* = tuple[
  human: string, short: string, iso: string, units: HumanFriendlyTimeUnits] ## Tuple of Human Friendly Time Units as strings.


func datetime2human*(datetime_obj: DateTime, iso_sep: char=' '): HumanTimes =
  ## Calculate date & time, with precision from seconds to millenniums.

  var seconds, minutes, hours, days, weeks, months, years, decades, centuries, millenniums: int

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
  var time_parts: seq[string]
  var human_time_auto = ""
  var this_time = ""
  if millenniums:
      this_time = fmt"{millenniums} Millenniums"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if centuries:
      this_time = fmt"{centuries} Centuries"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if decades:
      this_time = fmt"{decades} Decades"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if years:
      this_time = fmt"{years} Years"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if months:
      this_time = fmt"{months} Months"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if weeks:
      this_time = fmt"{weeks} Weeks"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if days:
      this_time = fmt"{days} Days"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if hours:
      this_time = fmt"{hours} Hours"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if minutes:
      this_time = fmt"{minutes} Minutes"
      if not human_time_auto:
          human_time_auto = this_time
      time_parts.add(this_time)
  if not human_time_auto:
      human_time_auto = fmt"{seconds} Seconds"
  time_parts.add(fmt"{seconds} Seconds")

  # Get a Human string ISO-8601 representation.
  let iso_datetime = str(datetime_obj).replace("T", $iso_sep)

  let t: HumanTimes = (
    human: " ".join(time_parts), short: human_time_auto,
    iso: iso_datetime, units: time_units)
  t


proc now2human*(): HumanTimes =  # Just a shortcut :)
  ## Now expressed as human friendly time units string.
  datetime2human(now())


runnableExamples:
  import times
  echo datetime2human(now())
  echo now2human()
