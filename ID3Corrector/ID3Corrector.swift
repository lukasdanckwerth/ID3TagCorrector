//
//  main.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 16/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//
import Foundation


// MARK: - Constants

struct Constants {
    
    
    /// Reference to the `URL` of the main directory.
    static let mainDirectoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".tag-corrector", isDirectory: true)
    
    /// Reference to the file containing genre corrections.
    static var genresFile = mainDirectoryURL.appendingPathComponent("genres")
    
    /// Reference to the file containing incorrect `"feat."` notations.
    static var featFile = mainDirectoryURL.appendingPathComponent("feat")
    
    /// Reference to the file containing incorrect `"Prod. by"` notations.
    static var prodByFile = mainDirectoryURL.appendingPathComponent("prod-by")
    
    /// Reference to the file containing replacements of words.
    static var replacementsFile = mainDirectoryURL.appendingPathComponent("replacements")
    
}


class ID3Corrector {
    
    
    // MARK: - Statics
    
    /// Constant with the correct `"feat."` - notation.
    static let feat = "feat."
    
    /// Constant with the correct `"Prod. by"` - notation
    static let prodBy = "Prod. by"
    
    
    // MARK: - Properties
    
    /// The map of incorrect genres with their correction.
    static var genres = keyValuePairs(at: Constants.genresFile)
    
    /// A map containing key value pairs with words to replace.
    static var replacements = keyValuePairs(at: Constants.replacementsFile)
    
    /// A collection of wrong `feat.` notations.
    static var feats = lines(at: Constants.featFile) + [feat]
    
    /// A collection of wrong `"Prod. by"` notations.
    static var producedBy = lines(at: Constants.prodByFile) + [prodBy]
    
    
    // MARK: - Correction Functionality
    
    /// Returns the corrected version of the given genre.  Iterates the `genre` map and returns the first entry where the given genre matches the key.
    static func correctGenre(_ genre: String) -> String {
        return genres.first(where: { genre == $0.key })?.value ?? genre
    }
    
    /// Returns the corrected version of the given name.
    static func correctName(_ name: String) -> String {
        
        let comps = name.components(separatedBy: " - ")
        
        guard comps.count == 1 else {
            return comps.compactMap(correctName).joined(separator: " - ")
        }
        
        var name = name.onlyParenthesis
        name = replaceFeat(name: &name)
        name = replaceProducedBy(name: &name)
        
        return name
    }
    
    
    // MARK: - Replace
    
    private static func replaceFeat(name: inout String) -> String {
        
        return name.replacing(words: feats.compactMap({ "(\($0)" }), with: "(\(feat)")
            ?? name.replacing(words: feats, with: "(\(feat)")?.appending(")")
            ?? name
    }
    
    private static func replaceProducedBy(name: inout String) -> String {
        return name.replacing(words: producedBy.compactMap({ "(\($0)" }), with: "(\(prodBy)")
            ?? name.replacing(words: producedBy, with: "(\(prodBy)")?.appending(")")
            ?? name
    }
    
    
    // MARK: - Ready Files
    
    /// Returns the content of the file at the given `URL`.
    static func content(at url: URL) -> String? {
        return try? String(contentsOf: url)
    }
    
    /// Returns the lines of the file at the given `URL`.
    static func lines(at url: URL) -> [String] {
        return content(at: url)?.trimmed.lines.filter({ !$0.isEmpty && !$0.hasPrefix("#") }) ?? []
    }
    
    /// Read key value file.
    static func keyValuePairs(at url: URL) -> [String : String] {
        
        var dictionary = [String : String]()
        
        for line in lines(at: url) {
            
            var pair = line.components(separatedBy: "=").map({ $0.trimmed })
            
            if pair.count == 2 {
                dictionary[pair[0]] = pair[1]
            } else if pair.count == 1 {
                dictionary[pair[0]] = ""
            }
        }
        
        return dictionary
    }
}
