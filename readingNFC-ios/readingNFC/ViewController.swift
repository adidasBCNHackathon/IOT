//
//  ViewController.swift
//  readingNFC
//
//  Created by Duato, Laura on 8/3/18.
//  Copyright © 2018 Duato, Laura. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    var session: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let output = "Enabling...\n\n"
        myLabel.text = output
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.begin()
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {

        DispatchQueue.main.async {
            self.myLabel.text = "Detected NDEF"
            
            for message in messages {
                for record in message.records {
                    let resultParser = NFCParser.parse(payload: record)
                    print("Parser text: \(resultParser)")
                    self.myLabel.text = "\(resultParser)"
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
