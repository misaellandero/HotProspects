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
    fileprivate(set) var isContacted = false
}
 
class Prospects : ObservableObject {
    @Published private(set) var people : [Prospect]
    static let saveKey = "SavedData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data){
                self.people = decoded
                return
            }
        }
        
        self.people = []
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(people){
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func toogle(_ prospect : Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add (_ prospect: Prospect){
        people.append(prospect)
        save()
    }
    
}
