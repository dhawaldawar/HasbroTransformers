//
//  BattleViewController.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

class BattleViewController: BaseViewController {
    
    private enum Constants {
        static let cellIdentifier = "battleSessionCell"
        static let headerIdentifier = "header"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var autobotsTeamLabel: UILabel!
    @IBOutlet weak var decepticonsTeamLabel: UILabel!
    @IBOutlet weak var battleResultTextview: UITextView!
    
    var viewModel: BattleViewModel!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK:- Private
    private func setupBindings() {
        autobotsTeamLabel.text = viewModel.autobotsTeam.string
        decepticonsTeamLabel.text = viewModel.decepticonsTeam.string

        battleResultTextview.text = """
        \(viewModel.totalPerformedBattles)
        \(viewModel.finalResultDescription)
        """
    }
}

extension BattleViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return section == 0 ? viewModel.numberOfPlannedBattles * 2 : viewModel.numberOfSurvivors * 2
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! BattleCollectionCellView
    
    let getViewModel: ((_ index: Int) -> BattleCellViewModel?)
    if indexPath.section == 0 {
        getViewModel = indexPath.row % 2 == 0 ? viewModel.getAutobotsBattleCellViewModel : viewModel.getDecepticonsBattleCellViewModel
    } else {
        getViewModel = indexPath.row % 2 == 0 ? viewModel.getAutobotsSurvivorBattleCellViewModel : viewModel.getDecepticonsSurvivorBattleCellViewModel
    }
    cell.configure(viewModel: getViewModel(indexPath.row / 2))
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerIdentifier, for: indexPath) as! BattleCollectionHeaderView
        sectionHeader.headerlabel.text = indexPath.section == 0 ? "Battles" : "Survivors"
        return sectionHeader
    }
}

extension BattleViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width/2, height: 300)
  }
}

class BattleCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var headerlabel: UILabel!
}
