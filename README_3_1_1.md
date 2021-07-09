# Artisan 3.1.1

This is README intended for old Artisan version 3.1.1. For the new version, check this [README](https://github.com/nayanda1/Artisan/blob/main/README.md) instead.

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
pod 'Artisan', '~> 3.1.1'
pod 'Draftsman', '~> 1.1.1'
pod 'Pharos', '~> 1.2.2'
```

### Swift Package Manager from XCode

- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **https://github.com/nayanda1/Artisan.git** as Swift Package URL
- Set rules at **version**, with **Up to Next Major** option and put **3.1.1** as its version
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in **Package.swift**

```swift
dependencies: [
    .package(url: "https://github.com/nayanda1/Artisan.git", .upToNextMajor(from: "3.1.1"))
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
    
    override func planContent(_ plan: InsertablePlan) {
        plan.fit(title)
            .at(.fullTop, .equalTo(margin), to: .parent)
        plan.fit(subTitle)
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

For more wiki, go to [here](https://github.com/nayanda1/Artisan/wiki)

## Contribute

You know how, just clone and do pull request
