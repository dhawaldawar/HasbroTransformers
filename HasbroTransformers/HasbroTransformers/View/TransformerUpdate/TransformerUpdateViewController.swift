//
//  TransformerUpdateViewController.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

class TransformerUpdateViewController: BaseViewController {
    
    @IBOutlet weak var strengthStepper: UIStepper!
    @IBOutlet weak var strengthLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedStepper: UIStepper!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankStepper: UIStepper!
    
    @IBOutlet weak var firepowerLabel: UILabel!
    @IBOutlet weak var firepowerStepper: UIStepper!
    
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var intelligenceStepper: UIStepper!
    
    @IBOutlet weak var enduranceLabel: UILabel!
    @IBOutlet weak var enduranceStepper: UIStepper!
    
    @IBOutlet weak var courageLabel: UILabel!
    @IBOutlet weak var courageStepper: UIStepper!
    
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillStepper: UIStepper!
    
    @IBOutlet weak var overallRatingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamSegment: UISegmentedControl!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewModel: TransformerUpdateViewModel!
    
    private let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localizations.Titles.listTransformer
        addLoadingView()
        setupBindings()
    }
    
    //MARK: Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        viewModel.create()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        viewModel.edit()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        viewModel.delete()
    }
    
    //MARK: Private
    private func setupBindings() {
        guard let loadingStatus = loadingViewController?.loadingStatus else {
            return
        }
        viewModel.loadingStatus.bind(to: loadingStatus).disposed(by: disposeBag)

        binding(characteristics: viewModel.strength, stepper: strengthStepper, label: strengthLabel)
        binding(characteristics: viewModel.speed, stepper: speedStepper, label: speedLabel)
        binding(characteristics: viewModel.rank, stepper: rankStepper, label: rankLabel)
        binding(characteristics: viewModel.firepower, stepper: firepowerStepper, label: firepowerLabel)
        binding(characteristics: viewModel.intelligence, stepper: intelligenceStepper, label: intelligenceLabel)
        binding(characteristics: viewModel.endurance, stepper: enduranceStepper, label: enduranceLabel)
        binding(characteristics: viewModel.courage, stepper: courageStepper, label: courageLabel)
        binding(characteristics: viewModel.skill, stepper: skillStepper, label: skillLabel)
        
        viewModel.name.bind(to: nameTextField.rx.text).disposed(by: disposeBag)
        nameTextField.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: disposeBag)
        
        viewModel.team.map { $0 == .autobot ? 0 : 1 }.bind(to: teamSegment.rx.value).disposed(by: disposeBag)
        
        viewModel.overallRating.map { "\($0)" }.bind(to: overallRatingLabel.rx.text).disposed(by: disposeBag)
        

        teamSegment.rx.value.map {
            $0 == 0 ? Transformer.Team.autobot : Transformer.Team.decepticon
            }.bind(to: viewModel.team).disposed(by: disposeBag)
        
        viewModel.completion.subscribe(onNext: { [weak self] status in
            switch status {
            case .success:
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let message):
                self?.showAlert(title: Localizations.Titles.errorAlert, message: message)
            }
        }).disposed(by: disposeBag)
        
        viewModel.isUpdateMode.subscribe(onNext: { [weak self] isUpdateMode in
            self?.addButton.isHidden = isUpdateMode
            self?.editButton.isHidden = !isUpdateMode
            self?.deleteButton.isHidden = !isUpdateMode
            }).disposed(by: disposeBag)
    }

    private func binding(characteristics: BehaviorRelay<Int>, stepper: UIStepper, label: UILabel) {
        characteristics.map { Double($0) }.bind(to: stepper.rx.value).disposed(by: disposeBag)
        characteristics.map { "\($0)" }.bind(to: label.rx.text).disposed(by: disposeBag)
        stepper.rx.value.map { Int($0) }.bind(to: characteristics).disposed(by: disposeBag)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .cancel)
        alertController.addAction(okayButton)
        self.present(alertController, animated: true)
    }

}
