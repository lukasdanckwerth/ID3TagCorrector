

set appending to the text returned of (display dialog "Please enter the word you want to add in the beginning ..." with title "What to add?" default answer "")

tell application "iTunes"
	if selection is not {} then
		repeat with curTrack in selection
			set name of curTrack to (appending & name of curTrack)
		end repeat
	end if
end tell

