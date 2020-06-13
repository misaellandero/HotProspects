//
//  ProspectView.swift
//  HotProspects
//
//  Created by Francisco Misael Landero Ychante on 09/06/20.
//  Copyright © 2020 Francisco Misael Landero Ychante. All rights reserved.
//
import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects : Prospects
    @State private var showScaner = false
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
                        HStack {
                            Text(prospect.name)
                                .font(.headline)
                            if self.filter == .none {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        Text(prospect.emailAdress)
                            .foregroundColor(.secondary)
                        
                    }
                    .contextMenu{
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted"){
                            self.prospects.toogle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Reminde me later"){
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
                
                
            .navigationBarTitle(title)
            .navigationBarItems(trailing: Button( action: {
                    self.showScaner = true
                }){
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                    
                })
            
                .sheet(isPresented: $showScaner){
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Misael Landero\nhola@landercorp.mx", completion: self.handleScan)
            }
            
        }
        
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>){
        self.showScaner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else {
                return
            }
            let person = Prospect()
            person.name = details[0]
            person.emailAdress = details[1]
            self.prospects.add(person)
        case .failure(let error):
            print("Scaning Failed")
        }
    }
    
    func addNotification(for prospect: Prospect){
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAdress
            
            content.sound = UNNotificationSound.default
            
            /*var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)*/
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
            
        }
        
        center.getNotificationSettings {
            settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
                
            } else {
                center.requestAuthorization(options:  [.alert, .badge, .sound]) {
                    succes, error in
                    if succes {
                        addRequest()
                    } else {
                        print("Doh")
                    }
                }
            }
        }
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(filter: .none)
    }
}
