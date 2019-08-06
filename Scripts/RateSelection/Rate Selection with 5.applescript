tell application "iTunes"
	if selection of front browser window is not {} then
		set theSelection to selection of front browser window
		repeat with aTrack in theSelection
			set rating of aTrack to 100
		end repeat
	else
		display dialog "No tracks selected." buttons {"Cancel"} default button 1 with icon 0 giving up after 30
	end if
end tell