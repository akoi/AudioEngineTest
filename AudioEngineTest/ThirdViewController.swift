//
//  ThirdViewController.swift
//  AudioEngineTest
//

import UIKit
import AVFoundation

class ThirdViewController: UIViewController {

    var engine: AVAudioEngine!
    var nodes: [String: AVAudioPlayerNode]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var engineError: NSError?
        engine.startAndReturnError(&engineError)
        
        for node in nodes.values {
            node.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        println("Deinit ThirdViewController")
    }
}
