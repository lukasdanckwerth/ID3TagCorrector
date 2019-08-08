//
//  ID3CorrectorTests.swift
//  ID3CorrectorTests
//
//  Created by Lukas Danckwerth on 08.08.19.
//  Copyright © 2019 Lukas Danckwerth. All rights reserved.
//

import XCTest

class ID3CorrectorTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGenreCorrection() {
        
        let wrongHipHopList = [ "hip hop", "hip-hop", "Hip-Hop", "Rap", "Rap / Hip Hop" ]
        
        for wrongHipHop in wrongHipHopList {
            let corrected = ID3Corrector.correctGenre(wrongHipHop)
            XCTAssert(corrected == "Hip Hop", "Expected '\(wrongHipHop)' to be corrected as 'Hip Hop'.")
        }
    }
    
    func testNameCorrection() {
        
        let names = [
            "Haiyti - Coco Chanel (prod. by Macloud & MIKSU)" : "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)",
            "Haiyti - Coco Chanel prod. Macloud & MIKSU" : "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)",
            "Haiyti - Coco Chanel prod. by Macloud & MIKSU" : "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)",
            "Haiyti - Coco Chanel (prod. Macloud & MIKSU)" : "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)",
            "Kodie Shane - Flex On Me ft. TK Kravitz" : "Kodie Shane - Flex On Me (feat. TK Kravitz)",
            "Hanybal - CHECK (prod. von Jimmy Torrio)" : "Hanybal - CHECK (Prod. by Jimmy Torrio)",
            "Club Soda feat. Action Bronson" : "Club Soda (feat. Action Bronson)",
            "Good Grief (Ft. Diamante)" : "Good Grief (feat. Diamante)",
            "Hold the Line (feat. Raquel Rodriguez) (Prod. Vicky Nguyen]" : "Hold the Line (feat. Raquel Rodriguez) (Prod. by Vicky Nguyen)"
        ]
        
        for entry in names {
            
            let name = entry.key
            let corrected = ID3Corrector.correctName(name)
            XCTAssert(corrected == entry.value, """
                \n\n
                Corrected  \(corrected)
                Expected   \(entry.value)
                Source     \(entry.key)
                \n
                """)
            if corrected == entry.value {
                print("""
                    \n\n
                    BAAAAMMM!
                    Corrected  \(corrected)
                    Source     \(entry.key)
                    \n
                    """)
            }
        }
    }
}
