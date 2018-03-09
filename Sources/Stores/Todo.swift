import Foundation

struct TodoItem: Codable {
    let title: String
    let done: Bool
}

class TodoStore {
    static let `default` = TodoStore()

    static internal let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static internal let dataURL = documentsDirectory.appendingPathComponent("Todo Items").appendingPathExtension("json")

    internal var items: [TodoItem]

    var count: Int {
        return items.count
    }

    init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let data = try? Data(contentsOf: TodoStore.dataURL) {
            items = try! decoder.decode([TodoItem].self, from: data)
        } else {
            items = []
        }
    }

    internal func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let data = try! encoder.encode(items)
        try! data.write(to: TodoStore.dataURL, options: .atomic)
    }

    func append(_ item: TodoItem) {
        items.append(item)
        save()
    }

    func remove(at index: Int) {
        items.remove(at: index)
        save()
    }

    func item(at index: Int) -> TodoItem {
        return items[index]
    }

    func toggleDone(atIndex index: Int) {
        if items.indices.contains(index) {
            items[index] = TodoItem(title: items[index].title, done: !items[index].done)
            save()
        }
    }
}
