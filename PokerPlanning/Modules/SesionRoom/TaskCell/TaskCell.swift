//
//  TaskCell.swift
//  PokerPlanning
//
//  Created by Aline Borges on 04/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(_ task: Task) {
        if let vote = task.vote {
            self.voteLabel.text = String(vote)
        } else {
            self.voteLabel.text = "??"
        }
        self.titleLabel.text = task.description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
