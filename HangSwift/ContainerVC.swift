//
//  ContainerVC.swift
//  Hitchhiker-Dev
//
//  Created by Irwin Gonzales on 7/8/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import QuartzCore

//MARK: Monitor State of Menu (collapsed or nah?)
enum SlideOutState
{
    case collapsed
    case leftPanelExpanded
}

enum ShowWhichVC
{
    case homeVC
}

//MARK:
var showVC: ShowWhichVC = .homeVC

//MARK:
class ContainerVC: UIViewController
{
    //MARK: Varibles
    var homeVC: HomeVC!
    var leftVC: LeftSidePanelVC!
    var centerController: UIViewController!
    var currentState: SlideOutState = .collapsed
    var isHidden = false
    
    let centerPanelExpandedOffset: CGFloat = 160
    
    var tap: UITapGestureRecognizer!

    
    //MARK: View did load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initCenter(screen: showVC)
    }
    
    
    //MARK: Initialize VCs to the center of the screen
    func initCenter(screen: ShowWhichVC)
    {
        var presentingController: UIViewController
        
        showVC = screen
        
        if homeVC == nil
        {
            homeVC = UIStoryboard.homeVC()
            homeVC.delegate = self
        }
        
        presentingController = homeVC
        
        //Clearing out unused VCs before loading a new center : Memory cleanup
        if let con = centerController
        {
            con.view.removeFromSuperview()
            con.removeFromParentViewController()
        }
        
        centerController = presentingController
        
        view.addSubview(centerController.view)
        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return isHidden
    }
}

//MARK: Conforming To Protocol of CenterVC
extension ContainerVC: CenterVCDelegate
{
    func toggleLeftPanel()
    {
        // Set const that checks the current state of the the expansion
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        //
        if notAlreadyExpanded
        {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController()
    {
        if leftVC == nil
        {
            leftVC = UIStoryboard.leftViewController()
            //addChildSidePanelViewController(leftVC!)
            addChildSidePanelViewController(leftVC!)
        }
    }
    
    func addChildSidePanelViewController(_ sidePanelController: LeftSidePanelVC)
    {
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func animateLeftPanel(shouldExpand: Bool)
    {
        if shouldExpand
        {
            isHidden = !isHidden
            animateStatusBar()
            
            setupWhiteCoverView()
            currentState = .leftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPanelExpandedOffset)
        }
        else
        {
            isHidden = !isHidden
            animateStatusBar()
            
            hideWhiteCoverView()
            animateCenterPanelXPosition(targetPosition: 0, completion: { (finished) in
                if finished == true
                {
                    self.currentState = .collapsed
                    self.leftVC = nil
                }
            })
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { 
            
            self.centerController.view.frame.origin.x = targetPosition
            
        }, completion: completion)
    }
    
    func setupWhiteCoverView()
    {
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = UIColor.white
        whiteCoverView.tag = 25
        
        self.centerController.view.addSubview(whiteCoverView)
        whiteCoverView.fadeTo(alphaValue: 0.75, withDuration: 0.2)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpand:)))
        tap.numberOfTapsRequired = 1
        
        self.centerController.view.addGestureRecognizer(tap)
    }
    
    func hideWhiteCoverView()
    {
        centerController.view.removeGestureRecognizer(tap)
        for subView in self.centerController.view.subviews
        {
            if subView.tag == 25
            {
                UIView.animate(withDuration: 0.2, animations: {
                    subView.alpha = 0.0
                }, completion: { (finished) in
                    subView.removeFromSuperview()
                })
            }
        }
    }
    
    func animateStatusBar()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { 
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
}

//MARK: Access to the Storyboard
private extension UIStoryboard
{
    // Access To Storyboard
    class func mainStoryBoard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    // Instansiate ViewControllers
    class func leftViewController() -> LeftSidePanelVC
    {
        return (mainStoryBoard().instantiateViewController(withIdentifier: "LeftSidePanelVC") as? LeftSidePanelVC)!
    }
    
    class func homeVC() -> HomeVC
    {
        return (mainStoryBoard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC)!
    }
}
