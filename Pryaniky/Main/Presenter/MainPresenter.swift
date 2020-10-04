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
	func getData(on index: Int) -> CellData
	func onSelection(by index: Int)
	func updateSelection(on index: Int, to id: Int)
	var count: Int { get }
}

class MainPresenter: MainPresenterProtocol {
	
	private let networkManager = PryanikyDataManager()
	private weak var view: MainViewProtocol?
	
	private var items = PryanikyData(data: [:], order: [])
	
	var count: Int {
		return items.order.count
	}
	
	required init(view: MainViewProtocol) {
		self.view = view
	}
	
	func onViewDidLoad() {
		loadData()
	}

	/*
			Вот тут я не аонял что оменно требовалось:
			- отображать в таблице заголовки и по клику показывать что внутри?
			- или в таблице отображать сразу элементы?
			Первый вариант показался проще, вот выбрал второй. =)
			В твком случае по IndexPath получаем индекс ключа, по ключу в презеторе получаем словарь, его конвертим в tuple данных с типом и генерим нужный тип ячейки.
			Наверное для этого стоило сделать для этого отдельный адаптер.
	*/
	func getData(on index: Int) -> CellData {
		let view = items.order[index]
		
		let type = PossibleTypes.init(rawValue: view)
		
		switch type {
		case .hz:
			guard let hz = items.data[view] as? Hz else { break }
			return (type, hz.text, nil, nil, nil)
		case .picture:
			guard let pictureData = items.data[view] as? Picture else { break }
			return (type, pictureData.text, pictureData.image, nil, nil)
		case .selector:
			guard let selectorData = items.data[view] as? Selector else { break }
			return (type, nil, nil, selectorData.variants, selectorData.selectedId)
		default:
			break
		}
		
		return (type: nil, nil, nil, nil, nil)
	}
	
	func onSelection(by index: Int) {
		let type = items.order[index]
		view?.showAlert(title: "Selected type is \(type)", message: "")
	}
	//Set new selected row for Selector Entity
	func updateSelection(on index: Int, to id: Int) {
		let key = items.order[index]
		if let item = items.data[key] as? Selector {
			let variants = item.variants
			let newSelector = Selector(variants: variants, selectedId: id)
			items.data.updateValue(newSelector, forKey: key)
		}
		getSelectedIdFor(selectorID: index)

	}
	
	//Get current selected row for Selector Entitty
	private func getSelectedIdFor(selectorID: Int) {
		let key = items.order[selectorID]
		if let item = items.data[key] as? Selector {
			let type = items.order[selectorID]
			view?.showAlert(title: "Selected type is \(type)", message: "Selected id is \(item.selectedId)")
		}
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
