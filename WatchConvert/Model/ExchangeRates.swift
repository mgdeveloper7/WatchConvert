//
//  ExchangeRates.swift
//  WatchConvert
//
//  Created by Mark Gumbs on 16/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import UIKit

class ExchangeRates: NSObject {

    var success : Bool?
    var timestampString : Double?
    var timestamp : NSDate?
    var base : NSDate?
    var dateString : String?
    var date : NSDate?
    var rates = [Rates]()
    
    override init(){
        
    }
    
    init(fromDictionary exchangDataDict: NSDictionary) {
        
        if let lSuccess  = exchangDataDict["success"] as? Bool {
            success = lSuccess
        }
        
        if let lTimestamp  = exchangDataDict["timestamp"] as? Double {
            timestampString = lTimestamp
            timestamp = NSDate(timeIntervalSince1970: lTimestamp)
        }
        
        if let lBase  = exchangDataDict["base"] as? String {
            //base = true
        }
        
        if let lDateString  = exchangDataDict["date"] as? String {
            dateString = lDateString
            
            let dateFormatter = DateFormatter()
            // Force timezone to UTC for conversion
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone! // Just for use in comparison
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: lDateString) as! NSDate

        }
        
        if let lRatesDict  = exchangDataDict["rates"] as? NSDictionary {
            
            for item in lRatesDict { // loop through data items

                let lRates = Rates()
                lRates.code = item.key as? String
                lRates.value = item.value as? Double

                rates.append(lRates)
            }

        }
        

    }
    
    /*
     {
     "success": true,
     "timestamp": 1519296206,
     "base": "EUR",
     "date": "2018-07-16",
     "rates": {
     "AUD": 1.566015,
     "CAD": 1.560132,
     "CHF": 1.154727,
     "CNY": 7.827874,
     "GBP": 0.882047,
     "JPY": 132.360679,
     "USD": 1.23396,
     }
     }
 */
    
}
