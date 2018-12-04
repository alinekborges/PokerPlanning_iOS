//
//  VoteCell.swift
//  PokerPlanning
//
//  Created by Aline Borges on 04/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit

class VoteCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func bind(_ vote: Vote) {
        self.titleLabel.text = vote.username
        if let vote = vote.vote {
            self.voteLabel.text = String(vote)
        } else {
            self.voteLabel.text = "??"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
}
