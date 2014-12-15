alogging
========

Advanced logging for Haxe

This package modeled after python [logging system](http://legacy.python.org/dev/peps/pep-0282/).
Main difference - use of macros, so unneeded logging codde can be eliminated at compile time.
This allows to keep logging code inside tightest loops and disable it thorough configuration without affecting performance. 

Also this has browser's console-like performance counters.
