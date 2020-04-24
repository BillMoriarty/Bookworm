//
//  ContentView.swift
//  Bookworm
//
//  Created by Bill Moriarty on 4/24/20.
//  Copyright © 2020 Bill Moriarty. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //a way to add books
    @Environment(\.managedObjectContext) var moc
    //read all the books we have
    @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
         NavigationView {
            Text("Count: \(books.count)")
                .navigationBarTitle("Bookworm")
                .navigationBarItems(trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })//button
                .sheet(isPresented: $showingAddScreen) {
                                //...environment() takes two parameters: a key to write to, and the value you want to send in.
                    AddBookView().environment(\.managedObjectContext, self.moc)
                }
        }// NavigationView
    }//body

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
