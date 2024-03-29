//
//  AuthViewController.swift
//  DiscordApp
//
//  Created by Viktor Varenik on 21.03.2023.
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(didAuth: Bool, token: String)
}

final class AuthViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()
    
    private let authLink = "https://discord.com/login"
    private let appLink = "https://discord.com/app"
    
    var coordinator: Coordinator?
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        [webView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setUpConstraints()
        
        // Load auth page
        let myURL = URL(string: authLink)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func injectJs(code: String) {
        let script = WKUserScript(
            source: code,
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        
        let controller = webView.configuration.userContentController
        controller.removeAllScriptMessageHandlers()
        controller.add(self, name: "injectJsHandler")
        controller.addUserScript(script)

        Logger.logInfo(message: "Injected JS: \(code)")
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        defer { decisionHandler(.allow) }
        guard let url = navigationAction.request.url else { return }

        // Auth ok
        if url.absoluteString == appLink {
            // Magic script for fetching auth token
            let code = "var a=(webpackChunkdiscord_app['push']([[''],{},b=>{m=[];for(let d in b['c'])m['push'](b['c'][d]);}]),m)['find'](b=>b?.['exports']?.['default']?.['getToken']!==void 0x0)['exports']['default']['getToken']();window['webkit']['messageHandlers']['injectJsHandler']['postMessage']({'token':a});"
            injectJs(code: code)
        }
    }
}

extension AuthViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "injectJsHandler":
            guard let body = message.body as? [String: Any] else {
                print("could not convert message body to dictionary: \(message.body)")
                return
            }
            guard let token = body["token"] as? String else {
                print("Could not locate payload param in callback request")
                return
            }

            print("Token received: \(token)")
            TokenService.userToken = token
            dismiss(animated: true)
            self.delegate?.authViewController(didAuth: true, token: token)
        default:
            print("Invoked unknown js handler: \(message.name)")
        }
    }
}
