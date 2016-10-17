//
//  FlickrConvenienceAPI.swift
//  Virtual Tourist
//
//  Created by Seab on 8/30/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    func searchPhotoByLocation(latitude: Double, longitude: Double, completionHandlerForSearch: (result: [String]?, error: NSError?) -> Void) {
        
        
        // maxPages = 400 / each page =100 (total = 4000)
        //randomly generate the page number
        
        let parameters: [String:AnyObject] = [
            Constants.FlickrParameterKeys.Method: Constants.Method.PhotoSearch,
            Constants.FlickrParameterKeys.ApiKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Latitude: latitude,
            Constants.FlickrParameterKeys.Longitude: longitude,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.FormatResponse,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPageNumber,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCall
        ]
        
        taskForGetMethod("", parameters: parameters) { (result, error) in
            guard (error == nil) else {
                completionHandlerForSearch(result: nil, error: error)
                return
            }
            
            guard let result = result else {
                //                print("sorry we didn't get the result from search")
                return
            }
            
            guard let photosArray = result["photos"] as? [String: AnyObject] else {
                completionHandlerForSearch(result: nil, error: error)
                //                print("couldn't find the photos key")
                return
            }
            
            guard let totalPages = photosArray["pages"] as? Int else {
                //                print("We could not find the 'pages' key in \(photosArray["pages"])")
                return
            }
            
            let pageLimit = min(totalPages, 40)
            //            print("page limit is \(pageLimit)")
            
            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            //            print("random page: \(randomPage)")
            
            FlickrClient.sharedInstance().searchPhotoByLocationWithRandomPage(latitude, longitude: longitude, page: randomPage, completionHandlerForSearchWithPage: { (result, error) in
                guard (error == nil) else {
                    //                    print("no pics with search and random number")
                    return
                }
                
                completionHandlerForSearch(result: result, error: nil)
                
            })
        }
    }
    
    func searchPhotoByLocationWithRandomPage(latitude: Double, longitude: Double, page: Int, completionHandlerForSearchWithPage: (result: [String]?, error: NSError?) -> Void) {
        let parameters: [String:AnyObject] = [
            Constants.FlickrParameterKeys.Method: Constants.Method.PhotoSearch,
            Constants.FlickrParameterKeys.ApiKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Latitude: latitude,
            Constants.FlickrParameterKeys.Longitude: longitude,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.FormatResponse,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPageNumber,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCall,
            Constants.FlickrParameterKeys.Page : "\(page)"
        ]
        
        taskForGetMethod("", parameters: parameters) { (result, error) in
            guard (error == nil) else {
                completionHandlerForSearchWithPage(result: nil, error: error)
                //                print("\(error?.userInfo)")
                return
            }
            
            guard let result = result else {
                //                print("Sorry we didnt get a result from searchByPhoto")
                return
            }
            
            guard let photosArray = result["photos"] as? [String : AnyObject] else {
                completionHandlerForSearchWithPage(result: nil, error: error)
                //                print("We could not find the 'photos' key in \(result["photos"])")
                return
            }
            
            guard let photoArray = photosArray["photo"] as? [[String:AnyObject]] else {
                completionHandlerForSearchWithPage(result: nil, error: error)
                //                print("We could not find the 'photo' key in \(photosArray["photo"])")
                return
            }
            
            let photoLinks = self.getDownloadLinksForPhotos(photoArray)
            
            completionHandlerForSearchWithPage(result: photoLinks, error: nil)
            
        }
    }
    
    // create the download links for the photos
    func getDownloadLinksForPhotos(result: [[String: AnyObject]]) -> [String] {
        var photoURLs = [String]()
        for photoURL in result {
            if let farmID = photoURL[Constants.JSONResponseKeys.FarmID],
                serverID = photoURL[Constants.JSONResponseKeys.ServerID],
                id = photoURL[Constants.JSONResponseKeys.ID],
                secret = photoURL[Constants.JSONResponseKeys.Secret]
            {
                let imageURL = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
                photoURLs.append(imageURL)
            }
            
        }
        //        print("this is the photo urls: \(photoURLs)")
        return photoURLs
    }
    
    func downloadImages(url: NSURL, completionHandlerForDownloadImages: (data: NSData?, error: NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
            guard (error == nil) else {
                return completionHandlerForDownloadImages(data: nil, error: error)
            }
            
            guard let data = data else {
                return completionHandlerForDownloadImages(data: nil, error: error)
            }
            
            //print("images: \(data)")
            completionHandlerForDownloadImages(data: data, error: nil)
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
