-- Update Todos - A script to create a text file of your iCal todos-- v2.0(* 
Original (v1.x)  by Brandon Booth  www.lucidgreen.net
Continued by Ptujec
 http://twitter.com/ptujec
 
-- change log -- 10/15/2008: 
 - Added this header 
 - Fixed todo ordering so all prioritized todos from all calendars order properly 
 
 2011-06-20 (by Ptujec):  
 - Droplist optimizations http://www.bloomingsoft.com/droplist/ 
 - Growl Notifications
 - Showing due dates
 - Unicode support
 - Lauches Dropbox and quits iCal when done	
*)property todoFile : (path to home folder) & "Dropbox:Lists:todos.txt" as stringtell application "iCal"	set varHighPriorties to {}	set varMediumPriorities to {}	set varLowPriorities to {}	set varNoPriorites to {}	set varNumberOfCalendars to (count every calendar)		repeat with varCurrentNumber from 1 to varNumberOfCalendars		set varHighTd to (every todo of calendar varCurrentNumber whose priority is high priority)		set varMedTd to (every todo of calendar varCurrentNumber whose priority is medium priority)		set varLowTd to (every todo of calendar varCurrentNumber whose priority is low priority)		set varNoTd to (every todo of calendar varCurrentNumber whose priority is no priority)				repeat with varTodo in varHighTd			if completion date of varTodo exists then			else if due date of varTodo exists then				set {year:y, month:m, day:d} to due date of varTodo				set ddate to d & " " & m				set the end of varHighPriorties to ("- !!! " & summary of varTodo & " (" & ddate & ")")			else if (exists of due date of varTodo) is false then				set the end of varHighPriorties to ("- !!! " & summary of varTodo)			end if		end repeat				repeat with varTodo in varMedTd			if completion date of varTodo exists then			else if due date of varTodo exists then				set {year:y, month:m, day:d} to due date of varTodo				set ddate to d & " " & m				set the end of varMediumPriorities to ("- !! " & summary of varTodo & " (" & ddate & ")")			else if (exists of due date of varTodo) is false then				set the end of varMediumPriorities to ("- !! " & summary of varTodo)			end if		end repeat				repeat with varTodo in varLowTd			if completion date of varTodo exists then			else if due date of varTodo exists then				set {year:y, month:m, day:d} to due date of varTodo				set ddate to d & " " & m				set the end of varLowPriorities to ("- ! " & summary of varTodo & " (" & ddate & ")")			else if (exists of due date of varTodo) is false then				set the end of varLowPriorities to ("- ! " & summary of varTodo)			end if		end repeat				repeat with varTodo in varNoTd			if completion date of varTodo exists then			else if due date of varTodo exists then				set {year:y, month:m, day:d} to due date of varTodo				set ddate to d & " " & m				set the end of varNoPriorites to ("- " & summary of varTodo & " (" & ddate & ")")			else if (exists of due date of varTodo) is false then				set the end of varNoPriorites to ("- " & summary of varTodo)			end if		end repeat			end repeat	set varTodoList to varHighPriorties & varMediumPriorities & varLowPriorities & varNoPrioritesend tellset varOldDelimiters to AppleScript's text item delimitersset AppleScript's text item delimiters to "\n"set varTodoList to varTodoList as stringset AppleScript's text item delimiters to varOldDelimitersglobal varTodoListlaunch application "Dropbox"quit application "iCal"on handWrite()	try		set varFile to open for access file todoFile with write permission		set eof of varFile to 0		set cdate to do shell script "date '+%d.%m.%Y'"		write "# Todos (latest update: " & cdate & ")\n" to varFile as Unicode text		write varTodoList to varFile as Unicode text		close access file todoFile		my growlRegister()		growlNotify("Update Todos", "Update successful!", 0)	on error error_msg		close access file todoFile		my growlRegister()		growlNotify("Update Todos", error_msg, 2)	end tryend handWritetell application "Finder"	if exists file todoFile then		handWrite() of me	else		do shell script "touch ~/Dropbox/Lists/todos.txt"		handWrite() of me	end ifend tellon growlRegister()	tell application "GrowlHelperApp"		register as application "Update Todos" all notifications {"Alert"} default notifications {"Alert"} icon of application "iCal"	end tellend growlRegisteron growlNotify(grrTitle, grrDescription, grrPriority)	tell application "GrowlHelperApp"		notify with name "Alert" title grrTitle description grrDescription priority grrPriority application name "Update Todos"	end tellend growlNotify