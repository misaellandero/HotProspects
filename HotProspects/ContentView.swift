//
//  ContentView.swift
//  HotProspects
//
//  Created by Francisco Misael Landero Ychante on 04/06/20.
//  Copyright © 2020 Francisco Misael Landero Ychante. All rights reserved.
//

import SwiftUI

class User: ObservableObject {
    @Published var name = "Taylor Swift"
}



struct EditView : View {
    @EnvironmentObject var user: User
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
    
}

struct DisplayView : View {
    @EnvironmentObject var user: User
    
    var body: some View {
        Text(user.name)
    }
}

enum NetworkError: Error {
    case badURL, requestFailed, unknow
}

class DelayUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    init(){
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)){
                self.value += 1
            }
        }
    }
}
struct ContentView: View {
    @ObservedObject var updater = DelayUpdater()
    let user = User()
    @State private var selectedTab = 0
    var body: some View {
        
        TabView(selection: $selectedTab){
            VStack {
                Image("Image")
                    .interpolation(.none)
                .resizable()
                .scaledToFit()
                    .frame(maxHeight: .infinity )
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                
                /*EditView()
                DisplayView()
                Text(" \(self.updater.value)")*/
                
            }.onTapGesture {
                self.selectedTab = 1
            }
            .tabItem{
                Image(systemName: "star")
                Text("One")
            }
            .tag(0)
            
            Text("tab 2")
            .tabItem{
                Image(systemName: "star.fill")
                Text("Two")
            }
            .tag(1)
        }
        .environmentObject(user)
        .onAppear{
            self.fetchData(from: "https://www.appllole.com"){
              result in
                switch result {
                case .success(let str):
                    print(str)
                case .failure(let error):
                    switch error {
                    case .badURL:
                        print("Bad URL")
                    case .requestFailed:
                        print("Network problems")
                    case .unknow:
                    print("Unknow error")
                    }
                }
                
            }
        }
            
        
        
    }
    
    func fetchData(from urlString: String, completion: @escaping ((Result<String, NetworkError>) -> Void)) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url){
            data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let StringData = String(decoding: data, as: UTF8.self)
                    completion(.success(StringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknow))
                }
            }
        }.resume()
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
