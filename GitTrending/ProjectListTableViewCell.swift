//
//  ProjectListTableViewCell.swift
//  GitTrending
//
//  Created by Vinove on 23/10/16.
//  Copyright © 2016 varun. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
class ProjectListTableViewCell: UITableViewCell ,ReactiveView{
    
    
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var StarsLbl: UILabel!
    
    var data: ProjectModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // bind cell with model
    func bindViewModel(viewModel: AnyObject) {
        let devloper = viewModel as! ProjectModel
        projectNameLbl.text = devloper.projectName
        StarsLbl.text = String(format: "Stars :  %d",devloper.Stars)
        descLbl.text = devloper.projectDescription
    }
    
    
    
}
