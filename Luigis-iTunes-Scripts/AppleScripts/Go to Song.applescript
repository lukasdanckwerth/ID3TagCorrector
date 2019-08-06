tell application "iTunes"
	if selection is not {} then
		set curTrackNumber to 0
		set countTracks to (count of (get selection)) as string
		repeat with curTrack in selection
			
			set curArtist to artist of curTrack
			set curName to name of curTrack
			
			set tmpList to (every track of library playlist 1 whose artist is curArtist and name is curName)
			
			repeat with aSong in tmpList
				play aSong
				activate
				tell application "System Events"
					keystroke "l" using {command down}
				end tell
				return
			end repeat
		end repeat
	end if
end tell
tou