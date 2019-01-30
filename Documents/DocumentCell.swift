//
//  DocumentCell.swift
//  Documents
//
//  Created by Brock Gibson on 1/28/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    
    @IBOutlet weak var lastModifiedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
