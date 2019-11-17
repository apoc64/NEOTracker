//
//  ContentView.swift
//  NEOTracker
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var model: [NEO] = []
    
    var body: some View {
        VStack{
            Text("NEOs").font(.largeTitle)
            List(model) { item in
                NEORow(model: item)
            }
        }.onAppear(perform: fetchNeos)
    }
    
    func fetchNeos() {
        NEO.requestNeos(completion: { (neos, error) in
            log("\(neos?.count ?? 0) NEOS")
            guard let neos = neos else { return }
            self.model = neos
        })
    }
}

struct NEORow: View {
    var model: NEO
    var imageName: String { return model.isDangerous ? "tornado" : "guitars" }
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
            Text(model.name).font(.title)
            Spacer()
            Text(model.designation).font(.subheadline).foregroundColor(.blue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
