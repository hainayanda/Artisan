<p align="center">
  <img width="256" height="256" src="Artisan.png"/>
</p>

# Artisan

Artisan is a MVVM framework for Swift using the bonding features from [Pharos](https://github.com/nayanda1/Pharos) and constraints builder from [Draftsman](https://github.com/nayanda1/Draftsman).

![build](https://github.com/nayanda1/Artisan/workflows/build/badge.svg)
![test](https://github.com/nayanda1/Artisan/workflows/test/badge.svg)
[![Version](https://img.shields.io/cocoapods/v/Artisan.svg?style=flat)](https://cocoapods.org/pods/Artisan)
[![License](https://img.shields.io/cocoapods/l/Artisan.svg?style=flat)](https://cocoapods.org/pods/Artisan)
[![Platform](https://img.shields.io/cocoapods/p/Artisan.svg?style=flat)](https://cocoapods.org/pods/Artisan)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Swift 5.1 or higher
- iOS 10.0 or higher

## Installation

### Cocoapods

Artisan is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Artisan ~> 3.0'
pod 'Draftsman ~> 1.0'
pod 'Pharos ~> 1.1'
```

### Swift Package Manager from XCode

- Add it using xcode menu **File > Swift Package > Add Package Dependency**
- Add **https://github.com/nayanda1/Artisan.git** as Swift Package url
- Set rules at **version**, with **Up to Next Major** option and put **3.0.1** as its version
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in **Package.swift**

```swift
dependencies: [
    .package(url: "https://github.com/nayanda1/Artisan.git", .upToNextMajor(from: "3.0.1"))
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

Nayanda Haberty, nayanda1@outlook.com

## License

Artisan is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Usage

Read [wiki](https://github.com/nayanda1/Artisan/wiki) for more detailed information.

### Basic Usage

Creating MVVM Pattern using Artisan is easy. All you need to do is extend `ViewMediator`, `TableCellMediator` or `CollectionCellMediator` and implement `bonding` method.
For the example, If you want to create custom `UITableViewCell`:

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
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(title)
            .at(.fullTop, .equalTo(margin), to: .parent)
        plan.fit(subTitle)
            .at(.bottomOf(title), .equalTo(spacing))
            .at(.fullBottom, .equalTo(margin), to: .parent)
    }
}

class MyCellVM<Cell: MyCell>: TableCellMediator<Cell> {
    @Observable var model: MyModel
    
    init(model: MyModel) {
        self.model = model
    }

    override func bonding(with view: Cell) {
        $event.map { $0.title }.relayValue(to: .relay(of: view.title, \.text))
        $event.map { $0.description }.relayValue(to: .relay(of: view.subTitle, \.text))
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
    lazy var tableView: UITableView = .init()

    @Observable var models: [MyModel] = []

    override viewDidLoad() {
        super.viewDidLoad()
        $models.map { MyCellVM(model: $0) }
            .whenDidSet { [weak self] changes in
                self?.tableView.cells = changes.new
            }
        getData()
    }

    func getData() {
        doGetDataFromAPI { [weak self] data in
            self?.models = data
        }
    }
}
```

It will automatically update table cells with new data everytime you get data from API

For more wiki, go to [here](https://github.com/nayanda1/Artisan/wiki)

## Contribute

You know how, just clone and do pull request
