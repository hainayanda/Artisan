<p align="center">
  <img width="256" height="256" src="Artisan.png"/>
</p>

# Artisan

Artisan is a DSL, MVVM and Data Binding framework for Swift.

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
pod 'Artisan'
pod 'Draftsman ~> 1.0'
```

### Swift Package Manager from XCode

- Add it using xcode menu **File > Swift Package > Add Package Dependency**
- Add **https://github.com/nayanda1/Artisan.git** as Swift Package url
- Set rules at **version**, with **Up to Next Major** option and put **2.0.2** as its version
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in **Package.swift**

```swift
dependencies: [
    .package(url: "https://github.com/nayanda1/Artisan.git", .upToNextMajor(from: "2.0.2"))
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

Read [wiki](https://github.com/nayanda1/Artisan/wiki) for more detailed information

### Basic Usage

Want to layout tableView to fill UIViewController? 

**old way**

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
}
```

**Artisan way**

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    planContent { plan in
        plan.fit(tableView)
            .edges(.equal, to: .parent)
    }
}
```

Want to bind and observe text in UISearchBar?

**old way**

```swift
class MyViewController: UIViewController {
    lazy var searchBar: UISearchBar = .init()
    
    var searchPhrase: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        ...
        ...
    }
    
    func set(searchPhrase: String?) {
        searchBar.text = searchPhrase
        self.searchPhrase = searchPhrase
    }
    ...
    ...
    ...
}

extension MyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchPhrase = searchText
        // do something with text
    }
}
```

**Artisan way**

```swift
class MyViewController: UIViewController {
    lazy var searchBar: UISearchBar = .init()

    @ViewState var searchPhrase: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        $searchPhrase.bonding(with: searchBar, \.text)
            .viewDidSet(then: { searchBar, changes in
                // do something with changes
            })
        ...
        ...
    }
    ...
    ...
    ...
}
```

Want to update cell in tableView?
Want to create iOS Application with MVVM framework?

Artisan have all of those feature in one pack. read [wiki](https://github.com/nayanda1/Artisan/wiki) for more or just look and experimenting with Example project.

## Contribute

You know how, just clone and do pull request
