//
//  ConversionDisplayController.swift
//  WatchConvertWK Extension
//
//  Created by Mark Gumbs on 17/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import WatchKit
import Foundation


class ConversionDisplayController: WKInterfaceController {

    @IBOutlet var currencyFromLabel: WKInterfaceLabel!
    @IBOutlet var currencyToLabel: WKInterfaceLabel!
    
    @IBOutlet var convertFromValue: WKInterfaceLabel!
    @IBOutlet var convertToValue: WKInterfaceLabel!

    
    var exchangeRates: ExchangeRates?
    var currencyFrom = ""
    var currencyTo = ""
    var conversionRateForCurrency = 0.0
    var currencyFromValue = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let contextArray = context as! [Any]
        
        exchangeRates = contextArray[0] as! ExchangeRates
        currencyFrom = contextArray[1] as! String
        currencyTo = contextArray[2] as! String
        conversionRateForCurrency = contextArray[3] as! Double
        currencyFromValue = contextArray[4] as! String

        currencyFromLabel.setText(currencyFrom + "=")
        currencyToLabel.setText(currencyTo)
        
        convertCurrency(fromValue: Double(currencyFromValue)!, conversionFactor: conversionRateForCurrency)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func convertCurrency(fromValue: Double, conversionFactor: Double) {
        
        let convertedValue = Double(round(100 * (fromValue * conversionFactor) )/100) //fromValue * conversionFactor;
        convertToValue.setText(String(convertedValue))
    }
    
}
