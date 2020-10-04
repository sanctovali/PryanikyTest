//
//  TextCell.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
	
	static let cellIdentifier = String(describing: TextCell.self)
	
	@IBOutlet weak var cellTextLabel: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
