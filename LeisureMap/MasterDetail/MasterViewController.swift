//
//  MasterViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/25.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit
import SwiftyJSON
class MasterViewController: UIViewController,FileWorkerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var storeTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let store=displayStores[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "StoreCellView", for: indexPath) as! StoreCellView
        cell.updateContent(store: store)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        let store=displayStores[indexPath.row]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category=categories[indexPath.row]
        displayStores.removeAll()
        for store in stores{
            let idx:Int=category.Index-1
            if(store.ServiceIndex==idx){
                displayStores.append(store)
            }
            
        }
        
        DispatchQueue.main.async {
            self.storeTable.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category=categories[indexPath.row]
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCellView", for: indexPath) as! ServiceCellView
        cell.updateContent(service: category)
        return cell
    }
    
    
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
//                                  print("\(index):\(name):latitude:\(latitude)")
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
        
        displayStores = displayStores + stores
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
