tell application "iTunes"
	if exists name of current track then
		set rating of current track to 100
		display notification "⭐️⭐️⭐️⭐️⭐️ for '" & name of current track & "'"
	else
		display dialog "No track playing." buttons {"Cancel"} default button 1 with icon 0 giving up after 30
	end if
end tell