//
//  VTWebservice.swift
//  
//
//  Created by Varun Tyagi on 25/08/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit
import Foundation

typealias CompletionHandler = (response:NSString,success:Bool) -> Void

class VTWebservice: NSObject {

    var task:NSURLSessionTask?
    var responseString:NSString = ""
    class var sharedInstance:VTWebservice {
        struct Singleton {
            static let instance = VTWebservice()

        }
        return Singleton.instance
    }
    
    
    func webHelper( url: NSURL ,completionHandler: CompletionHandler) {
        
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
      
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("en-US", forHTTPHeaderField: "Accept-Language")

         task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
          

            
            
            guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
                else {
                    print("error: not a valid http response")
                   self.responseString="{\"code\":\"500\", \"message\":\"Problem while fetching the data from server. Please try again or check your device network.\"}"
                     completionHandler(response:self.responseString ,success: false)
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                self.responseString = NSString (data: receivedData, encoding: NSUTF8StringEncoding)!
                
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("&gt;", withString:">")
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("&lt;", withString:"<");
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("&amp;" ,withString:"&")
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("&#39;", withString:"'")
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("&quot;" ,withString:"\"")
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("&quot;" ,withString:"\"")
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("\\r", withString:" ")
                self.responseString = self.responseString.stringByReplacingOccurrencesOfString("\\n" ,withString:" ")
                 completionHandler(response:self.responseString ,success: true)
                
                 break
            case 400:
                
                break
            default:
                self.responseString="{\"code\":\"500\", \"message\":\"Problem while fetching the data from server. Please try again or check your device network.\"}"
                completionHandler(response:self.responseString ,success: false)
                
            }
            
        });
        
        task!.resume()
        
        

        
    }
    
    
    
}
