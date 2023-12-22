    //
    //  PortfolioViewController.swift
    //  Quotex ES
    //
    //  Created by Радмир Тельман on 10.12.2023.
    //

    import UIKit
    import SnapKit

    class PortfolioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        static var cryptocurrencies: [Cryptocurrency] = []
        
        // MARK: - UI Components
        
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
            label.font = UIFont(name: "SFProDisplay-Regular", size: 20)
            return label
        }()
        
        private lazy var usdWalletLabel: UILabel = {
            let label = UILabel()
            label.text = "USD"
            label.textColor = UIColor(named: "usd")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 20)

            return label
        }()
        
        private lazy var addCurrencyLabel: UILabel = {
            let label = UILabel()
            label.text = "Add Currency"
            label.textColor = UIColor(named: "usd")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
            return label
        }()
        
        private lazy var plusAddCurrencyButton: UIButton = {
            let button = UIButton()
            let image = UIImage(named: "plus")
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            button.addTarget(self, action: #selector(plusAddCurrencyButtonTapped), for: .touchUpInside)
            return button
        }()
        
        private lazy var totalBalanceView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(named: "totalwh")
            view.layer.borderWidth = 2
            if let borderColor = UIColor(named: "border")?.cgColor {
                view.layer.borderColor = borderColor
            }
            view.layer.cornerRadius = 20
            return view
        }()
        
        private lazy var totalBalanceLabel: UILabel = {
            let label = UILabel()
            label.text = "Total balance"
            label.textColor = UIColor(named: "usd")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
            return label
        }()
        
        private lazy var mainBalancePortfolio: UILabel = {
            let label = UILabel()
            label.text = ""
            label.textColor = UIColor(named: "price")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 20)
            return label
        }()
        
        private lazy var hourMainBalancePortfolioPercent: UILabel = {
            let label = UILabel()
            label.text = randomPositivePercentage()
            label.textColor = UIColor(named: "price")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
            return label
        }()
        
        private lazy var dayMainBalancePortfolioPercent: UILabel = {
            let label = UILabel()
            label.text = randomPositivePercentage()
            label.textColor = UIColor(named: "price")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
            return label
        }()
        
        private lazy var weekMainBalancePortfolioPercent: UILabel = {
            let label = UILabel()
            label.text = randomPositivePercentage()
            label.textColor = UIColor(named: "price")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
            return label
        }()
                
        private lazy var upImageViewHour: UIImageView = createUpImageView()
        private lazy var upImageViewDay: UIImageView = createUpImageView()
        private lazy var upImageViewWeek: UIImageView = createUpImageView()
        private lazy var upImageViewAllTime: UIImageView = createUpImageView()
        
        private lazy var downImageViewAllTime: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "down")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private lazy var downImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "down")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private lazy var staticTimeLabel: UILabel = {
            let label = UILabel()
            label.text = "1H\n1D\n7D"
            label.textColor = UIColor(named: "usd")
            label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
            label.numberOfLines = 3
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 9
            let attributedText = NSMutableAttributedString(string: label.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            label.attributedText = attributedText
            return label
        }()
        
        private lazy var progressIndicatorImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "indicator")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private lazy var cryptoTableView: UITableView = {
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 81
            tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: "CryptoCell")
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            return tableView
        }()
        
        var isDarkModeEnabled: Bool = false {
            didSet {
                updateTheme()
            }
        }
        
        // MARK: - View Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.white
            NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: .didChangeTheme, object: nil)
            
            setupViews()
            setupConstraints()
            setupAddButton()
            loadCryptocurrencies()
            updateTheme()
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            cryptoTableView.reloadData()
            updateTotalBalance()
            saveCryptocurrencies()
        }
        
        // MARK: - Setup
        
        private func setupViews() {
            view.addSubview(headerView)
            view.addSubview(labelForInfoName)
            view.addSubview(usdWalletLabel)
            view.addSubview(addCurrencyLabel)
            view.addSubview(plusAddCurrencyButton)
            view.addSubview(totalBalanceView)
            view.addSubview(totalBalanceLabel)
            view.addSubview(mainBalancePortfolio)
            view.addSubview(hourMainBalancePortfolioPercent)
            view.addSubview(dayMainBalancePortfolioPercent)
            view.addSubview(weekMainBalancePortfolioPercent)
            view.addSubview(upImageViewHour)
            view.addSubview(upImageViewDay)
            view.addSubview(upImageViewWeek)
            view.addSubview(downImageView)
            view.addSubview(staticTimeLabel)
            view.addSubview(upImageViewAllTime)
            view.addSubview(downImageViewAllTime)
            view.addSubview(progressIndicatorImage)
            view.addSubview(cryptoTableView)
        }
        
        
        private func setupConstraints() {
            headerView.snp.makeConstraints() { make in
                make.top.equalToSuperview().offset(0)
                make.leading.trailing.equalToSuperview().offset(0)
                make.height.equalTo(115)
            }
            
            labelForInfoName.snp.makeConstraints() { make in
                make.top.equalTo(headerView.snp.top).offset(66)
                make.centerX.equalTo(headerView.snp.centerX)
            }
            
            usdWalletLabel.snp.makeConstraints() { make in
                make.top.equalTo(headerView.snp.bottom).offset(28)
                make.leading.equalToSuperview().offset(16)
            }
            
            addCurrencyLabel.snp.makeConstraints() { make in
                make.top.equalTo(headerView.snp.bottom).offset(40)
                make.leading.equalTo(usdWalletLabel.snp.trailing).offset(189)
            }
            
            plusAddCurrencyButton.snp.makeConstraints() { make in
                make.top.equalTo(headerView.snp.bottom).offset(24)
                make.leading.equalTo(addCurrencyLabel.snp.trailing).offset(0)
                make.trailing.equalToSuperview().offset(-16)
            }
            
            totalBalanceView.snp.makeConstraints() { make in
                make.top.equalTo(addCurrencyLabel.snp.bottom).offset(28)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.width.equalTo(343)
                make.height.equalTo(119)
            }
            
            totalBalanceLabel.snp.makeConstraints() { make in
                make.top.equalTo(totalBalanceView.snp.top).offset(16)
                make.leading.equalTo(totalBalanceView.snp.leading).offset(16)
            }
            
            mainBalancePortfolio.snp.makeConstraints() { make in
                make.top.equalTo(totalBalanceLabel.snp.bottom).offset(8)
                make.leading.equalTo(totalBalanceView.snp.leading).offset(16)
            }
            
            hourMainBalancePortfolioPercent.snp.makeConstraints() { make in
                make.trailing.equalTo(upImageViewHour.snp.leading).offset(-8)
                make.top.equalTo(totalBalanceView.snp.top).offset(16)
            }
            
            dayMainBalancePortfolioPercent.snp.makeConstraints() { make in
                make.trailing.equalTo(upImageViewDay.snp.leading).offset(-8)
                make.top.equalTo(hourMainBalancePortfolioPercent.snp.bottom).offset(9)
            }
            
            weekMainBalancePortfolioPercent.snp.makeConstraints() { make in
                make.trailing.equalTo(upImageViewWeek.snp.leading).offset(-8)
                make.top.equalTo(dayMainBalancePortfolioPercent.snp.bottom).offset(9)
            }
            
            configureUpImageViewConstraints(upImageView: upImageViewHour, relativeTo: hourMainBalancePortfolioPercent)
            configureUpImageViewConstraints(upImageView: upImageViewDay, relativeTo: dayMainBalancePortfolioPercent)
            configureUpImageViewConstraints(upImageView: upImageViewWeek, relativeTo: weekMainBalancePortfolioPercent)
            
            staticTimeLabel.snp.makeConstraints() { make in
                make.top.equalTo(totalBalanceView.snp.top).offset(16)
                make.trailing.equalTo(totalBalanceView.snp.trailing).offset(-16)
                make.height.greaterThanOrEqualTo(10 * 3 + 9 * 2)
            }
            
            progressIndicatorImage.snp.makeConstraints() { make in
                make.top.equalTo(mainBalancePortfolio.snp.bottom).offset(30)
                make.leading.equalTo(totalBalanceView.snp.leading).offset(16)
                make.trailing.equalTo(totalBalanceView.snp.trailing).offset(-16)
            }
            
            cryptoTableView.snp.makeConstraints() { make in
                make.top.equalTo(totalBalanceView.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.height.equalTo(500)
            }
        }
        
        // MARK: - Actions

        private func addCryptocurrency(_ cryptocurrency: Cryptocurrency) {
            PortfolioViewController.cryptocurrencies.append(cryptocurrency)
            updateTotalBalance()
            cryptoTableView.reloadData()
        }

        private func setupAddButton() {
            plusAddCurrencyButton.addTarget(self, action: #selector(plusAddCurrencyButtonTapped), for: .touchUpInside)
        }
        
        private func randomPositivePercentage() -> String {
            let randomPercent = Double.random(in: 0...100).rounded(toPlaces: 2)
            return String(format: "+%.2f%%", randomPercent)
        }

        private func randomNegativePercentage() -> String {
            let randomPercent = Double.random(in: -100...0).rounded(toPlaces: 2)
            return String(format: "%.2f%%", randomPercent)
        }

        @objc private func plusAddCurrencyButtonTapped() {
            let addVC = AddViewController()
            addVC.onSave = { [weak self] newCryptocurrency in
                PortfolioViewController.cryptocurrencies.append(newCryptocurrency)
                self?.updateTotalBalance()
                self?.cryptoTableView.reloadData()
            }
            navigationController?.pushViewController(addVC, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("CryptocurrencyListUpdated"), object: nil)
        }

        private func addNewCryptocurrency(_ cryptocurrency: Cryptocurrency) {
            PortfolioViewController.cryptocurrencies.append(cryptocurrency)
            updateTotalBalance()
            cryptoTableView.reloadData()
        }

        private func updateTotalBalance() {
            let totalBalance = PortfolioViewController.cryptocurrencies.reduce(0) { (result, crypto) -> Double in
                return result + Double((crypto.purchasePrice * crypto.quantity))
            }
            mainBalancePortfolio.text = String(format: "$%.2f", totalBalance)

            if totalBalance == 0 {
                hourMainBalancePortfolioPercent.text = "0%"
                dayMainBalancePortfolioPercent.text = "0%"
                weekMainBalancePortfolioPercent.text = "0%"
            } else {
                hourMainBalancePortfolioPercent.text = randomPositivePercentage()
                dayMainBalancePortfolioPercent.text = randomPositivePercentage()
                weekMainBalancePortfolioPercent.text = randomPositivePercentage()
            }
            NotificationCenter.default.post(name: NSNotification.Name("PortfolioDataUpdated"), object: nil, userInfo: ["totalBalance": totalBalance])
        }
        
        private func saveCryptocurrencies() {
            do {
                let encoder = JSONEncoder()
                let encodedData = try encoder.encode(PortfolioViewController.cryptocurrencies)
                UserDefaults.standard.set(encodedData, forKey: "cryptocurrencies")
            } catch {
                print("Failed to encode cryptocurrencies: \(error.localizedDescription)")
            }
        }
        private func loadCryptocurrencies() {
            if let data = UserDefaults.standard.data(forKey: "cryptocurrencies") {
                do {
                    let decoder = JSONDecoder()
                    let cryptocurrencies = try decoder.decode([Cryptocurrency].self, from: data)
                    PortfolioViewController.cryptocurrencies = cryptocurrencies
                } catch {
                    print("Failed to decode cryptocurrencies: \(error.localizedDescription)")
                }
            }
        }

        // MARK: - Helper Functions
        
        private func createUpImageView() -> UIImageView {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "up")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
        
        private func configureUpImageViewConstraints(upImageView: UIImageView, relativeTo label: UIView) {
            upImageView.snp.makeConstraints() { make in
                make.trailing.equalTo(staticTimeLabel.snp.leading).offset(-8)
                make.centerY.equalTo(label.snp.centerY)
                make.width.height.equalTo(12)
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoTableViewCell else {
                return UITableViewCell()
            }
            
            let cryptocurrency = PortfolioViewController.cryptocurrencies[indexPath.row]
            cell.configure(with: cryptocurrency)
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor(named: "black")
            cell.selectedBackgroundView = selectedBackgroundView
            cell.contentView.layer.cornerRadius = 20
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            if let borderColor = UIColor(named: "border")?.cgColor {
                cell.contentView.layer.borderColor = borderColor
            }
            cell.updateTheme()
            return cell
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                PortfolioViewController.cryptocurrencies.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)

                updateTotalBalance()
                saveCryptocurrencies()
            }
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return PortfolioViewController.cryptocurrencies.count
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
        @objc private func updateTheme() {
            let isDarkTheme = ThemeManager.isDarkTheme
            let textColorDarkTheme = UIColor.white
            let textColorLightTheme = UIColor.black
            let cellBackgroundColor = isDarkTheme ? UIColor.black : UIColor.white

            view.backgroundColor = isDarkTheme ? UIColor(named: "black") : UIColor(named: "white")
            headerView.backgroundColor = UIColor(named: "tabbar")
            usdWalletLabel.textColor = isDarkTheme ? textColorDarkTheme : textColorLightTheme
            addCurrencyLabel.textColor = isDarkTheme ? textColorDarkTheme : textColorLightTheme
            totalBalanceLabel.textColor = isDarkTheme ? textColorDarkTheme : textColorLightTheme

            totalBalanceView.backgroundColor = isDarkTheme ? UIColor(named: "backDark") : UIColor(named: "backLight")
            mainBalancePortfolio.textColor = isDarkTheme ? textColorDarkTheme : textColorLightTheme
            hourMainBalancePortfolioPercent.textColor = isDarkTheme ? textColorDarkTheme : textColorLightTheme
            dayMainBalancePortfolioPercent.textColor = isDarkTheme ? textColorDarkTheme : textColorLightTheme
            weekMainBalancePortfolioPercent.textColor = isDarkTheme ? textColorDarkTheme : textColorLightTheme
            
            staticTimeLabel.textColor = UIColor(named: "usd")
            cryptoTableView.backgroundColor = isDarkTheme ? UIColor.black : UIColor.white
            cryptoTableView.reloadData()
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                ThemeManager.isDarkTheme = (self.traitCollection.userInterfaceStyle == .dark)
                updateTheme()
            }
        }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
