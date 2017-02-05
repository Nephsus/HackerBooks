//
//  JsonParserService.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 28/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation

//MARK: - Aliases
typealias JSONObject = AnyObject
typealias JSONDictionary =  [String : String]
typealias JSONArray = [ JSONDictionary ]





func decodeInitializer(withDataJson data: Data ) -> Data{

    var jsonArray: Array<Dictionary<String,String>> = Array<Dictionary<String,String>> ()

    let jsonSerializado = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    
    if let jsonArrayDictionary = jsonSerializado as? Array<AnyObject>{
        
        for item in jsonArrayDictionary {
            if var bookLibrary = item as? [ String : String ]{
                bookLibrary["isFavorite"] = "false"
                jsonArray.append(bookLibrary)
            }
            
            
        }
    }
    let data = try? JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
   // let string = String(data: data!, encoding: .utf8)
   // print(string)
   
    return data!
}



func decode( withDataJson data: Data ) ->Library {

 
    let library : Library = Library()

   let jsonSerializado = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)

    if let jsonArrayDictionary = jsonSerializado as? Array<AnyObject>{
    
        for item in jsonArrayDictionary {
            if let bookLibrary = item as? [ String : String ]{
                library.addBook(book: decode(withDictionary: bookLibrary) )
            }
            
            
        }
    }
   
    return library
}


func decode( withDictionary dictionary: Dictionary<String,String> ) -> Book{

    let authors = dictionary["authors"]
    
    let arrayAuthors = authors?.components(separatedBy: ",")
    // hemos comprobado todo lo más peligroso
    
    let image_url = dictionary["image_url"]
    let pdf_url = dictionary["pdf_url"]
    
    let tags = dictionary["tags"]?.components(separatedBy: ",")
    let title = dictionary["title"]
    
    let favorite = dictionary["isFavorite"] ?? "false"
    
    
    
    
    return Book(title: title!, authors: arrayAuthors!, tags: tags!, urlImage: image_url!, urlPdf: pdf_url!, isFavorite: favorite)


}

