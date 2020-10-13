//
//  Presenter.swift
//  Pryaniky
//
//  Created by Valentin Kiselev on 10/2/20.
//  Copyright © 2020 Valianstin Kisialiou. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
	func startLoading()
	func finishLoading()
	func reloadView()
	func showAlert(title: String, message: String)
	
}

protocol MainPresenterProtocol: class {
	init(view: MainViewProtocol)
	func onViewDidLoad()
	func getData(on indexPath: IndexPath) -> CellData
	func onSelection(by indexPath: IndexPath)
	func updateSelection(on indexPath: IndexPath, to id: Int)
	func rowsInSection(_ section: Int) -> Int
	var sections: Int { get }
}

class MainPresenter: MainPresenterProtocol {
	
	
	
	private let networkManager = PryanikyDataManager()
	private weak var view: MainViewProtocol?
	
	private var items = PryanikyData(text: [], pictures: [], selectors: [], order: [])

	var sections: Int {
		return items.order.count
	}
	
	required init(view: MainViewProtocol) {
		self.view = view
	}
	
	func onViewDidLoad() {
		loadData()
	}
	
	func rowsInSection(_ section: Int) -> Int {
		let view = items.order[section]
		let type = PossibleTypes.init(rawValue: view)
		
		switch type {
		case .hz:
			return items.text.count
		case .picture:
			return items.pictures.count
		case .selector:
			return items.selectors.count
		default:
			return 0
		}
	}

	func getData(on indexPath: IndexPath) -> CellData {
		let view = items.order[indexPath.section]
		
		let type = PossibleTypes.init(rawValue: view)
		let row = indexPath.row
		
		switch type {
		case .hz:
			let text = items.text[row].text
			return (type, text, nil, nil, nil)
		case .picture:
			let pictureData = items.pictures[row]
			return (type, pictureData.text, pictureData.image, nil, nil)
		case .selector:
			let selectorData = items.selectors[row]
			let selectedIndex = selectorData.selectedIndex ?? 0
			let texts = selectorData.texts
			return (type, nil, nil, texts, selectedIndex)
		default:
			break
		}
		
		return (type: nil, nil, nil, nil, nil)
	}
	
	func onSelection(by indexPath: IndexPath) {
		let type = items.order[indexPath.section]
		view?.showAlert(title: "Selected type is \(type)", message: "")
	}
	//Set new selected row for Selector Entity
	func updateSelection(on indexPath: IndexPath, to id: Int) {
		if items.order[indexPath.section] == "selector" {
			items.selectors[indexPath.row].selectedIndex = id
		}
		getSelectedIdFor(indexPath: indexPath)

	}
	
	//Get current selected row for Selector Entitty
	private func getSelectedIdFor(indexPath: IndexPath) {

		let selector = items.selectors[indexPath.row]
			let type = items.order[indexPath.section]
			view?.showAlert(title: "Selected type is \(type)", message: "Selected id is \(selector.selectedID)")
		
	}
	
	private func loadData() {
		view?.startLoading()
		defer {
			view?.finishLoading()
			view?.reloadView()
		}
		
		networkManager.fetchSampleData { [weak self] (result) in
			switch result {
			case .Success(let data):
				self?.items = data
				self?.view?.reloadView()
			case .Failure(let error):
				self?.view?.showAlert(title: "Error", message: error.localizedDescription)
			}
		}
	}
	
}
