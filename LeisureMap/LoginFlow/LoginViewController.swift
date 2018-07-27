//
//  LoginViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate,AsyncReponseDelegate , FileWorkerDelegate {
    

    @IBOutlet weak var txtAccount: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    var requestWorker : AsyncRequestWorker?
    var fileWorker:FileWorker?
    let storeFileName:String="store.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestWorker = AsyncRequestWorker()
        requestWorker?.reponseDelegate = self
        
        fileWorker = FileWorker()
        fileWorker?.fileWorkerDelegate = self
        print("viewDidLoad")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoingClicked(_ sender: Any) {
        let account=txtAccount.text!
        let password=txtPassword.text!
        
        let from = "https://score.azurewebsites.net/api/login/\( account)/\(password)"
        
        self.requestWorker?.getResponse(from: from, tag: 1)
        
    }
    
    func readServiceCategory() {
        let from="https://score.azurewebsites.net/api/ServiceCategory"
        self.requestWorker?.getResponse(from: from, tag: 2)
    }
    
    func readStore()  {
        let from="https://score.azurewebsites.net/api/store"
        self.requestWorker?.getResponse(from: from, tag: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // a
        
        let accept = "abcdeABCDE"
        let cs = NSCharacterSet(charactersIn: accept).inverted
        // ['a', 'b', 'c']
        
        //                a  a
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        //["a", "b", "c"]
        
        
        if( string != filtered){
            return false
        }

        
        // Max Length
        
        var maxLength : Int = 0
        
        
        if textField.tag == 1 {
            maxLength = 4
        }
        
        if textField.tag == 2 {
            maxLength = 5
        }

        
        let currentString : NSString = textField.text! as NSString
        
        let newString : NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            
            textField.resignFirstResponder()
            
            txtPassword.becomeFirstResponder()
            
        }
        
        if textField.tag == 2 {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: AsyncResponseDelegate
    
    func receviedReponse(_ sender: AsyncRequestWorker, responseString: String, tag: Int) {
        print("\(tag):\(responseString)")
        
        switch tag {
        case 1:
            self.readServiceCategory()
            break
        case 2:
            do{
                if let dataFromString = responseString.data(using: .utf8, allowLossyConversion: false) {
                    let json = try JSON(data: dataFromString)
                    let sqliteContext=SQLiteWorker()
                    sqliteContext.createDatabase()
                    sqliteContext.clearAll()
                    for (_ ,subJson):(String, JSON) in json {
                        // Do something you want
//                        let index:Int=subJson["index"].intValue
                        let name:String=subJson["name"].stringValue
                        let imagePath:String=subJson["imagePath"].stringValue
                        sqliteContext.insertData(_name: name, _imagepath: imagePath)
//                        print("\(index):\(name)")
                    }
                    let categories=sqliteContext.readData()
                    print(categories)
                }
            }catch{
                print(error)
            }
            
            
            self.readStore()
            break
        case 3:
//            print("\(tag):\(responseString)")
            
//            do{
//                if let dataFromString = responseString.data(using: .utf8, allowLossyConversion: false) {
//                    let json = try JSON(data: dataFromString)
//                    for (_ ,subJson):(String, JSON) in json {
//                        // Do something you want
//                        let serviceIndex:Int=subJson["serviceIndex"].intValue
//                        let index:Int=subJson["index"].intValue
//                        let name:String=subJson["name"].stringValue
//                        let location:JSON=subJson["location"]
//                        let imagePath:String=subJson["imagePath"].stringValue
//                          let latitude:Double=subJson["latitude"].doubleValue
//                          let longitude:Double=subJson["longitude"].doubleValue
//                        print("\(index):\(name):latitude:\(latitude)")
//                    }
//                }
//            }catch{
//                print(error)
//            }
            
            fileWorker?.writeToFile(content: responseString, fileName: "store.json", tag: 1)
            
            break
        default:
            break
            
        }
        
//        let defaults : UserDefaults = UserDefaults.standard
//
//        defaults.set(responseString, forKey: "serviceVersion")
//
//        defaults.synchronize()
//
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "moveToLoginViewSegue", sender: self)
//        }
        
    }
    
    func fileWorkWriteCompleted(_ sender: FileWorker, fileName: String, tag: Int) {
        
        print(fileName)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToMasterViewSegue", sender: self)
        }
    }
    
    func fileWorkReadCompleted(_ sender: FileWorker, fileName: String, tag: Int) {
        
    }

}
