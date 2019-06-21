//
//  ImageHelper.swift
//  Countries
//
//  Created by amee on 21/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

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
                let anSVGImage: SVGKImage = SVGKImage(data: rawData as Data)
                completionHandler(anSVGImage.uiImage)
                return
            }
            
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: urlString) { (data, response , error) in
                guard error == nil, let data: Data = data else {
                    completionHandler(nil)
                    return
                }
                let anSVGImage: SVGKImage = SVGKImage(data: data)
                self.cache.setObject(data as NSData, forKey: filePath as NSString)
                completionHandler(anSVGImage.uiImage)
                return
            }
            downloadTask.resume()
        }
    }
}
