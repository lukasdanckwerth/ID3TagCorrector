//
//  ExtensionFileManager.swift
//  tag-corrector
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import Foundation

extension FileManager {
    
    
    /// Creates the directory at the given `URL` if it doesn't already exist.
    func createDirectoryIfNotExisting(_ directoryURL: URL) {
        if !fileExists(atPath: directoryURL.path) {
            try? createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
