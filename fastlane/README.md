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

### ios upmeta

```sh
[bundle exec] fastlane ios upmeta
```

Upload App Store metadata, privacy URL, support URL, and app info fields

### ios review_fields

```sh
[bundle exec] fastlane ios review_fields
```

Repair required App Store review fields without submitting for review

### ios price_cny1

```sh
[bundle exec] fastlane ios price_cny1
```

Set App Store price to CNY 1 using the current App Store Connect price schedule API

### ios upprivacy

```sh
[bundle exec] fastlane ios upprivacy
```

Upload App Privacy answer: Data Not Collected

### ios uppic

```sh
[bundle exec] fastlane ios uppic
```

Upload App Store screenshots only

### ios status

```sh
[bundle exec] fastlane ios status
```

Check App Store Connect app visibility through API key

### ios verify_meta

```sh
[bundle exec] fastlane ios verify_meta
```

Verify uploaded zh-Hans metadata fields on App Store Connect

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
