//
//  FirstViewControllerModelView.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 21.11.2022.
//

import Foundation
import RealmSwift

class FirstViewControllerModelView {
    
    enum InputMV {
        case firstInit
        case inputTextNumber(String)
        case searchNumber
        case randomNumber
        case close
    }
    
    enum OutputMV {
        case reload
        case error(ErrorType)
    }
    
    func inputCase(_ inputCase: InputMV ) {
        
        Task { @MainActor in
            switch inputCase {
            case .firstInit:
                firstInit()
            case .inputTextNumber(let text):
                enableSearchButton.value = text.count > 0
                numberText.value = text
            case .searchNumber:
                await searchFact(for: numberText.value)
            case .randomNumber:
                await searchFactForRandomNumber()
            case .close:
                invokeNotification()
            }
        }
    }
    
    let navigationTitle = "Example"
    let placeholder = Box("Insert number")
    let numberText = Box("")
    let infoText = Box("")
    let enableSearchButton = Box(false)
    var didSendEvent : Callback<OutputMV>?
    
    var notificationToken: NotificationToken?
    private var dataSource = [ItemObject]()
    private var dataSourceDB : Results<NumberModel>!
    
    func dataSourceCount() -> Int {
        return dataSource.count
    }
    
    func objectDataSource(index: Int) -> ItemObject {
        return dataSource[index]
    }
    
    func objectDB(index: Int) -> NumberModel {
        return dataSourceDB[index]
    }
    
    private func firstInit() {
        
        dataSourceDB = RealmService.shared.getAllrecords()
        notificationToken = RealmService.shared.subscribeNotification(object: dataSourceDB) { [weak self] insertions in
            self?.updateDataSource(insertions: insertions)
        }
        
        let tempArr = dataSourceDB.compactMap{ itemDB -> ItemObject in
            let cellMV = HistoryTableViewCellModelView(date: DateFormatter.formatting(type: .createDate, date: itemDB.date),
                                                       number: itemDB.number.description,
                                                       infoText: itemDB.infotext)
            return ItemObject(type: .history, data: cellMV)
        }
        
        dataSource.append(contentsOf: tempArr)
        didSendEvent?(.reload)
    }
    
    private func updateDataSource(insertions: [Int]) {
        print("Inserted indices: ", insertions)
        let index = insertions.first!
        let itemDB = dataSourceDB[index]
        let cellMV = HistoryTableViewCellModelView(date: DateFormatter.formatting(type: .createDate, date: itemDB.date),
                                                   number: itemDB.number.description,
                                                   infoText: itemDB.infotext)
        let itemObj = ItemObject(type: .history, data: cellMV)
        self.dataSource.insert(itemObj, at: index)
        
        self.didSendEvent?(.reload)
    }
    
    private func invokeNotification() {
        guard let notificationToken = notificationToken else { return }
        RealmService.shared.invalidateSubscription(notificationToken)
    }
    
    private func searchFact(for number: String) async {
        do {
            let text = try await NetworkService.networkRequest(methodType: .get, requestType: .search(number: number))
            infoText.value = text
            saveRecodr(text: text)
        }catch let(err) {
            didSendEvent?(.error(err as! ErrorType))
        }
    }
    
    private func searchFactForRandomNumber() async {
        inputCase(.inputTextNumber(""))
        do {
            let text = try await NetworkService.networkRequest(methodType: .get, requestType: .random)
            infoText.value = text
            saveRecodr(text: text)
        }catch let(err) {
            didSendEvent?(.error(err as! ErrorType))
        }
    }
    
    private func saveRecodr(text: String) {
        let numberStr = text.components(separatedBy: " ").first ?? "0"
        let number = Int(numberStr) ?? 0
        
        DispatchQueue.main.async {
            let model = NumberModel(number: number, infotext: text)
            RealmService.shared.saveRecodr(model: model)
        }
    }
}
