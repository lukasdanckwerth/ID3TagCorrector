//
//  CorrectGenre.swift
//  Luigis-iTunes-Scripts-Tests
//
//  Created by Lukas Danckwerth on 07.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import Foundation

guard let genre = CommandLine.arguments.dropFirst().first else {
    exit(1)
}

print(genre, delimitor = "")
