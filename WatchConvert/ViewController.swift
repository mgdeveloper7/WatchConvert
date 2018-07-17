//
//  ViewController.swift
//  WatchConvert
//
//  Created by Mark Gumbs on 16/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataResponse: NSDictionary?
    var exchangeRates: ExchangeRates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getWeatherDataFromService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getWeatherDataFromService(){
        
        // NOTE:  This function is called from a background thread
        let url = GlobalConstants.TestExchangeURL
        
        print("URL= " + url)
        
        let scdService = GetExchangeData()
        
        // TODO;  If timed out, we dont seem to be getting a proper error code
        if (scdService == nil) {
            let message = "Weather details cannot be retrieved at this time.  Please try again"
            Utility.showMessage(titleString: "Error", messageString: message )
//            self.view.hideToastActivity()
//            iconRefreshButton.isEnabled = true
        }
        else {
            scdService.getData(urlAndParameters: url as String) {
                [unowned self] (response, error, headers, statusCode) -> Void in
                
                if statusCode >= 200 && statusCode < 300 {
                    
                    let data = response?.data(using: String.Encoding.utf8)
                    
                    do {
                        let getResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        
                        print("Exchange Rate search complete")
                        
                        self.dataResponse = getResponse
                        self.exchangeRates = ExchangeRates(fromDictionary: getResponse )

                        
  //                      NotificationCenter.default.post(name: GlobalConstants.weatherRefreshFinishedKey, object: nil)
                        
                        DispatchQueue.main.async {
                            
                        }
                        
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                        
                        DispatchQueue.main.async {
                            let message = "Details cannot be retrieved at this time.  Please try again later."
                            Utility.showMessage(titleString: "Error", messageString: message )
                        }
                    }
                    
                } else if statusCode == 404 {
                    // Create default message, may be overridden later if we have found something in response
                    let message = "Details cannot be retrieved at this time.  Please try again later."
                    
                    DispatchQueue.main.async {
                        Utility.showMessage(titleString: "Error", messageString: message )
                    }
                    
                } else if statusCode == 2000 {
                    // Custom code for a timeout
                    let message = "Details cannot be retrieved at this time from Dark Sky.  Please try again later."
                    
                    DispatchQueue.main.async {
                        Utility.showMessage(titleString: "Error", messageString: message )
//                        self.view.hideToastActivity()
//                        self.iconRefreshButton.isEnabled = true
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        let message = "Deather details cannot be retrieved at this time from Dark Sky.  Please try again later."
                        Utility.showMessage(titleString: "Error", messageString: message )
//                        self.view.hideToastActivity()
//                        self.iconRefreshButton.isEnabled = true
                    }
                }
            }
        }  // End IF
    }

    
}

