//
//  CurrencySelectViewController.swift
//  WatchConvert
//
//  Created by Mark Gumbs on 04/09/2018.
//  Copyright © 2018 Mark Gumbs. All rights reserved.
//

import UIKit
import WatchConnectivity

class CurrencySelectViewController: UIViewController {

    @IBOutlet weak var outerImage: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var currencyFrom: UITextField!
    @IBOutlet weak var currencyTo: UITextField!
    @IBOutlet weak var configureWatchButton: UIButton!

    var dataResponse: NSDictionary?
    var exchangeRates: ExchangeRates?
    var currenciesArray = [CurrencyCodes()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let getCurrencyLookupData = GetCurrencyLookupData()
        currenciesArray = getCurrencyLookupData.returnLookupData()
        
        self.getWeatherDataFromService()
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  UI Methods
    
    func setupUI() {
        outerView.layer.cornerRadius = 10
        outerView.clipsToBounds = true
    }
    
    // MARK:  Button press methods
    @IBAction func configureWatchButtonPressed(_ sender: AnyObject) {
        
        if (currencyFrom.text != "" && currencyTo.text != "") {
            sendCurrenciesToWatch()
        }
        
//        // Dismiss view
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:  Web Service Methods
    
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

    // MARK:  Apple Watch Methods
    
    func sendCurrenciesToWatch() {
        
        if WCSession.default.isReachable == true {
            
            let session = WCSession.default
            
            // TODO:  Create multiple context:
            //      - Base Currency
            //      - Conversion Currency
            //      - ExchangeRates object (of currencies) or the relevant JSON
            
            var contextArray = [Any]()
            contextArray.append(currencyFrom.text as Any)
            contextArray.append(currencyTo.text as Any)
           //contextArray.append(hourTextColourArray[rowIndex])
            
            do {
                let applicationDict = ["WK_Currencies_Context": contextArray]
            
                try session.updateApplicationContext(applicationDict)
            } catch {
                print("Error setting WKDefaults_URLDefaultUnits for Watch - " + error.localizedDescription)
            }
            
        }
        else {
            
            let message = "Cannot find Apple Watch to send settings to."
            Utility.showMessage(titleString: "Error", messageString: message )
        }
    }
}
