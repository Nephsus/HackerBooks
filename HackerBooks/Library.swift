//
//  Library.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 24/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation



typealias Books = MultiDictionary<Tag,Book>


class Library {
 
    //MARK: - Properties
    public var books: Books = Books ()
    
    var tags = Set<Tag>()
    
    public static let SECCIONFAVORITE = "MIS FAVORITOS"
    private var internalFlagFavorites = false
    
   
    var booksCount: Int {
        get{
            let count: Int = self.books.count
            return count
        }
    }
    
    func addBook (book: Book){
        
        for tag in book.tags {
            let myTag = Tag( name: tag )
            tags.insert( myTag )
            self.books.insert( value: book, forKey: myTag )
        }
        //Además la añado a la sección favorito
        
        if book.isFavorite == "true"{
            addSeccionFavorite( book: book )
        }
        
    }
    
    private func addSeccionFavorite( book: Book){
        tags.insert( Tag(name: Library.SECCIONFAVORITE , priority: .FirsOrder ) )
        self.books.insert( value: book, forKey: Tag(name: Library.SECCIONFAVORITE ))
    
    }
 
    
    func getNumberBooksSection(byIndexSection section: Int) -> Int{
        
        let myArray = Array(tags).sorted()
        let t: Tag = myArray[ section ]
        //Si existe algún favorito añado esta sección, sino puesssss no

        return (books[ t ]?.count)!
        
    }
    
    func getNameSection(byIndexSection section: Int) -> String{
    
        let myArray = Array(tags).sorted()
        return myArray[ section ].name

    }
    
    func getNumberBook(byIndexSection section: Int ,
                       andRowIndex row: Int) -> Book{
        
        let myArray = Array(tags).sorted()
        let t: Tag = myArray[section]
        
        let setOfBooks = books[ t ]
        
        let arrayBooks = Array(setOfBooks!).sorted()
        
        return (arrayBooks[row])
        
    }
    
    func syncBookFavorite(book: Book){
    
        if book.isFavorite == "true"{
            addSeccionFavorite( book: book )
        }else{
            
             self.books.removeBook(value: book, forKey: Tag(name: Library.SECCIONFAVORITE ))

            guard self.books[ Tag(name: Library.SECCIONFAVORITE ) ] != nil  else {
                tags.remove( Tag(name: Library.SECCIONFAVORITE) )
                return
            }
            
            
        }
    
    }
    
    
    func persistanceToDisk() {
    
        let allBooks = self.books.getAllBooks()
        var arrayBookSerialization: Array<Dictionary<String,String>>= Array<Dictionary<String,String>>()
        
        for bookSerialization in allBooks {
            arrayBookSerialization.append(bookSerialization.toDictionary())
        }
        
        
        //PROCESO DE DESCARGA DEL FICHERO
        let fileManager = FileManager.default
        var ulrToDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        ulrToDocuments.appendPathComponent( UtilsStatics.FILENAMERESOURCELIBRARY )
        
        

        let data = try? JSONSerialization.data(withJSONObject: arrayBookSerialization, options: .prettyPrinted)
        
        try! data?.write(to: ulrToDocuments, options: .atomic)

    }
    
    
    
    
}


