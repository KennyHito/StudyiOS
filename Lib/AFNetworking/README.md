# AFNetworking（防抓包）

Release模式下
1.修改了AFURLSessionManager.m文件的383行初始化的configuration，设置了一下connectionProxyDictionary属性，清空了代理数据，这样抓包就抓不到数据了
1.修改了AFURLSessionManager.m文件的489行初始化的configuration，设置了一下connectionProxyDictionary属性，清空了代理数据，这样抓包就抓不到数据了
```
configuration.connectionProxyDictionary = @{};
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AFNetworking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AFNetworking'
```

## Author

李东博, lidongbo@lczq.com

## License

AFNetworking is available under the MIT license. See the LICENSE file for more info.
