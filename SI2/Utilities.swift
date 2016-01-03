//
//  Utilities.swift
//  SI2
//
//  Created by George Dodwell on 1/2/16.
//  Copyright © 2016 George Dodwell. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}