//
//  RootViewController.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 5/17/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController {


    let stepViewControllerName = "StepViewController"
    var surgeryIndex = 1
    
//    private(set) lazy var orderedViewControllers: [UIViewController] = {
//        return [self.newViewController(storyboardName: "Stage1", index: 0),
//                self.newViewController(storyboardName: "Stage2", index: 1),
//                self.newViewController(storyboardName: "Stage3", index: 2),
//                self.newViewController(storyboardName: "Stage4", index: 3),
//                self.newViewController(storyboardName: "Stage5", index: 4),
//                self.newViewController(storyboardName: "Stage6", index: 5),
//                self.newViewController(storyboardName: "Stage7", index: 6)]
//    }()
//
//
//    private func newViewController(storyboardName: String, index : Int) -> StepViewController {
//        let viewController = UIStoryboard(name: "Main", bundle: nil) .
//            instantiateViewController(withIdentifier: "\(storyboardName)ViewController") as! StepViewController
//        viewController.setIndex(index: index)
//        return viewController
//    }

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        //Each of the stages for surgery, this can be created any way, as long there is a first controller when the view loads or is relaoded or something
        
        if let num = DataManager.getNumOfStages(surgery: surgeryIndex) {
            var views : [UIViewController] = []
            for i in 0..<num {
                views.append(self.newViewController(index: i))
            }
//            return [self.newViewController(index: 0),
//                    self.newViewController(index: 1),
//                    self.newViewController(index: 2),
//                    self.newViewController(index: 3),
//                    self.newViewController(index: 4),
//                    self.newViewController(index: 5),
//                    self.newViewController(index: 6)]
            return views
        }
        
        return []
        
    }()
    
    //Used above only right now
    private func newViewController(index : Int) -> StepViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: stepViewControllerName) as! StepViewController
        viewController.setIndex(surgeryNum: surgeryIndex, index: index)
        return viewController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
//        self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
//        self.pageViewController!.delegate = self
//
//        let startingViewController: StepViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
//        let viewControllers = [startingViewController]
//        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
//
//        self.pageViewController!.dataSource = self.modelController
//
//        self.addChildViewController(self.pageViewController!)
//        self.view.addSubview(self.pageViewController!.view)
//
//        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
//        var pageViewRect = self.view.bounds
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
//        }
//        self.pageViewController!.view.frame = pageViewRect
//
//        self.pageViewController!.didMove(toParentViewController: self)
        
        setViewControllers()
        
        
        dataSource = self
        //Can set the whole array I think, but code in an extension does the actual moving of views
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

        print("loading view controllers")
    }
    
    func setViewControllers() {
        if let num = DataManager.getNumOfStages(surgery: surgeryIndex) {
            var views : [UIViewController] = []
            for i in 0..<num {
                views.append(self.newViewController(index: i))
            }
            //            return [self.newViewController(index: 0),
            //                    self.newViewController(index: 1),
            //                    self.newViewController(index: 2),
            //                    self.newViewController(index: 3),
            //                    self.newViewController(index: 4),
            //                    self.newViewController(index: 5),
            //                    self.newViewController(index: 6)]
            orderedViewControllers = views
            print("Set view controllers")
        } else {
            print("didn't set view controllers")
        }
        
    }
    
    func segueFunction(surgeryIndex : Int) {
        self.surgeryIndex = surgeryIndex
        setViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    var modelController: ModelController {
//        // Return the model controller object, creating it if necessary.
//        // In more complex implementations, the model controller may be passed to the view controller.
//        if _modelController == nil {
//            _modelController = ModelController()
//        }
//        return _modelController!
//    }
//
//    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods

//    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
//        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
//            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
//            let currentViewController = self.pageViewController!.viewControllers![0]
//            let viewControllers = [currentViewController]
//            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
//
//            self.pageViewController!.isDoubleSided = false
//            return .min
//        }
//
//        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
//        let currentViewController = self.pageViewController!.viewControllers![0] as! StepViewController
//        var viewControllers: [UIViewController]
//
//        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
//        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
//            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
//            viewControllers = [currentViewController, nextViewController!]
//        } else {
//            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
//            viewControllers = [previousViewController!, currentViewController]
//        }
//        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
//
//        return .mid
//    }


}


//MARK: UIPageViewControllerDataSource
//If a view controller shouldn't display, do the logic here.
//Used for when steps aren't completed during surgery
extension RootViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
            //            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
//    Same as above
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
            //            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}


