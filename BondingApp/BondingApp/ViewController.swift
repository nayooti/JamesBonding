import UIKit
import JamesBonding

class ViewController: UIViewController {

    private var topTextFieldBound: Bool = true

    @IBOutlet weak var textView: BoundTextView!
    @IBOutlet weak var topTextField: BoundTextField!
    @IBOutlet weak var bottomTextField: BoundTextField!
    @IBOutlet weak var label: BoundLabel!
    @IBOutlet weak var button: UIButton!

    lazy var message: Observable<String> = {
        let observable =  Observable("Hello World")
        return observable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }



    private func configureSubviews() {
        textView.bind(message)
        topTextField?.bind(message)
        bottomTextField?.bind(message)
        label?.bind(message)
        button?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        textView.delegate = self
    }

    @objc private func buttonPressed(_ sender: UIButton) {
        topTextFieldBound = !topTextFieldBound
        let buttonTitle = topTextFieldBound ? "Unbind Top Textfield" : "Bind Top Textfield"
        sender.setTitle(buttonTitle, for: .normal)
        if topTextFieldBound {
            topTextField?.bind(message)
        } else {
            topTextField?.unbind()
        }
    }

}

extension ViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

    }

}

