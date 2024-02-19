//
//  Prospect.swift
//  HotProspects
//
//  Created by Игорь Верхов on 26.10.2023.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAdress: String
    var isContacted: Bool
    var dateAdded = Date.now
    
    init(name: String, emailAdress: String, isContacted: Bool) {
        self.name = name
        self.emailAdress = emailAdress
        self.isContacted = isContacted
    }
    static var example = Prospect(name: "Anonymus", emailAdress: "you@yoursite.com", isContacted: false)
}
