//
//  MasterViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/25.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit
import SwiftyJSON
class MasterViewController: UIViewController,FileWorkerDelegate {
    
    var categories:[ServiceCategory]=[]
    var stores:[Store]=[]
    var displayStores:[Store]=[]
    
    var selectedStore:Store?
    
    
    var fileWorker:FileWorker?
    let storeFileName:String="store.json"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sqliteContext=SQLiteWorker()
        let categoriesInSQLite=sqliteContext.readData()
        categories=categories+categoriesInSQLite
        
        fileWorker = FileWorker()
        fileWorker?.fileWorkerDelegate = self
        
        let content=self.fileWorker?.readFromFile(fileName: storeFileName, tag: 1)
        do{
                            if let dataFromString = content?.data(using: .utf8, allowLossyConversion: false) {
                                let json = try JSON(data: dataFromString)
                                for (_ ,subJson):(String, JSON) in json {
                                    
                                    let store:Store=Store()
                                    
                                    // Do something you want
                                    let serviceIndex:Int=subJson["serviceIndex"].intValue
                                    let index:Int=subJson["index"].intValue
                                    let name:String=subJson["name"].stringValue
                                    let location:JSON=subJson["location"]
                                    let address:String=location["name"].stringValue
                                    let imagePath:String=subJson["imagePath"].stringValue
                                      let latitude:Double=subJson["latitude"].doubleValue
                                      let longitude:Double=subJson["longitude"].doubleValue
//                                    print("\(index):\(name):latitude:\(latitude)")
                                    store.ServiceIndex=serviceIndex
                                    store.Name=name
                                    store.Index=index
                                    store.ImagePath=imagePath
                                    store.StoreLocation=LocationDesc()
                                    store.StoreLocation?.Address=address
                                    store.StoreLocation?.Latitude=latitude
                                    store.StoreLocation?.Longitude=longitude
                                    stores.append(store)
                                }
                            }
                        }catch{
                            print(error)
                        }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK
    func fileWorkWriteCompleted(_ sender: FileWorker, fileName: String, tag: Int) {
        
    }
    
    func fileWorkReadCompleted(_ sender: FileWorker, fileName: String, tag: Int) {
        
    }

}
