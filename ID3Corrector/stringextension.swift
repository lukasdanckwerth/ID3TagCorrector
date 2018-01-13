//
//  stringextension.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 17/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//

import Foundation

extension String {

    func capitalizingFirstLetter() -> String {
        let first = "\(self[self.startIndex])".capitalized
        let other = "\(self.dropFirst())"
        return first + other
    }

    // Used for removing comment lines in text files (lines that starts with '#')
    mutating func removeLines(startingWith: String) -> String {
        var newValue = ""
        for line in self.lines {
            if !line.hasPrefix(startingWith) && line.trimmed.characters.count > 0 {
                newValue += line + "\n"
            }
        }
        self = newValue.trimmed
        return self
    }

    var uppercaseFirstOfEachWord: String {
        var result = ""
        for word in (self.characters.split(separator: " ").map(String.init)) {
            result += word.capitalizingFirstLetter() + " "
        }
        return result.trimmingCharacters(in: [" "])
    }

    /// Trimm whitespaces and remove double whitespaces
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "  ", with: " ")
    }

    var trimmedBrackets: String {
        return self.trimmingCharacters(in: ["(", ")", "[", "]"])
    }

    /// Returns an array with containing all words seperated by a whitespace
    var words: [String] {
        return self.components(separatedBy: .whitespacesAndNewlines)
    }

    /// Returns an array with containing all lines
    var lines: [String] {
        return self.components(separatedBy: .newlines)
    }
}
