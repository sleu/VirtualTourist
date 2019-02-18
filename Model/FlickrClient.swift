//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/14/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import UIKit

class FlickrClient: NSObject {
    
    static let shared = FlickrClient()
    var session = URLSession.shared
    
    func searchBy(latitude: Double, longitude: Double, pages: Int, handler: @escaping (_ photos: [[String:AnyObject]]?, _ pages: Int, _ error: String?) -> Void){
        
        var thisPage = pages
        if thisPage > 1 {
            thisPage = Int(arc4random_uniform(UInt32(pages))) + 1
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
            FlickrParameterKeys.Page: "\(thisPage)"
        ]
        
        let request = URLRequest(url: flickrURLFromParameters(params as [String : AnyObject]))
        
        let task = session.dataTask(with: request) {data, response, error in
            
            //Was there an error?
            guard (error == nil) else {
                handler(nil, 1, error?.localizedDescription)
                return
            }
            
            //Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handler(nil, 1, error?.localizedDescription)
                return
            }
            
            //Was there any data returned?
            guard let data = data else {
                handler(nil, 1, error?.localizedDescription)
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                handler(nil, 1, error.localizedDescription)
                return
            }
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[FlickrResponseKeys.Status] as? String, stat == FlickrResponseValues.OKStatus else {
                print("Flickr API returned an error. See error code and message in \(String(describing: parsedResult))")
                handler(nil, 1, error?.localizedDescription)
                return
            }
            
            /* GUARD: Is "photos" key in our result? */
            guard let photosDictionary = parsedResult[FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                print("Cannot find keys '\(FlickrResponseKeys.Photos)' in \(String(describing: parsedResult))")
                handler(nil, 1, error?.localizedDescription)
                return
            }
            
            /* GUARD: Is the "photo" key in photosDictionary? */
            guard let photosArray = photosDictionary[FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                print("Cannot find key '\(FlickrResponseKeys.Photo)' in \(photosDictionary)")
                handler(nil, 1, error?.localizedDescription)
                return
            }
            
            /* GUARD: Is "pages" key in the photosDictionary? */
            guard let totalPages = photosDictionary[FlickrResponseKeys.Pages] as? Int else {
                print("Cannot find key '\(FlickrResponseKeys.Pages)' in \(photosDictionary)")
                handler(nil, 1, error?.localizedDescription)
                return
            }
            let pageLimit = min(totalPages, FlickrParameterValues.MaxPages)
            if photosArray.count == 0 {
                handler(nil, 1, "No Photos")
            } else {
                handler(photosArray, pageLimit, nil)
            }
        }
        task.resume()
    }
    
    func downloadPhoto(imageUrl: String, handler: @escaping(_ photoData: Data) -> Void) {
        guard let imageURL = URL(string: imageUrl) else {
            print("photo url is nil")
            return
        }
        if let imageData = try? Data(contentsOf: imageURL) {
            let image = UIImage(data: imageData)
            let iData = image!.jpegData(compressionQuality: 0.9)
            handler(iData!)
            //self.imageData = iData
            print("photodownloaded")
        } else {
            print("Image does not exist at \(imageURL)")
        }
    }
}
