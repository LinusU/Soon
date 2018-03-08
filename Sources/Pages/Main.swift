import UIKit

class MainPage: UIViewController {
    lazy var titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Hello, World!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.frame = CGRect(x: 8, y: 16, width: 200, height: 40)

        self.view.addSubview(titleLabel)
    }
}
