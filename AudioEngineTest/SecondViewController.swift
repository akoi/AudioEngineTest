//
//  SecondViewController.swift
//  AudioEngineTest
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {

    var engine: AVAudioEngine = AVAudioEngine()
    var environmentNode = AVAudioEnvironmentNode()
    var nodes = [String: AVAudioPlayerNode]()
    
    
    private func initialiseNode(filename: String, loop: Bool)-> AVAudioPlayerNode {
        
        var fileError: NSError?
        let file = AVAudioFile(forReading: NSURL(
            fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "aifc")!), error: &fileError
        )
        
        let sourceNode = AVAudioPlayerNode()
        engine.attachNode(sourceNode)
        engine.connect(sourceNode, to: environmentNode, format: file.processingFormat)
        
        if (loop) {
            let fileCapacity = UInt32(file.length)
            let buffer = AVAudioPCMBuffer(PCMFormat: sourceNode.outputFormatForBus(0), frameCapacity: fileCapacity)
            var bufferError: NSError?
            file.readIntoBuffer(buffer, error:&bufferError)
            sourceNode.scheduleBuffer(buffer!, atTime: nil, options: .Loops, completionHandler: nil)
        } else {
            sourceNode.scheduleFile(file, atTime: nil, completionHandler: nil)
        }
        
        self.nodes[filename] = sourceNode
        return sourceNode
    }
    
    @IBAction func unwindFromThird(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        environmentNode.renderingAlgorithm = .HRTF
        engine.attachNode(environmentNode)
        engine.connect(environmentNode, to: engine.mainMixerNode, format: engine.mainMixerNode.outputFormatForBus(0))
        
        initialiseNode("buffer", loop: true)
        initialiseNode("file", loop: false)
        
        engine.prepare()
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
        }
    }
    
    deinit {
        println("Deinit SecondViewController")
    }
}
