import UIKit

import OverlayWindow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var signupWindow: OverlayWindow<SignupPage>?
    var unlockWindow: OverlayWindow<UnlockPage>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let mainPage = MainPage()
        let navigator = UINavigationController(rootViewController: mainPage)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = .white
        self.window!.rootViewController = navigator
        self.window!.makeKeyAndVisible()

        if AuthStore.default.hasPassword() {
            self.unlockWindow = OverlayWindow(rootViewController: UnlockPage(), animated: false)
            self.unlockWindow!.rootViewController.onUnlock.subscribe(with: self) { _ in self.unlockWindow = nil }
            self.unlockWindow!.rootViewController.askUserForPassword()
        } else {
            self.signupWindow = OverlayWindow(rootViewController: SignupPage(), animated: false)
            self.signupWindow!.rootViewController.onSignup.subscribe(with: self) { _ in self.signupWindow = nil }
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}

