import Foundation

import BioPass
import PromiseKit

private var bioPass = BioPass()

extension String {
    var djb2hash: Data {
        var hash = self.unicodeScalars.reduce(5381) { ($0 << 5) &+ $0 &+ Int($1.value) }
        return Data(bytes: &hash, count: MemoryLayout.size(ofValue: hash))
    }
}

extension Data {
    static func readAsync(from: URL) -> Promise<Data> {
        return Promise<Data> { seal in
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: from)
                    seal.fulfill(data)
                } catch {
                    seal.reject(error)
                }
            }
        }
    }

    func writeAsync(to: URL) -> Promise<Void> {
        return Promise<Void> { seal in
            DispatchQueue.global().async {
                do {
                    try self.write(to: to)
                    seal.fulfill(())
                } catch {
                    seal.reject(error)
                }
            }
        }
    }
}

class AuthStore {
    static let `default` = AuthStore()

    static internal let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static internal let passwordDigestURL = documentsDirectory.appendingPathComponent("Password Digest")

    func hasPassword() -> Bool {
        return FileManager.default.fileExists(atPath: AuthStore.passwordDigestURL.path)
    }

    func setPassword(_ password: String) -> Promise<Void> {
        return firstly {
            password.djb2hash.writeAsync(to: AuthStore.passwordDigestURL)
        }.then { _ in
            bioPass.store(password)
        }
    }

    func comparePassword(_ password: String) -> Promise<Bool> {
        return firstly {
            Data.readAsync(from: AuthStore.passwordDigestURL)
        }.then { digest in
            Promise { $0.fulfill(digest == password.djb2hash) }
        }
    }

    func readPasswordFromKeychain(withPrompt prompt: String? = nil) -> Promise<String?> {
        return bioPass.retreive(withPrompt: prompt)
    }
}
