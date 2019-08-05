//
//  main.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 16/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//
import Foundation


// MARK: - Constants

/// Constant with the correct "feat" - notation
let CORRECT_FEAT = "(feat."

/// Constant with the correct "prod. by" - notation
let CORRECT_PROD_BY = "(Prod. by"

/// path to the library folder containing the files
var wrongNotationFilesPath: URL {
    return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".id3corrector", isDirectory: true)
}


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



/// Provides functions to correct ID3 tags.
///
/// - author: Lukas Danckwerth
/// - version: 0.1
public class ID3Corrector {
    
    // /////////////////////////////////////////////////////////////////
    // Arrays with wrong notations
    // /////////////////////////////////////////////////////////////////
    lazy var wrongFeats: [String]? = {
        if let content = ID3Corrector.getContent(url: wrongNotationFilesPath.appendingPathComponent("WrongFeat.txt")) {
            return content.words
        }
        return nil
    }()
    
    lazy var wrongProdBys: [String]? = {
        if let content = ID3Corrector.getContent(url: wrongNotationFilesPath.appendingPathComponent("WrongProdBy.txt")) {
            return content.words
        }
        return nil
    }()
    
    lazy var wrongWords: [(String, String)]? = {
        if let content = ID3Corrector.getContent(url: wrongNotationFilesPath.appendingPathComponent("Replace.txt")) {
            if !content.isEmpty {
                var wrongWords = [(String, String)]()
                for line in content.lines {
                    var lineArray = line.components(separatedBy: ";")
                    if lineArray.count == 2 {
                        wrongWords.append((lineArray[0], lineArray[1]))
                    } else if lineArray.count == 1 {
                        wrongWords.append((lineArray[0], ""))
                    }
                }
                return wrongWords
            }
        }
        return nil
    }()
    
    lazy var wrongGenres: [(String, String)]? = {
        if let content = ID3Corrector.getContent(url: wrongNotationFilesPath.appendingPathComponent("WrongGenres.txt")) {
            return ID3Corrector.getTuples(content: content, seperator: ":")
        }
        return nil
    }()
    
    
    // /////////////////////////////////////////////////////////////////
    // Variables for runtime
    // /////////////////////////////////////////////////////////////////
    var boolNeedsBracketForFeat = false
    
    var boolNeedsBracketForProdBy = false
    
    var wrongNotationFilesPath: URL
    
    init(wrongNotationFilesPath url: URL) {
        
        self.wrongNotationFilesPath = url
    }
    
    
    /**
     Checks whether the given title starts with a number
     
     - parameters:
     -title: The title to check its prefix for numbers.
     - returns: "true" as a String if the given title starts with a number, "false" as String if not
     */
    func titleStartsWithNumber(title: String) -> String {
        do {
            let expression = try NSRegularExpression(pattern: "[012345]{0,1}[0123456789]{1}.*",options: .caseInsensitive)
            let matches = expression.matches(in: title, options: .anchored, range: NSRange(location: 0, length: title.count))
            return matches.count > 0 ? "true" : "false"
        } catch _ {
            return "false"
        }
    }
    
    
    
    func getFeat(title: String) -> String {
        var tmpFeat = title.components(separatedBy: CORRECT_FEAT)[1]
        if tmpFeat.contains(CORRECT_PROD_BY) {
            tmpFeat = tmpFeat.components(separatedBy: CORRECT_PROD_BY)[0]
        }
        return tmpFeat
            .replacingOccurrences(of: " and ", with: " & ")
            .replacingOccurrences(of: " And ", with: " & ")
            .replacingOccurrences(of: " AND ", with: " & ")
            .trimmed
    }
    
    
    
    func getProdBy(title: String) -> String {
        var tmpProdBy = title.components(separatedBy: CORRECT_PROD_BY)[1]
        if tmpProdBy.contains(CORRECT_FEAT) {
            tmpProdBy = tmpProdBy.components(separatedBy: CORRECT_FEAT)[0]
        }
        return tmpProdBy
            .replacingOccurrences(of: " and ", with: " & ")
            .replacingOccurrences(of: " And ", with: " & ")
            .replacingOccurrences(of: " AND ", with: " & ")
            .trimmed
    }
    
    
    
    func getName(title: String) -> String {
        var name = title
        if containsFeat(title: name) {
            name = name.components(separatedBy: CORRECT_FEAT)[0]
        }
        
        if containsProdBy(title: name) {
            name = name.components(separatedBy: CORRECT_PROD_BY)[0]
        }
        
        if containsFeat(title: name) {
            name = name.components(separatedBy: CORRECT_PROD_BY)[0]
        }
        
        return name.trimmed
    }
    
    
    func correct(title: String) -> String {
        var tmpTitle = title
        
        tmpTitle = correctFeat(title: tmpTitle)
        tmpTitle = correctProdBy(title: tmpTitle)
        
        if containsProdBy(title: tmpTitle) && containsFeat(title: tmpTitle) {
            let feat = getFeat(title: tmpTitle)
            let prodBy = getProdBy(title: tmpTitle)
            let name = getName(title: tmpTitle)
            tmpTitle = "\(name) \(CORRECT_FEAT) \(feat)\(boolNeedsBracketForFeat ? ")" : "") \(CORRECT_PROD_BY) \(prodBy)\(boolNeedsBracketForProdBy ? ")" : "")"
        } else if containsProdBy(title: tmpTitle) {
            let prodBy = getProdBy(title: tmpTitle)
            let name = getName(title: tmpTitle)
            tmpTitle = "\(name) \(CORRECT_PROD_BY) \(prodBy)\(boolNeedsBracketForProdBy ? ")" : "")"
        } else if containsFeat(title: tmpTitle) {
            let feat = getFeat(title: tmpTitle)
            let name = getName(title: tmpTitle)
            tmpTitle = "\(name) \(CORRECT_FEAT) \(feat)\(boolNeedsBracketForFeat ? ")" : "")"
        }
        
        
        for tuple in wrongWords ?? [] {
            if tmpTitle.contains(" \(tuple.0)") {
                tmpTitle = tmpTitle.replacingOccurrences(of: " \(tuple.0)", with: " \(tuple.1)")
            }
        }
        
        return tmpTitle
    }
    
    private func correctFeat(title: String) -> String {
        if let wrongFeat = wrongFeats?.first(where: { title.contains(" \($0) ") }) {
            return title.replacingOccurrences(of: " \(wrongFeat) ", with: " \(CORRECT_FEAT) ")
        }
        return title
    }
    
    private func correctProdBy(title: String) -> String {
        if let wrongProdBy = wrongFeats?.first(where: { title.contains(" \($0) ") }) {
            return title.replacingOccurrences(of: " \(wrongProdBy) ", with: " \(CORRECT_PROD_BY) ")
        }
        return title
    }
    
    func correct(genre: String) -> String {
        return wrongGenres?.first(where: { $0.0 == genre })?.1 ?? genre
    }
    
    private func containsFeat(title: String) -> Bool {
        return title.contains(CORRECT_FEAT)
    }
    
    private func containsProdBy(title: String) -> Bool {
        return title.contains(CORRECT_PROD_BY)
    }
    
    private func featBeforeProd(title: String) -> Bool {
        do {
            let expression = try NSRegularExpression(pattern: ".* \\(feat\\. .* \\(Prod\\. by .*", options: .caseInsensitive)
            let matches = expression.matches(in: title, options: .anchored, range: NSRange(location: 0, length: title.count))
            return matches.count > 0
        } catch _ {
            return false
        }
    }
    
    
    // MARK: - Auxiliary static functions
    
    /**
     Returns the content of the file at the given path or nil.
     - Author: Lukas Danckwerth
     - Version: 0.1
     */
    static func getContent(url: URL) -> String? {
        do {
            var content = try String(contentsOf: url)
            return content.removeLines(startingWith: "#")
        } catch {
            return nil
        }
    }
    
    static func getTuples(content: String, seperator: String) -> [(String, String)] {
        var tuples = [(String, String)]()
        
        for line in content.lines {
            if !line.hasPrefix("#") {
                var lineArray = line.components(separatedBy: seperator)
                if lineArray.count == 2 {
                    tuples.append((lineArray[0], lineArray[1]))
                } else if lineArray.count == 1 {
                    tuples.append((lineArray[0], ""))
                }
            }
        }
        
        return tuples
    }
}


//let correctGenreOption = StringOption(name: "correctGenre", helpMessage: "Correcte the passed genre.")
//let correctTitleOption = StringOption(name: "correctTitle", helpMessage: "Correcte the passed title.")
//
//let onlyArtistOption = StringOption(name: "onlyArtist", helpMessage: "Receive only artist.")
//let onlyFeatureOption = StringOption(name: "onlyFeature", helpMessage: "Receive only feature.")
//
//let capitalizeOption = StringOption(name: "capitalize", helpMessage: "Returns the capitalized version of the passed string.")
//
//let startsWithNumber = StringOption(name: "startsWithNumber", helpMessage: "Returns 'true' if the given title starts with a number.")
//
//let replaceOption = StringOption(name: "replace", helpMessage: "Replaces occurences of the string given in the replacementValues argument.")
//
//let capitalizedArgument = Argument(shortFlag: "c", longFlag: "capitalize", help: "Capitalize the output")
//let inArgument = StringCollectionArgument(shortFlag: "i", longFlag: "in", help: "Capitalize the output")
//let outArgument = StringArgument(shortFlag: "o", longFlag: "out", help: "Capitalize the output")
//let trimmArgument = Argument(shortFlag: "t", longFlag: "trimm", help: "Trimms the output.")
//
//replaceOption.requiredArguments = [inArgument, outArgument]
//
//// set configuration of command line tool
//CommandLineTool.configuration = [.needsValidOption, .printHelpForNoSelection]
//
//// execute the command line helper
//CommandLineTool.parseOrExit()

// reference to the user defaults
//var defaults: UserDefaults? { return UserDefaults(suiteName: "de.aid") }
//
//
//
//var corrector = ID3Corrector(wrongNotationFilesPath: wrongNotationFilesPath)
//
//
//// variable containing the output to print in the end
//var output: String!
//
//switch CommandLineTool.option {
//
//case correctGenreOption:
//    output = corrector.correct(genre: correctGenreOption.value)
//
//case correctTitleOption:
//    output = correctTitleOption.value
//
//case onlyArtistOption:
//    if onlyArtistOption.value.contains(CORRECT_FEAT) {
//        let array = onlyArtistOption.value.components(separatedBy: CORRECT_FEAT)
//        if array.count == 2 {
//            output = array[0].trimmed.trimmedBrackets
//        }
//    }
//
//case startsWithNumber:
//
//    let regex = try? NSRegularExpression(pattern: "^[0-9]+", options: .caseInsensitive)
//    let matches = regex?.matches(in: startsWithNumber.value, options: [], range: NSRange(location: 0, length: startsWithNumber.value.count))
//
//    output = matches?.count ?? 0 > 0 ? "true" : "false"
//
//case replaceOption:
//
//    for value in inArgument.values {
//        output = replaceOption.value.replacingOccurrences(of: value, with: "\(outArgument.value!)")
//    }
//
//default:
//    break
//}
//
//if capitalizedArgument.isSelected {
//    output = output.capitalized
//        .replacingOccurrences(of: " (Feat. ", with: " \(CORRECT_FEAT) ")
//        .replacingOccurrences(of: " (Prod. By ", with: " \(ID3Corrector.correctProdBy) ")
//}
//
//if trimmArgument.isSelected {
//    output = output.trimmed
//}

/// print the given input to the standard output

// receive arguments from command line
let arguments = CommandLine.arguments.dropFirst()

guard arguments.count > 0 else {
    exit(0)
}

var output: String? = arguments.last
if arguments.first == "--correctNames" {
    output = arguments.last

}
else if arguments.first == "--correctGenre" {
    
    
}
else if arguments.first == "--help" {
    
    print("""
    
    \t--correctNames    Corrects the passed title.
    \t--correctGenre    Corrects the passed genre.

    \t--help            Prints this manual page.

    """)
} else {
    
}

if let output = output {
    FileHandle.standardOutput.write(output.data(using: .utf8)!)
}
