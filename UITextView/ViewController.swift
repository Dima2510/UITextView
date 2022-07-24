//
//  ViewController.swift
//  UITextView
//
//  Created by Дмитрий Процак on 24.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    
    let toTopButton = UIButton()
    var mode = Mode.edit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: TextField
        titleTF.delegate = self
     
        titleTF.borderStyle = .none
        titleTF.layer.borderWidth = 1
        titleTF.layer.cornerRadius = 10
        titleTF.layer.borderColor = UIColor.gray.cgColor
        
        //MARK: TextView
        descriptionTV.delegate = self
        descriptionTV.layer.borderWidth = 1
        descriptionTV.layer.cornerRadius = 10
        descriptionTV.layer.borderColor = UIColor.gray.cgColor
        //устанавливает свойства такие как (номер телефона,почта и тд),которые становятся гипер ссылкой и можео выходить в инет нажав на них
        descriptionTV.dataDetectorTypes = [.link, .phoneNumber]
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.green
        shadow.shadowBlurRadius = 15
        
        //Меняем цвет гипер ссылки  и ее тени
        descriptionTV.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.shadow : shadow
        ]
        //Отступ текста от краев TextViw
        descriptionTV.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       
        
        //Дает возможность человеку проводить манипуляции с выделеным текстом
        //descriptionTV.allowsEditingTextAttributes = true
        
        
        descriptionTV.text = """
    UITextView supports the display of text using custom style information and also supports text editing. You typically use a text view to display multiple lines of text, such as when displaying the body of a large text document.
    This class supports multiple text styles through use of the attributedText property. (Styled text is not supported in versions of iOS earlier than iOS 6.) Setting a value for this property causes the text view to use the style information provided in the attributed string. You can still use the font, textColor, and textAlignment properties to set style attributes, but those properties apply to all of the text in the text view. It’s recommended that you use a text view—and not a UIWebView object—to display both plain and rich text in your app.
     more info: https://developer.apple.com/documentation/uikit/uitextview
"""
        
        //MARK: To Top
        view.addSubview(toTopButton)
        toTopButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toTopButton.topAnchor.constraint(equalTo: descriptionTV.bottomAnchor, constant: 23),
            toTopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toTopButton.heightAnchor.constraint(equalToConstant: 20 ),
            toTopButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        toTopButton.setTitle("To top", for: .normal)
        toTopButton.setTitleColor(.blue, for: .normal)
        toTopButton.addTarget(self, action: #selector(toTop), for: .touchUpInside)
        
        //При скроле текста клавиатура будет исчезать
        descriptionTV.keyboardDismissMode = .onDrag
        
    }
    
    //MARK: To Top Func
    ///метод позволяющий вернуть нас к вверху или к началу текста нажатием кнопки
    @objc func toTop() {
        descriptionTV.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }

   //MARK: Preview
    @IBAction func buttonAction(_ sender: UIButton) {
        mode.togle() //  заменяем наш mode
        let buttonTitle = mode == .preview ? "Edit" : "Previw" //замена название
        let toValue: CGFloat = mode == .preview ? 0 : 1   //при просмотре поста - границы текста будут убираться
        
        //замена текста тайтла
        UIView.animate(withDuration: 1) {
            sender.setTitle(buttonTitle, for: .normal)
        }
         
        //MARK: Func of changing borders
        titleTF.animateBorderWitdth(toValue: toValue, duration: 0.5)
        descriptionTV.animateBorderWitdth(toValue: toValue, duration: 0.5)
        descriptionTV.isEditable = mode == .edit
        
    }
    
}




extension ViewController: UITextFieldDelegate {
    //Метод позволяющий запретить настраивание нашего текста во время превью
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch mode {
        case.edit:
            return true
        default:
            return false
        }
    }
    
}

extension ViewController: UITextViewDelegate {
    //Метод позволяющий запретить настраивание нашего текста во время превью
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch mode {
        case.edit:
            return true
        default:
            return false
        }
    }
    
    
    //метод позволяющий запретить делать что либо с гипер ссылками
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true //false
    }
}


extension UIView {
    //Метод удаления границ и его анимация
    func animateBorderWitdth(toValue: CGFloat, duration: Double) {
        //создает анимацию
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        //значение от которого будет анимироваться - его текущая ширина
        animation.fromValue = layer.borderWidth
        //значение до которого будет изменяться
        animation.toValue = toValue
        //время анимации
        animation.duration = duration
        //добавлении анимации
        layer.add(animation, forKey: "Width")
        //фиксация его состояния
        layer.borderWidth = toValue
    }
    
}

//Enum для проверки в каком состоянии у нас экран
enum Mode {
    case preview //показывать
    case edit  //писать пост

    mutating func togle() {
        switch self {
        case .preview: self = .edit
        case .edit: self = .preview
        }
    }
}
