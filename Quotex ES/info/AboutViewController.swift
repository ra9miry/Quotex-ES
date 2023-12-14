//
//  AboutViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 12.12.2023.
//

import UIKit
import SnapKit

class AboutViewController: UIViewController {
    
    private let infoMassive: InfoMassive

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(named: "tabbar")
        header.layer.cornerRadius = 20
        header.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return header
    }()

    private lazy var labelForInfoName: UILabel = {
        let label = UILabel()
        label.text = "Useful Information"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "back")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mainNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: "white")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var infoAboutMainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(named: "white")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    init(infoMassive: InfoMassive) {
        self.infoMassive = infoMassive
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupViews()
        setupConstraints()
        navigationItem.hidesBackButton = true
        updateUI()
    }

    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(labelForInfoName)
        view.addSubview(backButton)
        view.addSubview(mainNameLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(infoAboutMainImage)
        contentView.addSubview(textLabel)
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
            make.leading.equalTo(backButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-30)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(mainNameLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        infoAboutMainImage.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }

        textLabel.snp.makeConstraints() { make in
            make.top.equalTo(infoAboutMainImage.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    @objc private func backButtonTapped() {
        if let tabBarController = navigationController?.viewControllers.first(where: { $0 is TabBarViewController }) as? TabBarViewController {
            tabBarController.navigateToTab(at: 3)
            navigationController?.popToViewController(tabBarController, animated: true)
        }
    }
    
    private func updateUI() {
        mainNameLabel.text = infoMassive.description
        infoAboutMainImage.image = UIImage(named: infoMassive.imageName)
        textLabel.text = infoMassive.additionalInfo
    }
}
