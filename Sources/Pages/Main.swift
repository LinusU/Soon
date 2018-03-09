import UIKit

import SnapKit

class MainPage: UIViewController {
    lazy var titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(titleLabel)

        titleLabel.text = "Hello, World!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
