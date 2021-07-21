<p align="center">
  <img width="256" height="256" src="Artisan.png"/>
</p>

# Artisan

Artisan is an MVVM framework for Swift using the bonding features from [Pharos](https://github.com/hainayanda/Pharos) and constraints builder from [Draftsman](https://github.com/hainayanda/Draftsman).

[![codebeat badge](https://codebeat.co/badges/a3e6f380-c48e-44bb-997c-56b9615c64b3)](https://codebeat.co/projects/github-com-hainayanda-artisan-main)
![build](https://github.com/hainayanda/Artisan/workflows/build/badge.svg)
![test](https://github.com/hainayanda/Artisan/workflows/test/badge.svg)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/cocoapods/v/Artisan.svg?style=flat)](https://cocoapods.org/pods/Artisan)
[![License](https://img.shields.io/cocoapods/l/Artisan.svg?style=flat)](https://cocoapods.org/pods/Artisan)
[![Platform](https://img.shields.io/cocoapods/p/Artisan.svg?style=flat)](https://cocoapods.org/pods/Artisan)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Swift 5.3 or higher (Swift 5.1 for version 3.1.1 or lower)
- iOS 10.0 or higher
- XCode 12.5 or higher (XCode 11 for version 3.1.1 or lower)


## Installation

### Cocoapods

Artisan is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Artisan', '~> 4.0.1'
pod 'Draftsman', '~> 2.0.2'
pod 'Pharos', '~> 1.2.3'
```

or for Swift 5.1 and XCode 11

```ruby
pod 'Artisan', '~> 3.1.1'
pod 'Draftsman', '~> 1.1.1'
pod 'Pharos', '~> 1.2.2'
```

### Swift Package Manager from XCode

- Set rules at **version**, with **Up to Next Major** option and put **4.0.1** or **3.1.1** for Swift 5.1 and XCode 11 as its version
- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **https://github.com/hainayanda/Artisan.git** as Swift Package URL
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in **Package.swift**

```swift
dependencies: [
    .package(url: "https://github.com/hainayanda/Artisan.git", .upToNextMajor(from: "4.0.1"))
]
```

or for Swift 5.1 and XCode 11

```swift
dependencies: [
    .package(url: "https://github.com/hainayanda/Draftsman.git", .upToNextMajor(from: "3.1.1"))
]
```

Use it in your target as `Artisan`

```swift
 .target(
    name: "MyModule",
    dependencies: ["Artisan"]
)
```

## Author

Nayanda Haberty, hainayanda@outlook.com

## License

Artisan is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Usage

Read [wiki](https://github.com/hainayanda/Artisan/wiki) for more detailed information.

### Basic Usage

Creating an MVVM Pattern using Artisan is easy. All you need to do is extend `ViewMediator`, `TableCellMediator` or `CollectionCellMediator` and implement `bonding` method.
For example, If you want to create a custom `UITableViewCell`:

```swift
import Artisan
import UIKit
import Draftsman
import Pharos

class MyCell: TableFragmentCell {
    lazy var title = builder(UILabel.self)
        .font(.boldSystemFont(ofSize: 16))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.secondary)
        .build()
    lazy var subTitle = builder(UILabel.self)
        .font(.systemFont(ofSize: 12))
        .numberOfLines(1)
        .textAlignment(.left)
        .textColor(.main)
        .build()
        
    // MARK: Dimensions
    var margin: UIEdgeInsets = .init(insets: 16)
    var spacing: CGFloat = 6
    
    @LayoutPlan
    var viewPlan: ViewPlan {
        title.plan
            .at(.fullTop, .equalTo(margin), to: .parent)
        subTitle.plan
            .at(.bottomOf(title), .equalTo(spacing))
            .at(.fullBottom, .equalTo(margin), to: .parent)
    }
}

class MyCellVM: TableCellMediator<MyCell> {
    @Observable var model: MyModel
    
    init(model: MyModel) {
        self.model = model
    }

    override func bonding(with view: MyCell) {
        $event.map { $0.title }.relayValue(to: view.title.relays.text))
        $event.map { $0.description }.relayValue(to: view.subTitle.relays.text))
    }
}
```

then add it to `UITableView`

```swift
import Artisan
import UIKit
import Draftsman
import Pharos

class MyViewController: UIViewController {
    var tableView: UITableView!
    var searchBar: UISearchBar!
  
    @Observable var searchPhrase: String?
    @Observable var models: [MyModel] = []

    override viewDidLoad() {
        super.viewDidLoad()
        $searchPhrase.bonding(with: searchBar.bondableRelays.text)
            .multipleSetDelayed(by: 1)
            .whenDidSet(invoke: self, method: MyViewController.getData(from:))
        $models.compactMap { model -> AnyTableCellMediator in
              MyCellVM(model: model) 
          }.observe(on: .main)
          .relayValue(to: tableView.relays.cells)
    }

    func getData(from changes: Changes<String?>) {
        doGetDataFromAPI(for: changes.new) { [weak self] data in
            self?.models = data
        }
    }
}
```

It will automatically run getData when the user type in searchBar, with a minimum interval between method calls, is 1 second and will update table cells with new data on Main Thread every time you get data from API

You can clone and check the [Example folder](https://github.com/hainayanda/Artisan/tree/main/Example) or for more wiki, go to [here](https://github.com/hainayanda/Artisan/wiki)

## Contribute

You know how, just clone and do pull request
