-- iTunes - Rate (for current track playing)
-- @Ptujec 2012-04-16
--
-- 2012-11-08
-- removed Growl and added Notification Center support (via LaunchBar)


on run
	
	tell application "LaunchBar" to display in notification center with title "Error!" subtitle "Hit spacebar to enter your rating!"
	
	
end run

on handle_string(S)
	
	tell application "iTunes"
		if player state is playing then
			set okflag to true
		else
			set okflag to false
		end if
	end tell
	
	if okflag is true then
		_rate(S)
		
	else if okflag is false then
		tell application "LaunchBar" to display in notification center with title "Error!" subtitle "iTunes is not playing ..."
		
	end if
	
end handle_string

on _rate(S)
	
	tell application "iTunes"
		set rating of current track to S * 20
	end tell
	
	tell application "iTunes"
		set aTrack to the current track
		set aName to the name of aTrack
		set aArtist to the artist of aTrack
		if artist of aTrack is not "" then
			set aArtist to the artist of aTrack
		else if artist of aTrack is "" then
			set aArtist to aName
		end if
		
		set rating of aTrack to S * 20
		
		if S is "1" then
			set _rating to "★・・・・"
		else if S is "2" then
			set _rating to "★★・・・"
		else if S is "3" then
			set _rating to "★★★・・"
		else if S is "4" then
			set _rating to "★★★★・"
		else if S is "5" then
			set _rating to "★★★★★"
		else
			set _rating to ""
		end if
		
		
		tell application "LaunchBar" to display in notification center with title "»" & aName & "« by " & aArtist subtitle "Rating is " & _rating as text
	end tell
	
	
end _rate