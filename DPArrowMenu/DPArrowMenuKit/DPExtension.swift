//
//  DPExtension.swift
//  DPArrowMenu
//
//  Created by Hongli Yu on 2018/12/28.
//  Copyright © 2018 Hongli Yu. All rights reserved.
//

import UIKit

public extension UIScreen {
  
  static func screen_width() -> CGFloat {
    return main.bounds.size.width
  }
  
  static func screen_height() -> CGFloat {
    return main.bounds.size.height
  }
  
}

public extension UIControl {
  
  func set(_ anchorPoint: CGPoint) {
    var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x,
                           y: bounds.size.height * anchorPoint.y)
    var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x,
                           y: bounds.size.height * layer.anchorPoint.y)
    
    newPoint = newPoint.applying(transform)
    oldPoint = oldPoint.applying(transform)
    
    var position = layer.position
    position.x -= oldPoint.x
    position.x += newPoint.x
    
    position.y -= oldPoint.y
    position.y += newPoint.y
    
    layer.position = position
    layer.anchorPoint = anchorPoint
  }
  
}

public extension UITableView {
  
  func registerCell(_ cellTypes:[AnyClass]) {
    for cellType in cellTypes {
      let typeString = String(describing: cellType)
      let xibPath = Bundle(for: cellType).path(forResource: typeString, ofType: "nib")
      if xibPath == nil {
        register(cellType, forCellReuseIdentifier: typeString)
      } else {
        register(UINib(nibName: typeString, bundle: nil), forCellReuseIdentifier: typeString)
      }
    }
  }
  
}
