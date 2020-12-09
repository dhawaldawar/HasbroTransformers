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
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localizations.Titles.listTransformer
        addLoadingView()
        setupBindings()
    }
    
    //MARK:- Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        viewModel.create()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        viewModel.edit()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        viewModel.delete()
    }
    
    //MARK:- Private
    private func setupBindings() {
        guard let loadingStatus = loadingViewController?.loadingStatus else {
            Log.assertionFailure("`LoadingViewController` is unavailable.")
            return
        }

        viewModel.loadingStatus.bind(to: loadingStatus).disposed(by: disposeBag)

        //Bindings for all the transformer's stats.
        binding(stats: viewModel.strength, stepper: strengthStepper, label: strengthLabel)
        binding(stats: viewModel.speed, stepper: speedStepper, label: speedLabel)
        binding(stats: viewModel.rank, stepper: rankStepper, label: rankLabel)
        binding(stats: viewModel.firepower, stepper: firepowerStepper, label: firepowerLabel)
        binding(stats: viewModel.intelligence, stepper: intelligenceStepper, label: intelligenceLabel)
        binding(stats: viewModel.endurance, stepper: enduranceStepper, label: enduranceLabel)
        binding(stats: viewModel.courage, stepper: courageStepper, label: courageLabel)
        binding(stats: viewModel.skill, stepper: skillStepper, label: skillLabel)
            
        viewModel.name.bind(to: nameTextField.rx.text).disposed(by: disposeBag)
        nameTextField.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: disposeBag)
        
        viewModel.team.map { $0 == .autobot ? 0 : 1 }.bind(to: teamSegment.rx.value).disposed(by: disposeBag)
        
        viewModel.overallRating.map { "\($0)" }.bind(to: overallRatingLabel.rx.text).disposed(by: disposeBag)

        teamSegment.rx.value.map {
            $0 == 0 ? Transformer.Team.autobot : Transformer.Team.decepticon
            }.bind(to: viewModel.team).disposed(by: disposeBag)
        
        // To subscribe once the operation has been completed.
        viewModel.completion.subscribe(onNext: { [weak self] status in
            switch status {
            case .success:
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let message):
                self?.showAlert(title: Localizations.Titles.errorAlert, message: message)
            }
        }).disposed(by: disposeBag)
        
        // To subscribe in which mode the view should be setup
        viewModel.isUpdateMode.subscribe(onNext: { [weak self] isUpdateMode in
            self?.addButton.isHidden = isUpdateMode
            self?.editButton.isHidden = !isUpdateMode
            self?.deleteButton.isHidden = !isUpdateMode
            }).disposed(by: disposeBag)
    }

    private func binding(stats: BehaviorRelay<Int>, stepper: UIStepper, label: UILabel) {
        stats.map { Double($0) }.bind(to: stepper.rx.value).disposed(by: disposeBag)
        stats.map { "\($0)" }.bind(to: label.rx.text).disposed(by: disposeBag)
        stepper.rx.value.map { Int($0) }.bind(to: stats).disposed(by: disposeBag)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .cancel)
        alertController.addAction(okayButton)
        self.present(alertController, animated: true)
    }

}
