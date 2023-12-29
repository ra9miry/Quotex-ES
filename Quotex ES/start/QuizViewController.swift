//
//  QuizViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 08.12.2023.
//

import UIKit
import SnapKit

struct QuizQuestion {
    var text: String
    var options: [String]
    var correctOptionIndex: [Int]
    var imageName: String
}

class QuizViewController: UIViewController {

    private var currentQuestionIndex = 0
    
    private lazy var questionNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        return label
    }()
    
    private lazy var questionStepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var mainQuestionNotNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(named: "back")
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var firstAnswerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Text", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "qbutton")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var secondAnswerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Text", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "qbutton")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var thankYouMainLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank You!"
        label.textColor = UIColor.white
        label.font = UIFont(name: "SFProDisplay-Bold", size: 28)
        label.textAlignment = .center
        return label
    }()

    private lazy var notThankYouMainSecondLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.textColor = UIColor.white
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
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
    private let quizQuestions: [QuizQuestion] = [
        QuizQuestion(
            text: "What percentage of your overall \n investment portfolio is allocated to \n cryptocurrencies?",
            options: ["Less than 10%", "More than 25%"],
            correctOptionIndex: [0, 1],
            imageName: "quesone"
        ),
        QuizQuestion(
            text: "Have you ever used cryptocurrency \n to make purchases?",
            options: ["Yes", "No"],
            correctOptionIndex: [0, 1],
            imageName: "questwo"
        ),
        QuizQuestion(
            text: "Do you support the use of \n cryptocurrency as a means of \n payment in the future?",
            options: ["Yes", "No"],
            correctOptionIndex: [0, 1],
            imageName: "questhr"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "back")

        setupViews()
        setupConstraints()
        updateQuestion()
    }

    private func setupViews() {
        view.addSubview(questionNumberLabel)
        view.addSubview(questionStepImageView)
        view.addSubview(mainQuestionNotNumberLabel)
        view.addSubview(firstAnswerButton)
        view.addSubview(secondAnswerButton)
        view.addSubview(thankYouMainLabel)
        view.addSubview(notThankYouMainSecondLabel)
        view.addSubview(continueButton)
    }
    
    private func setupConstraints() {
        questionNumberLabel.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
        }
        
        questionStepImageView.snp.makeConstraints() { make in
            make.top.equalTo(questionNumberLabel.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
        
        mainQuestionNotNumberLabel.snp.makeConstraints() { make in
            make.top.equalTo(questionStepImageView.snp.bottom).offset(71)
            make.centerX.equalToSuperview()
        }
        
        firstAnswerButton.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(secondAnswerButton.snp.top).offset(-20)
            make.height.equalTo(52)
        }
        
        secondAnswerButton.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-135)
            make.height.equalTo(52)
        }
        
        thankYouMainLabel.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(90)
            make.centerX.equalToSuperview()
        }
        
        notThankYouMainSecondLabel.snp.makeConstraints() { make in
            make.top.equalTo(thankYouMainLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-135)
            make.height.equalTo(52)
        }
    }
    
    private func updateQuestion() {
        guard currentQuestionIndex < quizQuestions.count else {
            hideAllElementsExceptContinueButton()
            showNewElements()
            return
        }

        let question = quizQuestions[currentQuestionIndex]
        questionNumberLabel.text = "Question \(currentQuestionIndex + 1)/\(quizQuestions.count)"
        questionStepImageView.image = UIImage(named: question.imageName)
        mainQuestionNotNumberLabel.text = question.text
        firstAnswerButton.setTitle(question.options[0], for: .normal)
        secondAnswerButton.setTitle(question.options[1], for: .normal)

        if currentQuestionIndex <= quizQuestions.count - 1 {
            thankYouMainLabel.isHidden = true
            notThankYouMainSecondLabel.isHidden = true
            continueButton.isHidden = true

            questionNumberLabel.isHidden = false
            questionStepImageView.isHidden = false
            mainQuestionNotNumberLabel.isHidden = false
            firstAnswerButton.isHidden = false
            secondAnswerButton.isHidden = false
        } else {
            hideAllElementsExceptContinueButton()
            showNewElements()
        }
    }

    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        currentQuestionIndex += 1
        updateQuestion()
    }
    
    @objc private func continueButtonTapped() {
        guard currentQuestionIndex >= quizQuestions.count else {
            currentQuestionIndex += 1
            updateQuestion()
            return
        }
        let tabBarViewController = StartScreenViewController()
        tabBarViewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(tabBarViewController, animated: true)
    }

    private func hideAllElementsExceptContinueButton() {
        questionNumberLabel.isHidden = true
        questionStepImageView.isHidden = true
        mainQuestionNotNumberLabel.isHidden = true
        firstAnswerButton.isHidden = true
        secondAnswerButton.isHidden = true
    }
    
    private func showNewElements() {
        thankYouMainLabel.isHidden = false
        notThankYouMainSecondLabel.isHidden = false
        continueButton.isHidden = false
    }
}
