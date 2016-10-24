//
//  ViewController.swift
//  reactSwift
//
//  Created by Varun Tyagi on 21/10/16.
//  Copyright © 2016 Varun Tyagi . All rights reserved.
//

import UIKit
import ReactiveCocoa



class ViewController: UIViewController ,UITableViewDelegate{

    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var projectListTbl: UITableView!
   
    
    var service =   ProjectViewModel(fromString:"tren")

    private var bindingHelper: TableViewBindingHelper<ProjectModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        searchTxt.rac_textSignal() ~> RAC(self.service, "searchKey")

        bindingHelper = TableViewBindingHelper(tableView: projectListTbl, sourceSignal: self.service.projectsArray.producer, nibName: "ProjectListTableViewCell", selectionCommand: self.service.executeCellSelection)
        
        
    }
    
func setupUI(){
    service.navigation=self.navigationController!
        searchTxt.layer.borderWidth=7
        searchTxt.layer.masksToBounds=true
        searchTxt.layer.borderColor=UIColor.lightGrayColor().CGColor
        let paddingView = UIView(frame:CGRectMake(0, 0, 30, 30))
        searchTxt.leftViewMode = .Always
        searchTxt.leftView=paddingView;
        
        
        let magnifyingGlassAttachment = NSTextAttachment(data: nil, ofType: nil)
        magnifyingGlassAttachment.image = UIImage(named: "search")
        
        let magnifyingGlassString = NSAttributedString(attachment: magnifyingGlassAttachment)
        let attributedText = NSMutableAttributedString(attributedString: magnifyingGlassString)
        
        projectListTbl.tableFooterView = UIView()
        let searchString = NSAttributedString(string: " Search")
        attributedText.appendAttributedString(searchString)
        searchTxt.attributedPlaceholder = attributedText
        
 
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.title="Git Trending"
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.title="Back"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

