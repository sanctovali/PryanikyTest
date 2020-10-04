//
//  APIManager.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation


typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void


//такой себе замена Decodable
protocol JSONDecodable {
    init? (JSON: [String: AnyObject])
}

protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, comletionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]?) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
    
}

//MARK: extensions
extension APIManager {
    func JSONTaskWith(request: URLRequest, comletionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP response", comment: "")
                ]
                let error = NSError(domain: SWINetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                comletionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    comletionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        comletionHandler(json, HTTPResponse, nil)
                    } catch let error {
                        comletionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]?) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request) {(json, response, error) in
            DispatchQueue.main.async(execute: {
                if let value = parse(json) {
                    completionHandler(.Success(value))
                } else {
                    let error = NSError(domain: SWINetworkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(.Failure(error))
                }
            })
            
        }
        dataTask.resume()
    }
}
