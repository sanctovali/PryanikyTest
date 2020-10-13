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

struct Selector {
	let variants: [Variant]
	var selectedID: Int
	
	var texts: [String] {
		return variants.map({$0.text})
	}
	
	var selectedIndex: Int? {
		get {
			var selectedIndex: Int?
				for (index, variant) in variants.enumerated() {
					if variant.id == selectedID {
						selectedIndex = index
						break
					}
				}
				return selectedIndex
		}
		
		set {
			guard let selectedIndex = newValue, selectedIndex < variants.count else { return }
			let text = variants[selectedIndex].text
			for variant in variants {
				if variant.text == text {
					selectedID = variant.id
					break
				}
			}
			
		}
	
	}


	init(variants: [Variant], selectedID: Int) {
		self.selectedID = selectedID
		self.variants = variants
	}
	
}

extension Selector: JSONDecodable {
	init?(JSON: [String : AnyObject]) {
		guard let selectedID = JSON["selectedId"] as? Int,
			let variantsArray = JSON["variants"] as? [[String : AnyObject]] else { return nil }
		var variants: [Variant] = []
		variantsArray.forEach { (variantsDictionary) in
			if let id = variantsDictionary["id"] as? Int,
				let text = variantsDictionary["text"] as? String {
				let variant = Variant(id: id, text: text)
				variants.append(variant)
			}
		}
		self.variants = variants
		self.selectedID = selectedID
	}
}

struct Variant {
	let id: Int
	let text: String
}
