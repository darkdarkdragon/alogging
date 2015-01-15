alogging
========

Advanced logging for Haxe

Main goal is to minimize, and, when not used, eliminate completely, runtime penalty.

Thus, in runtime you can only change log levels or enable/disable handlers, but can not
change hierarchy of loggers/handlers.

This package modeled somewhat after python [logging system](http://legacy.python.org/dev/peps/pep-0282/).
Main difference - use of macros, so unneeded logging code can be eliminated at compile time.
This allows to keep logging code inside tightest loops and disable it through configuration without affecting performance.

Also this has browser's console-like performance counters.
