//
//  SessionCell.swift
//  PokerPlanning
//
//  Created by Aline Borges on 03/12/18.
//  Copyright © 2018 Aline Borges. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ session: SessionRoom) {
        self.titleLabel.text = session.id
        self.userCountLabel.text = String(session.users.count)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
