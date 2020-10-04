//
//  PryanikyData.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation


enum PossibleTypes: String {
	case hz = "hz"
	case picture = "picture"
	case selector = "selector"
}

/*
Изначально собирался использовать этот протокол для передачи данных во вью, но тогда это мало чем отличалось бы от прямого взаимодейсвия вью с моделью

protocol DataPresentable {
	var data: [String : Any] { get set }
	var order: [String] { get set }
}
*/

struct PryanikyData {
	var data: [String : Any]
	var order: [String]
}

extension PryanikyData: JSONDecodable {
	init?(JSON: [String : AnyObject]) {
		guard let order = JSON["view"] as? [String],
			let recievedData = JSON["data"] as? [[String : AnyObject]] else { return nil }
		self.order = order
		self.data = [:]
		recievedData.forEach { (dictionary) in
			
			guard let name = dictionary["name"] as? String,
				let type = PossibleTypes.init(rawValue: name),
				let data = dictionary["data"] as? [String : AnyObject] else { return }
			switch type {
			case .hz:
				if let hz = Hz(JSON: data) {
					self.data[type.rawValue] = hz
				}
			case .picture:
				if let picture = Picture(JSON: data) {
					self.data[type.rawValue] = picture
				}
			case .selector:
				if let selector = Selector(JSON: data) {
					self.data[type.rawValue] = selector
				}
			}
		}
	}
}
