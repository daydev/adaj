[![Build Status](https://drone.io/github.com/daydev/adaj/status.png)](https://drone.io/github.com/daydev/adaj/latest)

##Description

Primitive utility for asynchronous JSON requests with Dart.
Sending JSON data is supported, as well, as simple success/error/always callbacks

## Usage

Add dependency in your pubspec.yaml

```yaml
dependencies:
  adaj: any
```
and run
```
pub install
```

Import library

```dart
import "package:adaj/adaj.dart" as http;
```

and now you can make adaj (Asynchronous Dart and JSON) calls

```dart
http.get("http://httpbin.org/get").done((json) {
  print(json["url"]); //prints "http://pastebin.org/get"
}).go();
```
Sending data with post
```dart
Map data = {"test": 42};
http.post("http://httpbin.org/post", data).done((json) {
  print(json);
}).go();
```

PUT and POST are supported in a similar way. For other HTTP methods you can use `ajax(url, {method, data})` method.
```dart
http.ajax("http://httpbin.org/", method: "HEAD", data: {}).go();
```
You also have `.fail()` and `.always()` callback hooks and you can chain them as much as you like

```dart
http.get(...).done(...).fail(...).always(...).done(...) /* and so on */ .go();
```
