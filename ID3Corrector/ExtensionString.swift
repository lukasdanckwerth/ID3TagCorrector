//
//  ExtensionString.swift
//  tag-corrector
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import Foundation


// MARK: - Extension String

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
    
    func replacing(words: [String], with replacement: String) -> String? {
        
        if let incorrectNotation = words.first(where: { self.contains(" \($0) ") }) {
            return replacingOccurrences(of: " \(incorrectNotation) ", with: " \(replacement) ")
        }
        
        return nil
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
    
    /// Removes leading and trailing brackets `"()[]"`.
    var trimmedBrackets: String {
        return trimmingCharacters(in: ["(", ")", "[", "]"])
    }
    
    /// Returns an array containing all words (seperated by a whitespace and new line)
    var words: [String] {
        return components(separatedBy: .whitespacesAndNewlines)
    }
    
    /// Returns an array with containing all lines.
    var lines: [String] {
        return components(separatedBy: .newlines)
    }
    
    /// Returns a string where all square brackets are replaced with parenthesis.
    var onlyParenthesis: String {
        return replacingOccurrences(of: "[", with: "(").replacingOccurrences(of: "]", with: ")")
    }
    
    
    // MARK: - Command line output
    
    /// Return the bold version of the string.
    var bold: String {
        return "\u{001B}[1m\(self)\u{001B}[0m"
    }
}
