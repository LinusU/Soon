# Soon

This is an example todo list application for iOS. The goal is to test out a nice development environment setup.

- ✅ Use **any editor** to develop, not just Xcode
- ✅ From freshly cloned repo to running app in a **single command**
- ✅ **No generated files** checked into git (e.g. `.xcodeproj`)

## Prerequisites

This setup depends on two tools being installed: [Mint](https://github.com/yonaskolb/Mint) and [ios-deploy](https://github.com/phonegap/ios-deploy). They can be installed using [Homebrew](https://brew.sh/) with the following commands:

```sh
brew tap yonaskolb/Mint https://github.com/yonaskolb/Mint.git
brew install node mint
npm install -g ios-deploy
```

## Building / Running

To fetch dependencies, build dependencies, build the app, install the app, and then finally launch the app on the first plugged in iPhone, run the `run` task.

```sh
make run
```

If you want to build without installing and running the app, use the `build` task.

```sh
make build
```

To launch the app with an debugger attached, run the `debug` command.

```sh
make debug
```

## Screenshots

<p align="center"><img src="Docs/Screenshot - Signup.jpg" width="375" /><img src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==" width="48" /><img src="Docs/Screenshot - Login.jpg" width="375" /></p>

<p align="center"><img src="Docs/Screenshot - List.jpg" width="375" /><img src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==" width="48" /><img src="Docs/Screenshot - Add.jpg" width="375" /></p>
