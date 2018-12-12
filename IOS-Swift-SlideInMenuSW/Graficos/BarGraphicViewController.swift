//
//  BarGraphicViewController.swift
//  IOS-Swift-SlideInMenuSW
//
//  Created by Mac Tecsup on 11/12/18.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit
import CoreCharts

class BarGraphicViewController: UIViewController,CoreChartViewDataSource {

    @IBOutlet weak var barChart: VCoreBarChart!
    var Arrays = [String]()
    var str = [String]()


    func didTouch(entryData: CoreChartEntry) {
        print(entryData.barTitle)
    }
    func loadCoreChartData() -> [CoreChartEntry] {
        
        return getTurkeyFamouseCityList()
        
    }
    
    func getTurkeyFamouseCityList()->[CoreChartEntry] {
        var allCityData = [CoreChartEntry]()
        let cityNames = str
        let plateNumber = [20,50,30]
        
        for index in 0..<cityNames.count {
            
            let newEntry = CoreChartEntry(id: "\(plateNumber[index])", barTitle: cityNames[index], barHeight: Double(plateNumber[index]), barColor: rainbowColor())
            allCityData.append(newEntry)
            
        }
        
        return allCityData
        
    }
    func removeDuplicates(from items: [String]) -> [String] {
        let uniqueItems = NSOrderedSet(array: items)
        return (uniqueItems.array as? [String]) ?? []
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.dataSource = self
         str = removeDuplicates(from: Arrays)
        print("RESULTTT..IDLIST... \(str)")



    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
 
  

}
