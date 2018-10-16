//
//  GlobalConstants.swift
//  WatchConvert
//
//  Created by Mark Gumbs on 16/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import UIKit

class GlobalConstants: NSObject {

    // Create a singleton so that the variables can be called outside of the class
    static let sharedInstance = GlobalConstants()
    
    // NOTE:  Currency lookup codes from https://www.iban.com/currency-codes
    
    // Test Data Flag
    static let UseTestDataURLs = false
    static let TestExchangeURL = "http://data.fixer.io/api/latest?access_key=a8bc1d778ac3c3a7138d85244f7d05ac&base=EUR"
    
    // Fixer IO API
    
    static let FixerIOAPIKey = "a8bc1d778ac3c3a7138d85244f7d05ac"
    
    // Endpoints
    
    static let FixerIOBaseURL = "http://data.fixer.io/api"
    static let FixerIOParamLatest = "/latest"
    static let FixerIOParamHistorical = "/YYYY-MM-DD"  // Replace YYYY-MM-DD with required date
    static let FixerIOParamConvert = "/convert"
    static let FixerIOParamTimeseries = "/timeseries"
    static let FixerIOParamFluctuation = "/fluctuation"
    
}
