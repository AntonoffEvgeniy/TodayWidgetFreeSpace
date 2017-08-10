//
//  TodayViewController.swift
//  FreeSpace
//
//  Created by Evgeniy Antonov on 7/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import NotificationCenter

let kUserDefaultsKeySystemSize = "system_size"
let kUserDefaultsKeyFreeSize = "free_size"

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var freeSpaceProgressView: UIProgressView!
    @IBOutlet weak var freeSpaceRateLabel: UILabel!
    @IBOutlet weak var usedSpaceLabel: UILabel!
    @IBOutlet weak var freeSpaceLabel: UILabel!
    @IBOutlet weak var totalSpaceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        updateSize()
        updateUI()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - custom functions
    func updateSize() {
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
        if let systemSize = systemAttributes?[.systemSize] as? Double, let freeSize = systemAttributes?[.systemFreeSize] as? Double {
            UserDefaults.standard.set(systemSize, forKey: kUserDefaultsKeySystemSize)
            UserDefaults.standard.set(freeSize, forKey: kUserDefaultsKeyFreeSize)
        }
    }
    
    func updateUI() {
        let systemSize = UserDefaults.standard.double(forKey: kUserDefaultsKeySystemSize)
        let freeSize = UserDefaults.standard.double(forKey: kUserDefaultsKeyFreeSize)
        let usedSize = systemSize - freeSize
        let sizeRate = usedSize / systemSize
        
        let rateString = String(format: "%.1f", sizeRate * 100)
        freeSpaceRateLabel.text = "\(rateString) %"
        freeSpaceProgressView.progress = Float(sizeRate)
        usedSpaceLabel.text = "Used: \(usedSize.formattedString())"
        freeSpaceLabel.text = "Free: \(freeSize.formattedString())"
        totalSpaceLabel.text = "Total: \(systemSize.formattedString())"
    }
}

internal extension Double {
    func formattedString() -> String {
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file)
    }
}
