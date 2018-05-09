//
//  GalleryViewController.swift
//  Virtual Tourist
//
//  Created by Derek Justus on 5/3/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class GalleryViewController : ViewController, MKMapViewDelegate {
    var pin: Pin!
    
    var dataLord:DataLord!
    var galleryPage: Int = 0
    var hasStore: Bool = false
    
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataLord.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin)-photos")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    var photos: Array<AnyObject>? {
        didSet {
            performUIUpdatesOnMain {
                    self.flikrCollection.reloadData()
                
            }
        }
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flikrCollection: UICollectionView!
    @IBOutlet weak var newImagesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        
        let annotation = VTAnnotation(pin: pin)
        mapView.addAnnotation(annotation)
        
        zoomOn(coordinate: annotation.coordinate)
        
        checkGalleryStatus()
    }
    
    func checkGalleryStatus() {
        if let photoStore = fetchedResultsController.fetchedObjects, photoStore.count > 0 {
            hasStore = true
            photos = photoStore
        } else {
            getGallery()
        }
    }
    
    func deleteGallery() {
        if let imgArray = fetchedResultsController.fetchedObjects {
            for photo in imgArray {
                fetchedResultsController.managedObjectContext.delete(photo)
            }
        
        try? dataLord.viewContext.save()
        }
    }
    
    @IBAction func fetchNewImages(_ sender: Any) {
        hasStore = false
        deleteGallery()
        getGallery()
    }
    
    func getGallery() {
        
        let annotation = VTAnnotation(pin: pin)
        
        galleryPage+=1
       
        let flickr = FlickrAdapter()
        flickr.requestor = self
        flickr.searchByLatLon(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude, page: galleryPage)
    }
    
    func zoomOn(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let mapRegion = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(mapRegion, animated: true)
        
    }
    
   
    func deleteItem(indexPath:IndexPath) {
        photos?.remove(at: indexPath.row)
        flikrCollection.reloadData()
        let photo = fetchedResultsController.object(at: indexPath)
        dataLord.viewContext.delete(photo)
        try? dataLord.viewContext.save()
        
    }

}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let arr = photos else {
            return 0
        }
        
        return arr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell:FlikrCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlikrCollectionCell", for: indexPath as IndexPath) as! FlikrCollectionCell
        if let photoArray = photos {
            cell.dataLord = dataLord
            cell.pin = pin
            
            if hasStore {
                let photo = photoArray[indexPath.row] as! Photo
                if let imageData = photo.image {
                    let image = UIImage(data: imageData)
                    cell.imgView.image = image
                }
            } else {
                let photo = photoArray[indexPath.row] as! FlickrPhoto
                cell.imgURL = photo.url_m
                cell.setupImg()
            }
            
        
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteItem(indexPath: indexPath)
    }
    
    
}

extension GalleryViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            //flikrCollection.insertItems(at: [newIndexPath!])
            break
        case .delete:
         // flikrCollection.deleteItems(at: [indexPath!])
            break
        case .update:
           //flikrCollection.reloadItems(at: [indexPath!])
            break
        case .move:
           //flikrCollection.moveItem(at: indexPath!, to: newIndexPath!)
            break
        }
    }
   
}

