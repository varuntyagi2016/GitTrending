//
//  RACObserve.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Varun Tyagi on 21/10/16.
//  Copyright © 2016 Varun Tyagi . All rights reserved.
//

import Foundation
import ReactiveCocoa

// replaces the RACObserve macro
func RACObserve(target: NSObject!, keyPath: String) -> RACSignal  {
  return target.rac_valuesForKeyPath(keyPath, observer: target)
}
