//
//  ID3Corrector_Test_CorrectGenre.swift
//  tag-corrector tests
//
//  Created by Lukas on 17.04.21.
//  Copyright © 2021 Lukas Danckwerth. All rights reserved.
//

import XCTest

class ID3Corrector_Test_CorrectGenre: ID3Corrector_Test {

    func testGenreCorrection() {
        
        let wrongHipHopList = [ "hip hop", "hip-hop", "Hip-Hop", "Rap", "Rap / Hip Hop" ]
        
        for wrongHipHop in wrongHipHopList {
            let corrected = ID3Corrector.correctGenre(wrongHipHop)
            XCTAssert(corrected == "Hip Hop", "Expected '\(wrongHipHop)' to be corrected as 'Hip Hop'.")
        }
    }
    
    func test_genreCorrection_HipHop() {
        XCTAssertEqual(ID3Corrector.correctGenre("hip hop"), "Hip Hop")
    }
}
