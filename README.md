#!/usr/bin/env echo
Created to schedule shutdowns outside of work schedules. This saves on VPS usage. It is written in python3, and setup will install it as a service. The proram used all default moduels, and will call bash/shell commands
"shutdown", and "wall."

To modify the schedule, edit the dates and times at the top of timec.py, or /usr/sbin/timec.

WARNING: Be sure to set the schedule you want. It will shutdown the comuter outside of these times.


