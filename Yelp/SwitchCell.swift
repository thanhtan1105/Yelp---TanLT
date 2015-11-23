//
//  SwitchCell.swift
//  Yelp
//
//  Created by Le Thanh Tan on 11/19/15.
//  Copyright © 2015 Le Thanh Tan. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValued value: Bool)
    
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var swtichs: UISwitch!
    @IBOutlet weak var label: UILabel!
    var delegate : SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func onSwitch(sender: UISwitch) {
        print("Value switch changed")
        if self.delegate != nil {
            self.delegate?.switchCell(self, didChangeValued: self.swtichs.on)            
        }
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
