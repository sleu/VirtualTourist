//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/14/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    static let shared = FlickrClient()
    var session = URLSession.shared
    
    func searchBy(latitude: Double, longitude: Double, page: Int, handler:@escaping (_ photos: [[String:AnyObject]]?, _ error: String?) -> Void){
        
        var validPage = 1
        if page < FlickrParameterValues.MaxPages {
            validPage = page
        }
        
        let params = [
            FlickrParameterKeys.Method: FlickrParameterValues.SearchMethod,
            FlickrParameterKeys.APIKey: FlickrParameterValues.APIKey,
            FlickrParameterKeys.BoundingBox: bboxString(latitude: latitude, longitude: longitude),
            FlickrParameterKeys.SafeSearch: FlickrParameterValues.UseSafeSearch,
            FlickrParameterKeys.Extras: FlickrParameterValues.MediumURL,
            FlickrParameterKeys.Format: FlickrParameterValues.ResponseFormat,
            FlickrParameterKeys.NoJSONCallback: FlickrParameterValues.DisableJSONCallback,
            FlickrParameterKeys.PhotosPerPage: FlickrParameterValues.PhotosPerPage,
            FlickrParameterKeys.Page: "\(validPage)"
        ]
        
        let request = URLRequest(url: flickrURLFromParameters(params as [String : AnyObject]))
        
        let task = session.dataTask(with: request) {data, response, error in
            
            //Was there an error?
            guard (error == nil) else {
                handler(nil, error?.localizedDescription)
                return
            }
            
            //Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handler(nil, error?.localizedDescription)
                return
            }
            
            //Was there any data returned?
            guard let data = data else {
                handler(nil, error?.localizedDescription)
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                handler(nil, error.localizedDescription)
                return
            }
            //TODO: what needs to be returned?
        }
    }
}
