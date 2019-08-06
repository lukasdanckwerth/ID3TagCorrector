on findReplace(findText, replaceText, sourceText)
	set ASTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to findText
	set sourceText to text items of sourceText
	set AppleScript's text item delimiters to replaceText
	set sourceText to "" & sourceText
	set AppleScript's text item delimiters to ASTID
	return sourceText
end findReplace

tell application "iTunes"
	if selection is not {} then
		
		set theSourceMessage to "Please enter the text you want to replace."
		set theSourceTitle to "Words to replace"
		set theSource to the text returned of (display dialog theSourceMessage with title theSourceTitle default answer "")
		
		set theReplacementMessage to "Please enter the replacement text."
		set theReplacementTitle to "Replacement text"
		set theReplacement to the text returned of (display dialog theReplacementMessage with title "What to add?" default answer "")
		
		repeat with aTrack in selection
			
			set theTitle to name of aTrack
			set theTitle to my findReplace(theSource, theReplacement, theTitle)

			set name of aTrack to theTitle
			
		end repeat
	end if
end tell