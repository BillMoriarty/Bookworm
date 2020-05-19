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
    //I think of this like SQL query
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
         NavigationView {
            List {
                ForEach(books, id: \.self) { currentBook in
                    NavigationLink(destination: DetailView(displayedBook: currentBook)) {
                        EmojiRatingView(rating: currentBook.rating)
                            .font(.largeTitle)

                        VStack(alignment: .leading) {
                            Text(currentBook.title ?? "Unknown Title")
                                .font(.headline)
                                .foregroundColor(currentBook.rating == 1 ? .red : .primary)
                            Text(currentBook.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }//for each
                .onDelete(perform: deleteBooks)
            }//list
                .navigationBarTitle("Bookworm")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
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
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        //I am unclear what purpose the below line serves
        try? moc.save()
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

