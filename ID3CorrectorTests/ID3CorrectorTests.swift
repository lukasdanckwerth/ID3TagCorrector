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
        
        
        textCorrection("Haiyti - Coco Chanel (prod. by Macloud & MIKSU)",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Haiyti - Coco Chanel prod. Macloud & MIKSU",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Haiyti - Coco Chanel prod. by Macloud & MIKSU",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Haiyti - Coco Chanel (prod. Macloud & MIKSU)",
                       "Haiyti - Coco Chanel (Prod. by Macloud & MIKSU)")
        
        textCorrection("Kodie Shane - Flex On Me ft. TK Kravitz",
                       "Kodie Shane - Flex On Me (feat. TK Kravitz)")
        
        textCorrection("Hanybal - CHECK (prod. von Jimmy Torrio)",
                       "Hanybal - CHECK (Prod. by Jimmy Torrio)")
        
        textCorrection("Club Soda feat. Action Bronson",
                       "Club Soda (feat. Action Bronson)")
        
        textCorrection("Good Grief (Ft. Diamante)",
                       "Good Grief (feat. Diamante)")
        
        textCorrection("Hold the Line (feat. Raquel Rodriguez) (Prod. Vicky Nguyen]",
                       "Hold the Line (feat. Raquel Rodriguez) (Prod. by Vicky Nguyen)")
        
        textCorrection("Lykke Li - deep end (alt version)",
                       "Lykke Li - deep end (Alternative Version)")
        
        textCorrection("KAY AY FT. IZZA - EINE WIE DU (Prod BY ISY BEATZ & C55)",
                       "KAY AY (feat. IZZA) - EINE WIE DU (Prod. by ISY BEATZ & C55)")
        
        textCorrection("Lil Lano - Fische (Prod. By HNDRX)",
                       "Lil Lano - Fische (Prod. by HNDRX)")
        
        textCorrection("Hanybal - CHECK (prod. von Jimmy Torrio)",
                       "Hanybal - CHECK (Prod. by Jimmy Torrio)")
        
        textCorrection("Nekfeu - Ma dope ft. SPri Noir",
                       "Nekfeu - Ma dope (feat. SPri Noir)")
        
//        textCorrection("ZUNA - CAZAL feat. MIAMI YACINE prod. by Lucry",
//                       "ZUNA - CAZAL (feat. MIAMI YACINE) (Prod. by Lucry)")
        
        
        // should stay the same
        textCorrection("BHZ - SO LEBEN KANN (Prod. by MotB)",
                       "BHZ - SO LEBEN KANN (Prod. by MotB)")
        
        
        // check replacement of 'Prod. by by'
        textCorrection("BHZ - SO LEBEN KANN (Prod. by by MotB)",
                       "BHZ - SO LEBEN KANN (Prod. by MotB)")
        
    }
    
    func textCorrection(_ name: String,_ expectation: String) {
        
        let corrected = ID3Corrector.correctName(name)
        
        XCTAssert(corrected == expectation, """
            \n\n
            Source     \(name)
            Corrected  \(corrected)
            Expected   \(expectation)
            \n
            """)
    }
}
