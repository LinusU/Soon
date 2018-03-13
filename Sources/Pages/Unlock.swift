import UIKit

import PromiseKit
import Signals

class UnlockPage: UIViewController {
    let onUnlock = Signal<String>()

    internal lazy var titleLabel = UILabel()
    internal lazy var passwordField = UITextField()

    internal var isCurrentlyAskingUser = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        titleLabel.text = "Unlock"
        titleLabel.font = UIFont.systemFont(ofSize: 24)

        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        passwordField.isHidden = true

        view.addSubview(titleLabel)
        view.addSubview(passwordField)

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(128)
        }

        passwordField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        passwordField.onEditingDidEndOnExit.subscribe(with: self) { _ in self.unlockWithManualEntry() }
    }

    internal func unlock(_ password: String?, incorrect: @escaping () -> Void) {
        guard let password = password else { return incorrect() }

        firstly {
            AuthStore.default.comparePassword(password)
        }.done { correct in
            guard correct == true else { return incorrect() }

            self.onUnlock.fire(password)
            self.isCurrentlyAskingUser = false
        }.catch { err in
            fatalError("\(err)")
        }
    }

    internal func beginManualEntry() {
        self.passwordField.isHidden = false
        self.passwordField.becomeFirstResponder()
    }

    internal func unlockWithManualEntry() {
        self.unlock(passwordField.text) {
            self.passwordField.shake { self.beginManualEntry() }
        }
    }

    func askUserForPassword() {
        if self.isCurrentlyAskingUser { return }
        self.isCurrentlyAskingUser = true

        firstly {
            AuthStore.default.readPasswordFromKeychain(withPrompt: "Access to the todo list")
        }.done { maybePassword in
            self.unlock(maybePassword) { self.beginManualEntry() }
        }.catch { err in
            print("Error reading from keychain: \(err)")
            self.beginManualEntry()
        }
    }
}
