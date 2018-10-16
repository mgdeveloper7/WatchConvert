//
//  GetCurrencyLookupData.swift
//  WatchConvert
//
//  Created by Mark Gumbs on 16/10/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import UIKit

class GetCurrencyLookupData: NSObject {

    var currenciesArray = [CurrencyCodes()]
    
    func readCurrencies() {
        
        if let path = Bundle.main.path(forResource: "CurrencyNames", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            //    print("jsonData:\(jsonObj)")
                
                populateArray(jsonObj: jsonObj)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }

    func populateArray(jsonObj : Any) {
        
        for currObj in jsonObj as! NSArray{
            
            let currDict = currObj as! NSDictionary
            
            let currencyCode = CurrencyCodes()
            currencyCode.code = currDict.object(forKey: "CurrencyCode") as? String
            currencyCode.desc = currDict.object(forKey: "Description") as? String

            currenciesArray.append(currencyCode)
        }
        print("Currency Array Populated")
    }
    
    func returnLookupData() -> [CurrencyCodes] {
        
        readCurrencies()
        return currenciesArray
    }
}
