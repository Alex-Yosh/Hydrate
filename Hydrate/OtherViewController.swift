//
//  OtherViewController.swift
//  Hydrate
//
//  Created by Alex Yoshida on 2021-09-18.
//

import UIKit

class OtherViewController: UIViewController {

    //initalize
    var result: Result?
    var reading = [Int]()
    var defaultwater = 0.0
    var Water = 0.0
    
    @IBOutlet var FirstName: UILabel!
    @IBOutlet var WaterNeeded: UILabel!
    @IBOutlet var Fun: UILabel!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var Consumed: UILabel!
    var Name: String!
    var Age: String!
    var Weight: String!
    var Gender: String!
    var Height: String!
    var Minutes: String!
    
    
    @IBOutlet weak var WaterBottle: UIImageView!
    
    
    
    //viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirstName.text = "Welcome " + Name + "!"
        parseJSON()
        let i = Int((result?.feeds.count)!)
        for x in 0..<i{
            reading.append(Int((result?.feeds[x].field1)!)!)
        }
        defaultwater = waterCalc()
        print(defaultwater)
        Water=defaultwater + waterDrank()
        
        if Water>0{
            WaterNeeded.text = String(rounding(Water)) + " L"
            waterbottleimage()
        }else{
            WaterNeeded.text = "0.00 L"
        }
        
        percent.text = rounding(100.0 - ((defaultwater-Water)/defaultwater)*100.0) + "%"
        Consumed.text = rounding(-(waterDrank())) + " L"
        Fun.text = funFacts()
    }
    
    
    //sigdig
    func rounding(_ x:Double) -> String{
        let value = x
        let formatted = String(format: "%.2f", value)
        return formatted
    }
    //funFacts
    func funFacts() -> String{
        
        let facts = ["Cartilage (make up the joints and the disk of the spine) includes approximately 80% water", "Blood is more than 90% water and delivers oxygen to the other parts of the human body", "Dehydration could lead to more skin disorders and wrinkling on the skin", "Dehydration can negatively impact brain structure and function; also associated with developing hormones and neurotransmitters", "Long periods of dehydration result with issues thinking and reasoning", "Everyone is thirsty", "Dehydration could lead to a difficulty handling higher temperatures", "When dehydrated, airways are held back by the body in order to prevent water loss", "Water can assist in weight loss", "You are as dry as a cactus!", "DRINK MORE NOW!", "You can do it!", "75% of people are chronically dehydrated", "Keep drinking!", "MORE AND MORE WATER"]
        
        let randomInt = Int.random(in: 0...(facts.count-1))
        return facts[randomInt]
    }
    

    
    //calculate water drank
    func waterDrank() -> Double{
        
        var inital = 0
        var final = 0
        var Difference = 0.0
        var first = true
        
        for value in reading{
            
            if Double(value) > 21{
                continue
            }
            if first{
                first=false
                inital=value
                continue
            }
            
            final = inital
            inital = value
        
        
            //diameter = 9.5cm
            let area = (4.75 * 4.75) * 3.14
            Difference -= ((Double(inital) - Double(final)) * area)/1000.0
        }
    
        return Difference
    }
    
    //waterbottle image
    func waterbottleimage(){
        let segmants = defaultwater/5

        if Water > (4 * segmants){
            WaterBottle.image = UIImage(named: "five")
        }
        else if Water > (3 * segmants){
            WaterBottle.image = UIImage(named: "four")
        }
        else if Water > (2 * segmants){
            WaterBottle.image = UIImage(named: "three")
        }
        else if Water > (segmants){
            WaterBottle.image = UIImage(named: "two")
        }
        else if Water > 0{
            WaterBottle.image = UIImage(named: "one")
        }
        else{
            WaterBottle.image = UIImage(named: "zero")
        }
    }
    
    
    
    
    
    
    func waterCalc() ->Double{
        //off age
        var ageTotal = 0.0
        
        if (Int(Age)! >= 12 && Int(Age)! < 14){
        ageTotal = 1.65
        }
        else if (Int(Age)! >= 14 && Int(Age)! < 19){
        ageTotal = 1.89
        }
        else if (Gender == "Male" && Int(Age)! >= 19){
        ageTotal = 2.98
        }
        else if (Gender == "Female" && Int(Age)! >= 19)
        {
            ageTotal = 2.19
        }
        
        var weight=0.0
        if String(Weight).count == 5{
            let index = String(Weight).index(String(Weight).startIndex, offsetBy: 2)
            let mySubstring = String(Weight)[..<index]
            weight = Double(mySubstring)!
        }
        
        
        //off weight
        var weightTotal = weight * 2/3
        //adds extra time from physical activity
        let extraTime = 12 * (Double(Minutes)!/30)
        weightTotal = round(100*((weightTotal+extraTime)/33.814))/100
        //ensures range of total water intake is returned
        
        return (weightTotal + ageTotal) / 2.0
        
    }


    func parseJSON(){
        let url = URL(string: "https://api.thingspeak.com/channels/1509916/feeds.json")!
        do{
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Result.self, from: jsonData)
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    struct Result: Codable {
        let feeds: [waterData]
    }

    struct waterData: Codable{
        
        var created_at: String!
        var entry_id: Int!
        var field1: String!
    }

    
    //button
    @IBAction func didTapBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
   
    
    @IBAction func Refresh(_ sender: Any) {
        self.viewDidLoad()
        self.viewWillAppear(false)
    }
 
    
}
