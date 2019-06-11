//
//  RevealViewHandeler.swift
//  Aceify Coach
//
//  Created by Sandeep Kumar on 4/8/16.
//  Copyright © 2016 Apptunix. All rights reserved.
//

import UIKit
import SWRevealViewController

class RevealViewHandeler: NSObject, SWRevealViewControllerDelegate
{
    var viewController:UIViewController!
    var blackView:UIView?
    var btnMenu: UIBarButtonItem!
    
    var tapGesture: UITapGestureRecognizer!
    
    static var shared = RevealViewHandeler()
    
    var widthOfSideBar:CGFloat = 0.8
    
    func createBlackView()
    {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(RevealViewHandeler.tapGesture(sender:)))
        blackView = UIView()
        blackView?.addGestureRecognizer(tapGesture)
        blackView?.isUserInteractionEnabled = true
        blackView?.backgroundColor = UIColor.black
        blackView?.alpha = 0.3
    }
    
    func setup(vc:UIViewController,
               barButtonMenu: UIBarButtonItem! = nil,
               mainNavigationHide:Bool = false)
    {
        vc.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.width * widthOfSideBar
        
        if vc.revealViewController() != nil
        {
            if tapGesture == nil
            {
                createBlackView()
            }
            viewController = vc
            btnMenu = barButtonMenu
            if (mainNavigationHide == true)
            {
            }
            vc.revealViewController().delegate = self
            
            vc.view.addGestureRecognizer(vc.revealViewController().panGestureRecognizer())
            vc.view.addGestureRecognizer(vc.revealViewController().tapGestureRecognizer())
            
            if(barButtonMenu != nil)
            {
                barButtonMenu.target = vc.revealViewController()
                barButtonMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            }
        }
    }
    
    @objc func tapGesture(sender:UITapGestureRecognizer) -> Void
    {
        viewController.revealViewController().revealToggle(btnMenu)
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition)
    {
        if (position == FrontViewPosition.right)
        {
            // Menu is shown
            //            self.navigationController.interactivePopGestureRecognizer.enabled = NO; // Prevents the iOS7’s pan gesture
            //            self.view.userInteractionEnabled = false;
            if blackView == nil
            {
                self.createBlackView()
            }

            if viewController != nil, let navigation = viewController.navigationController
            {
                blackView?.frame = navigation.view.bounds
                navigation.view.addSubview(blackView!)
            }
            else if viewController != nil
            {
                blackView?.frame = viewController.view.bounds
                viewController.view.addSubview(blackView!)
            }
        }
        else if (position == FrontViewPosition.left)
        { // Menu is closed
            if viewController != nil
            {
                blackView?.removeFromSuperview()
            }
        }
    }
    
}
