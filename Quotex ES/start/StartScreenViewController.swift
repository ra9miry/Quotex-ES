//
//  StartScreenViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 08.12.2023.
//

import UIKit
import SnapKit

class StartScreenViewController: UIViewController {

    private lazy var logoInStartScreenImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "logo")
        return image
    }()

    private lazy var loadingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = UIColor.white
        label.font = UIFont(name: "SFProDisplay-Regular", size: 20)
        label.textAlignment = .center
        return label
    }()

    private lazy var loadingNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "qbutton")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private var loadingProgress: Float = 0.0
    private var loadingTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "back")

        setupViews()
        setupConstraints()
        startLoadingAnimation()
        navigationItem.hidesBackButton = true
    }

    private func setupViews() {
        view.addSubview(logoInStartScreenImageView)
        view.addSubview(loadingTextLabel)
        view.addSubview(loadingNumberLabel)
        view.addSubview(continueButton)
    }

    private func setupConstraints() {
        logoInStartScreenImageView.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(240)
            make.centerX.equalToSuperview()
        }

        loadingTextLabel.snp.makeConstraints() { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoInStartScreenImageView.snp.bottom).offset(40)
        }

        loadingNumberLabel.snp.makeConstraints() { make in
            make.top.equalTo(loadingTextLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        continueButton.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-135)
            make.height.equalTo(52)
        }
    }

    private func startLoadingAnimation() {
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateLoading), userInfo: nil, repeats: true)
    }

    @objc private func updateLoading() {
        loadingProgress += 0.01
        loadingNumberLabel.text = "\(Int(loadingProgress * 100))"

        if loadingProgress >= 1.0 {
            loadingTimer?.invalidate()
            loadingTextLabel.isHidden = true
            loadingNumberLabel.isHidden = true
            continueButton.isHidden = false
        }
    }

    @objc private func continueButtonTapped() {
        let tabBarViewController = TabBarViewController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarViewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
