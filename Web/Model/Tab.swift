//
//  Tab.swift
//  Web
//
//  Created by Saqib Omer on 29/01/2022.
//

import SwiftUI

struct Tab: Identifiable {
    var id = UUID().uuidString
    var tabURL: String
}
extension Tab: Equatable {
    static func == (lhs: Tab, rhs: Tab) -> Bool {
        return lhs.id == rhs.id
    }
}
