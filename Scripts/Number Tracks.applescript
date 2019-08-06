tell application "iTunes"
	if selection is not {} then
		
		set theTrackNumber to 0
		set theTrackAmount to (count of (get selection)) as string
		
		repeat with aTrack in selection
			set theTrackNumber to (theTrackNumber + 1)
			set track number of aTrack to theTrackNumber
			set track count of aTrack to theTrackAmount
		end repeat
		
		display notification "Numbered " & theTrackAmount & " tracks."
	end if
end tell