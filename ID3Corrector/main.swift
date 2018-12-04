//
//  main.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 16/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//
import Foundation

/// print the given input to the standard output
func printStOut(_ input: String) {
    FileHandle.standardOutput.write(input.trimmed.data(using: .utf8)!)
}

/// path to the library folder containing the files
var wrongNotationFilesPath: URL {
    return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".id3corrector", isDirectory: true)
}

/// Constant with the correct "feat"-notation
let correctFeat = "(feat."

/// Constant with the correct "prod. by"-notation
let correctProdBy = "(Prod. by"


let correctGenreOption = StringOption(name: "correctGenre", helpMessage: "Correcte the passed genre.")
let correctTitleOption = StringOption(name: "correctTitle", helpMessage: "Correcte the passed title.")

let onlyArtistOption = StringOption(name: "onlyArtist", helpMessage: "Correcte the passed title.")
let onlyFeatureOption = StringOption(name: "onlyFeature", helpMessage: "Correcte the passed title.")

let capitalizeOption = StringOption(name: "capitalize", helpMessage: "Returns the capitalized version of the passed string.")

let startsWithNumber = StringOption(name: "startsWithNumber", helpMessage: "Returns 'true' if the given title starts with a number.")

let replaceOption = StringOption(name: "replace", helpMessage: "Replaces occurences of the string given in the replacementValues argument.")

let capitalizedArgument = Argument(shortFlag: "c", longFlag: "capitalize", help: "Capitalize the output")
let inArgument = StringArgument(shortFlag: "i", longFlag: "in", help: "Capitalize the output")
let outArgument = StringArgument(shortFlag: "o", longFlag: "out", help: "Capitalize the output")
replaceOption.requiredArguments = [inArgument, outArgument]

// set configuration of command line tool
CommandLineTool.configuration = [.needsValidOption, .printHelpForNoSelection]

// execute the command line helper
CommandLineTool.parseOrExit()

// reference to the user defaults
var defaults: UserDefaults? { return UserDefaults(suiteName: "de.aid") }



var corrector = ID3Corrector(wrongNotationFilesPath: wrongNotationFilesPath)


// variable containing the output to print in the end
var output: String!

switch CommandLineTool.option {
    
case correctGenreOption:
    output = corrector.correct(genre: correctGenreOption.value)
    
case correctTitleOption:
    output = correctTitleOption.value
    
case onlyArtistOption:
    if onlyArtistOption.value.contains(correctFeat) {
        let array = onlyArtistOption.value.components(separatedBy: correctFeat)
        if array.count == 2 {
            output = array[0].trimmed.trimmedBrackets
        }
    }
    
case replaceOption:
    output = replaceOption.value.replacingOccurrences(of: "\(inArgument.value!)", with: "\(outArgument.value!)")
    
default:
    exit(0)
}

if capitalizedArgument.isSelected {
    output = output.capitalized
        .replacingOccurrences(of: " (Feat. ", with: " \(correctFeat) ")
        .replacingOccurrences(of: " (Prod. By ", with: " \(correctProdBy) ")
}

printStOut(output)
