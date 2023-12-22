//
//  CryptoTableViewCell.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 10.12.2023.
//

import UIKit
import SnapKit

class CryptoTableViewCell: UITableViewCell {
    
    let cryptocurrencyImages: [String: String] = [
        "Bitcoin": "btc",
        "Ethereum": "eth",
        "Ripple": "xrp",
        "Litecoin": "ltc",
        "Dash": "dash",
        "Monero": "mnr",
        "NEM": "nem",
        "NEO": "neo",
        "IOTA": "iota",
        "Cardano": "crdn",
        "Polkadot": "plkdt",
        "Solana": "sln",
        "Dogecoin": "dg",
        "Chainlink": "chl",
        "Binance Coin": "bnb",
        "Tether": "th",
        "Stellar": "stlr"
    ]
    
    
    private lazy var cryptocurrencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var cryptocurrencyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "price")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var cryptocurrencyMarketLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 9)
        return label
    }()
    
    private lazy var ourCryptolabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "price")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var cryptocurrencyCrypt: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 9)
        return label
    }()
    
    private lazy var timePeriodData: [(String, Double)] = [
        ("1H", Double.random(in: -100...100)),
        ("1D", Double.random(in: -100...100)),
        ("7D", Double.random(in: -100...100))
    ]
    
    private lazy var percentLabels: [UILabel] = {
        return timePeriodData.map { data in
            let label = UILabel()
            label.text = String(format: "%.2f%%", data.1)
            label.textColor = data.1 >= 0 ? UIColor(named: "black") : UIColor(named: "black")
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        }
    }()

    private lazy var upDownImageViews: [UIImageView] = {
        return timePeriodData.map { data in
            let imageView = UIImageView()
            imageView.image = data.1 >= 0 ? UIImage(named: "up") : UIImage(named: "down")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
    }()
    
    private lazy var staticTimeLabel: UILabel = {
        let label = UILabel()
        label.text = percentLabels.map { $0.text ?? "" }.joined(separator: "\n")
        label.textColor = UIColor(named: "usd")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        label.numberOfLines = percentLabels.count
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9
        let attributedText = NSMutableAttributedString(string: label.text ?? "")
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
        return label
    }()
    
    var name: String? {
        didSet {
            cryptocurrencyNameLabel.text = name
        }
    }
    
    var market: String? {
        didSet {
            cryptocurrencyMarketLabel.text = market
        }
    }
    
    var ourCryptoPrice: String? {
        didSet {
            ourCryptolabel.text = ourCryptoPrice
        }
    }
    
    var amount: String? {
        didSet {
            cryptocurrencyCrypt.text = amount
        }
    }
    
    var image: UIImage? {
        didSet {
            cryptocurrencyImageView.image = image
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(named: "border")?.cgColor
        contentView.layer.cornerRadius = 20
        
        let borderMargin: CGFloat = 10
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: borderMargin, left: borderMargin, bottom: borderMargin, right: borderMargin))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(cryptocurrencyImageView)
        contentView.addSubview(cryptocurrencyNameLabel)
        contentView.addSubview(cryptocurrencyMarketLabel)
        contentView.addSubview(ourCryptolabel)
        contentView.addSubview(cryptocurrencyCrypt)
        
        percentLabels.forEach { label in
            contentView.addSubview(label)
        }
        
        upDownImageViews.forEach { imageView in
            contentView.addSubview(imageView)
        }
        
        contentView.addSubview(staticTimeLabel)
    }
    
    private func setupConstraints() {
        cryptocurrencyImageView.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        cryptocurrencyNameLabel.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(cryptocurrencyImageView.snp.trailing).offset(8)
        }
        
        cryptocurrencyMarketLabel.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        ourCryptolabel.snp.makeConstraints() { make in
            make.center.equalToSuperview()
        }
        
        cryptocurrencyCrypt.snp.makeConstraints() { make in
            make.top.equalTo(ourCryptolabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        for i in 0..<percentLabels.count {
            percentLabels[i].snp.makeConstraints() { make in
                make.trailing.equalTo(upDownImageViews[i].snp.leading).offset(-8)
                make.top.equalToSuperview().offset(14 + i * 18)
            }
            
            upDownImageViews[i].snp.makeConstraints() { make in
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalTo(percentLabels[i])
                make.width.height.equalTo(12)
            }
        }
    }
    
    private func createUpImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "up")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func configure(with cryptocurrency: Cryptocurrency) {
        if let imageName = cryptocurrencyImages[cryptocurrency.name] {
            self.cryptocurrencyImageView.image = UIImage(named: imageName)
        } else {
            self.cryptocurrencyImageView.image = UIImage(named: "default_crypto_image")
        }
        self.cryptocurrencyNameLabel.text = cryptocurrency.name
        self.cryptocurrencyMarketLabel.text = "Binance"
        
        let totalHoldingValue = cryptocurrency.coinPrice * cryptocurrency.quantity
        self.ourCryptolabel.text = String(format: "$%.2f", totalHoldingValue)

        self.cryptocurrencyCrypt.text = String(format: "%.6f", cryptocurrency.quantity)
        updatePercentagesAndImages()
        updateTheme()
    }

    
    private func updatePercentagesAndImages() {
        for i in 0..<timePeriodData.count {
            let data = timePeriodData[i]
            percentLabels[i].text = String(format: "%.2f%%", data.1)
            percentLabels[i].textColor = data.1 >= 0 ? UIColor(named: "positiveColor") : UIColor(named: "negativeColor")
            upDownImageViews[i].image = data.1 >= 0 ? UIImage(named: "up") : UIImage(named: "down")
        }
    }
    
    func updateTheme() {
        let isDarkTheme = ThemeManager.isDarkTheme

        let textColor = isDarkTheme ? UIColor.white : UIColor.black
        let cellBackgroundColor = isDarkTheme ? UIColor.black : UIColor.white
        let borderColor = isDarkTheme ? UIColor.white.cgColor : UIColor.black.cgColor

        contentView.backgroundColor = cellBackgroundColor
        cryptocurrencyNameLabel.textColor = textColor
        cryptocurrencyMarketLabel.textColor = textColor
        ourCryptolabel.textColor = textColor
        cryptocurrencyCrypt.textColor = textColor
        staticTimeLabel.textColor = textColor

        percentLabels.forEach { label in
            label.textColor = textColor
        }
        
        for imageView in upDownImageViews {
            imageView.tintColor = textColor
        }
        contentView.layer.borderColor = borderColor
        backgroundColor = cellBackgroundColor
    }

}
