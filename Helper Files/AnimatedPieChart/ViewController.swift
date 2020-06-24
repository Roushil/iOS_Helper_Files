//
//  ViewController.swift
//  PieChart
//
//  Copyright © 2019 TNODA.com. All rights reserved.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController {

    var fpc: FloatingPanelController!
    @IBOutlet var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.slices = [
            Slice(percent: 0.4, color: UIColor.red),
            Slice(percent: 0.3, color: UIColor.blue),
            Slice(percent: 0.2, color: UIColor.purple),
            Slice(percent: 0.1, color: UIColor.green)
        ]
        
// MARK:  display controller below
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        let secondVC = self.storyboard?.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
        fpc.set(contentViewController: secondVC)
        fpc.addPanel(toParent: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fpc.removePanelFromParent(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        pieChartView.animateChart()
    }
}

extension ViewController: FloatingPanelControllerDelegate{
    
    
}
