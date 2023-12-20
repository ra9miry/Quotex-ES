//
//  SettingsViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 08.12.2023.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = UIColor(named: "tabbar")
        header.layer.cornerRadius = 20
        header.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return header
    }()
    
    private lazy var labelForInfoName: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.font = UIFont(name: "SFProDisplay-Bold", size: 20)
        return label
    }()
    
    private lazy var settingsMainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "set")
        imageView.image = UIImage(named: "setb")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var headerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Color Theme"
        label.textColor = UIColor(named: "price")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var darkLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark"
        label.textColor = UIColor(named: "price")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var whiteLabel: UILabel = {
        let label = UILabel()
        label.text = "White"
        label.textColor = UIColor(named: "price")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var lightThemeRadioButton: UIButton = {
        let button = createLightRadioButton()
        return button
    }()
    
    private lazy var darkThemeRadioButton: UIButton = {
        let button = createDarkRadioButton()
        return button
    }()
    
    private var isDarkThemeEnabled: Bool = false {
        didSet {
            updateTheme()
        }
    }
    
    private lazy var privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy policy"
        label.textColor = UIColor(named: "price")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 20)
        return label
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms and conditions"
        label.textColor = UIColor(named: "price")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: .didChangeTheme, object: nil)
        updateTheme()
        setupViews()
        setupConstraints()
        setupTapGestureForLabel()
        isDarkThemeEnabled = false
        lightThemeRadioButton.isSelected = true
        darkThemeRadioButton.isSelected = false
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(labelForInfoName)
        view.addSubview(settingsMainImageView)
        view.addSubview(headerNameLabel)
        view.addSubview(darkLabel)
        view.addSubview(whiteLabel)
        view.addSubview(darkThemeRadioButton)
        view.addSubview(lightThemeRadioButton)
        view.addSubview(privacyPolicyLabel)
        view.addSubview(termsLabel)
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
        
        settingsMainImageView.snp.makeConstraints() { make in
            make.top.equalTo(headerView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        headerNameLabel.snp.makeConstraints() { make in
            make.top.equalTo(settingsMainImageView.snp.top).offset(50)
            make.leading.equalTo(settingsMainImageView.snp.leading).offset(16)
        }
        
        darkLabel.snp.makeConstraints() { make in
            make.top.equalTo(headerNameLabel.snp.bottom).offset(40)
            make.leading.equalTo(settingsMainImageView.snp.leading).offset(16)
        }
        
        whiteLabel.snp.makeConstraints() { make in
            make.top.equalTo(darkLabel.snp.bottom).offset(34)
            make.leading.equalTo(settingsMainImageView.snp.leading).offset(16)
        }
        
        darkThemeRadioButton.snp.makeConstraints() { make in
            make.top.equalTo(headerNameLabel.snp.bottom).offset(34)
            make.trailing.equalTo(settingsMainImageView.snp.trailing).offset(-16)
            make.size.equalTo(34)
        }
        
        lightThemeRadioButton.snp.makeConstraints() { make in
            make.top.equalTo(darkThemeRadioButton.snp.bottom).offset(16)
            make.trailing.equalTo(settingsMainImageView.snp.trailing).offset(-16)
            make.size.equalTo(34)
        }
        
        privacyPolicyLabel.snp.makeConstraints() { make in
            make.top.equalTo(settingsMainImageView.snp.bottom).offset(100)
            make.leading.equalToSuperview().offset(16)
        }
        
        termsLabel.snp.makeConstraints() { make in
            make.top.equalTo(privacyPolicyLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func createDarkRadioButton() -> UIButton {
        let button = UIButton(type: .custom)
        let imageOff = UIImage(named: "offrad")
        let imageOn = UIImage(named: "onrad")
        
        button.setImage(imageOn, for: .normal)
        button.setImage(imageOff, for: .selected)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    private func createLightRadioButton() -> UIButton {
        let button = UIButton(type: .custom)
        let imageOff = UIImage(named: "offrad")
        let imageOn = UIImage(named: "onrad")
        
        button.setImage(imageOn, for: .normal)
        button.setImage(imageOff, for: .selected)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    private func setupTapGestureForLabel() {
        let privacyPolicyTap = UITapGestureRecognizer(target: self, action: #selector(didTapPrivacyPolicyLabel))
        privacyPolicyLabel.isUserInteractionEnabled = true
        privacyPolicyLabel.addGestureRecognizer(privacyPolicyTap)

        let termsTap = UITapGestureRecognizer(target: self, action: #selector(didTapTermsLabel))
        termsLabel.isUserInteractionEnabled = true
        termsLabel.addGestureRecognizer(termsTap)
    }
    

    @objc private func radioButtonTapped(sender: UIButton) {
        if sender == darkThemeRadioButton {
            ThemeManager.isDarkTheme = true
        } else if sender == lightThemeRadioButton {
            ThemeManager.isDarkTheme = false
        }
        updateTheme()
    }

    @objc private func updateTheme() {
        let isDarkTheme = ThemeManager.isDarkTheme
        let themeImageName = isDarkTheme ? "setb" : "set"
        settingsMainImageView.image = UIImage(named: themeImageName)
        
        let textColor = isDarkTheme ? UIColor.white : UIColor.black
        headerNameLabel.textColor = textColor
        darkLabel.textColor = textColor
        whiteLabel.textColor = textColor
        privacyPolicyLabel.textColor = textColor
        termsLabel.textColor = textColor
        
        view.backgroundColor = isDarkTheme ? .black : .white
        headerView.backgroundColor = isDarkTheme ? .darkGray : UIColor(named: "tabbar")

        lightThemeRadioButton.isSelected = !isDarkTheme
        darkThemeRadioButton.isSelected = isDarkTheme
    }

    private func setDarkTheme() {
        self.view.backgroundColor = .black
        settingsMainImageView.image = UIImage(named: "setb")
        updateLabelColors(forDarkTheme: true)
    }
    
    private func updateLabelColors(forDarkTheme isDarkTheme: Bool) {
        let textColor = isDarkTheme ? UIColor.white : UIColor(named: "price") ?? .black
        headerNameLabel.textColor = textColor
        darkLabel.textColor = textColor
        whiteLabel.textColor = textColor
        privacyPolicyLabel.textColor = textColor
        termsLabel.textColor = textColor
    }
    
    @objc private func didTapPrivacyPolicyLabel() {
        if let url = URL(string: "https://browser.yandex.ru/") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func didTapTermsLabel() {
        if let url = URL(string: "https://www.google.com/chrome/") {
            UIApplication.shared.open(url)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didChangeTheme, object: nil)
    }
}
