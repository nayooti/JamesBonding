import UIKit

public protocol Observer: class {
    var id: UUID { get }
    func notify<Type>(value: Type)
}

public class BoundLabel: UILabel, Observer {

    public var id: UUID = UUID()
    private var observable: Observable<String>?

    public func bind(_ observable: Observable<String>) {
        self.text = observable.value
        observable.register(observer: self)
        self.observable = observable
    }

    public func unbind() {
        observable?.unregister(observer: self)
        self.observable = nil
    }

    public func notify<Type>(value: Type) {
        self.text = value as? String
    }
}

public class BoundTextField: UITextField, Observer {

    private var onValueChange: (()->Void)?
    public var id: UUID = UUID()

    private var observable: Observable<String>?


    deinit {
        observable?.unregister(observer: self)
        observable = nil
    }

    public func bind(_ observable: Observable<String>) {
        self.text = observable.value
        self.observable = observable
        addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
        onValueChange = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }

        observable.register(observer: self)
    }

    public func unbind() {
        onValueChange = nil
        observable?.unregister(observer: self)
        self.observable = nil
    }

    @objc func valueChanged(_ sender: UITextField) {
        onValueChange?()
    }

    public func notify<T>(value: T) {
        self.text = value as? String
    }
}

public class BoundTextView: UITextView, Observer {

    public override var delegate: UITextViewDelegate? {
        set {
            superDelegate = newValue
        } get {
            return superDelegate
        }
    }

    private weak var superDelegate: UITextViewDelegate?

    private var onValueChange: (()->Void)?
    public var id: UUID = UUID()

    private var observable: Observable<String>?

    convenience init() {
        self.init(frame: .zero, textContainer: nil)
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        super.delegate = self
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.delegate = self
    }

    deinit {
        observable?.unregister(observer: self)
        observable = nil
    }

    public func bind(_ observable: Observable<String>) {
        self.text = observable.value
        self.observable = observable
        onValueChange = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }

        observable.register(observer: self)
    }

    public func unbind() {
        onValueChange = nil
        observable?.unregister(observer: self)
        self.observable = nil
    }

    public func notify<T>(value: T) {
        self.text = value as? String
    }
}

extension BoundTextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        onValueChange?()
        superDelegate?.textViewDidChange?(textView)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        superDelegate?.textViewDidEndEditing?(textView)
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        superDelegate?.textViewDidChange?(textView)
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       return superDelegate?.textViewShouldBeginEditing?(textView) ?? false
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        superDelegate?.textViewDidBeginEditing?(textView)
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
       return superDelegate?.textViewShouldEndEditing?(textView) ?? false
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return superDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? false
    }

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return superDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? false
    }

    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return superDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? false
    }
}



