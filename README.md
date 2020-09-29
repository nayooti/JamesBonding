# JamesBonding - Multi-Way-Binding in Swift

A lightweight solution to link data between multiple view instances. 

### How to use it:
```
var message: Observable<String> = Observable("Hello World")

lazy var textView: BoundTextView {
  let textView = BoundTextView()
  textView.bind(message) // 
  return textView
}()

lazy var label: BoundLabel {
  let label = BoundLabel()
  label.bind(message)  
  return label
}()
```

The label and textView live-update when the value of message changes. 
Also when the `label.text` and `textView.text` change the value of message, so everything will stay in sync.

You can find more examples in the repo.

