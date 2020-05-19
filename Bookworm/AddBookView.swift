//
//  AddBookView.swift
//  Bookworm
//
//  Created by Bill Moriarty on 4/24/20.
//  Copyright © 2020 Bill Moriarty. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    
    /*As this form is going to store all the data required to make up a book, we need @State properties for each of the book’s values except id, which we can generate dynamically */
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Poetry"
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }//section

                Section {
                    Button("Save") {
                        // add the book
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review

                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }//button
                    
                }//section
            }
            .navigationBarTitle("Add Book")
        }//NavigationView
    }//body
}//struct AddBookView

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
