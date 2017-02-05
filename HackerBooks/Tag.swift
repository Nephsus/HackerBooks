//
//  TagName.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 24/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation

class Tag{

    var name : String
    var priority : OrderPriority
    
    init(name:String, priority: OrderPriority ) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.priority = priority
    }
    
    convenience init(name: String){
        self.init( name: name, priority: .NormalOrder )
    }

    
    //MARK: - Proxies
    func proxyForEquality() -> String{
        return self.name
    }

    
}

extension Tag: Comparable{

    public static func <(lhs: Tag, rhs: Tag) -> Bool{
        
        if lhs.priority == .FirsOrder{
            return true
        }else if rhs.priority == .FirsOrder{
            return false
        }else{
            return lhs.proxyForEquality() < rhs.proxyForEquality()
        }
    }
    
    public static func ==(lhs: Tag, rhs: Tag) -> Bool{
       return lhs.proxyForEquality() == rhs.proxyForEquality()
    
    }
    
    
}

extension Tag: Hashable{
    
    public var hashValue: Int {
        get {
            return proxyForEquality().hashValue
        }
    }
    
}

