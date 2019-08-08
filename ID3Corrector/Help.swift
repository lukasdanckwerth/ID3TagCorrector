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

\("   ")\("--correctGenre".bold) <GENRE>  Corrects the passed genre
\("   ")\("--correctName".bold) <NAME>    Corrects the passed name

\("   ")\("--help".bold)                  Print this help text and exit

"""

/// Prints the given message and exits with the given exit code.
func exit(_ message: String, exitCode: Int32 = EXIT_SUCCESS, withHelpMessage flag: Bool = false) -> Never {
    
    if flag {
        print(message, "\n\nPass '--help' for a list of available commands")
    } else {
        print(message)
    }
    
    exit(exitCode)
}
