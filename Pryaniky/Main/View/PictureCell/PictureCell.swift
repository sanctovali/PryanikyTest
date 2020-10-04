//
//  PictureCell.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {
	
	static let cellIdentifier = String(describing: PictureCell.self)
	
	@IBOutlet weak var cellTextLabel: UILabel!
	@IBOutlet weak var cellImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
