# JamesBonding - Multi-Way-Binding in Swift

A lightweight solution to link data between multiple view instances. 
I created this for my MVVM-based projects to sync state between ViewModel und UIElements.

<img src="https://github.com/nayooti/JamesBonding/blob/master/JamesBonding/ezgif.com-video-to-gif.gif" width="250">
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



