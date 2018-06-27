//
//  FinishSurgeryViewController.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 6/25/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import UIKit

class FinishSurgeryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testThings(_ sender: Any) {
        
        let parent = self.parent as! RootViewController
        var viewControllers = parent.orderedViewControllers
        viewControllers.removeLast()
        var stepControllers = viewControllers as! [StepViewController]
        
        var string = ""
        var i = 0
        for controller in stepControllers {
//            print("Controller: \(i)")
            print(controller.permInfo.description)
            //Ok, so I have to make a thing to have all the info
            if let stage = controller.stage {
                string += formattedControllerString(permInfo: controller.permInfo, stageInfo: stage)
                string += "\n"
            }
            
            i += 1
            
        }
        
        print("\n\n\nCSV string thing\n\n\n")
        print(string)
    }
    
    func formattedControllerString(permInfo : [StepViewController.CellDataType], stageInfo : DataManager.Stage) -> String {
        
        var string = ""
        string += "Stage" + ":\"" + stageInfo.name + "\"\n"
        for d in permInfo {
            if d.type == .Step {
                string += formatterStageString(line: d, data: stageInfo.steps[d.stepIndex])
                string += "\n"
            }
            
        }
        
        return string
    }
    
    func formatterStageString(line : StepViewController.CellDataType, data : DataManager.Step) -> String {
        
        //Data name is ":" and value separator is ","
        //So Stage:1,If Done:true etc
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        var string = ""
        string += "Step:" + String(line.stepIndex) + ","
        string += "Name" + ":\"" + data.description + "\","
        string += "People" + ":" + data.people.compactMap({$0.rawValue}).joined(separator: ";") + ","
        string += "Done" + ":" + String(line.cellDone) + ","
        string += "Time Done" + ":" + ((line.timeClicked != nil) ? formatter.string(from: line.timeClicked!) : "None")
        
        return string
    }
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
