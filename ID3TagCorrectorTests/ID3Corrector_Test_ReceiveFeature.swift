//
//  ID3Corrector_Test_ReceiveFeature.swift
//  tag-corrector tests
//
//  Created by Lukas on 17.04.21.
//  Copyright © 2021 Lukas Danckwerth. All rights reserved.
//

import XCTest

class ID3Corrector_Test_ReceiveFeature: ID3Corrector_Test {

    func test_receiveFeature() {
        getFeature("Kayslay Ft Graph Cassidy Lil F", "Graph Cassidy Lil F")
        getFeature("Missy Elliot Ft Jay-Z", "Jay-Z")
        getFeature("Beatnuts Ft. A.G.", "A.G.")
        getFeature("Tony Touch ft. Large Professor, Pete Rock, Masta Ace", "Large Professor, Pete Rock, Masta Ace")
    }
    
    func getFeature(_ name: String, _ expectation: String) {
        let removed = ID3Corrector.getFeature(name) ?? ""
        assert(name, removed, isEqual: expectation, after: "ReceiveFeature")
    }
}
