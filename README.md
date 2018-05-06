# nim-datetime2human

Calculate date &amp; time with precision from seconds to millenniums.
Human friendly date time as string. ISO-8601.

![screenshot](https://source.unsplash.com/BXOXnQ26B7o/800x402 "Illustrative Photo by https://unsplash.com/@aronvisuals")


# Use

```nim
>>> import datetime2human
>>> echo datetime2human(now())
(human: "5 Decades 2 Years 6 Months 2 Weeks 3 Days 2 Hours 4 Minutes 16 Seconds", short: "5 Decades", iso: "2018-05-05 23:04:16-03:00", units: (seconds: 16, minutes: 4, hours: 2, days: 3, weeks: 2, months: 6, years: 2, decades: 5, centuries: 0, millenniums: 0))
echo now2human()
(human: "5 Decades 2 Years 6 Months 2 Weeks 3 Days 2 Hours 4 Minutes 16 Seconds", short: "5 Decades", iso: "2018-05-05 23:04:16-03:00", units: (seconds: 16, minutes: 4, hours: 2, days: 3, weeks: 2, months: 6, years: 2, decades: 5, centuries: 0, millenniums: 0))
>>>
```


# Install

```
nimble install datetime2human
```


# Requisites

- [Nim](https://nim-lang.org)


# Documentation

<details>
    <summary><b>datetime2human()</b></summary>

**Description:**
Calculate date &amp; time with precision from seconds to millenniums.
Human friendly date time as string. ISO-8601 representation.
The proc only accepts `DateTime`.

**Arguments:**
- `datetime_obj` A valid `DateTime` object, `DateTime` type, required.

**Returns:** `HumanTimes` type, a tuple.

</details>


<details>
    <summary><b>now2human()</b></summary>

**Description:**
Now expressed as human friendly time units string, Just a shortcut to `datetime2human`.

**Arguments:** None.

**Returns:** `HumanTimes` type, a tuple.

</details>
