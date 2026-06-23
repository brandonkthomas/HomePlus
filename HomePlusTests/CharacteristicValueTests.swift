//
//  CharacteristicValueTests.swift
//  CharacteristicValueTests
//
//  Created by Brandon Thomas on 6/13/26.
//
// https://developer.apple.com/documentation/testing
//

import Foundation
import Testing
@testable import HomePlus

struct CharacteristicValueTests {
    
    /// Validates that CharacteristicValue Double parsing returns expected results
    @Test func characteristicValueDoubleParserPasses() {
        let parseResult1: Double? = CharacteristicValue.double(12)
        let parseResult2: Double? = CharacteristicValue.double(true)
        let parseResult3: Double? = CharacteristicValue.double("bad")
        
        #expect(parseResult1 == 12.0)
        #expect(parseResult2 == 1)
        #expect(parseResult3 == nil)
    }
    
    /// Validates that CharacteristicValue Int parsing returns expected results
    @Test func characteristicValueIntParserPasses() {
        let parseResult1: Int? = CharacteristicValue.int(12.8)
        let parseResult2: Int? = CharacteristicValue.int(false)
        let parseResult3: Int? = CharacteristicValue.int(nil)
        
        #expect(parseResult1 == 12)
        #expect(parseResult2 == 0)
        #expect(parseResult3 == nil)
    }
    
    /// Validates that CharacteristicValue Bool parsing returns expected results
    @Test func characteristicValueBoolParserPasses() {
        let parseResult1: Bool? = CharacteristicValue.bool(true)
        let parseResult2: Bool? = CharacteristicValue.bool(0)
        let parseResult3: Bool? = CharacteristicValue.bool(2)
        let parseResult4: Bool? = CharacteristicValue.bool("bad")
        
        #expect(parseResult1 == true)
        #expect(parseResult2 == false)
        #expect(parseResult3 == true)
        #expect(parseResult4 == nil)
    }
}
