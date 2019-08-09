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
    
    
    // MARK: - Properties
    
    /// Returns a new string made by capitalizing only the first character of the string.
    var capitalizingFirstCharacter: String {
        guard count > 1 else { return self }
        return "\(self[startIndex])".capitalized + "\(dropFirst())"
    }
    
    /// Returns a new string made by removing whitespaces and newlines from both sides of the string.
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Returns a new string made by removing brackets `"()[]"` from both sides of the string.
    var trimmingBrackets: String {
        return trimmingCharacters(in: ["(", ")", "[", "]"])
    }
    
    /// Returns a new string made by replacing all `"["` with `"("`, and `"]"` with `")"`.
    var reaplacingBrackets: String {
        return replacingOccurrences(of: "[", with: "(").replacingOccurrences(of: "]", with: ")")
    }
    
    /// Returns an array containing all words, seperated by whitespaces and newlines.
    var words: [String] {
        return components(separatedBy: .whitespacesAndNewlines)
    }
    
    /// Returns an array with containing all lines, separated by newlines.
    var lines: [String] {
        return components(separatedBy: .newlines)
    }
    
    
    // MARK: - Functions
    
    /// Returns a new string if a word from the given `words` collection occures in this string where all occurences of the
    /// found word are replace with the given string in `replacement`.  If no occurence is found this funtion returns `nil`.
    func replacing(words: [String], with replacement: String) -> String? {
        
        if let incorrectNotation = words.first(where: { self.contains(" \($0) ") }) {
            return replacingOccurrences(of: " \(incorrectNotation) ", with: " \(replacement) ")
        }
        
        return nil
    }
    
    /// Returns a new string with all occurences of eacy key in the given `replacements` directory are replaced by their
    /// value in the dictionary.
    func replacing(_ replacements: [String : String]) -> String {
        return replacements.reduce(self, { string, entry in
            string.replacingOccurrences(of: entry.key, with: entry.value)
        })
    }
    
    
    // MARK: - Command line output
    
    /// Return the bold version of the string.
    var bold: String {
        return "\u{001B}[1m\(self)\u{001B}[0m"
    }
}


// MARK: - Extension String

extension Array where Element == String {
    
    
    // MARK: - Properties
    
    /// Return an array with each element trimmed by calling the `trimmed` property.
    var trimmed: Array {
        return self.compactMap({ $0.trimmed })
    }
    
    /// Return an array with empty lines and line starting with `"#"` are filtered out.
    var cleaned: Array {
        return self.trimmed.filter({ !$0.isEmpty && !$0.hasPrefix("#") })
    }
}
