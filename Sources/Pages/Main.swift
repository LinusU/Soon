import UIKit

import SnapKit

class ItemCell: UITableViewCell {
    lazy var checkbox = UILabel()
    lazy var titleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(checkbox)
        contentView.addSubview(titleLabel)

        checkbox.text = "✓"
        checkbox.font = UIFont.systemFont(ofSize: 17)

        titleLabel.font = UIFont.systemFont(ofSize: 17)

        checkbox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.leftMargin).offset(8)
            make.width.equalTo(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(checkbox.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(withData data: TodoItem) {
        checkbox.isHidden = !data.done
        titleLabel.text = data.title
    }
}

class MainPage: UITableViewController {
    lazy var store = TodoStore.default

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ItemCell.self, forCellReuseIdentifier: "item")

        navigationItem.title = "Todo items"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! ItemCell
        let item = store.item(at: indexPath.row)

        cell.configure(withData: item)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
            store.toggleDone(atIndex: indexPath.row)
            cell.configure(withData: store.item(at: indexPath.row))
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
