//
//  ViewController.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import UIKit

typealias CellData = (type: PossibleTypes?, text: String?, image: UIImage?, variant: [Int : String]?, id: Int?)

class MainViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.hidesWhenStopped = true
		indicator.style = .large
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	fileprivate lazy var presenter: MainPresenterProtocol = MainPresenter(view: self)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.onViewDidLoad()
		setupViews()
	}
	
	fileprivate func setupViews() {
		setupTableView()
		setupActivityIndicator()
	}
	
	fileprivate func setupActivityIndicator() {
		view.addSubview(activityIndicator)
		activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
		activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
	}
	
	fileprivate func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 90
		registerCells()
	}
	
	fileprivate func registerCells() {
		
		let textCell = UINib(nibName: TextCell.cellIdentifier, bundle: nil)
		tableView.register(textCell, forCellReuseIdentifier: TextCell.cellIdentifier)
		
		let pictureCell = UINib(nibName: PictureCell.cellIdentifier, bundle: nil)
		tableView.register(pictureCell, forCellReuseIdentifier: PictureCell.cellIdentifier)
		
		let selectorCell = UINib(nibName: SelectorCell.cellIdentifier, bundle: nil)
		tableView.register(selectorCell, forCellReuseIdentifier: SelectorCell.cellIdentifier)
	}
	
	fileprivate func getTextCell(with text: String) -> TextCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier) as! TextCell
		cell.cellTextLabel.text = text
		return cell
	}
	
	fileprivate func getPictureCell(with text: String, image: UIImage) -> PictureCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PictureCell.cellIdentifier) as! PictureCell
		cell.cellImageView.image = image
		cell.cellTextLabel.text = text
		return cell
	}
	
	fileprivate func getSelectorCell(with variants: [Int:String], id: Int) -> SelectorCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SelectorCell.cellIdentifier) as! SelectorCell
		cell.delegate = self
		cell.selectorData = variants
		cell.cellPickerView.selectRow(id, inComponent: 0, animated: false)
		cell.cellPickerView.reloadAllComponents()
		return cell
	}
		
}

extension MainViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.onSelection(by: indexPath.row)
	}
}

extension MainViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		/*
		Вот тут я не аонял что оменно требовалось:
		- отображать в таблице заголовки и по клику показывать что внутри?
		- или в таблице отображать сразу элементы?
		Первый вариант показался проще, вот выбрал второй. =)
		В твком случае по IndexPath получаем индекс ключа, по ключу в презеторе получаем словарь, его конвертим в tuple данных с типом и генерим нужный тип ячейки.
		Наверное для этого стоило сделать для этого отдельный адаптер.
*/
		let item = presenter.getData(on: indexPath.row)
		guard let type = item.type else { return UITableViewCell() }
		
		switch type {
		case .hz:
			guard let text = item.text else { break }
			return getTextCell(with: text)
		case .picture:
			guard let image = item.image, let text = item.text else { break }
			return getPictureCell(with: text, image: image)
		case .selector:
			guard let variants = item.variant, let id = item.id else { break }
			let cell = getSelectorCell(with: variants, id: id)
			cell.cellPickerView.tag = indexPath.row
			return cell
		}
		
		return UITableViewCell()
	}
	
}

extension MainViewController: MainViewProtocol {
	func startLoading() {
		activityIndicator.startAnimating()
	}
	
	func finishLoading() {
		activityIndicator.stopAnimating()
	}
	
	func reloadView() {
		tableView.reloadData()
	}
	
	func showAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		ac.addAction(action)
		present(ac, animated: true, completion: nil)
	}
	
}

extension MainViewController: SelectorCellDelegate {
	func valueChanged(row: Int, in pickertag: Int) {
		presenter.updateSelection(on: pickertag, to: row)
	}
}
