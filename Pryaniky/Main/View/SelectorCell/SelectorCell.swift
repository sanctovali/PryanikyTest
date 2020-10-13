//
//  SelectorCell.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

protocol SelectorCellDelegate {
	func valueChanged(to row: Int, in pickerView: UIPickerView)
}

class SelectorCell: UITableViewCell {
	
	static let cellIdentifier = String(describing: SelectorCell.self)
	
	@IBOutlet weak var cellPickerView: UIPickerView!
	var delegate: SelectorCellDelegate?
	
	var selectorData: [String]? //[Int : String]?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		cellPickerView.delegate = self
		cellPickerView.dataSource = self
		
    }

 
}


extension SelectorCell: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		guard let selector = selectorData else { return nil}
		return selector[row] //Array(selector.values)[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		guard let selector = selectorData else { return 0 }
		return selector.count
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		delegate?.valueChanged(to: row, in: cellPickerView)
	}
	
	
}
