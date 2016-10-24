//
//  ProjectViewModel.swift
//  reactSwift
//
//  Created by Varun Tyagi on 21/10/16.
//  Copyright © 2016 Varun Tyagi . All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import Foundation

class ProjectViewModel : NSObject{
    
    var navigation : UINavigationController = UINavigationController()
    var searchKey:NSString!
    var executeSearch: RACCommand?
    var executeCellSelection: RACCommand?
    let detailVC = DetailViewController()
    var connectionErrors: RACSignal!
    var projectsArray = MutableProperty<[ProjectModel]>([ProjectModel]())
    var someProperty: NSString // no need (!). It will be initialised from controller
    
    init(fromString string: NSString ) {
        self.searchKey=""
        self.someProperty = string
        
        super.init()

        //Add search Signal
        let validSearchSignal = self.rac_valuesForKeyPath("searchKey",
            observer: self).map{(text) -> AnyObject! in
                return (text as! NSString).length }.distinctUntilChanged()
        
        validSearchSignal.subscribeNext{(x) in print("swift search text is valid \(x)")
            if (VTWebservice.sharedInstance.task != nil) {
                VTWebservice.sharedInstance.task?.cancel()
            }
            self.getProjectList()
        }
      
        self.executeCellSelection = RACCommand() {
            (model:AnyObject!) -> RACSignal in
            
            let detailVC:DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
            detailVC.dataModel=model as! ProjectModel
            self.navigation.pushViewController(detailVC, animated: true)
            return RACSignal.empty()
        }
        }


    func getProjectList() {
        
        let   url  = NSURL(string: "https://api.github.com/search/repositories?q=\(searchKey)+language:assembly&sort=stars&order=desc&page=1")
         VTWebservice.sharedInstance.webHelper(url! ){ (response:NSString,success:Bool) in
        let JSONData = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let responseDic: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(JSONData!, options:[]) as! NSDictionary
       
        if(success){
            self.projectsArray.value.removeAll()

            let dataArray = responseDic["items"] as! NSArray;
            if dataArray.count>0{
            for item in dataArray {
                let obj = item as! NSDictionary
                 self.projectsArray.value.append(ProjectModel(json: obj))
            }
                
            print(responseDic)
                }
            else
            {
                self.projectsArray.value.removeAll()
            }
            }
                }
        }
}
    
    







