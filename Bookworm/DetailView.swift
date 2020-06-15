//
//  DetailView.swift
//  Bookworm
//
//  Created by Bill Moriarty on 5/19/20.
//  Copyright © 2020 Bill Moriarty. All rights reserved.
//
import CoreData
import SwiftUI

let dateFormatter = DateFormatter()


struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let displayedBook: Book

        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.displayedBook.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)

                    Text(self.displayedBook.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }//Z
                Text(self.displayedBook.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(self.displayedBook.review ?? "No review")
                    .padding()
                
                Text(dateFormatter.string(from: self.displayedBook.date ?? Date()))

                RatingView(rating: .constant(Int(self.displayedBook.rating)))
                    .font(.largeTitle)
            
                            
                Spacer()
            }
        } // GeometryReader
        .navigationBarTitle(Text(displayedBook.title ?? "Unknown Book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Definitely delete?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }//alert
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }//body
    
    func deleteBook() {
        moc.delete(displayedBook)
        
        //dismiss the currently presented view, since the user just deleetd this book
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        book.date = Date()
        
        return NavigationView {
            DetailView(displayedBook: book)
        }
    }
}
