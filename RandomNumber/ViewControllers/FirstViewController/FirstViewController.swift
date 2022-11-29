//
//  ViewController.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 20.11.2022.
//

import UIKit

class FirstViewController: UIViewController, Storyboardable {

    @IBOutlet private weak var numberTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var randomButton: UIButton!
    @IBOutlet private weak var infoTextView: UITextView!
    @IBOutlet private weak var historyTableView: UITableView!
    
    private var model = FirstViewControllerModelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defer {
            model.inputCase(.firstInit)
        }
        
        configTextField()
        configurationTable()
        configTextView()
        configureButton()
        navigationItem.title = model.navigationTitle
        
        model.enableSearchButton.bind { [unowned self] enable in
            DispatchQueue.main.async {
                self.searchButton.isEnabled = enable
            }
        }
        
        model.didSendEvent = {[weak self] event in
            switch event {
            case .reload:
                DispatchQueue.main.async {
                    self?.historyTableView.reloadData()
                }
            case .error(let error):
                print("\(error)")
                self?.showAlert(title: "Error", message: error.describe)
            }
        }
    }

    deinit {
        model.inputCase(.close)
    }
    
    private func configTextField() {
        numberTextField.borderStyle = .roundedRect
        numberTextField.keyboardType = .numberPad
        numberTextField.returnKeyType = .done
        let action = UIAction(handler: {[unowned self] action in textFieldTextChanged(text: numberTextField.text!) })
        numberTextField.addAction(action, for: .editingChanged)
        numberTextField.delegate = self
        
        model.placeholder.bind { [unowned self] text in
            DispatchQueue.main.async {
                self.numberTextField.placeholder = text
            }
        }
        model.numberText.bind { [unowned self] text in
            DispatchQueue.main.async {
                self.numberTextField.text = text
            }
        }
    }
    
    private func configureButton() {
        searchButton.orangeButton()
        randomButton.orangeButton()
    }
    
    private func configTextView() {
        infoTextView.isUserInteractionEnabled = false
        model.infoText.bind{ [unowned self] text in
            DispatchQueue.main.async {
                self.infoTextView.text = text
            }
        }
    }
    
    private func textFieldTextChanged(text: String) {
        model.inputCase(.inputTextNumber(text))
    }
    
    private func configurationTable() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.registerNib(HistoryTableViewCell.self)
        historyTableView.estimatedRowHeight = 75
        historyTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func detailVC(index: Int) {
        let itemDB = model.objectDB(index: index)
        let vc = SecondViewController.createObject()
        let model = SecondViewControllerModelView(modelDB: itemDB)
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FirstViewController {
    
    @IBAction func actionSearchButton(sender: UIButton) {
        numberTextField.resignFirstResponder()
        model.inputCase(.searchNumber)
    }
    
    @IBAction func actionRandomNumberButton(sender: UIButton) {
        numberTextField.resignFirstResponder()
        model.inputCase(.randomNumber)
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.dataSourceCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = model.objectDataSource(index: indexPath.row)
        
        switch item.type {
        
        case .history:
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HistoryTableViewCell
            if let modelCell = item.data as? HistoryTableViewCellModelView {
                cell.config(model: modelCell)
                return cell
            }
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        detailVC(index: indexPath.row)
    }
    
}

extension FirstViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
