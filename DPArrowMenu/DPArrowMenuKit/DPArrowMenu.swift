//
//  DPArrowMenu.swift
//  DPArrowMenu
//
//  Created by Hongli Yu on 19/01/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public class DPArrowMenu: NSObject {
    
  static let shared = DPArrowMenu()
  private var configuration = DPConfiguration()
  
  private var sender: UIView?
  private var senderFrame: CGRect?
  private var viewModels: [DPArrowMenuViewModel]?
  private var done: ((_ selectedIndex: NSInteger)->Void)?
  private var cancel: (()->Void)?
  
  private lazy var backgroundView: UIView = {
    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = UIColor.clear
    view.addGestureRecognizer(tapGesture)
    return view
  }()
  
  private lazy var popOverMenu: DPArrowMenuView = {
    let menu = DPArrowMenuView(frame: CGRect.zero)
    menu.setupBasicUI()
    backgroundView.addSubview(menu)
    return menu
  }()
  
  private var isOnScreen: Bool = false {
    didSet {
      if isOnScreen {
        addOrientationChangeNotification()
      } else {
        removeOrientationChangeNotification()
      }
    }
  }
  
  private lazy var tapGesture: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self,
                                         action: #selector(onBackgroudViewTapped(gesture:)))
    gesture.delegate = self
    return gesture
  }()
  
  private func show(_ sender: UIView?, senderFrame: CGRect? = nil, viewModels: [DPArrowMenuViewModel],
                    done: @escaping (NSInteger)->Void, cancel:@escaping ()->Void) {
    self.sender = sender
    self.senderFrame = senderFrame
    self.viewModels = viewModels
    self.done = done
    self.cancel = cancel
    
    UIApplication.shared.keyWindow?.addSubview(backgroundView)
    adjustPostionForPopOverMenu()
  }
  
  private func adjustPostionForPopOverMenu() {
    backgroundView.frame = CGRect(x: 0, y: 0,
                                  width: UIScreen.screen_width(),
                                  height: UIScreen.screen_height())
    setupPopOverMenu()
    showIfNeeded()
  }
    
  private func setupPopOverMenu() {
    popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
    configurePopMenuFrame()
    
    popOverMenu.show(menuArrowPoint, frame: popMenuFrame,
                     viewModels: viewModels, arrowDirection: arrowDirection,
                     done: { [weak self] (index: NSInteger) in
      guard let strongSelf = self else { return }
      strongSelf.isOnScreen = false
      strongSelf.doneAction(index)
    })
    popOverMenu.set(getAnchorPointForPopMenu())
  }
  
  private func getAnchorPointForPopMenu() -> CGPoint {
    var anchorPoint = CGPoint(x: menuArrowPoint.x / popMenuFrame.size.width, y: 0)
    if arrowDirection == .down {
      anchorPoint = CGPoint(x: menuArrowPoint.x / popMenuFrame.size.width, y: 1)
    }
    return anchorPoint
  }
    
  private var senderRect: CGRect = CGRect.zero
  private var popMenuOriginX: CGFloat = 0
  private var popMenuFrame: CGRect = CGRect.zero
  private var menuArrowPoint: CGPoint = CGPoint.zero
  private var arrowDirection: DPArrowMenuDirection = .up
  private var popMenuHeight: CGFloat {
    return configuration.menuRowHeight * CGFloat(viewModels?.count ?? 0) + DPDefaultMenuArrowHeight
  }
  
  private func configurePopMenuFrame() {
    configureSenderRect()
    configureMenuArrowPoint()
    configurePopMenuOriginX()
    if arrowDirection == .up {
      popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height),
                            width: configuration.menuWidth, height: popMenuHeight)
      if popMenuFrame.origin.y + popMenuFrame.size.height > UIScreen.screen_height() {
        popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height),
                              width: configuration.menuWidth,
                              height: UIScreen.screen_height() - popMenuFrame.origin.y - DPDefaultMargin)
      }
    } else {
      popMenuFrame = CGRect(x: popMenuOriginX, y: senderRect.origin.y - popMenuHeight,
                            width: configuration.menuWidth, height: popMenuHeight)
      if popMenuFrame.origin.y < 0 {
        popMenuFrame = CGRect(x: popMenuOriginX, y: DPDefaultMargin,
                              width: configuration.menuWidth,
                              height: senderRect.origin.y - DPDefaultMargin)
      }
    }
  }
  
  private func configureSenderRect() {
    if sender != nil {
      if sender!.superview != nil {
        senderRect = sender!.superview!.convert(sender!.frame, to: backgroundView)
      } else {
        senderRect = sender!.frame
      }
    } else if senderFrame != nil {
      senderRect = senderFrame!
    }
    senderRect.origin.y = min(UIScreen.screen_height(), senderRect.origin.y)
    arrowDirection = (senderRect.origin.y + senderRect.size.height / 2.0
      < UIScreen.screen_height() / 2.0) ? .up : .down
  }

  private func configurePopMenuOriginX() {
    var senderXCenter: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width) / 2.0, y: 0)
    let menuCenterX: CGFloat = configuration.menuWidth / 2.0 + DPDefaultMargin
    var menuX: CGFloat = 0
    if (senderXCenter.x + menuCenterX > UIScreen.screen_width()) {
      senderXCenter.x = min(senderXCenter.x - (UIScreen.screen_width() - configuration.menuWidth - DPDefaultMargin), configuration.menuWidth - DPDefaultMenuArrowWidth - DPDefaultMargin)
      menuX = UIScreen.screen_width() - configuration.menuWidth - DPDefaultMargin
    } else if senderXCenter.x - menuCenterX < 0 {
      senderXCenter.x = max(DPDefaultMenuCornerRadius + DPDefaultMenuArrowWidth,
                            senderXCenter.x - DPDefaultMargin)
      menuX = DPDefaultMargin
    } else {
      senderXCenter.x = configuration.menuWidth / 2.0
      menuX = senderRect.origin.x + senderRect.size.width / 2.0 - configuration.menuWidth / 2.0
    }
    popMenuOriginX = menuX
  }

  private func configureMenuArrowPoint() {
    var point: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width) / 2.0, y: 0)
    let menuCenterX: CGFloat = configuration.menuWidth / 2.0 + DPDefaultMargin
    if senderRect.origin.y + senderRect.size.height / 2.0 < UIScreen.screen_height() / 2.0 {
      point.y = 0
    } else {
      point.y = popMenuHeight
    }
    if (point.x + menuCenterX) > UIScreen.screen_width() {
      point.x = min(point.x - (UIScreen.screen_width() - configuration.menuWidth - DPDefaultMargin),
                    configuration.menuWidth - DPDefaultMenuArrowWidth - DPDefaultMargin)
    } else if point.x - menuCenterX < 0 {
      point.x = max(DPDefaultMenuCornerRadius + DPDefaultMenuArrowWidth, point.x - DPDefaultMargin)
    } else {
      point.x = configuration.menuWidth / 2.0
    }
    menuArrowPoint = point
  }
    
  @objc fileprivate func onBackgroudViewTapped(gesture : UIGestureRecognizer) {
    dismiss()
  }
  
  private func showIfNeeded() {
    if !isOnScreen {
      isOnScreen = true
      popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      UIView.animate(withDuration: DPDefaultAnimationDuration, animations: {
        self.popOverMenu.alpha = 1
        self.popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
      })
    }
  }
    
  private func dismiss() {
    isOnScreen = false
    doneAction(-1)
  }
    
  private func doneAction(_ selectedIndex: NSInteger) {
    UIView.animate(withDuration: DPDefaultAnimationDuration, animations: {
      self.popOverMenu.alpha = 0
      self.popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }) { (isFinished) in
      if isFinished {
        self.backgroundView.removeFromSuperview()
        selectedIndex < 0 ? self.cancel?() : self.done?(selectedIndex)
      }
    }
  }

  // MARK: Animation
  public static func show(_ sender : UIView, viewModels: [DPArrowMenuViewModel]?,
                          done: @escaping (NSInteger)->Void,
                          cancel: @escaping ()->Void) {
    guard let viewModels = viewModels, viewModels.count > 0 else { return }
    shared.show(sender, viewModels: viewModels, done: done, cancel: cancel)
  }
  
  public static func dismiss() {
    shared.dismiss()
  }

}

extension DPArrowMenu { // notifications for orientation changed
    
  private func addOrientationChangeNotification() {
    NotificationCenter
      .default
      .addObserver(self,
                   selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                   name: UIApplication.didChangeStatusBarOrientationNotification,
                   object: nil)
  }
  
  private func removeOrientationChangeNotification() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func onChangeStatusBarOrientationNotification(notification : Notification) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()
      + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
        self.adjustPostionForPopOverMenu()
    })
  }
  
}

extension DPArrowMenu: UIGestureRecognizerDelegate {
    
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                shouldReceive touch: UITouch) -> Bool {
    let touchPoint = touch.location(in: backgroundView)
    if touch.view?.superview is UITableViewCell {
      return false
    }
    if CGRect(x: 0, y: 0,
              width: configuration.menuWidth,
              height: configuration.menuRowHeight).contains(touchPoint) {
      // Navgation bar button item
      self.doneAction(0)
      return false
    }
    return true
  }
    
}
