//
//  DPArrowMenuView.swift
//  DPArrowMenu
//
//  Created by Hongli Yu on 19/01/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPArrowMenuView: UIControl {
    
  private var viewModels: [DPArrowMenuViewModel]?
  private var arrowDirection: DPArrowMenuDirection = .up
  private var done: ((NSInteger)->Void)?
  
  private lazy var configuration = DPConfiguration()
    
  lazy var menuTableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    tableView.backgroundColor = UIColor.clear
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorColor = configuration.menuSeparatorColor
    tableView.layer.cornerRadius = configuration.cornerRadius
    tableView.clipsToBounds = true
    tableView.registerCell([DPPopOverMenuCell.self])
    return tableView
  }()

  func setupBasicUI() {
    alpha = 1
    layer.shadowOffset = CGSize(width: 2, height: 2)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.4
    clipsToBounds = false
  }
  
  func show(_ point: CGPoint, frame: CGRect, viewModels: [DPArrowMenuViewModel]?,
            arrowDirection: DPArrowMenuDirection, done: @escaping ((NSInteger)->())) {
    self.frame = frame
    self.viewModels = viewModels
    self.arrowDirection = arrowDirection
    self.done = done
    
    self.repositionMenuTableView()
    self.drawBackgroundLayer(point)
  }
  
  private func repositionMenuTableView() {
    var menuRect = CGRect(x: 0, y: DPDefaultMenuArrowHeight,
                          width: frame.size.width,
                          height: frame.size.height - DPDefaultMenuArrowHeight)
    if arrowDirection == .down {
      menuRect = CGRect(x: 0, y: 0, width: frame.size.width,
                        height: frame.size.height - DPDefaultMenuArrowHeight)
    }
    menuTableView.frame = menuRect
    menuTableView.reloadData()
    if menuTableView.frame.height < configuration.menuRowHeight * CGFloat(viewModels?.count ?? 0) {
        menuTableView.isScrollEnabled = true
    } else {
        menuTableView.isScrollEnabled = false
    }
    addSubview(menuTableView)
  }
  
  private lazy var backgroundLayer: CAShapeLayer = {
    let layer: CAShapeLayer = CAShapeLayer()
    return layer
  }()
  
  private func drawBackgroundLayer(_ arrowPoint: CGPoint) {
    if backgroundLayer.superlayer != nil {
        backgroundLayer.removeFromSuperlayer()
    }
    backgroundLayer.path = getBackgroundPath(arrowPoint).cgPath
    backgroundLayer.fillColor = configuration.backgoundTintColor.cgColor
    backgroundLayer.strokeColor = configuration.borderColor.cgColor
    backgroundLayer.lineWidth = configuration.borderWidth
    layer.insertSublayer(backgroundLayer, at: 0)
  }
  
  func getBackgroundPath(_ arrowPoint : CGPoint) -> UIBezierPath {
      let radius : CGFloat = configuration.cornerRadius / 2.0
      let path : UIBezierPath = UIBezierPath()
      path.lineJoinStyle = .round
      path.lineCapStyle = .round
    
      if arrowDirection == .up {
        path.move(to: CGPoint(x: arrowPoint.x - DPDefaultMenuArrowWidth,
                              y: DPDefaultMenuArrowHeight))
        path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
        path.addLine(to: CGPoint(x: arrowPoint.x + DPDefaultMenuArrowWidth,
                                 y: DPDefaultMenuArrowHeight))
        path.addLine(to: CGPoint(x: bounds.size.width - radius,
                                 y: DPDefaultMenuArrowHeight))
        path.addArc(withCenter: CGPoint(x: bounds.size.width - radius,
                                        y: DPDefaultMenuArrowHeight + radius),
                    radius: radius,
                    startAngle: CGFloat((Double.pi / 2.0) * 3),
                    endAngle: 0,
                    clockwise: true)
        path.addLine(to: CGPoint(x: bounds.size.width,
                                 y: bounds.size.height - radius))
        path.addArc(withCenter: CGPoint(x: bounds.size.width - radius,
                                        y: bounds.size.height - radius),
                    radius: radius,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2.0),
                    clockwise: true)
        path.addLine(to: CGPoint(x: radius, y: bounds.size.height))
        path.addArc(withCenter: CGPoint(x: radius, y: bounds.size.height - radius),
                    radius: radius,
                    startAngle: CGFloat(Double.pi / 2.0),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: DPDefaultMenuArrowHeight + radius))
        path.addArc(withCenter: CGPoint(x: radius, y: DPDefaultMenuArrowHeight + radius),
                    radius: radius,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat((Double.pi / 2.0) * 3),
                    clockwise: true)
        path.close()
      } else {
        path.move(to: CGPoint(x: arrowPoint.x - DPDefaultMenuArrowWidth,
                              y: bounds.size.height - DPDefaultMenuArrowHeight))
        path.addLine(to: CGPoint(x: arrowPoint.x, y: bounds.size.height))
        path.addLine(to: CGPoint(x: arrowPoint.x + DPDefaultMenuArrowWidth,
                                 y: bounds.size.height - DPDefaultMenuArrowHeight))
        path.addLine(to: CGPoint(x: bounds.size.width - radius,
                                 y: bounds.size.height - DPDefaultMenuArrowHeight))
        path.addArc(withCenter: CGPoint(x: bounds.size.width - radius,
                                        y: bounds.size.height - DPDefaultMenuArrowHeight - radius),
                    radius: radius,
                    startAngle: CGFloat(Double.pi / 2.0),
                    endAngle: 0,
                    clockwise: false)
        path.addLine(to: CGPoint(x: bounds.size.width, y: radius))
        path.addArc(withCenter: CGPoint(x: bounds.size.width - radius, y: radius),
                    radius: radius,
                    startAngle: 0,
                    endAngle: CGFloat((Double.pi / 2.0)*3),
                    clockwise: false)
        path.addLine(to: CGPoint(x: radius, y: 0))
        path.addArc(withCenter: CGPoint(x: radius, y: radius),
                    radius: radius,
                    startAngle: CGFloat((Double.pi / 2.0)*3),
                    endAngle: CGFloat(Double.pi),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0,
                                 y: bounds.size.height - DPDefaultMenuArrowHeight - radius))
        path.addArc(withCenter: CGPoint(x: radius,
                                        y: bounds.size.height - DPDefaultMenuArrowHeight - radius),
                    radius: radius,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(Double.pi / 2.0),
                    clockwise: false)
        path.close()
      }
    return path
  }
    
}

extension DPArrowMenuView: UITableViewDelegate {
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return configuration.menuRowHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    done?(indexPath.row)
  }
    
}

extension DPArrowMenuView: UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModels?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = DPPopOverMenuCell(style: .default,
                                 reuseIdentifier: String(describing: DPPopOverMenuCell.self))
    if let viewModel = viewModels?[indexPath.row] {
      cell.bindData(viewModel)
    }
    if (indexPath.row == (viewModels?.count ?? 0) - 1) { // Remove the last separator
      cell.separatorInset = UIEdgeInsets(top: 0, left: bounds.size.width, bottom: 0, right: 0)
    } else {
      cell.separatorInset = configuration.menuSeparatorInset
    }
    return cell
  }
    
}
