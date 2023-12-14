//  InfoTableViewCell.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 09.12.2023.
//

import UIKit
import SnapKit

class InfoTableViewCell: UITableViewCell {

    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private lazy var infoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        contentView.addSubview(infoImageView)
        contentView.addSubview(infoDescriptionLabel)
    }

    private func setupConstraints() {
        infoImageView.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
            make.width.equalTo(132)
            make.height.equalTo(110)
        }

        infoDescriptionLabel.snp.makeConstraints() { make in
            make.leading.equalTo(infoImageView.snp.trailing).offset(16)
            make.top.bottom.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(with infoItem: InfoItem) {
        infoImageView.image = UIImage(named: infoItem.imageName)
        infoDescriptionLabel.text = infoItem.description
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }

}
