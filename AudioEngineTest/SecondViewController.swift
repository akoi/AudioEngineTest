//
//  SecondViewController.swift
//  AudioEngineTest
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {

    var engine: AVAudioEngine!
    var nodes: [String: AVAudioPlayerNode]!
    var format: AVAudioFormat!
    
    @IBAction func unwindFromThird(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nodes = [:]
        self.engine = AVAudioEngine()
        
        initialiseNode("buffer", loop: true)
        initialiseNode("file", loop: false)
        
        engine.prepare()
    }

    
    private func initialiseNode(filename: String, loop: Bool) {
        
        var fileError: NSError?
        let file = AVAudioFile(forReading: NSURL(
            fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "aifc")!), error: &fileError
        )
        
        let sourceNode = AVAudioPlayerNode()
        self.format = file.processingFormat
        
        engine.attachNode(sourceNode)
        engine.connect(sourceNode, to: engine.mainMixerNode, format: self.format)
        
        if (loop) {
            let fileCapacity = UInt32(file.length)
            let buffer = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: fileCapacity)
            var bufferError: NSError?
            file.readIntoBuffer(buffer, error:&bufferError)
            sourceNode.scheduleBuffer(buffer!, atTime: nil, options: .Loops, completionHandler: nil)
        } else {
            sourceNode.scheduleFile(file, atTime: nil, completionHandler: nil)
        }
        
        self.nodes[filename] = sourceNode
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "openThirdController") {
            var vc = segue.destinationViewController as ThirdViewController
            vc.nodes = self.nodes
            vc.engine = self.engine
            vc.format = self.format
        }
    }
    
    deinit {
        self.nodes = nil
        self.engine = nil

        println("Deinit SecondViewController")
    }
}
