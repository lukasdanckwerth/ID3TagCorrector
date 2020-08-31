#!/usr/bin/xcrun swift

//
//  main.swift
//  ID3TagCorrector
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import Foundation

// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - `TrackTitle`
// ===-----------------------------------------------------------------------------------------------------------===

struct TrackTitle {
    var raw: String
    
    var title: String {
        let onlyTitle: String
        if let candidate = raw.component(before: ID3Corrector.feats) {
            onlyTitle = candidate.component(before: ID3Corrector.producedBy) ?? candidate
        } else if let candidate = raw.component(before: ID3Corrector.producedBy) {
            onlyTitle = candidate.component(before: ID3Corrector.feats) ?? candidate
        } else {
            onlyTitle = raw
        }
        
        return onlyTitle
            .replacing(ID3Corrector.replacements)
            .removingRedundantWhitespaces
            .trimmed
    }
    
    var featSignal: String? {
        raw.find(oneOf: ID3Corrector.feats)
    }
    
    var prodSignal: String? {
        raw.find(oneOf: ID3Corrector.producedBy)
    }
    
    var featuring: String? {
        guard let candidate = raw.component(after: ID3Corrector.feats) else { return nil }
        var featuringString = candidate.component(before: ID3Corrector.producedBy) ?? candidate
        featuringString = featuringString.removingRedundantWhitespaces
        featuringString = featuringString.replacing(ID3Corrector.replacements)
        featuringString = ID3Corrector.remove(in: featuringString)
        if self.featSignal?.hasPrefix("(") == true {
            featuringString = featuringString.trimmingCharacters(in: CharacterSet(charactersIn: ")"))
        }
        return featuringString
    }
    
    var producedBy: String? {
        guard let candidate = raw.component(after: ID3Corrector.producedBy) else { return nil }
        var producedByString = candidate.component(before: ID3Corrector.feats) ?? candidate
        producedByString = producedByString.removingRedundantWhitespaces
        producedByString = producedByString.replacing(ID3Corrector.replacements)
        producedByString = ID3Corrector.remove(in: producedByString)
        if self.featSignal?.hasPrefix("(") == true {
            producedByString = producedByString.trimmingCharacters(in: CharacterSet(charactersIn: ")"))
        }
        return producedByString
    }
    
    var formatted: String {
        
        var title = self.title
        
        if let featuring = self.featuring {
            title += " (feat. \(featuring))"
        }
        
        if let producedBy = self.producedBy {
            title += " (Prod. by \(producedBy))"
        }
        
        return title
    }
}

// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - Extension FileManager
// ===-----------------------------------------------------------------------------------------------------------===

extension FileManager {
    
    // MARK: - URLs
    
    /// Reference to the `URL` of the main directory.
    static let mainDirectoryURL = `default`.homeDirectoryForCurrentUser.appendingPathComponent(".tag-corrector", isDirectory: true)
    
    /// Reference to the file containing genre corrections.
    static var incorrectGenresFileURL = fileURL(for: "incorrect-genres")
    
    /// Reference to the file containing incorrect `"feat."` notations.
    static var incorrectFeaturesFileURL = fileURL(for: "incorrect-features")
    
    /// Reference to the file containing incorrect `"Prod. by"` notations.
    static var incorrectProducedByFileURL = fileURL(for: "incorrect-produced-by")
    
    /// Reference to the file containing removements of words.
    static var removementsFile = fileURL(for: "removements")
    
    /// Reference to the file containing replacements of words.
    static var replacementsFile = fileURL(for: "replacements")
    
    
    // MARK: - Functions
    
    /// Returns a `URL` to the text file (`".txt"`) with the given name in the main directory.
    static func fileURL(for fileName: String) -> URL {
        return mainDirectoryURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    }
    
    /// Creates the directory at the given `URL` if it doesn't already exist.
    func createDirectoryIfNotExisting(_ directoryURL: URL) {
        if !fileExists(atPath: directoryURL.path) {
            try? createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
}

// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - Extension FileManager
// ===-----------------------------------------------------------------------------------------------------------===

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
    
    /// Returns a new string made by removin wrong leading and trailing whitespaces from brackets.
    var removingRedundantWhitespaces: String {
        return replacing([
            "( " : "(",
            " )" : ")"
        ])
    }
    
    /// Returns a new string made by replacing all double whitespaces `"  "` and with a single one `" "`.
    var removingDoubleWhitespaces: String {
        return replacingOccurrences(of: "  ", with: " ")
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
    
    func find(oneOf words: [String]) -> String? {
        return words.first(where: { self.contains(" \($0) ") })
    }
    
    func component(after words: [String]) -> String? {
        if let found = self.find(oneOf: words), let suffixCandidate = self.components(separatedBy: " \(found) ").last {
            if found.hasPrefix("("), suffixCandidate.hasSuffix(")") {
                return suffixCandidate.trimmingCharacters(in: CharacterSet(charactersIn: ")"))
            } else {
                return suffixCandidate
            }
        } else {
            return nil
        }
    }
    
    func component(before words: [String]) -> String? {
        if let found = self.find(oneOf: words), let candidate = self.components(separatedBy: " \(found) ").first {
            return candidate
        } else {
            return nil
        }
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
    var removeEmptyAndCommentLines: Array {
        return self.trimmed.filter({ !$0.isEmpty && !$0.hasPrefix("#") })
    }
}

// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - Help Text
// ===-----------------------------------------------------------------------------------------------------------===

/// The string containing a help text for this tool.
let help = """
usage: tag-corrector <command> [<args>]

COMMANDS:

\("   ")\("correctGenre".bold)  <genre>     Corrects the passed genre
\("   ")\("correctName".bold)  <name>       Corrects the passed name
\("   ")\("remove".bold)  <file> <name>     Removes all words in the given file from the given name

\("   ")\("--help".bold)                   Print this help text and exit
\("   ")\("--version".bold)                Print the version of tag-corrector

"""


// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - Exit Command Line Tool
// ===-----------------------------------------------------------------------------------------------------------===

/// Prints the given message and exits with the given exit code.
func exit(_ message: String, exitCode: Int32 = EXIT_SUCCESS, withHelpMessage flag: Bool = false) -> Never {
    
    if flag {
        print(message, "\n\nPass '--help' for a list of available commands\n")
    } else {
        print(message)
    }
    
    exit(exitCode)
}


// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - ID3Corrector
// ===-----------------------------------------------------------------------------------------------------------===

struct ID3Corrector {
    
    
    // MARK: - Statics
    
    /// Constant with the correct `"feat."` - notation.
    static let feat = "feat."
    
    /// Constant with the correct `"Prod. by"` - notation
    static let prodBy = "Prod. by"
    
    
    // MARK: - Properties
    
    /// A dictionary of incorrect genres with their correction.
    static var genres = dictionary(at: FileManager.incorrectGenresFileURL)
    
    /// A map containing key value pairs with words to replace.
    static var replacements = dictionary(at: FileManager.replacementsFile)
    
    /// A collection of incorrect `feat.` notations.
    static var feats = lines(at: FileManager.incorrectFeaturesFileURL)
    
    /// A collection of incorrect `"Prod. by"` notations.
    static var producedBy = lines(at: FileManager.incorrectProducedByFileURL) + [prodBy]
    
    
    // MARK: - Correction Functionality
    
    /// Returns the corrected version of the given genre.  Iterates the `genre` map and returns the first entry where the given genre matches the key.
    static func correctGenre(_ genre: String) -> String {
        return genres.first(where: { genre == $0.key })?.value ?? genre
    }
    
    /// Returns the corrected version of the given name.
    static func correctName(_ name: String) -> String {
        
        let originalName = name.reaplacingBrackets
        let comps = name.components(separatedBy: " - ")
        
        guard comps.count == 1 else {
            return comps.compactMap(correctName).joined(separator: " - ")
        }
        
        let trackTitle = TrackTitle(raw: originalName)
        
        return trackTitle.formatted.replacing(replacements)
    }
    
    /// Removes all occurences of the words from the file at the given `URL` in the given name.
    static func remove(wordsAt url: URL = FileManager.removementsFile, in name: String) -> String {
        return lines(at: url).reduce(name, { name, word in
            name.replacingOccurrences(of: word, with: "")
        }).trimmed.removingDoubleWhitespaces
    }
    
    
    
    // MARK: - Replace
    
    private static func replaceFeat(name: inout String) -> String {
        
        // skip for existing correct `"feat."` - notation
        guard !name.contains(" (\(feat) ") else { return name }
        
        return name.replacing(words: feats.compactMap({ "(\($0)" }), with: "(\(feat)")
            ?? name.replacing(words: feats, with: "(\(feat)")?.appending(")")
            ?? name
    }
    
    private static func replaceProducedBy(name: inout String) -> String {
        
        // skip for existing correct `"Prod. by"` - notation
        guard !name.contains(" (\(prodBy) ") else { return name }
        
        return name.replacing(words: producedBy.compactMap({ "(\($0)" }), with: "(\(prodBy)")
            ?? name.replacing(words: producedBy, with: "(\(prodBy)")?.appending(")")
            ?? name
    }
    
    
    // MARK: - Ready Files
    
    /// Returns the content of the file at the given `URL`.
    static func content(at url: URL) -> String? {
        return try? String(contentsOf: url)
    }
    
    /// Returns the lines of the file at the given `URL`.
    static func lines(at url: URL) -> [String] {
        return content(at: url)?.lines.removeEmptyAndCommentLines ?? []
    }
    
    /// Returns a dictionary containing key value pairs from the file at the given `URL`.  Keys and values are separated by an `"="` sign.
    static func dictionary(at url: URL) -> [String : String] {
        
        var dictionary = [String : String]()
        
        for line in lines(at: url) {
            
            let pair = line.components(separatedBy: "=").map({ $0.trimmed })
            
            if pair.count == 2 {
                dictionary[pair[0]] = pair[1]
            } else if pair.count == 1 {
                dictionary[pair[0]] = ""
            }
        }
        
        return dictionary
    }
}


// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - Receive arguments
// ===-----------------------------------------------------------------------------------------------------------===

// receive command line arguments
var arguments = CommandLine.arguments.dropFirst()

// returns the next arguments
func nextArgument(onError message: String) -> String {
    
    // guard the existing of an argument
    guard let argumemt = arguments.popFirst() else {
        exit(message, withHelpMessage: true)
    }
    
    return argumemt
}


// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - Preconditions
// ===-----------------------------------------------------------------------------------------------------------===

// receive command
let command = nextArgument(onError: "No arguments given")

// create main directory if it doesn't exist
FileManager.default.createDirectoryIfNotExisting(FileManager.mainDirectoryURL)


var output: String?


// ===-----------------------------------------------------------------------------------------------------------===
//
// MARK: - Switch Command
// ===-----------------------------------------------------------------------------------------------------------===

switch command {
case "correctGenre":
    
    let genre = nextArgument(onError: "No genre specified")
    output = ID3Corrector.correctGenre(genre).trimmed
    
case "correctName":
    
    let name = nextArgument(onError: "No name specified")
    output = ID3Corrector.correctName(name).trimmed
    
case "remove":
    
    let filePath = nextArgument(onError: "No path to text file specified")
    let name = nextArgument(onError: "No name specified")
    let url = URL(fileURLWithPath: filePath)
    
    output = ID3Corrector.remove(wordsAt: url, in: name).trimmed
    
case "--help", "-h":
    
    exit(help)
    
case "--version", "-v":
    
    exit("0.0.6")
    
default:
    
    exit("Unknown argument '\(command)'", withHelpMessage: true)
    
}

print(output ?? "", terminator: "")
