//
//  ViewController.swift
//  BitCoinLiveUpdate
//
//  Created by user146304 on 12/6/18.
//  Copyright © 2018 Voflic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    

    @IBOutlet weak var bitcoinPriceLable: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    /*Its url for bitcoin*/
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD","BRL","CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    var finalURL = ""
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    /************************************************/
    /*UIPickerViewDataSource, UIPickerViewDelegate*/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currencySelected = currencySymbolArray[row]
        getBitcoinData(url: finalURL)
        
    }
    /*************************************************************/
    /*networking process*/
    func getBitcoinData(url: String){
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess {
                print("Success! Got the BitCoin")
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            }else{
                print("Error:\(String(describing:response.result.error))")
                self.bitcoinPriceLable.text = "Connetion Issues"
            }
        }
    }
    /**************************************************************/
    /*Json passing*/
    func updateBitcoinData(json : JSON){
    if let bitcoinResult = json["ask"].double{
        bitcoinPriceLable.text = currencySelected + String(bitcoinResult)/*or "\(currencySelected)\(bitcoinResult)"*/
    }else{
        bitcoinPriceLable.text = "Price Unavailable"
        }
    }
}

