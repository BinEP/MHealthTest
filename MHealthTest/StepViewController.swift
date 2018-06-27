//
//  StepViewController.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 5/21/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import UIKit

class StepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TODO: Set by segue
    var surgeryNum = -1
    var index : Int = -1
    
    enum CellType {
        case Stage, Step
    }
    
//    var meRed : UInt = 0xffc4c4
//    var meGreen : UInt = 0x83ff81
    
    var meRed : UInt = 0xFFF6E6
    var meGreen : UInt = 0xFFF6E6
//    Data for each cell and where to get data
    struct CellDataType {
        var type : CellType
        var stepIndex : Int
        var cellIndex : Int
        var cellDone = false
        var groupNum : Int
        var timeClicked : Date?
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var surgeryStepLabel: UILabel!
//    @IBOutlet weak var stageIndexLabel: UILabel!
    
    
    
    var cellInfo : [CellDataType] = []
    var permInfo : [CellDataType] = []

    var stage : DataManager.Stage?
    
//    So the view controller know whcih stage it should get data for, could also pass data in here.
//    Executed before the view controller loads
    func setIndex(surgeryNum : Int, index : Int) {
        print("index set")
        self.index = index
        self.surgeryNum = surgeryNum
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View Appear")
        
    }
//    Is the function that determines if the list of people changes so a new header should be displayed
    func checkLists(first : [DataManager.Duties], second : [DataManager.Duties]) -> Bool {
         return first.count == second.count && first.map({"\($0.rawValue)"}).sorted() == second.map({"\($0.rawValue)"}).sorted()
    }

//    Sets up the data
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("View loading")
        stage = DataManager.getDataForStage(surgery : surgeryNum, step: index)
//        stageIndexLabel.text = "\(index + 1)"
        surgeryStepLabel.text = stage?.name
        
        
        view.backgroundColor = UIColorFromRGB(rgbValue: meGreen)
        tableView.backgroundColor = UIColorFromRGB(rgbValue: meGreen)
        
        
        
        //Build data model
        resetStuff()
        // Do any additional setup after loading the view.
    }
    
//    Makes the number of cells for each step plus however many different duty sets are needed. Length of cellInfo corresponds to number of cells
    func resetStuff() {
        
        cellInfo.removeAll()
        var steps = stage!.steps

        var prevDuty = [DataManager.Duties.None]
        var groupNum = 0

        for i in 0..<stage!.steps.count {
            print("Row I: \(i)")
            if !checkLists(first: steps[i].people, second: prevDuty) {
                prevDuty = steps[i].people
                groupNum += 1
                cellInfo.append(CellDataType(type : .Stage, stepIndex : i, cellIndex : cellInfo.count, cellDone: false, groupNum : groupNum, timeClicked : nil))
            }
            cellInfo.append(CellDataType(type : .Step, stepIndex : i, cellIndex : cellInfo.count, cellDone: false, groupNum : groupNum, timeClicked : nil))
        }
        
        permInfo = cellInfo.map({$0})
        print(cellInfo.description)
    }
//Yup
    @IBAction func resetButton(_ sender: UIButton) {
        resetStuff()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
//    CellInfo length is size of table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("num steps: \(stage!.steps.count)")
//        return (cellInfo.filter {!$0.cellDone}).count
        return cellInfo.count

    }
    
//    Makes a cell either a stage cell or a duty heading. Constructs from data stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = cellInfo[indexPath.row].type
//        print("Setting cell Info")

        if (type == .Stage) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stageCell", for: indexPath) as! StageNameViewCell
            
            let dataIndex = cellInfo[indexPath.row].stepIndex
            let people = stage!.steps[dataIndex].people
            
            let dutyString = people.map({"\($0.rawValue)"}).joined(separator: ", ")
            
            print("Person Name: \(dutyString)")
            cell.name = dutyString
            cell.backgroundColor = UIColorFromRGB(rgbValue: meGreen)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as! StepViewCell

            let dataIndex = cellInfo[indexPath.row].stepIndex
            if cellInfo[indexPath.row].cellDone {
                cell.setName(newName: " ")
            } else {
                let description = stage!.steps[dataIndex].description
                print("Duty description: \(description)")
                cell.setName(newName: description)
            }
           
            cell.backgroundColor = (cellInfo[indexPath.row].cellDone) ? UIColorFromRGB(rgbValue: meGreen) : UIColorFromRGB(rgbValue: meRed)
//            cell.accessoryType = (cellInfo[indexPath.row].cellDone) ? .checkmark : .none

            
            return cell
        }
        
        
     
        // Configure the cell...
    
    }
//    Internet function
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //TODO: Disappear things in blocks. Clear text while clicking off. Wait until all done with section to remove all
//    So that each row changes color and gets marked as completed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selecred")
        
        
        
        
        
//        cellInfo.remove(at: indexPath.row)
   
        let index = indexPath.row
//        https://stackoverflow.com/questions/39513258/get-current-date-in-swift-3/39514533
        permInfo[cellInfo[index].cellIndex].timeClicked = Date()


        if (cellInfo[index].type == .Step) {

//            cellInfo.remove(at: index)


            if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? StepViewCell {
                cell.stepName.text = ""
                cellInfo[index].cellDone = true
                permInfo[cellInfo[index].cellIndex].cellDone = true
                
            }

            //Part where I check to see if all duties of one discipline are done before removing the whole section
            var shouldRemove = true
            var i = 0
            for data in cellInfo {
                if data.groupNum == cellInfo[index].groupNum {
                    if cellInfo[i].type == .Step {
                        shouldRemove = cellInfo[i].cellDone && shouldRemove
                    }
                }
                i += 1
            }
            
          
            //Part where I remove the whole section
//            print(cellInfo.description)

            print("Should remove \(shouldRemove)")
            let refGroupNum = cellInfo[index].groupNum

            if shouldRemove {
                i = 0
                for _ in 0..<cellInfo.count {
                    
                    if cellInfo[i].groupNum == refGroupNum {
                        if cellInfo[i].type == .Stage {
                            cellInfo[i].cellDone = true
                            permInfo[cellInfo[i].cellIndex].cellDone = true
                            permInfo[cellInfo[i].cellIndex].timeClicked = Date()
                        }
                        cellInfo.remove(at: i)
                        print("Removing")
                        i -= 1
                    }
                    i += 1
                }
                print(permInfo.description)

            }



  
        
            tableView.reloadData()

            }
        }
    
        
        
        
        
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    }

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
