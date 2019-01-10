//
//  ViewController.swift
//  DPArrowMenu
//
//  Created by Hongli Yu on 19/01/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
  private var viewModels: [DPArrowMenuViewModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let arrowMenuViewModel0 = DPArrowMenuViewModel(title: "Find Teachers",
                                                   imageName: "iconProfessionalTeacherSemiBlack")
    let arrowMenuViewModel1 = DPArrowMenuViewModel(title: "Find Language Partners",
                                                   imageName: "iconUserFriendsSemiBlack24")
    viewModels.append(arrowMenuViewModel0)
    viewModels.append(arrowMenuViewModel1)
  }
    
  @IBAction func showAction(_ sender: Any) {
    guard let view = sender as? UIView else { return }
    DPArrowMenu.show(view, viewModels: viewModels, done: { index in
      print(index)
    }) {
      print("cancel")
    }
  }

}

