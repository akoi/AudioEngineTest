//
//  ThirdViewController.swift
//  AudioEngineTest
//

import UIKit
import AVFoundation

class ThirdViewController: UIViewController {

    var engine: AVAudioEngine!
    var nodes: [String: AVAudioPlayerNode]!
    var format: AVAudioFormat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var engineError: NSError?
        engine.startAndReturnError(&engineError)
        
        // register config change notif
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruption:", name: AVAudioEngineConfigurationChangeNotification, object: nil)
        
        playNodes()
        
        println("viewDidLoad: \(self.engine.running)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInterruption(notif: NSNotification) {
        println("####################### \(self.engine.running)")

        var session = AVAudioSession.sharedInstance()
        let active = session.setActive(true, error: nil)
//        if (!self.engine.running) {
//            println("Restarting")
//            
//            var engineError: NSError?
//            engine.startAndReturnError(&engineError)
//            
//            println("handleInterruption: \(self.engine.running): \(engine.outputNode.description): \(engine.outputNode.audioUnit)")
//            
//            self.engine = AVAudioEngine()
//            
//            reattachNodes()
//            
//            // Try playing a new node - works ok
//            //let newNode = initialiseNode("buffer", loop: true)
//            //newNode.play()
//            
//        }
    }
    
    func playNodes() {
        for node in nodes.values {
            node.play()
            println("Playing node")
        }
    }
    
    func reattachNodes() {
        for node in nodes.values {
            engine.attachNode(node)
            engine.connect(node, to: engine.mainMixerNode, format: self.format)
        }
        playNodes()
    }
    
    
    private func initialiseNode(filename: String, loop: Bool)-> AVAudioPlayerNode {
        
        var fileError: NSError?
        let file = AVAudioFile(forReading: NSURL(
            fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "aifc")!), error: &fileError
        )
        
        let sourceNode = AVAudioPlayerNode()
        let format = file.processingFormat
        
        engine.attachNode(sourceNode)
        engine.connect(sourceNode, to: engine.outputNode, format: format)
        
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
        return sourceNode
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
