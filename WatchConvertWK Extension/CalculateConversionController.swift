//
//  CalculateConversionController.swift
//  WatchConvertWK Extension
//
//  Created by Mark Gumbs on 17/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import WatchKit
import Foundation

class CalculateConversionController: WKInterfaceController {

    @IBOutlet var convertFromValue: WKInterfaceLabel!
    @IBOutlet var currencyFromLabel: WKInterfaceLabel!
    @IBOutlet var currencyToLabel: WKInterfaceLabel!

    @IBOutlet var oneButton: WKInterfaceButton!
    @IBOutlet var twoButton: WKInterfaceButton!
    @IBOutlet var threebutton: WKInterfaceButton!
    @IBOutlet var fourbutton: WKInterfaceButton!
    @IBOutlet var fivebutton: WKInterfaceButton!
    @IBOutlet var sixbutton: WKInterfaceButton!
    @IBOutlet var sevenbutton: WKInterfaceButton!
    @IBOutlet var eightbutton: WKInterfaceButton!
    @IBOutlet var ninebutton: WKInterfaceButton!
    @IBOutlet var zerobutton: WKInterfaceButton!
    
    @IBOutlet var decimalbutton: WKInterfaceButton!
    @IBOutlet var backspacebutton: WKInterfaceButton!
    @IBOutlet var equalbutton: WKInterfaceButton!
    
    var currencyFromValue = ""
    var decimalPointEntered = false
    
    var exchangeRates: ExchangeRates?
    var currencyFrom = ""
    var currencyTo = ""
    var conversionRateForCurrency = 0.0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let contextArray = context as! [Any]
        
        exchangeRates = contextArray[0] as! ExchangeRates
        currencyFrom = contextArray[1] as! String
        currencyTo = contextArray[2] as! String
        
        currencyFromLabel.setText(currencyFrom)
        currencyToLabel.setText(currencyTo)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // Button Presses
    // Tedious way but necessary in Watchkit
    
    @IBAction func oneButtonPressed() {
        processNumericalButtonPress(value: "1")
    }
    
    @IBAction func twoButtonPressed() {
        processNumericalButtonPress(value: "2")
    }
    
    @IBAction func threeButtonPressed() {
        processNumericalButtonPress(value: "3")
    }
    
    @IBAction func fourButtonPressed() {
        processNumericalButtonPress(value: "4")
    }
    
    @IBAction func fiveButtonPressed() {
        processNumericalButtonPress(value: "5")
    }
    
    @IBAction func sixButtonPressed() {
        processNumericalButtonPress(value: "6")
    }
    
    @IBAction func sevenButtonPressed() {
        processNumericalButtonPress(value: "7")
    }
    
    @IBAction func eightButtonPressed() {
        processNumericalButtonPress(value: "8")
    }
    
    @IBAction func nineButtonPressed() {
        processNumericalButtonPress(value: "9")
    }
    
    @IBAction func zeroButtonPressed() {
        processNumericalButtonPress(value: "0")
    }
    
    @IBAction func decimalButtonPressed() {
        
        if !decimalPointEntered {
            processNumericalButtonPress(value: ".")
            decimalPointEntered = true
        }
    }
    
    @IBAction func backspaceButtonPressed() {
        
        if currencyFromValue .last == "." {
            decimalPointEntered = false
        }
        currencyFromValue = String(currencyFromValue .dropLast())
        convertFromValue.setText(currencyFromValue)
    }
    
    @IBAction func equalsButtonPressed() {
        
        // Create a context, passing in
        //
        // - Currency Value
        // - Currency Value units
        // - Converted Value
        // - Converted Value units
        
        conversionRateForCurrency = Utility.findExchangeRate(currency: currencyTo, exchangeRates: exchangeRates!)
        navigateToConversionDisplayPage()
    }
    
    
    func processNumericalButtonPress(value: String) {
        
        // Append whatever button press into the convert from label
        currencyFromValue  = currencyFromValue  + value
        convertFromValue.setText(currencyFromValue)
    }
    
    
    func navigateToConversionDisplayPage() {

        // Create a context of the currenct from and currency to
        
        var contextArray = [Any]()
        contextArray.append(exchangeRates)
        contextArray.append(currencyFrom)
        contextArray.append(currencyTo)
        contextArray.append(conversionRateForCurrency)
        contextArray.append(currencyFromValue)
        
        self.pushController(withName: "ConversionDisplayControllerID", context: contextArray)
    }

}
