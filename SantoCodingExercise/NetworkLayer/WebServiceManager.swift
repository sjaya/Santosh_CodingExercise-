//
//  WebServiceManager.swift
//  SantoCodingExercise
//
//  Created by Santosh Jayapal on 04/11/18.
//  Copyright © 2018 com.santosh.project. All rights reserved.
//

import Foundation

enum WebserviceStatus {
  case success(data:Data, response : URLResponse),
  failed(error:Error),
  failedMessage(message:String)
}

class WebserviceManager {
  
  static var shared = WebserviceManager()
  lazy var reachability = Reachability()
  
  func checkReachability() -> Bool {
    try? reachability?.startNotifier()
    guard let reachability = reachability else {return false}
    return reachability.connection != .none
  }
  
  func stopChecking() {
    reachability?.stopNotifier()
  }
  
  class func callGETWEbservice(api: String, completion:((WebserviceStatus)->Void)?) {
    if !WebserviceManager.shared.checkReachability() {
      completion?(.failedMessage(message: "Please check your internet connection."))
      return
    }
    guard let url = URL(string: api)
      else {
        completion?(.failedMessage(message: "Invalid url."))
        return
    }
    var request = URLRequest(url:url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
    request.httpMethod = "GET"
    request .setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    callWebservice(request: request, completion: completion)
  }
  
  private class func callWebservice(request: URLRequest, completion:((WebserviceStatus)->Void)?) {
    let task = URLSession .shared.dataTask(with: request) { data, response, error in
      printResponse(url : request.url, data : data)
      if let data = data , let response = response {
        completion?(.success(data: data, response: response))
      }
      else if let error = error {
        completion?(.failed(error: error))
      } else {
        completion?(.failedMessage(message: "Unknown error"))
      }
    }
    task.resume()
}

  //"Authorization", "Bearer " + UserAccessToken
  class func printResponse(url: URL?, data : Data?) {
    guard let data = data else {return}
    let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    print("printResponse url ::\(String(describing: url?.absoluteURL)) response::\(String(describing: str))")
  }

}

