//
//  DownloaderTaskService.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 25/1/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation

typealias completionLoaderTask = (Data?, URLResponse?, Error?) -> Void

class DownloadTaskService{
    
    
    

    func download(endpoint url: URL,
                  withCompletionLoaderTask clousure: @escaping completionLoaderTask ) throws -> Void{
        
        let defaultSession = URLSession( configuration:  URLSessionConfiguration.default )
        
        let dataTask = defaultSession.dataTask(with: url, completionHandler: clousure)
        
        
        dataTask.resume()
        
        
        
    }
    


}
