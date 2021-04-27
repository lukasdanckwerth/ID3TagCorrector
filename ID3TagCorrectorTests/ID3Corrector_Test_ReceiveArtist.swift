//
//  ID3Corrector_Test_ReceiveArtist.swift
//  tag-corrector tests
//
//  Created by Lukas on 18.04.21.
//  Copyright © 2021 Lukas Danckwerth. All rights reserved.
//

import XCTest

class ID3Corrector_Test_ReceiveArtist: ID3Corrector_Test {

    func test_receiveFeature() {
        getArtist("Kayslay Ft Graph Cassidy Lil F", "Kayslay")
        getArtist("Missy Elliot Ft Jay-Z", "Missy Elliot")
        getArtist("Beatnuts Ft. A.G.", "Beatnuts")
        getArtist("Tony Touch ft. Large Professor, Pete Rock, Masta Ace", "Tony Touch")
    }
    
    func getArtist(_ name: String, _ expectation: String) {
        let removed = ID3Corrector.getArtist(name)
        assert(name, removed, isEqual: expectation, after: "ReceiveArtist")
    }
}
