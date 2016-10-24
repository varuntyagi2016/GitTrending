//
//  RAC.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Varun Tyagi on 21/10/16.
//  Copyright © 2016 Varun Tyagi . All rights reserved.
//

import Foundation
import ReactiveCocoa

// a struct that replaces the RAC macro
struct RAC  {
  var target : NSObject!
  var keyPath : String!
  var nilValue : AnyObject!
  
  init(_ target: NSObject!, _ keyPath: String, nilValue: AnyObject? = nil) {
    self.target = target
    self.keyPath = keyPath
    self.nilValue = nilValue
  }
  
  
  func assignSignal(signal : RACSignal) {
    signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
  }
}

infix operator ~> {}
func ~> (signal: RACSignal, rac: RAC) {
  rac.assignSignal(signal)
}
