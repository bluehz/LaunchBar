-- https://gist.github.com/275067/3acc381e6c830e059607f84aa9db31f4ed222290
-- by mfilej
--
-- changed to show rating 
-- better display for streams … espescially radio streaming  
-- by Ptujec
--
-- 2011-10-05
-- changed to convert image data to a tempory jpg file (due to changes of iTunes artwork image data)
-- with help of http://dougscripts.com/itunes/scripts/ss.php?sp=savealbumartjpeg

-- Display the track if iTunes is running
--
-- 2012-11-08
-- removed Growl and added Notification Center support (via LaunchBar)
-- removed image section since Notification Center only allows the application icon

on run
	if appIsRunning("iTunes") then
		tell application "iTunes"
			if exists name of current track then
				set aTrack to the current track
				set aDescription to the name of aTrack
				
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
						
						tell application "LaunchBar" to display in notification center with title aDescription & " " & rating_ subtitle aTitle
					end if
				end tell
			end if
		end tell
		
	else
		tell application "LaunchBar" to display in notification center with title "Error!" subtitle "iTunes not running"
	end if
	
end run

-- Check if application is running
on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning