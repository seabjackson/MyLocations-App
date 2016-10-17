//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Seab on 8/30/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    // MARK: Constants
    
    struct Constants {
        
        // MARK: URL
        struct URL {
            static let ApiScheme = "https"
            static let ApiHost = "api.flickr.com"
            static let ApiPath = "/services/rest/"
        }
        
        struct Method {
            static let PhotoSearch = "flickr.photos.search"
            static let GetPhotosByLocation = "flickr.places.findByLatLon"
        }
        
        // MARK: Paramater Keys
        struct FlickrParameterKeys {
            static let Method = "method"
            static let ApiKey = "api_key"
            static let Latitude = "lat"
            static let Longitude = "lon"
            static let Format = "format"
            static let PerPage = "per_page"
            static let Page = "page"
            static let NoJSONCallback = "nojsoncallback"
        }
        
        struct FlickrParameterValues {
            static let APIKey = "1a05b27500117e2820280e04b47192ad"
            static let FormatResponse = "json"
            static let DisableJSONCall = "1"
            static let PerPageNumber = 21
        }
        
        struct JSONResponseKeys {
            static let ID = "id"
            static let FarmID = "farm"
            static let ServerID = "server"
            static let Secret = "secret"
        }
        
    }
    
}
