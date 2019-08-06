tell application "iTunes"
	if selection is not {} then
		repeat with curTrack in selection
			
			set trackTitle to (name of curTrack) as Unicode text
			
			-- do shell script "cd ~/Library/iTunes/Scripts/"
			set name of curTrack to do shell script "~/Library/iTunes/Scripts/Luigis-iTunes-Scripts/ID3Corrector -t " & quoted form of trackTitle --as Unicode text
			
		end repeat
	end if
end tell


