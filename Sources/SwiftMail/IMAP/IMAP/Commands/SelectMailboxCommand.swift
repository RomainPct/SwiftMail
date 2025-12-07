import Foundation
import NIO
import NIOIMAP

/// Command to select a mailbox
struct SelectMailboxCommand: IMAPCommand {
    typealias ResultType = Mailbox.Status
    typealias HandlerType = SelectHandler
    
    let mailboxName: String
    let selectParameters:[SelectParameter]
    let timeoutSeconds: Int = 30
    
    init(mailboxName: String, parameters:[SelectParameter]) {
        self.mailboxName = mailboxName
        self.selectParameters = parameters
    }
    
    func validate() throws {
        guard !mailboxName.isEmpty else {
            throw IMAPError.invalidArgument("Mailbox name cannot be empty")
        }
    }
    
    func toTaggedCommand(tag: String) -> TaggedCommand {
        return TaggedCommand(tag: tag, command: .select(
            MailboxName(ByteBuffer(string: mailboxName)),
            selectParameters
        ))
    }
}
