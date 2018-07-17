//
//  Utility.swift
//  WatchConvert
//
//  Created by Mark Gumbs on 16/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    class func getBuildVersion() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
    }
    
    class func showMessage(titleString : String, messageString : String)
    {
        #if os(iOS)
//        let alertView = UIAlertView(title: titleString, message: messageString, delegate: nil, cancelButtonTitle: "OK")
//        alertView.show()
        #endif
        
        //        let alertController = UIAlertController(title: titleString, message:  messageString, preferredStyle: UIAlertControllerStyle.alert)
        //
        //        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        //            print("OK")
        //        }
        //
        //        alertController.addAction(okAction)
        //        self.present(alertController, animated: true, completion: nil)
        
    }
    
     class func areDatesSameDay (date1: NSDate, date2: NSDate) -> Bool {
        
        var retVal = false
        
        let df = DateFormatter()
        df.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!  // Just for use in comparison
        
        df.dateFormat = "yyyy-MM-dd"  // Remove timestamp for comparison
        
        let compareDateString1 = df.string(from: date1 as Date)
        let compareDateString2 = df.string(from: date2 as Date)
        
        if compareDateString1 == compareDateString2 {
            retVal = true
        }
        
        return retVal
    }
    
    class func findExchangeRate(currency: String, exchangeRates: ExchangeRates) -> Double {
        
        // Loop through the exchange rates class hierarchy to get the rate for the given currency
        
        for r in exchangeRates.rates {
            
            print(r.code!)
            if currency == r.code! {
                return r.value!
            }
        }
        
        return 0
    }
}
