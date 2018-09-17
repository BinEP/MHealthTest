//
//  FinishSurgeryViewController.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 6/25/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import UIKit
import QuickLook

class FinishSurgeryViewController: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    var previewURL : TemporaryFileURL?
    let quickLookController = QLPreviewController()

    @IBOutlet weak var tableView: UITableView!
    
    var csvString : String?
    var csvArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        quickLookController.dataSource = self
        quickLookController.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 25.0 //you can provide any
        tableView.rowHeight = UITableViewAutomaticDimension
        setupString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupString() {
        let parent = self.parent as! RootViewController
        var viewControllers = parent.orderedViewControllers
        viewControllers.removeLast()
        let stepControllers = viewControllers as! [StepViewController]
        
        var string = ""
        var i = 0
        
        string += "Surgery:" + parent.surgeryName + "\n"
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
        
//        \\s*,\\s*
        
        let fixString = string.replacingOccurrences(of: ",", with: ", ")
            .replacingOccurrences(of: ", ", with: ", ")

        csvString = fixString
        csvArray = csvString!.components(separatedBy: "\n")
        
        while csvArray.last == "" {
            csvArray.removeLast()
        }
    }
    
    @IBAction func testThings(_ sender: Any) {
        
        if let string = csvString {
            let fileURL = saveToFile(contents: string, surgeryName: (self.parent as! RootViewController).surgeryName)
            presentQuickLook(fileURL: fileURL)
        }
        
       
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
    
    func saveToFile(contents : String, surgeryName : String) -> TemporaryFileURL{
        
        print("Surgery Name: \(surgeryName)")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        let fileName = formatter.string(from: Date()) + " " + surgeryName
        
//        let tempURL = TemporaryFileURL(extension: fileName)
        let tempURL = TemporaryFileURL(name : fileName, extension: "csv")
        print("URL: \(tempURL.contentURL)")

        do{
            try contents.write(to: tempURL.contentURL, atomically: true, encoding: String.Encoding.utf8 )
        } catch{
            print("error trying to find")
            print (error)
        }
        
        return tempURL
    }
    
    func presentQuickLook(fileURL : TemporaryFileURL) {
        
        previewURL = fileURL
        
        if QLPreviewController.canPreview(previewURL!.contentURL as QLPreviewItem) {
            print("Preview")
            //Sets what to preview in the quick look controller
            quickLookController.currentPreviewItemIndex = 0
            print("Going to display")
            //            navigationController?.pushViewController(quickLookController, animated: true)
            //Fixes the  rendering of table so that it gets presented below the title bar of the quick look controller
            UINavigationBar.appearance().isTranslucent = true
            //Presents quick look
            present(quickLookController, animated: true, completion: nil)
        }
        
        
    }
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Quicklook Methods
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewURL!.contentURL as QLPreviewItem
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
//        racesTableView.deselectRow(at: racesTableView.indexPathForSelectedRow!, animated: true)
        print("The Preview Controller has been dismissed.")
        //        print("Before change back: \(UINavigationBar.appearance().translucent)")
        //
        //        UINavigationBar.appearance().translucent = false
        //        print("Change back: \(UINavigationBar.appearance().translucent)")
        previewURL = nil
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    //    CellInfo length is size of table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return csvArray.count
    }
    
    //    Makes a cell either a stage cell or a duty heading. Constructs from data stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 2
        
        cell.textLabel?.text = csvArray[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}


public final class TemporaryFileURL: ManagedURL {
    
    public let contentURL: URL
    
    public init(name : String, extension ext: String) {
        contentURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(name)
            .appendingPathExtension(ext)
    }
    
    deinit {
        DispatchQueue.global(qos: .utility).async { [contentURL = self.contentURL] in
            try? FileManager.default.removeItem(at: contentURL)
            print("Deleted")
        }
    }
}

public protocol ManagedURL {
    var contentURL: URL { get }
    func keepAlive()
}

public extension ManagedURL {
    public func keepAlive() { }
}

extension URL: ManagedURL {
    public var contentURL: URL { return self }
}
