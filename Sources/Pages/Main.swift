import UIKit

import Signals
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
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ItemCell.self, forCellReuseIdentifier: "item")

        navigationItem.title = "Todo items"
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true

        addButton.onAction.subscribe(with: self) { _ in
            let alert = UIAlertController(title: "Add item", message: "What do you need to do?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let doneAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                if let text = alert?.textFields![0].text {
                    let indexPath = IndexPath(row: self.store.count, section: 0)

                    self.store.append(TodoItem(title: text, done: false))
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            })

            alert.addAction(cancelAction)
            alert.addAction(doneAction)

            alert.addTextField { textField in
                textField.autocapitalizationType = .sentences
                textField.autocorrectionType = .yes
                textField.enablesReturnKeyAutomatically = true
                textField.placeholder = "Take the trash out"
                textField.returnKeyType = .done
            }

            self.present(alert, animated: true, completion: nil)
        }
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
