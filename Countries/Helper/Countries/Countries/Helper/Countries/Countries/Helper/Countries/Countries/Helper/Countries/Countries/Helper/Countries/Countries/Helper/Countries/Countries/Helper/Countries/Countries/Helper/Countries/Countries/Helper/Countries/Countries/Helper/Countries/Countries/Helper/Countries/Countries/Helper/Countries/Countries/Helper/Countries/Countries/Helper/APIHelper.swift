//
//  APIHelper.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit
import Foundation

struct APIHelper {
    
    /**
     This method returns array containing Country structure
     
     - Parameter filePath: file path from which json need to read.
     - Returns: Array of Country objects.
     */
    static func loadCountryData(filePath: String, completionHandler: @escaping ([Country]?, Error?) -> Void) {
        
        guard let jsonUrl = URL(string: filePath) else {
            completionHandler(nil, nil)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let decoder = JSONDecoder()
            do {
                let jsonData: Data = try Data(contentsOf: jsonUrl)
                let countryDataArray: [Country] = try decoder.decode([Country].self, from: jsonData)
                completionHandler(countryDataArray, nil)
            } catch {
                print("Error info: \(error)")
                completionHandler([], error)
            }
        }
    }
    
    /**
     This method returns UIImage from storage if available or from network
     
     - Parameter filePath: file path from which image need to load.
     - Returns: UIImage object
     */
    static func loadImage(filePath: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let jsonUrl = URL(string: filePath) else {
            completionHandler(nil)
            return
        }
        DispatchQueue.global(qos: .background).async {
            do {
                let imageData: Data = try Data(contentsOf: jsonUrl)
                if let image = UIImage(data: imageData) {
                    completionHandler(image)
                } else {
                    completionHandler(nil)
                }
            } catch {
                print("Error info: \(error)")
                completionHandler(nil)
            }
        }
    }
    
}

struct ImageLoader {
    /**
     This method returns UIImage from storage if available or from network
     
     - Parameter filePath: file path from which image need to load.
     - Returns: UIImage object
     */
    static let shared: ImageLoader = ImageLoader()
    private var cache = NSCache<NSString, NSData>()
    
    func imageForUrl(filePath: String, completionHandler: @escaping (UIImage?) -> ()) {
        guard let urlString = URL(string: filePath) else {
            completionHandler(nil)
            return
        }
        DispatchQueue.global(qos: .background).async { () in
            let data: NSData? = self.cache.object(forKey: NSString(string: filePath))
            if let rawData = data {
                let image = UIImage(data: rawData as Data)
                DispatchQueue.main.async {
                    completionHandler(image)
                }
                return
            }
            
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: urlString) { (data, response , error) in
                guard error == nil, let data: Data = data else {
                    completionHandler(nil)
                    return
                }
                let image = UIImage(data: data as Data)
                print("Image = \(image)")
                self.cache.setObject(data as NSData, forKey: filePath as NSString)
                DispatchQueue.main.async {
                    completionHandler(image)
                }
                return
            }
            downloadTask.resume()
        }
    }
}
