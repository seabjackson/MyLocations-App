//
//  PhotosViewController.swift
//  MyLocations
//
//  Created by Seab on 10/17/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

private let reuseIdentifier = "PhotosCollectionCell"
class PhotosViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let locationManager = CLLocationManager()
    var userLocation = [CLLocation]()
    var photos: [Photo] = []
    var imageURLS = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        locationManager.delegate = self

        // ask the user for authorization to get their current location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.showsUserLocation = true
        
        // set up the UI for collection view
        let spacing = CGFloat(5.0)
        let dimension = (view.frame.size.width - 10.0) / 3
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = CGFloat(5.0)
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        userLocation.append(location!)
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func getThePhotoLinks() {
        FlickrClient.sharedInstance().searchPhotoByLocation(userLocation.last!.coordinate.latitude, longitude: userLocation.last!.coordinate.longitude) { (result, error) in
            
            guard (error == nil) else {
                print("couldn't find the photo links")
                return
            }
            
            guard let photoLinks = result else {
                print("error in retrieving links")
                return
            }
            
            performUIUpdatesOnMain(){
                for photoLink in photoLinks {
                    let imageURL = photoLink
                    self.imageURLS.append(imageURL)
                 //   self.photos.append(Photo(imageURL: imageURL, imageData: imageData)
                }
            }
        }
    }
    
    func deleteOrDownloadNewPhoto() {
        photos.removeAll()
        getThePhotoLinks()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotosCollectionViewCell
//        let photo = photos as! Photo
//        if let imageData = photo.imageURL {
//            cell.imageView.image = UIImage(data: imageData)
//        } else {
//            //loadCellWithImage(cell, photo: photo)
//        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
