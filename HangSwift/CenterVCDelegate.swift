//
//  CenterVCDelegate.swift
// 
//
//  Created by Irwin Gonzales on 7/8/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit

protocol CenterVCDelegate
{
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
    
    func toggleLoginVC()
    func addLoginViewController()
    func animateLoginVC(shouldExpand: Bool)
}
