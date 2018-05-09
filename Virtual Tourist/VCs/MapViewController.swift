//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Derek Justus on 5/3/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController : ViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var dataLord:DataLord!
    
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataLord.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func fetchActivePin(coordinate: CLLocationCoordinate2D) {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude == %d && longitude == %d", coordinate.latitude, coordinate.longitude)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataLord.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        loadPinsFromStore()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("addPinToMap:"))
        longPress.minimumPressDuration = 0.8
        
        mapView.addGestureRecognizer(longPress)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func loadPinsFromStore() {
        if let pins = fetchedResultsController.fetchedObjects {
            for pin in pins {
                let annotation = VTAnnotation(pin: pin)
                mapView.addAnnotation(annotation)
            }
        }
    }
 
    @objc func addPinToMap(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            
            let pinLocation = gesture.location(in: mapView)
            let coord = mapView.convert(pinLocation, toCoordinateFrom: mapView)
            
            let pin = Pin(context: dataLord.viewContext)
            pin.lat = coord.latitude
            pin.long = coord.longitude
            try? dataLord.viewContext.save()
            
            
            
           
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinColor = .green
 
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
            let annot = view.annotation as! VTAnnotation
            let pin = annot.pin
            if let nc = self.navigationController, let vc = self.storyboard?.instantiateViewController(withIdentifier: "GalleryVC") as? GalleryViewController {
                vc.pin = pin
                vc.dataLord = dataLord
                nc.pushViewController(vc, animated: true)
            }
    }
    

    

}

extension MapViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            let pin = anObject as! Pin
            let annotation = VTAnnotation(pin: pin)
            mapView.addAnnotation(annotation)
            break
        case .delete:
            print("delete")
            break
        case .update:
           print("update")
        case .move:
           print("move")
        }
    }
    
}
