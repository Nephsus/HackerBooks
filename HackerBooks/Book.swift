//
//  Book.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 24/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation


class Book {

   //MARK: - Properties
    let title : String
    let authors: [String]
    let tags : [String]
    let urlImage : String
    let urlPdf : String
    var favorite: String
    var isFavorite: String {
        get { return self.favorite }
        set(newValue){
              return self.favorite=newValue
        }
    
    }


    init(title: String, authors: [String], tags: [String], urlImage: String, urlPdf: String, isFavorite: String ) {
        
        self.title = title
        self.authors = authors
        self.tags =  tags
        self.urlImage = urlImage
        self.urlPdf = urlPdf 
        self.favorite = isFavorite
    
    }
    
    //MARK: - Proxies
    func proxyForEquality() -> String{
        return "\(title)"
    }

}


//MARK: - Protocols
extension Book : Hashable{
    public var hashValue: Int { get { return proxyForEquality().hashValue } }
    
    
    
}

extension Book : Comparable{
    public static func <(lhs: Book, rhs: Book) -> Bool{
        return lhs.proxyForEquality() < rhs.proxyForEquality()
    }
    public static func ==(lhs: Book, rhs: Book) -> Bool{
        return (lhs.proxyForEquality() == rhs.proxyForEquality())
    }
    
}

extension Book {

    func toDictionary () -> Dictionary<String,String> {
        let dictionary = [  "authors": self.authors.joined(separator: ", "),
                            "image_url": self.urlImage,
                            "pdf_url": self.urlPdf,
                            "tags": self.tags.joined(separator: ", "),
                            "title": self.title,
                            "isFavorite": self.isFavorite]
        
       return dictionary
        
        
        
    }
    
    
}





