//
//  MultiDictionary.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 31/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

public
struct MultiDictionary<Key: Hashable, Value: Hashable>{
    
    //MARK: - Types
    public
    typealias Bucket = Set<Value>
    
    //MARK: - Properties
    private
    var _dict : [Key : Bucket]
    
    //MARK: - Lifecycle
    public
    init(){
        _dict = Dictionary()
    }
    
    //MARK: - Accessors
    public
    var isEmpty: Bool{
        return _dict.isEmpty
    }
    
    public
    var countBuckets : Int{
        return _dict.count
    }
    
    public
    var count : Int{
        var total = 0
        for bucket in _dict.values{
            total += bucket.count
        }
        return total
    }
    
    public
    var countUnique : Int{
        var total = Bucket()
        
        for bucket in _dict.values{
            total = total.union(bucket)
        }
        return total.count
    }
    
    //MARK: - Setters (Mutators)
    public
    subscript(key: Key) -> Bucket?{
        get{
            return _dict[key]
        }
        
        set(maybeNewBucket){
            guard let newBucket = maybeNewBucket else{
                // añadir nada es no añadir
                return
            }
            
            guard let previous = _dict[key] else{
                // Si no había nada bajo dicha clave
                // la añadimos con un bucket vacio
                _dict[key] = Bucket()
                return
            }
            
            // Creamos una unión de lo viejo y lo nuevo
            _dict[key] = previous.union(newBucket)
        }
    }
    
    // Toda función que cambie el estado (self) de la
    // estructura, tiene que venir precedida por
    // la palabreja mutating
    public
    mutating func insert(value: Value, forKey key: Key){
        
        if var previous = _dict[key]{
            previous.insert(value)
            _dict[key] = previous
        }else{
            _dict[key] = [value]
        }
    }
    
   
    
    public mutating func removeBook(value: Value, forKey key: Key){
    
        if var previous = _dict[key]{
            previous.remove(value)
            _dict[key] = previous
            if previous.isEmpty {
                  _dict.removeValue(forKey: key)
            }
        
        }
        
    
    
    
    }
    
    
    
    
    
    public func getAllBooks()-> Array<Value>{
       
        var books = Set<Value>()
        
        
        for (_, allBooks) in _dict {
          books = books.union(allBooks)
        }
    
        return Array(books)
    
    }
    
}

