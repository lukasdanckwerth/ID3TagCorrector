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

let capitalizedOption = StringOption(name: "capitalized", helpMessage: "Returns the capitalized version of the passed string.")


// set configuration of command line tool
CommandLineTool.configuration = [.needsValidOption, .printHelpForNoSelection]

// execute the command line helper
CommandLineTool.parseOrExit()

// reference to the user defaults
var defaults: UserDefaults? { return UserDefaults(suiteName: "de.aid") }



var corrector = ID3Corrector(wrongNotationFilesPath: wrongNotationFilesPath)


// variable containing the output to print in the end
var output: String!

print("execution path: \(wrongNotationFilesPath)")

switch CommandLineTool.option {
    
case correctGenreOption:
    output = correctGenreOption.value
case correctGenreOption:
    output = correctGenreOption.value
case capitalizedOption:
    output = capitalizedOption.value.capitalized
        .replacingOccurrences(of: " (Feat. ", with: " \(correctFeat) ")
        .replacingOccurrences(of: " (Prod. By ", with: " \(correctProdBy) ")
default:
    exit(0)
    
}

printStOut(output)

exit(0)

////////////////////////////////////////////////////////////////////
//
// Command Line Tool
////////////////////////////////////////////////////////////////////
if CommandLine.arguments.count >= 3 {
    
    // The first argument contains the command line tool itself. So we can
    // use its path for the text files for correction.
    let pathFile = CommandLine.arguments[0]
    let option = CommandLine.arguments[1]
    let input = CommandLine.arguments[2]
    
    var output: String! = input
    
    switch option {
        
    case "-g": // Option "-g" for correcting Genre
        
        for wrongGenre in getTuples(path: pathFile + "Files/WrongGenres.txt", seperator: ":") {
            if input.contains(wrongGenre.0) {
                output = wrongGenre.1
                break } }
        break
        
        
    case "-t": // Option "-t" for correcting title
        output = getCorrector(pathFiles: pathFile + "Files/").correct(title: input)
        break
        
        
    case "-tc": // Option "-tc" for correcting title and capitalize title
        output = getCorrector(pathFiles: pathFile + "Files/").correct(title: input.capitalized)
        break
        
        
    case "-c": // Option "-c" for capitalize first character of each word
        output = input.capitalized
            .replacingOccurrences(of: " (Feat. ", with: " \(correctFeat) ")
            .replacingOccurrences(of: " (Prod. By ", with: " \(correctProdBy) ")
        break
        
        
    case "-fa": // Option "-fa" for (f)ormat (a)rtist and feat
        //        output = getCorrector(pathFiles: pathFile + "Files/").correct(featFor: <#T##String#>)
        break
        
        
//    case "-hn": // Option "-hn" for (h)as (n)umber at the beginning
//        let corretor = ID3Corrector()
//        output = corretor.titleStartsWithNumber(title: input)
//        break
        
        
    case "-oa": // Option "-oa" for (o)nly (a)rtist
        if input.contains(correctFeat) {
            let array = input.components(separatedBy: correctFeat)
            if array.count == 2 {
                output = array[0].trimmed.trimmedBrackets
            }
        }
        break
        
        
    case "-of": // Option "-of" for (o)nly (f)eature
        if input.contains(correctFeat) {
            let array = input.components(separatedBy: correctFeat)
            if array.count == 2 {
                output = array[1].trimmed.trimmedBrackets
            }
        } else {
            output = ""
        }
        break
        
    case "-r": // Option "-r" for (r)eplace
        
        let source = CommandLine.arguments[3]
        let replacement = CommandLine.arguments[4]
        
        output = input.replacingOccurrences(of: "\(source)", with: "\(replacement)")
        
        break
        
        
    default: // As default just return the input so nothing to do here ...
        break
    }
    
    // Return output by writing it to standardOutput
    FileHandle.standardOutput.write(output.trimmed.data(using: .utf8)!)
}
