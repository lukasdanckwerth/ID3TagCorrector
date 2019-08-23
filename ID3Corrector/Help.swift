//
//  Help.swift
//  tag-corrector
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import Foundation


// MARK: - Help Text

/// The string containing a help text for this tool.
let help = """
usage: tag-corrector <command> [<args>]

COMMANDS:

\("   ")\("correctGenre".bold) <genre>     Corrects the passed genre
\("   ")\("correctName".bold) <name>       Corrects the passed name
\("   ")\("remove".bold) <file> <name>     Removes all words in the given file from the given name

\("   ")\("--help".bold)                   Print this help text and exit

"""


// MARK: - Exit Function

/// Prints the given message and exits with the given exit code.
func exit(_ message: String, exitCode: Int32 = EXIT_SUCCESS, withHelpMessage flag: Bool = false) -> Never {
    
    if flag {
        print(message, "\n\nPass '--help' for a list of available commands\n")
    } else {
        print(message)
    }
    
    exit(exitCode)
}
