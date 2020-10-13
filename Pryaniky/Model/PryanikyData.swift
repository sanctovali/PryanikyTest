//
//  PryanikyData.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation


enum ValidTypes: String {
	case hz = "hz"
	case picture = "picture"
	case selector = "selector"
}

struct PryanikyData{
	var text: [Hz]
	var pictures: [Picture]
	var selectors: [Selector]
	var order: [ValidTypes]
}

extension PryanikyData: JSONDecodable {
	init?(JSON: [String : AnyObject]) {
		guard let order = JSON["view"] as? [String],
			let recievedData = JSON["data"] as? [[String : AnyObject]] else { return nil }
		self.order = []
		self.text = []
		self.pictures = []
		self.selectors = []
		
		order.forEach { (view) in
			if let type = ValidTypes.init(rawValue: view) {
				self.order.append(type)
			}
		}

		recievedData.forEach { (dictionary) in
			guard let name = dictionary["name"] as? String,
				let type = ValidTypes.init(rawValue: name),
				let data = dictionary["data"] as? [String : AnyObject] else { return }
			switch type {
			case .hz:
				if let hz = Hz(JSON: data) {
					self.text.append(hz)
				}
			case .picture:
				if let picture = Picture(JSON: data) {
					self.pictures.append(picture)
				}
			case .selector:
				if let selector = Selector(JSON: data) {
					self.selectors.append(selector)
				}
			}
		}
	}
}

