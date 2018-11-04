//
//  ListViewController.swift
//  SantoCodingExercise
//
//  Created by Santosh Jayapal on 04/11/18.
//  Copyright © 2018 com.santosh.project. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var titleString = "" //Leave it empty, fetch the title value from server
  var dataList = [DataModel]() //Create an empty list, data will be added after fetching from server
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getDataFromServer()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func reloadView() {
    self.navigationItem.title = titleString
    self.tableView.reloadData()
  }
}

//MARK: Table Data Source Methods
extension ListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataList.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let listCell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
    let dataModel = dataList[indexPath.row]
    listCell.titleLabel.text = dataModel.title
    listCell.descriptionLabel.text = dataModel.description
    return listCell
  }
}


//MARK: Web service Calls
extension ListViewController {
  
  //Func to retreive json response from the server
  func getDataFromServer() {
    WebserviceManager.callGETWEbservice(api: requestApi) {[weak self] status in
      switch status {
      case .success(data: let data, response: let response):
       // print("calldataWebService data ::\(String(describing: NSString(data: data, encoding: String.Encoding.ascii.rawValue))) response::\(response)")
        //Parse the data to get the data list array
        self?.dataList = (self?.parseListData(data: data))!
        DispatchQueue.main.async {
          self?.reloadView()
        }
      case .failed(error: let error):
        print("calldataWebService error ::\(error)")
        self?.showAlert("Error", message: error.localizedDescription)
      case .failedMessage(message: let message):
        print("calldataWebService message ::\(message)")
        self?.showAlert("Error", message: message)
      }
    }
  }
}

// MARK: Parsing methods
extension ListViewController {
  
  func parseListData(data: Data) -> [DataModel] {
    var dataList = [DataModel]() //Initialise an array to store the parsed objects
    print("calldataWebService data ::\(String(describing: NSString(data: data, encoding: String.Encoding.ascii.rawValue))) ")
    
    

    if let jObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
      print("yes")
      
     if let jsonDictionary = jObject as? [String:Any?] {
      //Get the title of the Page
      if let title = jsonDictionary["title"] as? String {
        self.titleString = title
      }
      
      //Get the list of Rows to display
      if let jsonArray = jsonDictionary["rows"] as? [[String:Any]] {
        for row in jsonArray {
          let dataModel = DataModel()
          dataModel.title = row["title"] as? String ?? ""
          dataModel.description = row["description"] as? String ?? ""
          dataModel.imageUrl = row["imageHref"] as? String ?? ""
          dataList.append(dataModel) //Add the parsed object to the list
        }
      }
    }
    }
    return dataList
  }
}

