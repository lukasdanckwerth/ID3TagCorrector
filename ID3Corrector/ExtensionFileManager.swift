//
//  ExtensionFileManager.swift
//  tag-corrector
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import Foundation

extension FileManager {
    
    
    // MARK: - URLs
    
    /// Reference to the `URL` of the main directory.
    static let mainDirectoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".tag-corrector", isDirectory: true)
    
    /// Reference to the file containing genre corrections.
    static var incorrectGenresFileURL = fileURL(for: "incorrect-genres")
    
    /// Reference to the file containing incorrect `"feat."` notations.
    static var incorrectFeaturesFileURL = fileURL(for: "incorrect-features")
    
    /// Reference to the file containing incorrect `"Prod. by"` notations.
    static var incorrectProducedByFileURL = fileURL(for: "incorrect-produced-by")
    
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
