//
//  ListViewController.swift
//  SantoCodingExercise
//
//  Created by Santosh Jayapal on 04/11/18.
//  Copyright © 2018 com.santosh.project. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class ListViewController: UIViewController {
  
  //Ui Elements
  @IBOutlet weak var tableView: UITableView!
  var refreshControl = UIRefreshControl()
  
  
  //Data Variables
  var titleString = "" //Leave it empty, fetch the title value from server
  var dataList = [DataModel]() //Create an empty list, data will be added after fetching from server
  
  //MARK: View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setViewElements()
    
    //Set image request time out
    getDataFromServer()
  }
  
  //Adds the required accessories to the views created in story board
  func setViewElements() {
    
    //Add table view Refresh
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
    refreshControl.backgroundColor = UIColor.clear
    refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
    tableView.addSubview(refreshControl)
    
    let imageManager = SDWebImageManager.shared()
    imageManager.imageDownloader?.downloadTimeout = 30.0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  //MARK: View Data Methods
  //Populates the data fetched from server into the view
  func setViewData() {
    self.navigationItem.title = titleString
    self.tableView.reloadData()
  }
  
  //Re fetches the data from server
  @objc func refreshData() {
    getDataFromServer()
    refreshControl.endRefreshing()
  }
  
  //MARK: Image Loading Methods
  //Function to set image from url in an Imageview
  func setImage(model:DataModel, imageView:UIImageView, index: IndexPath) {
    if let escapedString = model.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
      let imagUrl = URL(string: escapedString) { //If URL is valid then load image from URL
      imageView.sd_setImage(with: imagUrl, placeholderImage: UIImage(named: "LoadingImage"), options: .continueInBackground , completed: {[weak self] image, error, cacheType, imageURL in
        if error != nil {
          model.image = UIImage(named: "errorImage")
        }
        else {
          model.image = image
        }
        DispatchQueue.main.async {
          self?.tableView.reloadRows(at: [index], with: .fade)
        }
      })
    }
    else { //If URL is invalid load an image showing invalid message
      model.image = UIImage(named: "errorImage")
      tableView.reloadRows(at: [index], with: .fade)
    }
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
    
    if let dataImage = dataModel.image {
      listCell.cellImageView.image = dataImage
    }
    else {
    setImage(model: dataModel, imageView: listCell.cellImageView, index: indexPath)
    }
    listCell.isUserInteractionEnabled = false
    return listCell
  }
  
 
  
}


//MARK: Web Service Calls
extension ListViewController {
  
  //Func to retreive json response from the server
  func getDataFromServer() {
    
    showProgress(isStop: false)
    WebserviceManager.callGETWEbservice(api: requestApi) {[weak self] status in
      switch status {
      case .success(data: let data, response: let response):
        print("Received list data ::\(String(describing: NSString(data: data, encoding: String.Encoding.ascii.rawValue))) response::\(response)")
        //Parse the data to get the data list array
        self?.dataList = (self?.parseListData(data: data))!
        DispatchQueue.main.async {
         self?.showProgress(isStop: true)
          self?.setViewData()
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
          
          if let title = row["title"] as? String {
          let dataModel = DataModel()
          dataModel.title = title
          dataModel.description = row["description"] as? String ?? ""
          dataModel.imageUrl = row["imageHref"] as? String ?? ""
          dataList.append(dataModel) //Add the parsed object to the list
          }
        }
      }
    }
    }
    return dataList
  }
}

