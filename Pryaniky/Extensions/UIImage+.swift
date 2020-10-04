//
//  UIIMage+.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/4/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit
//Allows initialiaze UIIMage from url
extension UIImage {
	convenience init?(withContentsOfUrl url: URL) {
		do {
			let imageData = try Data(contentsOf: url)
			self.init(data: imageData)
		} catch {
			return nil
		}
	}
}
