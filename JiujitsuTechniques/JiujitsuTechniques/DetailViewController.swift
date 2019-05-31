// Project:     Lab12
// Author:      White
// Date:        5/7/19
// File:        DetailViewController.swft

//
//  Created by Casey White on 3/12/19.
//  Copyright © 2019 Carl Fowler. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblAttack: UILabel!
    @IBOutlet weak var lblHrsTrained: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            
            if let lblPosition = lblPosition {lblPosition.text = "\(detail.position!)\n"}
            
            if let lblAttack = lblAttack {lblAttack.text = "\(detail.attack!)\n"}
            
            if let lblHrsTrained = lblHrsTrained {lblHrsTrained.text = "\(detail.hoursTrained!)\n"}
            
            if let lblRank = lblRank {lblRank.text = "\(detail.rank!)\n"}
            
            if let lblDate = lblDate {lblDate.text = "\(detail.date!)\n"}
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Technique? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

