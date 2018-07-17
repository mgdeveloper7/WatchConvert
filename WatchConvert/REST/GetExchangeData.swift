//
//  GetExchangeData.swift
//  WatchConvert
//
//  Created by Mark Gumbs on 16/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import UIKit

class GetExchangeData: NSObject {

    override init() {
        super.init()
    }
    
    func getData( urlAndParameters: String!, completionBlock:@escaping ((String?, NSError?,[NSObject : AnyObject]?, Int) -> Void) ){
        
//        if AppSettings.DemoMode {
//
//            let demoDataFileName = GlobalConstants.DemoWeatherFile
//
//            //            handleDemoResponse(statusCode: 200, responseFileName: demoDataFileName, demoBlock: completionBlock)
//            return
//        }
//
        getResourceFromUrl(url: urlAndParameters, block: completionBlock)
        
    }

    
    func getResourceFromUrl(url: String!, block: ((String?, NSError?, [NSObject : AnyObject]?, Int) -> Void)!) {
        
        let configuration = URLSessionConfiguration .default
        let session = URLSession(configuration: configuration)
        let request : NSMutableURLRequest = NSMutableURLRequest()
        
        var urlString = url
        request.url = NSURL(string: NSString(format: "%@", urlString!) as String) as URL?
        
        // Use the 2 lines below to test a custom URL
        if (GlobalConstants.UseTestDataURLs) {
            urlString = GlobalConstants.TestExchangeURL
            request.url = NSURL(string: NSString(format: "%@", urlString!) as String) as URL?
        }
        
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        let dataTask = session.dataTask(with: request as URLRequest) {
            data, response, error in
            
            
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("WatchConvert: error not a valid http response or timed out: \(error ?? "" as! Error)")
                    block("", nil,nil,2000)
                    
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                // Valid Response
                let response = String (data: receivedData, encoding: String.Encoding.utf8)
                print("Response = \(response)")
                
                // Get JSON
                do {
                    // TODO:  Review below, not using the getResponse variable
                    let getResponse = try JSONSerialization.jsonObject(with: receivedData, options: .allowFragments)
                    print (getResponse)
                    
                    block(response, nil,nil,httpResponse.statusCode)
                    
                    
                } catch {
                    print("WatchConvert: error serializing JSON: \(error)")
                    block(response, nil,nil,httpResponse.statusCode)
                }
                
                break
            case 400:
                block(nil, nil,nil,httpResponse.statusCode)
                
                break
            case 500:
                block(nil, nil,nil,httpResponse.statusCode)
                
                break
            default:
                print("GET request got response \(httpResponse.statusCode)")
                block(nil, nil,nil,httpResponse.statusCode)
                
            }
        }
        dataTask.resume()
        
    }
    
}
