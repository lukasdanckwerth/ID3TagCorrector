//
//  textfile.swift
//  ID3Corrector
//
//  Created by Lukas Danckwerth on 17/10/2016.
//  Copyright © 2016 Lukas Danckwerth. All rights reserved.
//

import Foundation

/**
Returns the content of the file at the given path or nil.
- Author: Lukas Danckwerth
- Version: 0.1
*/
func getContent(path: String) -> String? {
	do {
		var content = try String(contentsOfFile: path)
		return content.removeLines(startingWith: "#")
	} catch {
		return nil
	}
}

/**

- Author: Lukas Danckwerth
- Version: 0.1
*/
func getTuples(path: String, seperator: String) -> [(String, String)] {
	var tuples = [(String, String)]()

	if let wrongGenres = getContent(path: path) {
		for line in wrongGenres.lines {
			if !line.hasPrefix("#") {
				var lineArray = line.components(separatedBy: seperator)
				if lineArray.count == 2 {
					tuples.append((lineArray[0], lineArray[1]))
				} else if lineArray.count == 1 {
					tuples.append((lineArray[0], ""))
				}
			}
		}
	}

	return tuples
}


