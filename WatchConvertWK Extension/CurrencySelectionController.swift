//
//  CurrencySelectionController.swift
//  WatchConvertWK Extension
//
//  Created by Mark Gumbs on 17/07/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import WatchKit
import Foundation


class CurrencySelectionController: WKInterfaceController {

    @IBOutlet var currencyFromLabel: WKInterfaceLabel!
    @IBOutlet var currencyToLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var nextButton: WKInterfaceButton!

    var dataResponse: NSDictionary?
    var exchangeRates: ExchangeRates?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        statusLabel.setText("")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // Button Press
    
    @IBAction func nextButtonPressed() {
        
        statusLabel.setText("Getting latest currencies...")
        self.getCurrencyDataFromService()
    }
    
    func getCurrencyDataFromService(){
        
        // NOTE:  This function is called from a background thread
        let url = GlobalConstants.TestExchangeURL
        
        print("URL= " + url)
        
        let scdService = GetExchangeData()
        
        // TODO;  If timed out, we dont seem to be getting a proper error code
        if (scdService == nil) {
            let message = "Currency details cannot be retrieved at this time.  Please try again"
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
                        
                        //self.equalbutton.setEnabled(true)
                        self.dataResponse = getResponse
                        self.exchangeRates = ExchangeRates(fromDictionary: getResponse )
                        
                        DispatchQueue.main.async {
                            self.navigateToConversionPage()
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
    
    func navigateToConversionPage() {
        statusLabel.setText("")
        
        // Create a context of the currenct from and currency to
        
        var contextArray = [Any]()
        contextArray.append(exchangeRates)
        contextArray.append("EUR")
        contextArray.append("GBP")

        self.pushController(withName: "CalculateConversionControllerID", context: contextArray)
    }
}
