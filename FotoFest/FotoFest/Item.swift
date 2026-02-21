//
//  Item.swift
//  FotoFest
//
//  Created by Andreas Pelczer on 21.02.26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
