//
//  ContactEditCell.swift
//  O2Trip
//
//  Created by Quan on 15/9/25.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class ContactEditCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}
