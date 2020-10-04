//
//  PryanikyDataManager.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation


enum RequestType: FinalURLPoint{
    
    case Sample
    
    var baseURL: URL {
        return URL(string: "https://pryaniky.com")!
    }
    
    var path: String {
        switch self {
        case .Sample:
            return "/static/json/sample.json"
        }
    }
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

final class PryanikyDataManager: APIManager {
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
	
    func fetchSampleData(completionHandler: @escaping (APIResult<PryanikyData>) -> Void) {
		let request = RequestType.Sample.request
        fetch(request: request, parse: { (json) -> PryanikyData? in
            if let dictionary = json{
                return PryanikyData(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: completionHandler)
        
    }
}
