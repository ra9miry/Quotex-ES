//
//  AddViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 13.12.2023.
//

import UIKit
import SnapKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var onSave: ((Cryptocurrency) -> Void)?

    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(named: "tabbar")
        header.layer.cornerRadius = 20
        header.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return header
    }()

    private lazy var labelForInfoName: UILabel = {
        let label = UILabel()
        label.text = "Portfolio"
        label.textColor = .white
        label.font = UIFont(name: "SFProDisplay-Bold", size: 20)
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "bb")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mainNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Add to Portfolio"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 20)
        return label
    }()
    
    private lazy var addView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "totalwh")
        view.layer.borderColor = UIColor(named: "border")?.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var addCurrencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Currency"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Coin Price"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var purchasePriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Purchase Price"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Quantity"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Date"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private let cryptocurrencies = ["Bitcoin", "Ethereum", "Ripple", "Litecoin", "Dash", "Monero", "NEM", "NEO", "IOTA", "Cardano", "Polkadot", "Solana", "Dogecoin", "Chainlink", "Binance Coin", "Tether", "Stellar"]
    
    private lazy var currencyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select currency"
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "usd")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .right
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        let dropdownImage = UIImage(systemName: "chevron.down")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10))
        let dropdownImageView = UIImageView(image: dropdownImage)
        dropdownImageView.contentMode = .scaleAspectFit
        dropdownImageView.tintColor = .gray
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always

        return textField
    }()

    private lazy var coinPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Loading price..."
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "usd")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .right
        textField.isEnabled = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.rightView = paddingView
        textField.rightViewMode = .always 
        return textField
    }()

    private lazy var purchaseTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "usd")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.inputViewController?.dismissKeyboard()
        textField.keyboardType = .numberPad
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.rightView = paddingView
        textField.rightViewMode = .always 
        return textField
    }()

    private lazy var quantityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "usd")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.inputViewController?.dismissKeyboard()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.rightView = paddingView
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        textField.leftViewMode = .always
        return textField
    }()

    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "usd")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.inputViewController?.dismissKeyboard()
        let imageView = UIImageView(image: UIImage(named: "date"))
        imageView.contentMode = .right
        let imageWidth: CGFloat = 10
        let imageHeight: CGFloat = 12
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 10, height: imageHeight))
        textField.rightView?.addSubview(imageView)
        textField.rightView?.addSubview(rightPaddingView)
        textField.rightViewMode = .always
        return textField
    }()


    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(UIColor(named: "white"), for: .normal   )
        button.backgroundColor = UIColor(named: "qbutton")
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: .didChangeTheme, object: nil)
        saveButton.isEnabled = false
        setupViews()
        setupConstraints()
        dateTextField.inputView = datePicker
        datePicker.maximumDate = Date()
        updateTheme()
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(labelForInfoName)
        view.addSubview(backButton)
        view.addSubview(mainNameLabel)
        view.addSubview(addView)
        view.addSubview(addCurrencyLabel)
        view.addSubview(coinPriceLabel)
        view.addSubview(purchasePriceLabel)
        view.addSubview(quantityLabel)
        view.addSubview(dateLabel)
        view.addSubview(currencyTextField)
        view.addSubview(coinPriceTextField)
        view.addSubview(purchaseTextField)
        view.addSubview(quantityTextField)
        view.addSubview(dateTextField)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints() { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(115)
        }
        
        labelForInfoName.snp.makeConstraints() { make in
            make.top.equalTo(headerView.snp.top).offset(66)
            make.centerX.equalTo(headerView.snp.centerX)
        }
        
        backButton.snp.makeConstraints() { make in
            make.top.equalTo(headerView.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(30)
        }
        
        mainNameLabel.snp.makeConstraints() { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        addView.snp.makeConstraints() { make in
            make.top.equalTo(mainNameLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(343)
            make.height.equalTo(400)
        }
            
        addCurrencyLabel.snp.makeConstraints() { make in
            make.top.equalTo(addView.snp.top).offset(48)
            make.leading.equalTo(addView.snp.leading).offset(16)
        }
        
        currencyTextField.snp.makeConstraints() { make in
            make.top.equalTo(addView.snp.top).offset(36)
            make.trailing.equalTo(addView.snp.trailing).offset(-16)
            make.width.equalTo(213)
            make.height.equalTo(38)
        }
        
        coinPriceLabel.snp.makeConstraints() { make in
            make.top.equalTo(addCurrencyLabel.snp.bottom).offset(41)
            make.leading.equalTo(addView.snp.leading).offset(16)
        }
        
        coinPriceTextField.snp.makeConstraints() { make in
            make.top.equalTo(currencyTextField.snp.bottom).offset(20)
            make.trailing.equalTo(addView.snp.trailing).offset(-16)
            make.width.equalTo(213)
            make.height.equalTo(38)
        }
        
        purchasePriceLabel.snp.makeConstraints() { make in
            make.top.equalTo(coinPriceLabel.snp.bottom).offset(41)
            make.leading.equalTo(addView.snp.leading).offset(16)
        }
        
        purchaseTextField.snp.makeConstraints() { make in
            make.top.equalTo(coinPriceTextField.snp.bottom).offset(20)
            make.trailing.equalTo(addView.snp.trailing).offset(-16)
            make.width.equalTo(213)
            make.height.equalTo(38)
        }
        
        quantityLabel.snp.makeConstraints() { make in
            make.top.equalTo(purchasePriceLabel.snp.bottom).offset(41)
            make.leading.equalTo(addView.snp.leading).offset(16)
        }
        
        quantityTextField.snp.makeConstraints() { make in
            make.top.equalTo(purchaseTextField.snp.bottom).offset(20)
            make.trailing.equalTo(addView.snp.trailing).offset(-16)
            make.width.equalTo(213)
            make.height.equalTo(38)
        }
            
        dateLabel.snp.makeConstraints() { make in
            make.top.equalTo(quantityLabel.snp.bottom).offset(41)
            make.leading.equalTo(addView.snp.leading).offset(16)
        }
        
        dateTextField.snp.makeConstraints() { make in
            make.top.equalTo(quantityTextField.snp.bottom).offset(20)
            make.trailing.equalTo(addView.snp.trailing).offset(-16)
            make.width.equalTo(213)
            make.height.equalTo(38)
        }
        
        saveButton.snp.makeConstraints() { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(28)
            make.leading.equalTo(addView.snp.leading).offset(16)
            make.trailing.equalTo(addView.snp.trailing).offset(-16)
            make.height.equalTo(52)
        }
    }
    
    @objc private func backButtonTapped() {
        if let tabBarController = navigationController?.viewControllers.first(where: { $0 is TabBarViewController }) as? TabBarViewController {
            tabBarController.navigateToTab(at: 0)
            navigationController?.popToViewController(tabBarController, animated: true)
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let currencyName = currencyTextField.text, !currencyName.isEmpty else {
            showAlert(message: "Currency name is required.")
            return
        }

        guard let coinPriceString = coinPriceTextField.text?.replacingOccurrences(of: "$", with: ""),
              let coinPrice = Double(coinPriceString) else {
            showAlert(message: "Invalid coin price.")
            return
        }

        guard let purchasePriceString = purchaseTextField.text,
              let purchasePrice = Double(purchasePriceString) else {
            showAlert(message: "Purchase price is not valid.")
            return
        }

        guard let quantityString = quantityTextField.text,
              let quantity = Double(quantityString) else {
            showAlert(message: "Quantity is not valid.")
            return
        }

        guard let purchaseDateString = dateTextField.text, !purchaseDateString.isEmpty,
              let purchaseDate = dateFormatter.date(from: purchaseDateString) else {
            showAlert(message: "Date is required or format is incorrect.")
            return
        }

        let imageName = determineImageName(for: currencyName)
        let cryptocurrency = Cryptocurrency(name: currencyName, coinPrice: coinPrice, purchasePrice: purchasePrice, quantity: quantity, purchaseDate: purchaseDate, imageName: imageName)

        onSave?(cryptocurrency)
        navigationController?.popViewController(animated: true)
        showAlertWithDismiss(message: "Cryptocurrency has been successfully added to your portfolio.")
    }
    
    private func showAlertWithDismiss(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    private func determineImageName(for currencyName: String) -> String {
        return "default_crypto_image"
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    struct CryptoPriceResponse: Decodable {
        let bitcoin: PriceData?
        let ethereum: PriceData?

        struct PriceData: Decodable {
            let usd: Double?
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = formatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return cryptocurrencies.count
        }
        
        // MARK: UIPickerViewDelegate
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return cryptocurrencies[row]
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = cryptocurrencies[row]
        currencyTextField.text = selectedCurrency
        fetchPrice(for: selectedCurrency)
        dismissKeyboard()
    }


    func fetchPrice(for currency: String) {
        let currencyId = mapCurrencyToId(currency: currency)
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(currencyId)&vs_currencies=usd"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for currency: \(currency)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            do {
                let priceResponse = try JSONDecoder().decode([String: CryptoPriceResponse.PriceData].self, from: data)
                if let priceData = priceResponse[currencyId], let price = priceData.usd {
                    DispatchQueue.main.async {
                        self?.coinPriceTextField.text = String(format: "$%.2f", price)
                        self?.saveButton.isEnabled = true
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }

        task.resume()
    }

    func mapCurrencyToId(currency: String) -> String {
        switch currency.lowercased() {
        case "bitcoin": return "bitcoin"
        case "ethereum": return "ethereum"
        default: return currency.lowercased()
        }
    }
    
    @objc private func updateTheme() {
        let isDarkTheme = ThemeManager.isDarkTheme

        let textColor = isDarkTheme ? UIColor.white : UIColor.black
        let backgroundColor = isDarkTheme ? UIColor.black : UIColor.white
        let backButtonImageName = isDarkTheme ? "back" : "bb"
        let backButtonImage = UIImage(named: backButtonImageName)
        backButton.setImage(backButtonImage, for: .normal)

        view.backgroundColor = backgroundColor
        headerView.backgroundColor = UIColor(named: "tabbar")
        labelForInfoName.textColor = .white
        addView.backgroundColor = backgroundColor
        mainNameLabel.textColor = textColor
        addCurrencyLabel.textColor = textColor
        coinPriceLabel.textColor = textColor
        purchasePriceLabel.textColor = textColor
        quantityLabel.textColor = textColor
        dateLabel.textColor = textColor
        currencyTextField.textColor = textColor
        coinPriceTextField.textColor = textColor
        purchaseTextField.textColor = textColor
        quantityTextField.textColor = textColor
        dateTextField.textColor = textColor
    }

}
