//
//  ExpandingTextView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 01/04/2022.
//

import SwiftUI

struct ExpandingTextView: View {
    @Binding var text: String
    let fontSize: CGFloat
    let minHeight: CGFloat = 10
    @State private var textViewHeight: CGFloat?
    @State var height: CGFloat = 10
    let charsLimit: Int

    var body: some View {

        WrappedTextView(text: $text, textDidChange: self.textDidChange,
                        charsLimit: charsLimit,
                        fontSize: fontSize)
//            .submitLabel(.done)
            .frame(height: height ?? minHeight)
    }

    private func textDidChange(_ textView: UITextView) {
        self.height = max(textView.contentSize.height, minHeight)
    }
}

struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    let textDidChange: (UITextView) -> Void
    let charsLimit: Int
    let fontSize: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.textColor = .white
        textView.textContainer.maximumNumberOfLines = 10
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.addDoneButtonOnKeyboard()

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        print(text.count)
        if text.count > charsLimit {
            text = String(text.prefix(charsLimit))
        } else {
            uiView.text = self.text
            DispatchQueue.main.async {
                self.textDidChange(uiView)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, textDidChange: textDidChange)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: (UITextView) -> Void

        init(text: Binding<String>, textDidChange: @escaping (UITextView) -> Void) {
            self._text = text
            self.textDidChange = textDidChange
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
    }
}

extension UITextView {

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"),
                                                    style: .done,
                                                    target: nil,
                                                    action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}
