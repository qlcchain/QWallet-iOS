//
//  BrowserViewController.swift
//  Qlink
//
//  Created by 旷自辉 on 2020/10/20.
//  Copyright © 2020 pan. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import JavaScriptCore
import PromiseKit
import TrustWalletCore
import UserNotifications
import BigInt

protocol BrowserViewControllerDelegate: class {
    //func didCall(action: DappAction, callbackID: Int, inBrowserViewController viewController: ViewController)
    func didVisitURL(url: URL, title: String, inBrowserViewController viewController: BrowserViewController)
    func dismissKeyboard(inBrowserViewController viewController: BrowserViewController)
    func forceUpdate(url: URL, inBrowserViewController viewController: BrowserViewController)
}
 class BrowserViewController: QBaseViewController {

    @IBOutlet weak var webBackView: UIView!
    // walletconnect
    var interactor: WCInteractor?
    let clientMeta = WCPeerMeta(name: "WalletConnect SDK", url: "https://github.com/TrustWallet/wallet-connect-swift")
    
    @IBOutlet weak var navTtile: UILabel!
    
    @objc public var defaultAddress: String = ""
    @objc public var websitUrl: String = ""
    @objc public var navTitleString: String = ""
    
    var defaultChainId: Int = 1
    var recoverSession: Bool = false
    var notificationGranted: Bool = false
    var uri = ""

    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    private weak var backgroundTimer: Timer?
    
    private struct Keys {
            static let estimatedProgress = "estimatedProgress"
            static let developerExtrasEnabled = "developerExtrasEnabled"
            static let URL = "URL"
            static let ClientName = "AlphaWallet"
        }
        
        private lazy var userClient: String = {
            return Keys.ClientName + "/" + (Bundle.main.versionNumber ?? "")
        }()
        
        private lazy var errorView: BrowserErrorView = {
            let errorView = BrowserErrorView()
            errorView.translatesAutoresizingMaskIntoConstraints = false
            errorView.delegate = self
            return errorView
        }()
        
        private var estimatedProgressObservation: NSKeyValueObservation!
        
        weak var delegate: BrowserViewControllerDelegate?
        
        lazy var webView: WKWebView = {
            let webView = WKWebView(
                frame: .zero,
                configuration: config
            )
            webView.allowsBackForwardNavigationGestures = true
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.navigationDelegate = self
            if true {
                webView.configuration.preferences.setValue(true, forKey: Keys.developerExtrasEnabled)
            }
            return webView
        }()

        lazy var progressView: UIProgressView = {
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.tintColor = UIColor.green
            progressView.trackTintColor = .clear
            return progressView
        }()

        lazy var config: WKWebViewConfiguration = {
            let config = WKWebViewConfiguration.make(forMianUrl: "https://mainnet.infura.io/v3/dc2243ed5aa5488d9fcf794149f56fc2", chainId: 1, address:self.defaultAddress, in: ScriptMessageProxy(delegate: self))
            config.websiteDataStore = WKWebsiteDataStore.default()
            return config
        }()
        
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
       // init() {
           
          //  super.init(nibName: nil, bundle: nil)


    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       // }
        
        private func initUI() {
            webBackView.addSubview(webView)
            injectUserAgent()

            webView.addSubview(progressView)
            webView.bringSubview(toFront: progressView)
            webBackView.addSubview(errorView)
            let edgeInsets: UIEdgeInsets = .zero
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: webBackView.leadingAnchor, constant: edgeInsets.left),
                webView.trailingAnchor.constraint(equalTo: webBackView.trailingAnchor, constant: -edgeInsets.right),
                webView.topAnchor.constraint(equalTo: webBackView.topAnchor, constant: edgeInsets.top),
                webView.bottomAnchor.constraint(equalTo: webBackView.bottomAnchor, constant: -edgeInsets.bottom),
                
                progressView.topAnchor.constraint(equalTo: webBackView.layoutGuide.topAnchor),
                progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
                progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
                progressView.heightAnchor.constraint(equalToConstant: 2),

                errorView.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: edgeInsets.left),
                errorView.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: -edgeInsets.right),
                errorView.topAnchor.constraint(equalTo: webView.topAnchor, constant: edgeInsets.top),
                errorView.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: -edgeInsets.bottom),
            ])
            view.backgroundColor = .white

            estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] webView, _ in
                guard let strongSelf = self else { return }

                let progress = Float(webView.estimatedProgress)

                strongSelf.progressView.progress = progress
                strongSelf.progressView.isHidden = progress == 1
            }
        }
    
    @IBAction func clickBackActon(_ sender: Any) {
        
        if (!self.webView.canGoBack) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.webView.goBack()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = .white
        // walletconnect
        self.navTtile.text = navTitleString
        self.initUI()
        self.goTo(url: URL(string: websitUrl)!)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print("<== notification permission: \(granted)")
            if let error = error {
                print(error)
            }
            self.notificationGranted = granted
        }
    }
    
    // -----------------------walletconnect action-----------------
    func connect(session: WCSession) {
        print("==> session", session)
        let interactor = WCInteractor(session: session, meta: clientMeta, uuid: UIDevice.current.identifierForVendor ?? UUID())
        configure(interactor: interactor)

        interactor.connect().done { [weak self] connected in
            //self?.connectionStatusUpdated(connected)
        }.catch { [weak self] error in
            self?.presentVC(error: error)
        }

        self.interactor = interactor
    }

    func configure(interactor: WCInteractor) {
        let accounts = [defaultAddress]
        let chainId = defaultChainId

        interactor.onError = { [weak self] error in
           // self?.presentVC(error: error)
        }

        interactor.onSessionRequest = { [weak self] (id, peerParam) in
             self?.interactor?.approveSession(accounts: accounts, chainId: chainId).cauterize()
        }

//        interactor.onDisconnect = { [weak self] (error) in
//            if let error = error {
//                print(error)
//            }
//           // self?.connectionStatusUpdated(false)
//        }

//        interactor.eth.onSign = { [weak self] (id, payload) in
//            let alert = UIAlertController(title: payload.method, message: payload.message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
//                self?.interactor?.rejectRequest(id: id, message: "User canceled").cauterize()
//            }))
//            alert.addAction(UIAlertAction(title: "Sign", style: .default, handler: { _ in
//                self?.signEth(id: id, payload: payload)
//            }))
//            self?.present(alert, animated: true, completion: nil)
//        }

        interactor.eth.onTransaction = { [weak self] (id, event, transaction) in
            let data = try! JSONEncoder().encode(transaction)
            let message = String(data: data, encoding: .utf8)
            let dataDic:NSDictionary =  (self?.getDictionaryFromJSONString(jsonString: message ?? ""))!

            print(dataDic);
            
            WalletSignUtil.signAndSendEthTranser(withPamaerDic: dataDic as! [AnyHashable : Any], gasPrice: "", sendComplete: {(isfinsh,resutl) ->() in
                print(isfinsh)
                print(resutl)
                self?.interactor?.approveRequest(id: id, result: resutl).cauterize()
            })
        }

   
    }

    func approve(accounts: [String], chainId: Int) {
        interactor?.approveSession(accounts: accounts, chainId: chainId).done {
            print("<== approveSession done")
        }.catch { [weak self] error in
            self?.presentVC(error: error)
        }
    }

//    func signEth(id: Int64, payload: WCEthereumSignPayload) {
//        let data: Data = {
//            switch payload {
//            case .sign(let data, _):
//                return data
//            case .personalSign(let data, _):
//                let prefix = "\u{19}Ethereum Signed Message:\n\(data)".data(using: .utf8)!
//                return prefix + data
//            case .signTypeData(_, let data, _):
//                // FIXME
//                return data
//            }
//        }()
//
//        var result = privateKey.sign(digest: Hash.keccak256(data: data), curve: .secp256k1)!
//        result[64] += 27
//        self.interactor?.approveRequest(id: id, result: "0x" + result.hexString).cauterize()
//    }

    

    func presentVC(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
     
        let jsonData:Data = jsonString.data(using: .utf8)!
     
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
         
     
    }
    
    func connectTapped(wcuri:String?) {
        guard let string = wcuri, let session = WCSession.from(string: string) else {
            print("invalid uri: \(String(describing:wcuri))")
            return
        }
        uri = wcuri!
        connect(session: session)
    }
    
    @IBAction func clickReloadAction(_ sender: Any) {
        self.reload()
    }
    func approveTapped() {
        
        guard let chainId = Int("1") else {
            print("invalid chainId")
            return
        }
        guard EthereumAddress.isValidString(string: defaultAddress) || CosmosAddress.isValidString(string: defaultAddress) else {
            print("invalid eth or bnb address")
            return
        }
        approve(accounts: [defaultAddress], chainId: chainId)
    }
    
    // ----------------------browser action----------------------
    private func injectUserAgent() {
            webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
                guard let strongSelf = self, let currentUserAgent = result as? String else { return }
                strongSelf.webView.customUserAgent = currentUserAgent + " " + strongSelf.userClient
            }
        }
        
    func goTo(url: URL) {
            hideErrorView()
            webView.load(URLRequest(url: url))
        }
        
    func notifyFinish(callbackID: Any, value: Any, isSuccess:Bool) {
            let script: String = {
                if (isSuccess) {
                    return "executeCallback(\(callbackID), null, \"\(value)\")"
                } else {
                    return "executeCallback(\(callbackID), \"\(value)\", null)"
                }
            }()
            webView.evaluateJavaScript(script, completionHandler: nil)
        }
        
        func reload() {
            hideErrorView()
            webView.reload()
        }

        private func stopLoading() {
            webView.stopLoading()
        }

        private func recordURL() {
            guard let url = webView.url else { return }
            delegate?.didVisitURL(url: url, title: webView.title ?? "", inBrowserViewController: self)
        }

        private func hideErrorView() {
            errorView.isHidden = true
        }

        deinit {
            estimatedProgressObservation.invalidate()
        }

        func handleError(error: Error) {
            if error.code == NSURLErrorCancelled {
                return
            } else {
                if error.domain == NSURLErrorDomain,
                    let failedURL = (error as NSError).userInfo[NSURLErrorFailingURLErrorKey] as? URL {
                    delegate?.forceUpdate(url: failedURL, inBrowserViewController: self)
                }
                errorView.show(error: error)
            }
        }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.connectTapped(wcuri: "wc:036b9428-3fc4-4639-8a29-60194e511188@1?bridge=https%3A%2F%2Fbridge.walletconnect.org&key=ffdf9d0cff6734abe47b20992ecd8ded995608c725c75a8c9de7c801534b3bc2")
//    }
}
//  65000000000
extension BrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navTtile.text = webView.url?.absoluteString
        recordURL()
        hideErrorView()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        hideErrorView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url, let scheme = url.scheme else {
            return decisionHandler(.allow)
        }
        let app = UIApplication.shared
        if ["tel", "mailto"].contains(scheme), app.canOpenURL(url) {
            app.open(url)
            return decisionHandler(.cancel)
        }
//        let folderWithFilenameAbsoluteStringNoEncodig: String = url.absoluteString.removingPercentEncoding!
//        var uri:String = ""
//        if let range = folderWithFilenameAbsoluteStringNoEncodig.range(of:"uri=") {
//            uri = String(folderWithFilenameAbsoluteStringNoEncodig.suffix(from: range.upperBound))
//            print(uri)
//            self.connectTapped(wcuri: uri)
//            return decisionHandler(.cancel)
//        }
  //      print("folderWithFilenameAbsoluteStringNoEncodig = \(folderWithFilenameAbsoluteStringNoEncodig)")
//        if folderWithFilenameAbsoluteStringNoEncodig.contains("/wc/cn") {
//            return decisionHandler(.cancel)
//        }
        decisionHandler(.allow)

    }
}

extension BrowserViewController: WKScriptMessageHandler {
     func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      
        
        if let body = message.body as? [String: Any], var object = body["object"] as? [String: Any] {
            
            print(body)
           
            
            if (body["name"] as? String ?? "" == "signTransaction") {
                 
                let transerView:ConfirmTranserView = ConfirmTranserView.getInstance()
                transerView.configWith(fromAddress: object["from"] as! String, toAddress: object["to"] as! String, gasLimit: object["gas"] as! String)
                
                 guard let strongSelf:BrowserViewController = self else { return }
                
                transerView.confirmBlock = {(isConfirm: Bool ,gasPrice : String?)in
                    
                    if isConfirm {
                        
                        WalletSignUtil.signAndSendEthTranser(withPamaerDic: object as [AnyHashable : Any], gasPrice: gasPrice ?? "", sendComplete: {(isfinsh,resutl) ->() in

                                print(isfinsh)
                                print(resutl)
                                strongSelf.notifyFinish(callbackID: body["id"] ?? 0, value: resutl, isSuccess: isfinsh)

                        })
                        
                    } else {
                        
                        strongSelf.notifyFinish(callbackID: body["id"] ?? 0, value: "Reject", isSuccess: false)
                        
                    }
                    
                }
                transerView.show()
                
            }
            
           
           
        }
        
      
        
//        print(body!)
//        print(jsonString!)
        
        
        //let dataDic:NSDictionary =  (self?.getDictionaryFromJSONString(jsonString: message ?? ""))!

//        print(dataDic);
//
//        WalletSignUtil.signAndSendEthTranser(withPamaerDic: dataDic as! [AnyHashable : Any], sendComplete: {(isfinsh,resutl) ->() in
//            print(isfinsh)
//            print(resutl)
//            self?.interactor?.approveRequest(id: id, result: resutl).cauterize()
//        })
//
//
//        if let body = message.body as? [String: Any], let object = body["object"] as? [String: Any] {
//           let signName = body["name"]
//           let signId = body["id"]
//
//            WalletSignUtil.
//        }
//        guard let command = DappAction.fromMessage(message) else { return }ni
//        let requester = DAppRequester(title: webView.title, url: webView.url)
//        let token = TokensDataStore.token(forServer: server)
//        let transfer = Transfer(server: server, type: .dapp(token, requester))
//        let action = DappAction.fromCommand(command, transfer: transfer)
//
//        delegate?.didCall(action: action, callbackID: command.id, inBrowserViewController: self)
    }
}

extension BrowserViewController: BrowserErrorViewDelegate {
    func didTapReload(_ sender: Button) {
        reload()
    }
}

// walletconnect extension
extension BrowserViewController {
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("<== applicationDidEnterBackground")

        if interactor?.state != .connected {
            return
        }

        if notificationGranted {
            pauseInteractor()
        } else {
            startBackgroundTask(application)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("==> applicationWillEnterForeground")
        if let id = backgroundTaskId {
            application.endBackgroundTask(id)
        }
        backgroundTimer?.invalidate()

        if recoverSession {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.interactor?.resume()
            }
        }
    }

    func startBackgroundTask(_ application: UIApplication) {
        backgroundTaskId = application.beginBackgroundTask(withName: "WalletConnect", expirationHandler: {
            self.backgroundTimer?.invalidate()
            print("<== background task expired")
        })

        var alerted = false
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            print("<== background time remainning: ", application.backgroundTimeRemaining)
            if application.backgroundTimeRemaining < 15 {
                self.pauseInteractor()
            } else if application.backgroundTimeRemaining < 120 && !alerted {
                let notification = self.createWarningNotification()
                UNUserNotificationCenter.current().add(notification, withCompletionHandler: { error in
                    alerted = true
                    if let error = error {
                        print("post error \(error.localizedDescription)")
                    }
                })
            }
        }
    }

    func pauseInteractor() {
        recoverSession = true
        interactor?.pause()
    }

    func createWarningNotification() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "WC session will be interrupted"
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        return UNNotificationRequest(identifier: "session.warning", content: content, trigger: trigger)
    }
}


