fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Run SwiftLint

### ios git_sync

```sh
[bundle exec] fastlane ios git_sync
```

Git: clean, pull, and push

### ios increment

```sh
[bundle exec] fastlane ios increment
```

Increment build number

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app

### ios test

```sh
[bundle exec] fastlane ios test
```

Run tests

### ios deploy_simulator

```sh
[bundle exec] fastlane ios deploy_simulator
```

Deploy to simulator

### ios dev

```sh
[bundle exec] fastlane ios dev
```

Complete development workflow: lint, test, build, and deploy to simulator

### ios ci

```sh
[bundle exec] fastlane ios ci
```

Continuous Integration process

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
