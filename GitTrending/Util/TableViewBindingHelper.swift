//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Varun Tyagi on 21/10/16.
//  Copyright © 2016 Varun Tyagi . All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

@objc protocol ReactiveView {
    func bindViewModel(viewModel: AnyObject)
}

// a helper that makes it easier to bind to UITableView instances

class TableViewBindingHelper<T: AnyObject> : NSObject {
    
    //MARK: Properties
    
    var delegate: UITableViewDelegate?
    
    private let tableView: UITableView
    private let templateCell: UITableViewCell
    private let selectionCommand: RACCommand?
    private let dataSource: DataSource
    
    //MARK: Public API
    
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, nibName: String, selectionCommand: RACCommand? = nil) {
        self.tableView = tableView
        self.selectionCommand = selectionCommand
        
        let nib = UINib(nibName: nibName, bundle: nil)
        
        // create an instance of the template cell and register with the table view
        templateCell = nib.instantiateWithOwner(nil, options: nil)[0] as! UITableViewCell
        tableView.registerNib(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
        
        dataSource = DataSource(data: nil, templateCell: templateCell,selectionCommand: selectionCommand)
        
        super.init()
        
    
        sourceSignal.startWithNext { [weak self] data in
            self?.dataSource.data = data.map({ $0 as AnyObject })
            self?.tableView.reloadData()
            dispatch_async(dispatch_get_main_queue()) {
                self?.tableView.reloadData()
            }
        }
    
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        
       
      
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let templateCell: UITableViewCell
    var data: [AnyObject]?
    var selectionCommand: RACCommand?

    
    init(data: [AnyObject]?, templateCell: UITableViewCell,selectionCommand:RACCommand?) {
        self.data = data
        self.templateCell = templateCell
        self.selectionCommand=selectionCommand
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return templateCell.frame.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(templateCell.reuseIdentifier!),
            
            reactiveView = cell as? ReactiveView else {
                return UITableViewCell()
        }
        
        reactiveView.bindViewModel(data![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         if self.selectionCommand != nil {
        self.selectionCommand?.execute(data![indexPath.row])
            print("did select called");

        }
    
       
    }
    
//    - (RACCommand *)selectionCommand {
//    self.selectionCommand = [[RACCommand alloc]
//    initWithSignalBlock:^RACSignal *(CETweetViewModel *selected) {
//    NSLog(selected.status);
//    return [RACSignal empty];
//    }];
//    }

    
    
}
