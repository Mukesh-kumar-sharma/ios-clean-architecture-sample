//
//  APIClient.swift
//  ios-clean-architecture-sample
//
//  Created by KAGE on 1/16/17.
//  Copyright © 2017 KAGE. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper

public enum Result<T> {
    case Success(T)
    case Error(Error)
}

open class APIClient {
    class func request<T: Mappable>(url: URLConvertible, method: Alamofire.HTTPMethod, parameters: Parameters, completionHandler: ((Result<T>) -> ())? = nil) {
        Alamofire.request(url, method: method, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let entity = Mapper<T>().map(JSONObject: value) {
                        completionHandler?(Result<T>.Success(entity))
                    }
                case .failure(let error):
                    completionHandler?(Result<T>.Error(error))
                }
            }
    }
}
