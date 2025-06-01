import SwiftUI

// model for an inbox message
struct InboxMessage: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var snippet: String
    var date: Date
    var iconName: String // sfsymbol name
    var isRead: Bool = false
}

struct InboxView: View {
    @State private var messages: [InboxMessage] = [
        InboxMessage(title: "Event Reminder: Tech Innovators Summit", snippet: "Your event starts in 2 days. Get ready!", date: Date().addingTimeInterval(-86400 * 2), iconName: "calendar.badge.clock", isRead: false),
        InboxMessage(title: "New Invitation: Project Alpha Kick-off", snippet: "You've been invited by Jane Doe.", date: Date().addingTimeInterval(-3600 * 5), iconName: "envelope.open.fill", isRead: false),
        InboxMessage(title: "Summer Festival Update", snippet: "Schedule change for Stage B. Check details.", date: Date().addingTimeInterval(-86400 * 1), iconName: "megaphone.fill", isRead: true),
        InboxMessage(title: "Welcome to EventApp!", snippet: "Explore features and create your first event.", date: Date().addingTimeInterval(-86400 * 7), iconName: "sparkles", isRead: true)
    ]

    var body: some View {
        NavigationView {
            List {
                if messages.isEmpty {
                    Text("Your inbox is empty.") // empty inbox message
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .listRowBackground(AppColors.primaryBackground)
                } else {
                    ForEach($messages) { $message in // iterate through messages
                        InboxMessageRow(message: $message) // display each message
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .onTapGesture {
                                message.isRead = true // mark message as read
                            }
                    }
                    .onDelete(perform: deleteMessage) // delete message
                }
            }
            .listStyle(.plain)
            .navigationTitle("Inbox") // inbox title
            .background(AppColors.primaryBackground.ignoresSafeArea())
            .toolbar {
                if !messages.isEmpty { EditButton() } // edit button
            }
        }
        .accentColor(AppColors.accent)
    }

    func deleteMessage(at offsets: IndexSet) {
        messages.remove(atOffsets: offsets) // remove messages
    }
}

struct InboxMessageRow: View {
    @Binding var message: InboxMessage

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: message.iconName) // message icon
                .font(.title2)
                .foregroundColor(message.isRead ? .gray : AppColors.accent) // icon color based on read status
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(message.title) // message title
                    .font(.headline)
                    .fontWeight(message.isRead ? .regular : .bold) // bold if unread
                    .foregroundColor(message.isRead ? AppColors.textSecondary : AppColors.textPrimary)
                    .lineLimit(1)
                Text(message.snippet) // message snippet
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }
            Spacer()
            Text(message.date, style: .relative) // relative date
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .cornerRadius(10)
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView() // inbox preview
    }
}
