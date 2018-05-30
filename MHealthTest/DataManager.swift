//
//  DataController.swift
//  MHealthTest
//
//  Created by Brady Stoffel on 5/21/18.
//  Copyright © 2018 Brady Stoffel. All rights reserved.
//

import Foundation

class DataManager {
    
    enum Duties : String {
        case Surgeon = "Surgeon", CirculatingNurse = "Circulating Nurse", Anesthesia = "Anesthesia", Perfusion = "Perfusion", All = "Any", None = "None"
    }
    
    struct Step {
        var description : String
        var people : [Duties]
    }
    
    struct Stage {
        var name : String
        var steps : [Step]
    }
    
    struct Surgery {
        var name : String
        var data : [Stage]
    }
    
    //TODO: Move this to a server somehow
    static var allSurgeries = [1 : Surgery(name: "Cardiac Bypass?", data: [
        //Prior to OR transport
        Stage(name : "Prior to OR transport", steps:
            [Step(description: "Discuss availability of equipment, implants", people: [Duties.CirculatingNurse, Duties.Surgeon]),
             Step(description: "Discuss any additional or non-routine instrument requirements", people: [Duties.CirculatingNurse, Duties.Surgeon]),
             
             Step(description: "Discuss standard vs. non-standard line and ET tube placement", people: [Duties.Anesthesia, Duties.Surgeon]),
             Step(description: "Blood component availability", people: [Duties.CirculatingNurse]),
             
             Step(description: "Surgeon Ready", people: [Duties.All]),
             Step(description: "Anesthesia Ready", people: [Duties.All]),
             Step(description: "Perfusion Ready", people: [Duties.All]),
             Step(description: "Circulating Nurse and Room Ready", people: [Duties.All]),
             ]),
        
        //Prior to Induction
        Stage(name : "Prior to Induction", steps :
            [Step(description: "Anticipation of difficult airway? Does the surgeon need to be in the room?", people: [Duties.Anesthesia]),
             ]),
        
        //        Prior to OR incision
        Stage(name : "Prior to OR incision", steps :
            [Step(description: "*In addition to Institutional Timeout", people: [Duties.All]),
             
             //             Surgeon
                Step(description: "Verbalize potential surgical challenges", people: [Duties.Surgeon]),
                Step(description: "Verify cannulation strategy, size, and sites", people: [Duties.Surgeon]),
                Step(description: "Verbalize extent of AO calcification", people: [Duties.Surgeon]),
                Step(description: "Confirm CP strategy (antegrade, retrograde, how often", people: [Duties.Surgeon]),
                
                //             Anesthesia
                Step(description: "Verify focused iTEE findings", people: [Duties.Anesthesia]),
                Step(description: "Verify necessary medication administration (abx, β blockers, immunosuppression)", people: [Duties.Anesthesia]),
                Step(description: "Verify potentional for coagulopathy and potential for hemodynamic issues", people: [Duties.Anesthesia]),
                
                //             Perfusion
                Step(description: "Verbalize completion of pre-pump checklist", people: [Duties.Perfusion]),
                Step(description: "Verbalize blood sparing strategies", people: [Duties.Perfusion]),
                Step(description: "Temperature management strategies", people: [Duties.Perfusion]),
                Step(description: "Blood pressure strategies", people: [Duties.Perfusion]),
                
                ]),
        
        //        Prior to CPB Initiation
        Stage(name : "Prior to CPB Initiation", steps :
            [Step(description: "Ask perfusion - Can we go one bypass?", people: [Duties.Surgeon]),
             Step(description: "Confirm readiness to go on bypass", people: [Duties.Perfusion]),
             ]),
        
        //        After cross clamp removal and prior to separation from CPB
        Stage(name : "After cross clamp removal and prior to separation from CPB", steps :
            
            //            Perfusion
            [Step(description: "Verbalize patient temperature", people: [Duties.Perfusion]),
             Step(description: "Verbalize K⁺, pH, Hgb", people: [Duties.Perfusion]),
             Step(description: "Verbalize how much volume was removed during bypass", people: [Duties.Perfusion]),
             Step(description: "Verbalize vasoactive drugs used during bypass", people: [Duties.Perfusion]),
             
             //             Surgeon
                Step(description: "Review of procedure", people: [Duties.Surgeon]),
                Step(description: "Concerns for TEE review", people: [Duties.Surgeon]),
                Step(description: "Concerns for coming off bypass", people: [Duties.Surgeon]),
                
                //             Anesthesia
                Step(description: "Vent on? Gas on?", people: [Duties.Anesthesia]),
                Step(description: "Echo findings / de-airing", people: [Duties.Anesthesia]),
                Step(description: "Anticipated needs for blood products", people: [Duties.Anesthesia]),
                Step(description: "Hemodynamic support (pressors)", people: [Duties.Anesthesia]),
                Step(description: "Urine output", people: [Duties.Anesthesia]),
                ]),
        
        //        Prior ro protamine Administration
        Stage(name : "Prior to protamine Administration, steps", steps :
            [Step(description: "Ask Anesthesia to administer protamine test dose", people: [Duties.Surgeon]),
             Step(description: "Verbally confirms readiness for protamine test dose", people: [Duties.Perfusion]),
             ]),
        
        //        After Sternal Slosure
        Stage(name : "After Sternal Closure", steps :
            [Step(description: "Communicate ICU readiness to Anesthesia", people: [Duties.CirculatingNurse]),
             Step(description: "Communicate adequate O₂ supply for ICU transport to Anesthesia", people: [Duties.CirculatingNurse]),
             ])
        ]),
                               
                               
        //New Surgery
        
        2 : Surgery(name: "ICU thing", data: [
            //All together
            Stage(name : "ALl ICU things", steps:
                [Step(description: "Identify patient, surgical procedure, surgeon and anesthesiologist", people: [Duties.Anesthesia])
                    
                               ])
            ])
    
    ]

    
    class func getDataForStage(surgery : Int, step : Int) -> Stage {
        
        
        print("Step\(step)")
        print("Surgery\(surgery)")

        return (allSurgeries[surgery]?.data[step])!
    }
    
    class func getNumOfStages(surgery : Int) -> Int? {
        return allSurgeries[surgery]?.data.count
    }
    
    class func getSurgeries() -> [Int : Surgery] {
        return allSurgeries
    }
    
    
}
