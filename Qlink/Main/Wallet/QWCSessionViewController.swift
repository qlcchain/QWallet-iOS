// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit
import PromiseKit
import TrustWalletCore
import UserNotifications

class QWCSessionViewController: QBaseViewController {

    @IBOutlet weak var uriField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var chainIdField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!

    var interactor: WCInteractor?
    let clientMeta = WCPeerMeta(name: "WalletConnect SDK", url: "https://github.com/TrustWallet/wallet-connect-swift")

    let privateKey = PrivateKey(data: Data(hexString: "8808d99262da2e6f50c88ed43b8ec489dbd074e1a487b1eb93721c69673c571f")!)!

    var defaultAddress: String = ""
    var defaultChainId: Int = 1
    var recoverSession: Bool = false
    var notificationGranted: Bool = false

    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    private weak var backgroundTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let string = "wc:6e9f486b-6a97-4457-ae6c-266660a9ad8b@1?bridge=https%3A%2F%2Fbridge.walletconnect.org&key=ae42f51ca4fd7991a06f8c2735ee1705c8c56fd46d118f993dd38b44b07fe373"

        defaultAddress = CoinType.ethereum.deriveAddress(privateKey: privateKey)
        uriField.text = string
        addressField.text = defaultAddress
        chainIdField.text = "1"
        chainIdField.textAlignment = .center
        approveButton.isEnabled = false
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print("<== notification permission: \(granted)")
            if let error = error {
                print(error)
            }
            self.notificationGranted = granted
        }
    }

    func connect(session: WCSession) {
        print("==> session", session)
        let interactor = WCInteractor(session: session, meta: clientMeta, uuid: UIDevice.current.identifierForVendor ?? UUID())
        configure(interactor: interactor)

        interactor.connect().done { [weak self] connected in
            self?.connectionStatusUpdated(connected)
        }.catch { [weak self] error in
            self?.present(error: error)
        }

        self.interactor = interactor
    }

    func configure(interactor: WCInteractor) {
        let accounts = [defaultAddress]
        let chainId = defaultChainId

        interactor.onError = { [weak self] error in
            self?.present(error: error)
        }

        interactor.onSessionRequest = { [weak self] (id, peerParam) in
            let peer = peerParam.peerMeta
            let message = [peer.description, peer.url].joined(separator: "\n")
            let alert = UIAlertController(title: peer.name, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
                self?.interactor?.rejectSession().cauterize()
            }))
            alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { _ in
                self?.interactor?.approveSession(accounts: accounts, chainId: chainId).cauterize()
            }))
           // self?.show(alert, sender: nil)
            self?.interactor?.approveSession(accounts: accounts, chainId: chainId).cauterize()
        }

        interactor.onDisconnect = { [weak self] (error) in
            if let error = error {
                print(error)
            }
            self?.connectionStatusUpdated(false)
        }

        interactor.eth.onSign = { [weak self] (id, payload) in
            let alert = UIAlertController(title: payload.method, message: payload.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                self?.interactor?.rejectRequest(id: id, message: "User canceled").cauterize()
            }))
            alert.addAction(UIAlertAction(title: "Sign", style: .default, handler: { _ in
                self?.signEth(id: id, payload: payload)
            }))
            self?.show(alert, sender: nil)
        }

        interactor.eth.onTransaction = { [weak self] (id, event, transaction) in
            let data = try! JSONEncoder().encode(transaction)
            let message = String(data: data, encoding: .utf8)
            let alert = UIAlertController(title: event.rawValue, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
                self?.interactor?.rejectRequest(id: id, message: "I don't have ethers").cauterize()
            }))
            self?.show(alert, sender: nil)
        }

        interactor.bnb.onSign = { [weak self] (id, order) in
            let message = order.encodedString
            let alert = UIAlertController(title: "bnb_sign", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak self] _ in
                self?.interactor?.rejectRequest(id: id, message: "User canceled").cauterize()
            }))
            alert.addAction(UIAlertAction(title: "Sign", style: .default, handler: { [weak self] _ in
                self?.signBnbOrder(id: id, order: order)
            }))
            self?.show(alert, sender: nil)
        }
    }

    func approve(accounts: [String], chainId: Int) {
        interactor?.approveSession(accounts: accounts, chainId: chainId).done {
            print("<== approveSession done")
        }.catch { [weak self] error in
            self?.present(error: error)
        }
    }

    func signEth(id: Int64, payload: WCEthereumSignPayload) {
        let data: Data = {
            switch payload {
            case .sign(let data, _):
                return data
            case .personalSign(let data, _):
                let prefix = "\u{19}Ethereum Signed Message:\n\(data)".data(using: .utf8)!
                return prefix + data
            case .signTypeData(_, let data, _):
                // FIXME
                return data
            }
        }()

        var result = privateKey.sign(digest: Hash.keccak256(data: data), curve: .secp256k1)!
        result[64] += 27
        self.interactor?.approveRequest(id: id, result: "0x" + result.hexString).cauterize()
    }

    func signBnbOrder(id: Int64, order: WCBinanceOrder) {
        let data = order.encoded
        print("==> signbnbOrder", String(data: data, encoding: .utf8)!)
        let signature = privateKey.sign(digest: Hash.sha256(data: data), curve: .secp256k1)!
        let signed = WCBinanceOrderSignature(
            signature: signature.dropLast().hexString,
            publicKey: privateKey.getPublicKeySecp256k1(compressed: false).data.hexString
        )
        interactor?.approveBnbOrder(id: id, signed: signed).done({ confirm in
            print("<== approveBnbOrder", confirm)
        }).catch { [weak self] error in
            self?.present(error: error)
        }
    }

    func connectionStatusUpdated(_ connected: Bool) {
        self.approveButton.isEnabled = connected
        self.connectButton.setTitle(!connected ? "Connect" : "Kill Session", for: .normal)
    }

    func present(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.show(alert, sender: nil)
    }

    @IBAction func connectTapped() {
        guard let string = uriField.text, let session = WCSession.from(string: string) else {
            print("invalid uri: \(String(describing: uriField.text))")
            return
        }
        if let i = interactor, i.state == .connected {
            i.killSession().done {  [weak self] in
                self?.approveButton.isEnabled = false
                self?.connectButton.setTitle("Connect", for: .normal)
            }.cauterize()
        } else {
            connect(session: session)
        }
    }

    @IBAction func approveTapped() {
        guard let address = addressField.text,
            let chainIdString = chainIdField.text else {
            print("empty address or chainId")
            return
        }
        guard let chainId = Int(chainIdString) else {
            print("invalid chainId")
            return
        }
        guard EthereumAddress.isValidString(string: address) || CosmosAddress.isValidString(string: address) else {
            print("invalid eth or bnb address")
            return
        }
        approve(accounts: [address], chainId: chainId)
    }
}

extension QWCSessionViewController {
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
