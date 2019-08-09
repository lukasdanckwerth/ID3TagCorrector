//
//  main.swift
//  tag-corrector
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import Foundation


// MARK: - Receive arguments

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


// MARK: - Preconditions

// receive command
let command = nextArgument(onError: "No arguments given")

// create main directory if it doesn't exist
FileManager.default.createDirectoryIfNotExisting(FileManager.mainDirectoryURL)


var output: String?


// MARK: - Switch Command

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
    
    output = ID3Corrector.remove(wordsAt: filePath, in: name).trimmed
    
case "--help", "-h":
    
    exit(help)
    
default:
    
    exit("Unknown argument '\(command)'", withHelpMessage: true)
    
}

print(output ?? "", terminator: "")
