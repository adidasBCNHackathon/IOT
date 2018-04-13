//
//  NFCParser.swift
//  readingNFC
//
//  Created by Duato, Laura on 10/3/18.
//  Copyright © 2018 Duato, Laura. All rights reserved.
//

import Foundation
import CoreNFC
import VYNFCKit

class NFCParser {
    static func parse(payload: NFCNDEFPayload) -> String {
        
        if let parsedPayload = VYNFCNDEFPayloadParser.parse(payload) {
            var text = ""
            var urlString = ""
            if let parsedPayload = parsedPayload as? VYNFCNDEFTextPayload {
                text = String(format: "%@%@", text, parsedPayload.text)
            } else if let parsedPayload = parsedPayload as? VYNFCNDEFURIPayload {
                text = String(format: "%@%@", text, parsedPayload.uriString)
                urlString = parsedPayload.uriString
            } else if let parsedPayload = parsedPayload as? VYNFCNDEFTextXVCardPayload {
                text = String(format: "%@%@", text, parsedPayload.text)
            } else if let sp = parsedPayload as? VYNFCNDEFSmartPosterPayload {
                for textPayload in sp.payloadTexts {
                    if let textPayload = textPayload as? VYNFCNDEFTextPayload {
                        text = String(format: "%@%@\n", text, textPayload.text)
                    }
                }
                text = String(format: "%@%@", text, sp.payloadURI.uriString)
                urlString = sp.payloadURI.uriString
            } else if let wifi = parsedPayload as? VYNFCNDEFWifiSimpleConfigPayload {
                for case let credential as VYNFCNDEFWifiSimpleConfigCredential in wifi.credentials {
                    text = String(format: "%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                                  text, credential.ssid, credential.networkKey, credential.macAddress,
                                  VYNFCNDEFWifiSimpleConfigCredential.authTypeString(credential.authType),
                                  VYNFCNDEFWifiSimpleConfigCredential.encryptTypeString(credential.encryptType)
                    )
                }
                if let version2 = wifi.version2 {
                    text = String(format: "%@\nVersion2: %@", text, version2.version)
                }
            } else {
                text = "Parsed but unhandled payload type"
            }
            return text
        }
        return ""
    }
}
