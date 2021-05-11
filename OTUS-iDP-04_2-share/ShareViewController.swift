//
//  ShareViewController.swift
//  OTUS-iDP-04_2-share
//
//  Created by Igor Andryushenko on 08.05.2021.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

        override func viewDidLoad() {

            super.viewDidLoad()
            self.handleSharedFile()
        }
        
        private func handleSharedFile() {
          let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
          let contentType = kUTTypeData as String
          for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier(contentType) {
              provider.loadItem(forTypeIdentifier: contentType,
                                options: nil) { [unowned self] (data, error) in
                guard error == nil else { return }
                
                if let str = data as? String,
                   let text = try? String(str) {

                    //print(text)

                   
//                    let defaults = UserDefaults.standard
//                    defaults.set(text, forKey: "shared")
                    
                    let defaults = UserDefaults(suiteName: "group.otus.idp.04") 
                    defaults?.set(text, forKey:"shared")
                    defaults?.synchronize()
                    
                    openContainerApp()
                } else {
                  fatalError("err")
                }
              }
            }
          }
        }
        
        private func save(_ data: Data, key: String, value: Any) {
          let userDefaults = UserDefaults()
          userDefaults.set(data, forKey: key)
        }
        
        func openContainerApp() {

               let scheme = "otus04share://type"

               let url: URL = URL(string: scheme)!

               let context = NSExtensionContext()

               context.open(url, completionHandler: nil)

               var responder = self as UIResponder?

               let selectorOpenURL = sel_registerName("openURL:")

               while (responder != nil) {

                   if responder!.responds(to: selectorOpenURL) {

                       responder!.perform(selectorOpenURL, with: url)

                       break

                   }

                   responder = responder?.next

               }

               self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)

           }

    }


