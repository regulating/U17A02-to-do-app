import SwiftUI

enum TaskFilter: String, CaseIterable, Identifiable {
    case all = "All Tasks" // all tasks
    case pending = "Pending" // pending tasks
    case completed = "Finished" // finished tasks
    var id: String { self.rawValue }
}

struct EventsListView: View {
    @StateObject private var taskManager = TaskManager()
    @State private var showingAddTaskSheet = false
    @State private var selectedTaskForEdit: TaskItem? = nil
    @State private var currentFilter: TaskFilter = .pending

    var filteredTasks: [TaskItem] {
        switch currentFilter {
        case .all:
            return taskManager.tasks // show all tasks
        case .pending:
            return taskManager.tasks.filter { !$0.isCompleted } // show pending tasks
        case .completed:
            return taskManager.tasks.filter { $0.isCompleted } // show completed tasks
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Filter", selection: $currentFilter) {
                    ForEach(TaskFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter) // filter options
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if filteredTasks.isEmpty {
                    emptyStateView // show empty state view
                } else {
                    List {
                        ForEach(filteredTasks) { taskItem in
                            if let taskIndex = taskManager.tasks.firstIndex(where: { $0.id == taskItem.id }) {
                                TaskRowView(task: $taskManager.tasks[taskIndex], onToggleCompletion: {
                                    taskManager.toggleCompletion(for: taskManager.tasks[taskIndex]) // toggle completion
                                })
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedTaskForEdit = taskManager.tasks[taskIndex] // select task for edit
                                }
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                                .background(AppColors.secondaryBackground) // card background
                                .cornerRadius(8)
                                .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            }
                        }
                        .onDelete(perform: deleteTaskFromFilteredList) // delete tasks
                    }
                    .listStyle(.plain)
                    .background(AppColors.primaryBackground)
                }
                Spacer()
            }
            .navigationTitle("My Events") // events title
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedTaskForEdit = nil
                        showingAddTaskSheet = true // show add task sheet
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !taskManager.tasks.isEmpty { EditButton() } // show edit button
                }
            }
            .sheet(isPresented: $showingAddTaskSheet) {
                TaskEditView(taskManager: taskManager, taskToEdit: nil) // add new task view
            }
            .sheet(item: $selectedTaskForEdit) { task in
                TaskEditView(taskManager: taskManager, taskToEdit: task) // edit task view
            }
            .background(AppColors.primaryBackground.ignoresSafeArea())
        }
        .accentColor(AppColors.accent)
    }

    var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: currentFilter == .completed ? "checkmark.seal.fill" : "calendar.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray.opacity(0.5))

            Text(emptyStateTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)

            Text(emptyStateSubtitle)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if currentFilter != .completed || filteredTasks.isEmpty { // show button if not completed or no items
                Button {
                    selectedTaskForEdit = nil
                    showingAddTaskSheet = true // show add task sheet
                } label: {
                    Text("Create an Event")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 50)
                .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.primaryBackground)
    }

    private var emptyStateTitle: String {
        if filteredTasks.isEmpty {
            switch currentFilter {
            case .all: return "No Events Yet" // no events
            case .pending: return "All Caught Up!" // no pending events
            case .completed: return "No Finished Events" // no finished events
            }
        }
        return "Nothing here. For now." // default empty message
    }

    private var emptyStateSubtitle: String {
        if filteredTasks.isEmpty {
            switch currentFilter {
            case .all: return "Tap the '+' to add your first event." // add first event
            case .pending: return "You have no pending events." // no pending events subtitle
            case .completed: return "Completed events will appear here." // completed events subtitle
            }
        }
        return ""
    }

    private func deleteTaskFromFilteredList(at offsets: IndexSet) {
        let idsToDelete = offsets.map { filteredTasks[$0].id }
        taskManager.tasks.removeAll { idsToDelete.contains($0.id) } // remove tasks
    }
}

struct EventsListView_Previews: PreviewProvider { // list preview
    static var previews: some View {
        EventsListView() // preview events list
    }
}
