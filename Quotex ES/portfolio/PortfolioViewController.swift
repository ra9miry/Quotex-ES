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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var usdWalletLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var addCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Currency"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var plusAddCurrencyButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
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
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var mainBalancePortfolio: UILabel = {
        let label = UILabel()
        label.text = "$23.456,44"
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var hourMainBalancePortfolioPercent: UILabel = {
        let label = UILabel()
        label.text = "+20,50%"
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var dayMainBalancePortfolioPercent: UILabel = {
        let label = UILabel()
        label.text = "+50,50%"
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var weekMainBalancePortfolioPercent: UILabel = {
        let label = UILabel()
        label.text = "+125,50%"
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 12)
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
        label.font = UIFont.systemFont(ofSize: 12)
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
    
    private lazy var allTimeMainLabel: UILabel = {
        let label = UILabel()
        label.text = "All Time"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var allUpTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 5 654, 63 %"
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var allDownTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "- 150, 50 %"
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var cryptoTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 81
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: "CryptoCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "totalwh")
        return tableView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupViews()
        setupConstraints()
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cryptoTableView.reloadData()
        updateTotalBalance()
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
        view.addSubview(allTimeMainLabel)
        view.addSubview(allUpTimeLabel)
        view.addSubview(allDownTimeLabel)
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
            make.top.equalTo(mainBalancePortfolio.snp.bottom).offset(20)
            make.leading.equalTo(totalBalanceView.snp.leading).offset(16)
            make.trailing.equalTo(totalBalanceView.snp.trailing).offset(-16)
        }
        
        allTimeMainLabel.snp.makeConstraints() { make in
            make.top.equalTo(mainBalancePortfolio.snp.bottom).offset(30)
            make.leading.equalTo(totalBalanceView.snp.leading).offset(16)
        }
        
        allUpTimeLabel.snp.makeConstraints() { make in
            make.top.equalTo(mainBalancePortfolio.snp.bottom).offset(30)
            make.leading.equalTo(allTimeMainLabel.snp.trailing).offset(120)
        }
        
        allDownTimeLabel.snp.makeConstraints() { make in
            make.top.equalTo(mainBalancePortfolio.snp.bottom).offset(30)
            make.trailing.equalTo(downImageViewAllTime.snp.leading).offset(0)
        }
        
        downImageViewAllTime.snp.makeConstraints() { make in
            make.trailing.equalTo(totalBalanceView.snp.trailing).offset(-16)
            make.centerY.equalTo(allDownTimeLabel.snp.centerY)
            make.width.height.equalTo(12)
        }
        
        upImageViewAllTime.snp.makeConstraints() { make in
            make.leading.equalTo(allUpTimeLabel.snp.trailing).offset(0)
            make.centerY.equalTo(allUpTimeLabel.snp.centerY)
            make.width.height.equalTo(12)
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
        updateMainBalancePortfolio()
        cryptoTableView.reloadData()
    }

    private func updateMainBalancePortfolio() {
        let totalBalance = PortfolioViewController.cryptocurrencies.reduce(0) { $0 + ($1.purchasePrice * $1.quantity) }
        mainBalancePortfolio.text = String(format: "$%.2f", totalBalance)
    }

    private func setupAddButton() {
        plusAddCurrencyButton.addTarget(self, action: #selector(plusAddCurrencyButtonTapped), for: .touchUpInside)
    }

    @objc private func plusAddCurrencyButtonTapped() {
        let addVC = AddViewController()

        // Here we're setting the closure that will be called when the user saves the cryptocurrency
        addVC.onSave = { [weak self] newCryptocurrency in
            PortfolioViewController.cryptocurrencies.append(newCryptocurrency)
            self?.updateTotalBalance()
            self?.cryptoTableView.reloadData()
        }

        navigationController?.pushViewController(addVC, animated: true)
    }

    private func addNewCryptocurrency(_ cryptocurrency: Cryptocurrency) {
        PortfolioViewController.cryptocurrencies.append(cryptocurrency)
        updateTotalBalance()
        cryptoTableView.reloadData()
    }

    private func updateTotalBalance() {
        let totalBalance = PortfolioViewController.cryptocurrencies.reduce(0) { (result, crypto) -> Double in
            return result + (crypto.purchasePrice * crypto.quantity)
        }
        mainBalancePortfolio.text = String(format: "$%.2f", totalBalance)
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
        cell.configure(with: UIImage(named: "btc"),
                       name: cryptocurrency.name,
                       market: "Binance",
                       price: String(format: "$%.2f", cryptocurrency.coinPrice),
                       ourCryptoPrice: String(format: "$%.2f", cryptocurrency.purchasePrice),
                       amount: String(format: "%.6f", cryptocurrency.quantity))
        let cryptocurrencyImage = UIImage(named: "btc")
        let cryptoMarket = "Binance"
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(named: "totalwh")
        cell.selectedBackgroundView = selectedBackgroundView
        
        cell.contentView.backgroundColor = UIColor(named: "totalwh")
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 2
        if let borderColor = UIColor(named: "border")?.cgColor {
            cell.contentView.layer.borderColor = borderColor
        }
        cell.backgroundColor = UIColor(named: "totalwh")
        cell.contentView.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        return cell
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
}
