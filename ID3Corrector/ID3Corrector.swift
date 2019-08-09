//
//  main.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 16/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//
import Foundation


// MARK: - ID3Corrector

struct ID3Corrector {
    
    
    // MARK: - Statics
    
    /// Constant with the correct `"feat."` - notation.
    static let feat = "feat."
    
    /// Constant with the correct `"Prod. by"` - notation
    static let prodBy = "Prod. by"
    
    
    // MARK: - Properties
    
    /// A dictionary of incorrect genres with their correction.
    static var genres = keyValuePairs(at: FileManager.genresFile)
    
    /// A map containing key value pairs with words to replace.
    static var replacements = keyValuePairs(at: FileManager.replacementsFile)
    
    /// A collection of incorrect `feat.` notations.
    static var feats = lines(at: FileManager.featFile) + [feat]
    
    /// A collection of incorrect `"Prod. by"` notations.
    static var producedBy = lines(at: FileManager.prodByFile) + [prodBy]
    
    
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
        
        var name = name.reaplacingBrackets
        name = replaceFeat(name: &name)
        name = replaceProducedBy(name: &name)
        name = name.replacing(replacements)
        
        return name
    }
    
    /// Removes all occurences of the words from the file at the given `URL` in the given name.
    static func remove(wordsAt wordlistPath: String, in name: String) -> String {
        let url = URL(fileURLWithPath: wordlistPath)
        return lines(at: url).reduce(name, { name, word in
            name.replacingOccurrences(of: word, with: "")
        }).trimmed
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
        return content(at: url)?.lines.cleaned ?? []
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
