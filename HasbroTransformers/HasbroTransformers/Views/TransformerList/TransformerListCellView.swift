//
//  TransformerListCellView.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit

class TransformerListCellView: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overallRatingLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
    @IBOutlet weak var teamImageView: UIImageView!

    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var strengthProgressView: UIProgressView!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedProgressView: UIProgressView!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankProgressView: UIProgressView!
    
    @IBOutlet weak var firepowerLabel: UILabel!
    @IBOutlet weak var firepowerProgressView: UIProgressView!
    
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var intelligenceProgressView: UIProgressView!
    
    @IBOutlet weak var enduranceLabel: UILabel!
    @IBOutlet weak var enduranceProgressView: UIProgressView!
    
    @IBOutlet weak var courageLabel: UILabel!
    @IBOutlet weak var courageProgressView: UIProgressView!
    
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillProgressView: UIProgressView!

    var viewModel: TransformerListCellViewModel! {
        didSet {
            nameLabel.text = viewModel.name
            overallRatingLabel.text = "\(viewModel.overallRating)"
            teamLabel.text = viewModel.team

            strengthLabel.text = "\(viewModel.strength)"
            strengthProgressView.progress = calculateProgress(value: viewModel.strength)
            
            speedLabel.text = "\(viewModel.speed)"
            speedProgressView.progress = calculateProgress(value: viewModel.speed)
            
            rankLabel.text = "\(viewModel.rank)"
            rankProgressView.progress = calculateProgress(value: viewModel.rank)
            
            firepowerLabel.text = "\(viewModel.firepower)"
            firepowerProgressView.progress = calculateProgress(value: viewModel.firepower)
            
            intelligenceLabel.text = "\(viewModel.intelligence)"
            intelligenceProgressView.progress = calculateProgress(value: viewModel.intelligence)
            
            enduranceLabel.text = "\(viewModel.endurance)"
            enduranceProgressView.progress = calculateProgress(value: viewModel.endurance)
            
            courageLabel.text = "\(viewModel.courage)"
            courageProgressView.progress = calculateProgress(value: viewModel.courage)
            
            skillLabel.text = "\(viewModel.skill)"
            skillProgressView.progress = calculateProgress(value: viewModel.skill)
            
            if let teamIconURL = viewModel.teamIconURL {
                teamImageView.loadImage(url: teamIconURL)
            }
        }
    }

    private func calculateProgress(value: Int) -> Float {
        Float(value) / 10.0
    }

}
