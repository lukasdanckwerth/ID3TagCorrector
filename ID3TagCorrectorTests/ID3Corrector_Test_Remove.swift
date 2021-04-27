//
//  ID3Corrector_Test_Remove.swift
//  tag-corrector tests
//
//  Created by Lukas on 17.04.21.
//  Copyright © 2021 Lukas Danckwerth. All rights reserved.
//

import XCTest

class ID3Corrector_Test_Remove: ID3Corrector_Test {

    // ===-----------------------------------------------------------------------------------------------------------===
    //
    // MARK: - Remove
    // ===-----------------------------------------------------------------------------------------------------------===
    
    func testRemovements() {
        remove("Ferge X Fisherman – Backstage // JUICE PREMIERE",
               "Ferge X Fisherman – Backstage")
        remove("The Buttertones - \"Denial You Win Again\" (Official Video)",
               "The Buttertones - \"Denial You Win Again\"")
        remove("HAFTBEFEHL - 1999 Part.5 (prod. von Bazzazian) [Official Audio]",
               "HAFTBEFEHL - 1999 Part.5 (prod. von Bazzazian)")
        remove("Gabber Eleganza & HDMIRROR – Frozen Dopamina (Official Video) [LFEK008]",
               "Gabber Eleganza & HDMIRROR – Frozen Dopamina [LFEK008]")
        remove("Moses Sumney - Cut Me | A COLORS SHOW",
               "Moses Sumney - Cut Me")
    }
    
    func remove(_ name: String, _ expectation: String) {
        let removed = ID3Corrector.remove(wordsAt: removementsFileURL, in: name)
        assert(name, removed, isEqual: expectation, after: "Remove")
    }
}
