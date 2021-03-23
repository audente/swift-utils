import SwiftUI
import Foundation
import MessageUI


public struct MailSender: UIViewControllerRepresentable {
    let subject: String
    let body: String
    let recipients: [String]
    let ccRecipients: [String]
    let sender: String
    
    public init(subject: String, body: String, recipients: [String], ccRecipients: [String], sender: String) {
        self.subject = subject
        self.body =  body
        self.recipients =  recipients
        self.ccRecipients =  ccRecipients
        self.sender = sender
    }
    
    public typealias UIViewControllerType = MFMailComposeViewController
    @Environment(\.presentationMode) var presentationMode
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailSender
        
        init(_ parent: MailSender) {
            self.parent = parent
        }
        
        public func mailComposeController(_ mfmCVC: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailSender>) -> MFMailComposeViewController {
        let picker = MFMailComposeViewController()
        
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients(recipients)
        picker.setCcRecipients(ccRecipients)
        picker.setPreferredSendingEmailAddress(sender)
        picker.mailComposeDelegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailSender>) {
        
    }
}
