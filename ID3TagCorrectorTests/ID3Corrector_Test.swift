//
//  ID3Corrector_Test.swift
//  tag-corrector tests
//
//  Created by Lukas on 17.04.21.
//  Copyright © 2021 Lukas Danckwerth. All rights reserved.
//

import XCTest

class ID3Corrector_Test: XCTestCase {

    lazy var bundle = Bundle(for: ID3Corrector_Test.self)
    
    lazy var removementsFileURL = bundle.url(forResource: "removements", withExtension: "txt")!
    
    lazy var replacementsFileURL = bundle.url(forResource: "replacements", withExtension: "txt")!
    
    lazy var incorrectGenresFileURL = bundle.url(forResource: "incorrect-genres", withExtension: "txt")!
    
    lazy var incorrectFeaturesFileURL = bundle.url(forResource: "incorrect-features", withExtension: "txt")!
    
    lazy var incorrectProducedByFileURL = bundle.url(forResource: "incorrect-produced-by", withExtension: "txt")!
    
    override func setUp() {
        ID3Corrector.replacements = ID3Corrector.dictionary(at: replacementsFileURL)
        ID3Corrector.genres = ID3Corrector.dictionary(at: incorrectGenresFileURL)
        ID3Corrector.feats = ID3Corrector.lines(at: incorrectFeaturesFileURL)
        ID3Corrector.producedBy = ID3Corrector.lines(at: incorrectProducedByFileURL)
        FileManager.removementsFile = removementsFileURL
    }
    
    // ===-----------------------------------------------------------------------------------------------------------===
    //
    // MARK: - Auxiliary
    // ===-----------------------------------------------------------------------------------------------------------===
    
    func assert(_ name: String, _ corrected: String, isEqual expectation: String, after operation: String) {
        XCTAssert(corrected == expectation, """
            \n\n
            Error during \(operation)
            
            Source     \(name)
            Result     \(corrected)
            Expected   \(expectation)
            \n
            """)
    }
}
