//
//  CryptoTableViewCell.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 10.12.2023.
//

import UIKit
import SnapKit

class CryptoTableViewCell: UITableViewCell {

    private lazy var cryptocurrencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var cryptocurrencyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private lazy var cryptocurrencyMarketLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()

    private lazy var cryptocurrencyPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    private lazy var ourCryptolabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "price")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var cryptocurrencyCrypt: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()

    private lazy var timePeriodData: [(String, String)] = [
        ("1H", "+20,50%"),
        ("1D", "+50,50%"),
        ("7D", "+125,50%")
    ]

    private lazy var percentLabels: [UILabel] = {
        return timePeriodData.map { data in
            let label = UILabel()
            label.text = data.1
            label.textColor = UIColor(named: "price")
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        }
    }()

    private lazy var upImageViews: [UIImageView] = {
        return timePeriodData.map { _ in
            return createUpImageView()
        }
    }()

    private lazy var staticTimeLabel: UILabel = {
        let label = UILabel()
        label.text = percentLabels.map { $0.text ?? "" }.joined(separator: "\n")
        label.textColor = UIColor(named: "usd")
        label.font = UIFont.systemFont(ofSize: 12)
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

    var price: String? {
        didSet {
            cryptocurrencyPriceLabel.text = price
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
        contentView.addSubview(cryptocurrencyPriceLabel)
        contentView.addSubview(ourCryptolabel)
        contentView.addSubview(cryptocurrencyCrypt)

        percentLabels.forEach { label in
            contentView.addSubview(label)
        }

        upImageViews.forEach { imageView in
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

        cryptocurrencyPriceLabel.snp.makeConstraints() { make in
            make.top.equalTo(cryptocurrencyNameLabel.snp.bottom).offset(6)
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
                make.leading.equalTo(ourCryptolabel.snp.trailing).offset(40)
                make.top.equalToSuperview().offset(14 + i * 18)
            }

            upImageViews[i].snp.makeConstraints() { make in
                make.leading.equalTo(percentLabels[i].snp.trailing).offset(8)
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
    
    func configure(with image: UIImage?, name: String, market: String, price: String, ourCryptoPrice: String, amount: String) {
        self.image = image
        self.name = name
        self.market = market
        self.price = "\(price)"
        self.ourCryptoPrice = "\(ourCryptoPrice)"
        self.amount = "\(amount)"
    }
}
