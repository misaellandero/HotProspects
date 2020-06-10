//
//  ContentView.swift
//  HotProspects
//
//  Created by Francisco Misael Landero Ychante on 04/06/20.
//  Copyright © 2020 Francisco Misael Landero Ychante. All rights reserved.
//

import SwiftUI
import SamplePackage
 
struct ContentView: View {
    var prospects = Prospects()
    
    var body: some View {
        TabView{
            ProspectView(filter: .none)
                .tabItem{
                    Image(systemName: "person.3")
                    Text("EveryOne")
            }
            ProspectView(filter: .uncontacted)
                .tabItem{
                    Image(systemName: "checkmark.circle")
                    Text("Contacted")
            }
            ProspectView(filter: .contacted)
                .tabItem{
                    Image(systemName: "questionmark.diamond")
                    Text("Uncontacted")
            }
            MeView()
                .tabItem{
                    Image(systemName: "person.crop.square")
                    Text("Me")
            }
        }
        .environmentObject(prospects)
    }
     
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
