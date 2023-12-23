//
//  StatisticsViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 08.12.2023.
//

import UIKit
import SnapKit
import Charts
import DGCharts

class StatisticsViewController: UIViewController {
    
    var updateTimer: Timer?

    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(named: "tabbar")
        header.layer.cornerRadius = 20
        header.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return header
    }()

    private lazy var labelForInfoName: UILabel = {
        let label = UILabel()
        label.text = "Statistics"
        label.textColor = .white
        label.font = UIFont(name: "SFProDisplay-Bold", size: 20)
        return label
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
    
    var totalPortfolioBalance: Double = 0
    
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
    
    private lazy var currencyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "totalwh")
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        if let borderColor = UIColor(named: "border")?.cgColor {
            view.layer.borderColor = borderColor
        }
        return view
    }()
    
    private lazy var аllCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = "All Currency"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        return label
    }()
    
    private lazy var pieChartView: PieChartView = {
        let chartView = PieChartView()
        chartView.legend.enabled = false
        chartView.holeColor = .clear
        chartView.entryLabelColor = .black
        return chartView
    }()
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.backgroundColor = UIColor.red
        colorView.layer.cornerRadius = 6
        colorView.clipsToBounds = true
        return colorView
    }()
    
    private lazy var nameChartLabel: UILabel = {
        let label =  UILabel()
        label.text = "BTC"
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        return label
    }()
    
    private lazy var percentChartLabel: UILabel = {
        let label =  UILabel()
        label.text = "12%"
        label.textColor = UIColor(named: "price")
        label.textAlignment = .left
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        return label
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: .didChangeTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalBalanceFromNotification(_:)), name: NSNotification.Name("PortfolioDataUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePieChart), name: NSNotification.Name("CryptocurrencyListUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePieChart), name: NSNotification.Name("CryptocurrencyDataChanged"), object: nil)
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updatePieChart), userInfo: nil, repeats: true)
        NotificationCenter.default.post(name: NSNotification.Name("CryptocurrencyListUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePieChart), name: NSNotification.Name("CryptocurrencyListUpdated"), object: nil)
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatePieChart), userInfo: nil, repeats: true)
        
        setupViews()
        setupConstraints()
        setupPieChart()
        updateTotalBalance()
        updateTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        updatePieChart()
        hourMainBalancePortfolioPercent.text = PortfolioData.shared.hourPercentage
        dayMainBalancePortfolioPercent.text = PortfolioData.shared.dayPercentage
        weekMainBalancePortfolioPercent.text = PortfolioData.shared.weekPercentage
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(labelForInfoName)
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
        view.addSubview(currencyView)
        view.addSubview(аllCurrencyLabel)
        view.addSubview(pieChartView)
        view.addSubview(colorView)
        view.addSubview(nameChartLabel)
        view.addSubview(percentChartLabel)
        view.addSubview(detailsStackView)
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
        
        totalBalanceView.snp.makeConstraints() { make in
            make.top.equalTo(headerView.snp.bottom).offset(28)
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
        
        currencyView.snp.makeConstraints() { make in
            make.top.equalTo(totalBalanceView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(240)
        }
        
        аllCurrencyLabel.snp.makeConstraints() { make in
            make.top.equalTo(currencyView.snp.top).offset(16)
            make.leading.equalTo(currencyView.snp.leading).offset(16)
        }
        
        pieChartView.snp.makeConstraints() { make in
            make.top.equalTo(аllCurrencyLabel.snp.bottom).offset(18)
            make.leading.equalTo(currencyView.snp.leading).offset(16)
            make.size.equalTo(190)
        }
        
        detailsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(currencyView.snp.centerY)
            make.trailing.equalTo(currencyView.snp.trailing).offset(-30)
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
    
    private func updatePercentages() {
        let randomPercent = Double.random(in: 0...100).rounded(toPlaces: 2)
        let percentageString = String(format: "+%.2f%%", randomPercent)
    }
    
    private func updateTotalBalance() {
        totalPortfolioBalance = PortfolioViewController.cryptocurrencies.reduce(0) { (result, crypto) -> Double in
            return result + (crypto.coinPrice * crypto.quantity)
        }
        mainBalancePortfolio.text = String(format: "$%.2f", totalPortfolioBalance)
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func randomPositivePercentage() -> String {
        let randomPercent = Double.random(in: 0...100).rounded(toPlaces: 2)
        return String(format: "+%.2f%%", randomPercent)
    }

    private func randomNegativePercentage() -> String {
        let randomPercent = Double.random(in: -100...0).rounded(toPlaces: 2)
        return String(format: "%.2f%%", randomPercent)
    }
    
    class DollarValueFormatter: NSObject, ValueFormatter {
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            return "$" + String(format: "%.2f", value)
        }
    }
    
    @objc private func updateTotalBalanceFromNotification(_ notification: Notification) {
        if let totalBalance = notification.userInfo?["totalBalance"] as? Double {
            mainBalancePortfolio.text = String(format: "$%.2f", totalBalance)
            let isZeroBalance = totalBalance == 0
            hourMainBalancePortfolioPercent.text = isZeroBalance ? "0%" : randomPositivePercentage()
            dayMainBalancePortfolioPercent.text = isZeroBalance ? "0%" : randomPositivePercentage()
            weekMainBalancePortfolioPercent.text = isZeroBalance ? "0%" : randomPositivePercentage()
        }
    }
    
    private func setupPieChart() {
        var entries: [ChartDataEntry] = []

        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = ChartColorTemplates.joyful()
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
    }
    
    @objc private func updatePieChart() {
        DispatchQueue.main.async {
            let totalPortfolioValue = PortfolioViewController.cryptocurrencies.reduce(0) { (result, crypto) -> Double in
                return result + (crypto.coinPrice * crypto.quantity)
            }
            guard totalPortfolioValue > 0 else {
                self.pieChartView.data = nil
                self.pieChartView.notifyDataSetChanged()
                return
            }
            var entries: [PieChartDataEntry] = []
            for crypto in PortfolioViewController.cryptocurrencies {
                let cryptoValue = crypto.coinPrice * crypto.quantity
                let percentageOfTotal = (cryptoValue / totalPortfolioValue) * 100
                let entry = PieChartDataEntry(value: percentageOfTotal)
                entries.append(entry)
            }
            let dataSet = PieChartDataSet(entries: entries)
            dataSet.colors = ChartColorTemplates.joyful()
            dataSet.drawValuesEnabled = false
            let data = PieChartData(dataSet: dataSet)
            self.pieChartView.data = data
            self.pieChartView.notifyDataSetChanged()
            self.updateDetailsStackView()
        }
    }
    
    private func updateDetailsStackView() {
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, crypto) in PortfolioViewController.cryptocurrencies.enumerated() {
            let color = ChartColorTemplates.joyful()[index % ChartColorTemplates.joyful().count]
            let colorView = createColorView(color: color)
            let nameLabel = createNameLabel(with: crypto.name)
            let percentLabel = createPercentLabel(with: crypto)

            let container = UIStackView(arrangedSubviews: [colorView, nameLabel, percentLabel])
            container.axis = .horizontal
            container.spacing = 5
            detailsStackView.addArrangedSubview(container)
        }
    }
    
    func didUpdatePortfolio() {
        updatePieChart()
    }
    
    private func createColorView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
        return view
    }
    
    private func createNameLabel(with name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }

    private func createPercentLabel(with crypto: Cryptocurrency) -> UILabel {
        let label = UILabel()
        let percentValue = (crypto.coinPrice * crypto.quantity / totalPortfolioBalance) * 100
        label.text = String(format: "%.2f%%", percentValue)
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }
    
    @objc private func updateTheme() {
        let isDarkTheme = ThemeManager.isDarkTheme
        let textColor = isDarkTheme ? UIColor.white : UIColor.black
        let backgroundColor = isDarkTheme ? UIColor.black : UIColor.white

        view.backgroundColor = backgroundColor
        headerView.backgroundColor = UIColor(named: "tabbar")
        labelForInfoName.textColor = .white
        totalBalanceView.backgroundColor = backgroundColor
        totalBalanceLabel.textColor = textColor
        mainBalancePortfolio.textColor = textColor
        hourMainBalancePortfolioPercent.textColor = textColor
        dayMainBalancePortfolioPercent.textColor = textColor
        weekMainBalancePortfolioPercent.textColor = textColor
        staticTimeLabel.textColor = textColor
        аllCurrencyLabel.textColor = textColor
        nameChartLabel.textColor = textColor
        percentChartLabel.textColor = textColor
        currencyView.backgroundColor = backgroundColor
        pieChartView.backgroundColor = backgroundColor
        for view in detailsStackView.arrangedSubviews {
            if let stackView = view as? UIStackView {
                stackView.arrangedSubviews.forEach { subview in
                    if let label = subview as? UILabel {
                        label.textColor = textColor
                    }
                }
            }
        }
    }
}

extension StatisticsViewController: CryptoTableViewCellDelegate {
    func didUpdateCryptoData() {
        updatePieChart()
    }
}
