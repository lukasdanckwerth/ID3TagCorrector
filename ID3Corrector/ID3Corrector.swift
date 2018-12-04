//
//  id3corrector.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 17/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//

import Foundation

func getCorrector(pathFiles: String) -> ID3Corrector {

	let corrector = ID3Corrector(wrongNotationFilesPath: URL(string: "")!)

	if let contentWrongFeats = getContent(path: pathFiles + "WrongFeat.txt") {
		if !contentWrongFeats.isEmpty {
			corrector.wrongFeats = contentWrongFeats.words
		}
	}

	if let contentWrongProdBys = getContent(path: pathFiles + "WrongProdBy.txt") {
		if !contentWrongProdBys.isEmpty {
			corrector.wrongProdBys = contentWrongProdBys.words
		}
	}

	if let contentWrongWords = getContent(path: pathFiles + "WrongWords.txt") {
		if !contentWrongWords.isEmpty {
			corrector.wrongWords = [(String, String)]()
			for line in contentWrongWords.lines {
				var lineArray = line.components(separatedBy: ";")
				if lineArray.count == 2 {
					corrector.wrongWords!.append((lineArray[0], lineArray[1]))
				} else if lineArray.count == 1 {
					corrector.wrongWords!.append((lineArray[0], ""))
				}
			}
		}
	}

	return corrector
}

/**
Provides functions to correct ID3 tags.

- Author: Lukas Danckwerth
- Version: 0.1
*/
public class ID3Corrector {

	// /////////////////////////////////////////////////////////////////
	// Constants for right notation
	// /////////////////////////////////////////////////////////////////

	/// Constant with the correct "feat"-notation
	let correctFeat = "(feat."

	/// Constant with the correct "prod. by"-notation
	let correctProdBy = "(Prod. by"



	// /////////////////////////////////////////////////////////////////
	// Arrays with wrong notations
	// /////////////////////////////////////////////////////////////////
	var wrongFeats = ["Featuring", "featuring", "Ft", "ft", "Ft.", "ft.", "Feat",
	                  "(Featuring", "(featuring", "(Ft", "(ft", "(Ft.", "(ft.",
	                  "(Feat", "Feat.", "feat", "feat.", "(with", "(With", "f/",
	                  "w/", "(Feat.", "(feat"]

	var wrongProdBys = ["Prod. by", "(prod. By", "Prod. By", "Prod by", "Prod By", "Prod by", "prod. by",
	                    "PROD BY", "PROD. BY", "(prod. by", "(prod by", "(Prod. By",
	                    "(PROD. BY", "(PROD BY", "(prod."]

	var wrongWords: [(String, String)]?


	// /////////////////////////////////////////////////////////////////
	// Variables for runtime
	// /////////////////////////////////////////////////////////////////
	var boolNeedsBracketForFeat = false

	var boolNeedsBracketForProdBy = false

    
    
    init(wrongNotationFilesPath url: URL) {
        
        func readContent(url: URL) -> String? {
            do {
                return try String(contentsOf: url)
            } catch {
                return nil
            }
        }
        
        if var content = readContent(url: url.appendingPathComponent("Replace.txt")) {
            
        }
        
    }
    
    
	/**
	Checks whether the given title starts with a number

	- parameters:
	-title: The title to check its prefix for numbers.
	- returns: "true" as a String if the given title starts with a number, "false" as String if not
	*/
	func titleStartsWithNumber(title: String) -> String {
		do {
			let expression = try NSRegularExpression(pattern: "[012345]{0,1}[0123456789]{1}.*",options: .caseInsensitive)
			let matches = expression.matches(in: title, options: .anchored, range: NSRange(location: 0, length: title.count))
			return matches.count > 0 ? "true" : "false"
		} catch _ {
			return "false"
		}
	}



	func getFeat(title: String) -> String {
		var tmpFeat = title.components(separatedBy: correctFeat)[1]
		if tmpFeat.contains(correctProdBy) {
			tmpFeat = tmpFeat.components(separatedBy: correctProdBy)[0]
		}
		return tmpFeat
			.replacingOccurrences(of: " and ", with: " & ")
			.replacingOccurrences(of: " And ", with: " & ")
			.replacingOccurrences(of: " AND ", with: " & ")
			.trimmed
	}



	func getProdBy(title: String) -> String {
		var tmpProdBy = title.components(separatedBy: correctProdBy)[1]
		if tmpProdBy.contains(correctFeat) {
			tmpProdBy = tmpProdBy.components(separatedBy: correctFeat)[0]
		}
		return tmpProdBy
			.replacingOccurrences(of: " and ", with: " & ")
			.replacingOccurrences(of: " And ", with: " & ")
			.replacingOccurrences(of: " AND ", with: " & ")
			.trimmed
	}



	func getName(title: String) -> String {
		var name = title
		if containsFeat(title: name) {
			name = name.components(separatedBy: correctFeat)[0]
		}

		if containsProdBy(title: name) {
			name = name.components(separatedBy: correctProdBy)[0]
		}

		if containsFeat(title: name) {
			name = name.components(separatedBy: correctProdBy)[0]
		}

		return name.trimmed
	}


	func correct(title: String) -> String {
		var tmpTitle = title

		tmpTitle = correctFeat(title: tmpTitle)
		tmpTitle = correctProdBy(title: tmpTitle)

		if containsProdBy(title: tmpTitle) && containsFeat(title: tmpTitle) {
			let feat = getFeat(title: tmpTitle)
			let prodBy = getProdBy(title: tmpTitle)
			let name = getName(title: tmpTitle)
			tmpTitle = "\(name) \(correctFeat) \(feat)\(boolNeedsBracketForFeat ? ")" : "") \(correctProdBy) \(prodBy)\(boolNeedsBracketForProdBy ? ")" : "")"
		} else if containsProdBy(title: tmpTitle) {
			let prodBy = getProdBy(title: tmpTitle)
			let name = getName(title: tmpTitle)
			tmpTitle = "\(name) \(correctProdBy) \(prodBy)\(boolNeedsBracketForProdBy ? ")" : "")"
		} else if containsFeat(title: tmpTitle) {
			let feat = getFeat(title: tmpTitle)
			let name = getName(title: tmpTitle)
			tmpTitle = "\(name) \(correctFeat) \(feat)\(boolNeedsBracketForFeat ? ")" : "")"
		}

		if wrongWords != nil {
			for tuple in wrongWords! {
				if tmpTitle.contains(" \(tuple.0)") {
					tmpTitle = tmpTitle.replacingOccurrences(of: " \(tuple.0)", with: " \(tuple.1)")
				}
			}
		}

		return tmpTitle
	}


	func correct(featInArtist artist: String) -> String {
		wrongFeats.append("&")

		var tmpArtist = artist

		tmpArtist = correctFeat(title: tmpArtist)

		return tmpArtist
	}


	/**
	Corrects wrong "feat."-occurences in the given title

	- parameters:
	title: A title with possible wrong "feat."-occurences
	- returns:
	The title with corrected "feat."-occurences
	*/
	private func correctFeat(title: String) -> String {
		boolNeedsBracketForFeat = false
		for wrongFeat in wrongFeats {
			if title.contains(" \(wrongFeat) ") {
				if !wrongFeat.hasPrefix("(") {
					boolNeedsBracketForFeat = true
				}
				return title.replacingOccurrences(of: " \(wrongFeat) ", with: " \(correctFeat) ")
			}
		}
		return title
	}


	private func correctProdBy(title: String) -> String {
		boolNeedsBracketForProdBy = false
		for wrongProdBy in wrongProdBys {
			if title.contains(" \(wrongProdBy) ") {
				if !wrongProdBy.hasPrefix("(") {
					boolNeedsBracketForProdBy = true
				}
				return title.replacingOccurrences(of: " \(wrongProdBy) ", with: " \(correctProdBy) ")
			}
		}
		return title
	}


	private func containsFeat(title: String) -> Bool {
		return title.contains(correctFeat)
	}

	private func containsProdBy(title: String) -> Bool {
		return title.contains(correctProdBy)
	}

	private func featBeforeProd(title: String) -> Bool {
		do {
			let expression = try NSRegularExpression(pattern: ".* \\(feat\\. .* \\(Prod\\. by .*",options: .caseInsensitive)
			let matches = expression.matches(in: title, options: .anchored, range: NSRange(location: 0, length: title.count))
			return matches.count > 0
		} catch _ {
			return false
		}
	}
}
