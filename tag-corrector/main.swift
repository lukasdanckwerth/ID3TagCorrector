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
func nextArgument(or message: String) -> String {
    
    guard let argumemt = arguments.popFirst() else {
        exit(message, withHelpMessage: true)
    }
    
    return argumemt
}


// MARK: - Preconditions

// receive command
let command = nextArgument(or: "No arguments given")

// create main directory if it doesn't exist
FileManager.default.createDirectoryIfNotExisting(Constants.mainDirectoryURL)


var output: String?

// MARK: - Switch Command

switch command {
case "--correctGenre":
    
    let genre = nextArgument(or: "No genre specified")
    output = ID3Corrector.correctGenre(genre)
    
case "--correctName":
    
    let name = nextArgument(or: "No name specified")
    output = ID3Corrector.correctGenre(name)
    
case "--help", "-h":
    
    exit(help)
    
default:
    
    exit("Unknown argument '\(command)'", withHelpMessage: true)
}

print(output ?? "", terminator: "")
