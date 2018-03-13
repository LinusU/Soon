import UIKit

import Signals

class SignupPage: UIViewController {
    let onSignup = Signal<String>()

    internal lazy var titleLabel = UILabel()
    internal lazy var passwordField = UITextField()
    internal lazy var help = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        titleLabel.text = "Create password"
        titleLabel.font = UIFont.systemFont(ofSize: 24)

        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"

        help.text = "Please create a password that will be required in order to view your todo list. If you have a TouchID or FaceID capable device, you will also be able to unlock the app using that system.\n\nTouch the password field to begin."
        help.font = UIFont.systemFont(ofSize: 15)
        help.isEditable = false
        help.isSelectable = false

        view.addSubview(titleLabel)
        view.addSubview(passwordField)
        view.addSubview(help)

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(128)
        }

        passwordField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        help.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.top.equalTo(passwordField.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        passwordField.onEditingDidEndOnExit.subscribe(with: self) { _ in self.createPassword() }
    }

    func createPassword() {
        let password = passwordField.text!

        AuthStore.default.setPassword(password).done { _ in
            self.onSignup.fire(password)
        }.catch { err in
            fatalError("\(err)")
        }
    }
}
