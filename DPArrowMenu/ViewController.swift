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
    DPArrowMenu.show(view, viewModels: viewModels, done: { [weak self] index in
      guard let title = self?.viewModels[index].title else { return }
      self?.showAlert(alertText: title, alertMessage: "selected index \(index)")
    }) {
      print("cancel")
    }
  }

}

extension UIViewController {

  func showAlert(alertText : String, alertMessage : String) {
    let alert = UIAlertController(title: alertText,
                                  message: alertMessage,
                                  preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Got it",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

}
