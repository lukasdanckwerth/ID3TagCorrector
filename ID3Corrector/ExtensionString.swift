//
//  stringextension.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 17/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//

import Foundation

extension String {

    

    // Used for removing comment lines in text files (lines that starts with '#')
    mutating func removeLines(startingWith: String) -> String {
        var newValue = ""
        for line in self.lines {
            if !line.hasPrefix(startingWith) && line.trimmed.count > 0 {
                newValue += line + "\n"
            }
        }
        self = newValue.trimmed
        return self
    }
    
    /// Returns this string with only the very first letter capitalized.
    var veryFirstLetterCapitalized: String {
        guard count > 1 else { return self }
        return "\(self[startIndex])".capitalized + "\(dropFirst())"
    }

    /// Trimm whitespaces and remove double whitespaces
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "  ", with: " ")
    }

    var trimmedBrackets: String {
        return self.trimmingCharacters(in: ["(", ")", "[", "]"])
    }

    /// Returns an array containing all words (seperated by a whitespace and new line)
    var words: [String] {
        return self.components(separatedBy: .whitespacesAndNewlines)
    }

    /// Returns an array with containing all lines
    var lines: [String] {
        return self.components(separatedBy: .newlines)
    }
}
