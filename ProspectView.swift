//
//  ProspectView.swift
//  HotProspects
//
//  Created by Francisco Misael Landero Ychante on 09/06/20.
//  Copyright © 2020 Francisco Misael Landero Ychante. All rights reserved.
//

import SwiftUI

struct ProspectView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects : Prospects
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "EveryOne"
        case .contacted:
            return "Contacted people"
        case .uncontacted :
            return "Uncontacted peope"
        }
    }
    
    var filterProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter {$0.isContacted}
        case .uncontacted:
            return prospects.people.filter {!$0.isContacted}
       
        }
    }
    
    
    var body: some View {
        NavigationView{
            List{
                ForEach(filterProspects) { prospect in
                    VStack(alignment: .leading){
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAdress)
                            .foregroundColor(.secondary)
                    }
                }
            }
                
                
            .navigationBarTitle(title)
                .navigationBarItems(trailing: Button( action: {
                    let prospect = Prospect()
                    prospect.name = "Paul Hudson"
                    prospect.emailAdress = "paul@hackingwithswift.com"
                    self.prospects.people.append(prospect)
                }){
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                    
                })
        }
        
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(filter: .none)
    }
}
