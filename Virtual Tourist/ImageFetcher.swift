//
//  ImageFetcher.swift
//  Virtual Tourist
//
//  Created by Derek Justus on 5/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation

class ImageFetcher {
    
    func imageFromUrl(url: URL, completionHandler: @escaping (Data?, String?) -> ()) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(nil, error?.localizedDescription)
                return
            }
            
            completionHandler(data, nil)
        }
            
        task.resume()
    }
    
}
