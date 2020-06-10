//
//  Prospect.swift
//  HotProspects
//
//  Created by Francisco Misael Landero Ychante on 10/06/20.
//  Copyright © 2020 Francisco Misael Landero Ychante. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAdress = ""
    var isContacted = false
}
 
class Prospects : ObservableObject {
    @Published var people : [Prospect]
    
    init() {
        self.people = []
    }
    
}
