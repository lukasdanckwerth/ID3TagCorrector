tell application "iTunes"
	if selection is not {} then
		
		set theMessage to "Please enter the year you want to set ..."
		set theTitle to "Set Year"
		set theYear to the text returned of (display dialog theMessage with title theTitle default answer "")
		
		repeat with aTrack in selection
			set year of aTrack to theYear
		end repeat
		
	end if
end tell
