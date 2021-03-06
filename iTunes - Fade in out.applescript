(* 
  db iTunes Fade-in/out
  By David Battino, Batmosphere.com
  Based on ideas from Doug's AppleScripts and Mac OS Hints
  
  This script fades out iTunes if it's playing and fades it in if it's stopped.
*)

-- edited by Ptujec
--
-- 2012-11-08
-- + show rating
-- + display info also for streams and podcasts
-- + Notification Center support (via LaunchBar)



-- check if iTunes is running 
tell application "System Events"
	if process "iTunes" exists then
		set okflag to true --iTunes is running
	else
		set okflag to false
	end if
end tell

if okflag is true then
	
	tell application "iTunes"
		
		set currentvolume to the sound volume
		if player state is playing then
			repeat
				--Fade down	
				repeat with i from currentvolume to 0 by -1 --try by -4 on slower Macs
					set the sound volume to i
					delay 0.01 -- Adjust this to change fadeout duration (delete this line on slower Macs)
				end repeat
				pause
				--Restore original volume
				set the sound volume to currentvolume
				exit repeat
			end repeat
		else -- if player state is paused then
			
			set the sound volume to 0 --2007-03-20 script update to fix startup glitch
			play
			
			-- tell application "System Events" to set visible of process "iTunes" to false
			
			-- reveal current track
			
			repeat with j from 0 to currentvolume by 1 --try by 4 on slower Macs
				set the sound volume to j
				delay 0.01 -- Adjust this to change fadeout duration (delete this line on slower Macs)	
			end repeat
			
			--- Notification
			tell application "iTunes"
				if exists name of current track then
					set aTrack to the current track
					set aDescription to the name of aTrack
					
					-- rating 
					if rating of aTrack is 100 then
						set rating_ to " ★★★★★"
						-- else if rating of aTrack is 80 then
						--	set rating_ to " ★★★★"
					else if rating of aTrack is 60 then
						set rating_ to " ★★★・・"
						-- else if rating of aTrack is 40 then
						--	set rating_ to " ★★・・・"
						-- else if rating of aTrack is 20 then
						--	set rating_ to " ★・・・・"
					else
						set rating_ to " "
					end if
					
					-- Podcast
					if aTrack is podcast then
						set aTitle to the name of aTrack
						set aDescription to the description of aTrack
						
						
					else if artist of aTrack is not "" then
						set aTitle to the artist of aTrack
						
						
						-- Stream
					else if artist of aTrack is "" then
						set aTitle to aDescription
						if current stream title is not missing value then
							set aDescription to current stream title as text
						else if current stream URL is not missing value then
							set aDescription to current stream URL as text
						else
							set aDescription to " " as text
						end if
					end if
					
					tell application "LaunchBar" to display in notification center with title aTitle subtitle aDescription & " " & rating_
					
				end if
			end tell
			
		end if
		
	end tell
	
	
else
	tell application "LaunchBar" to display in notification center with title "Error!" subtitle "iTunes not running"
end if