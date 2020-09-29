import Foundation

public class Observable<Type> {

    private var _value: Type?
    private var observers: [UUID: ObserverRef] = [:]

    public var value: Type? {
        get {
            return _value
        }
        set {
            _value = newValue
            observers.forEach { $0.value.observer?.notify(value: _value! )}
        }
    }

    public init(_ value: Type) {
        self._value = value
    }

    public func bindingChanged(to newValue: Type) {
        value = newValue
    }

    public func register(observer: Observer) {
        observers[observer.id] = ObserverRef(observer: observer)
    }

    public func unregister(observer: Observer) {
        observers[observer.id] = nil
    }

    private class ObserverRef: Hashable {

        weak var observer: Observer?
        private var uid: UUID

        init(observer: Observer?) {
            self.observer = observer
            self.uid = UUID()
        }

        static func == (lhs: Observable<Type>.ObserverRef, rhs: Observable<Type>.ObserverRef) -> Bool {
            return lhs.uid == rhs.uid
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(uid)
        }

    }
}



