//
//  FlikrCollectionCell.swift
//  Virtual Tourist
//
//  Created by Derek Justus on 5/3/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class FlikrCollectionCell : UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    var imgURL: String!
    var dataLord: DataLord!
    var pin: Pin!
    
    func setupImg() {
        imgView.image = UIImage(imageLiteralResourceName: "placeholder150")
        if let url = URL(string: imgURL) {
            let fetcher = ImageFetcher()
       
            fetcher.imageFromUrl(url: url, completionHandler: {(data, error) in
                guard error == nil else {
                    print("Problem fetching image!")
                    return
                }
                
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.saveImage(image: imageData)
                    performUIUpdatesOnMain {
                         self.imgView.image = image
                        
                    }
                }
            })
        }
    }
    
    func saveImage(image: Data) {
        
        let photo = Photo(context: dataLord.viewContext)
        photo.creationDate = Date()
        photo.pin = self.pin
        photo.image = image
        
        try? dataLord.viewContext.save()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }
}
