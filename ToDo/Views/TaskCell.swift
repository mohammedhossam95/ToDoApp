//
//  TaskCell.swift
//  ToDoListDemo
//
//  Created by Dev2 on 4/9/19.
//  Copyright © 2019 Hossam__95. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
