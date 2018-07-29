//
//  WebViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/29.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit
import WebKit
private let reuseIdentifier = "Cell"

class WebViewController: UIViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    
    
    

    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url=URL(String:"https://apple.com")
//        let request=URLRequest(url: url!)
//        webView.location(request)
        
        let contentController=WKUserContentController()
        
        
        let jScript:String="var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);msg();"
        
        let userScript=WKUserScript(source: jScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        
        contentController.addUserScript(userScript)
        contentController.add(self, name: "callbackHandler")
        let preferences=WKPreferences()
        preferences.javaScriptEnabled=true
        let configration=WKWebViewConfiguration()
        configration.preferences=preferences
        configration.userContentController=contentController
        
        webView=WKWebView(frame: view.bounds, configuration: configration)
        webView.uiDelegate=self
        webView.navigationDelegate=self
        self.view.addSubview(webView)
        
        let html:String="<html><body><button onclick='query()'>Prompt</button><br /><button type='button' onclick='msg()' text='Hi'>Just Alert Hi</button><br /><button type='button' onclick='callNativeApp()' text='Send Message To Native App'>Send Message To Native App</button><p id='demo'></p><script>function query() { var os = prompt('你現在用什麼作業系統', 'iOS'); if (os != null) { document.getElementById('demo').innerHTML = os + ' is best operation syste, in the world';return os;}}function getelement(){return 'value from javascript function';}function msg(){alert('Hi !');}function callNativeApp(){webkit.messageHandlers.callbackHandler.postMessage('call native from javascript');}</script></body></html>"
        
        webView.loadHTMLString(html,baseURL:nil)

    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        completionHandler()
        
        let alert=UIAlertController(title: "JavaScriptAlertPanel", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {
            (act:UIAlertAction)
            in
            print("Confirm pressed")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        var txt:UITextField?
        let alert = UIAlertController(title: prompt, message: "Input Text", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textTextField:UITextField)
            in
            textTextField.text=defaultText
            txt=textTextField
        })
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {
            (act:UIAlertAction)
            in
            print("\(String(describing:txt?.text))")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (act:UIAlertAction)
            in
            if let input=alert.textFields?.first?.text{
                completionHandler(input)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }


}
