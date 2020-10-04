//
//  Models.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit




struct Hz: JSONDecodable {
	let text: String
	
	init?(JSON: [String : AnyObject]) {
		guard let text = JSON["text"] as? String else { return nil }
		self.text = text
	}
}

struct Picture: JSONDecodable {
	let imageUrl: String
	var image: UIImage?
	let text: String
	
	init?(JSON: [String : AnyObject]) {
		guard let text = JSON["text"] as? String,
			let urlString = JSON["url"] as? String,
			let url = URL(string: urlString) else { return nil }
		self.text = text
		self.imageUrl = urlString
		self.image = UIImage(withContentsOfUrl: url) ?? UIImage(named: "unpredicted-icon")
	}
}

struct Selector: JSONDecodable {
	let variants: [Int : String]
	var selectedId: Int
	
	init?(JSON: [String : AnyObject]) {
		guard let selectedId = JSON["selectedId"] as? Int,
			let variantsArray = JSON["variants"] as? [[String : AnyObject]] else { return nil }
		var variants: [Int : String] = [:]
		variantsArray.forEach { (variantsDictionary) in
			if let id = variantsDictionary["id"] as? Int,
				let text = variantsDictionary["text"] as? String {
				variants[id] = text
			}
		}
		self.variants = variants
		self.selectedId = selectedId
	}
	
	init(variants: [Int : String], selectedId: Int) {
		self.selectedId = selectedId
		self.variants = variants
	}
	
}
