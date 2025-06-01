import SwiftUI

struct TaskRowView: View {
    @Binding var task: TaskItem
    var onToggleCompletion: () -> Void

    var body: some View {
        HStack(spacing: 15) {
            Button(action: onToggleCompletion) { // button to toggle completion
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle") // completion indicator
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(task.isCompleted ? AppColors.accent : .gray) // color based on completion
            }
            .buttonStyle(.plain) // make entire area tappable

            VStack(alignment: .leading) {
                Text(task.title) // task title
                    .font(.headline)
                    .strikethrough(task.isCompleted, color: .gray) // strikethrough if completed
                    .foregroundColor(task.isCompleted ? .gray : AppColors.textPrimary) // color based on completion

                if let notes = task.notes, !notes.isEmpty { // display notes if available
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }

                if let dueDate = task.dueDate { // display due date if available
                    Text("Due: \(dueDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(task.isCompleted ? .gray : AppColors.textSecondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
