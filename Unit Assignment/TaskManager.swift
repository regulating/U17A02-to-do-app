// TaskManager.swift
import SwiftUI
import Combine // for ObservableObject

class TaskManager: ObservableObject {
    @Published var tasks: [TaskItem] = [] { // list of tasks
        didSet {
            saveTasks() // save tasks on change
        }
    }

    private let tasksStorageKey = "todoAppTasks_v2" // storage key for tasks

    init() {
        loadTasks() // load tasks on init
    }

    func addTask(title: String, notes: String? = nil, dueDate: Date? = nil, locationDetails: String? = nil) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return } // ensure title is not empty

        let newTask = TaskItem( // create new task
            id: UUID(), // unique id
            title: title, // task title
            isCompleted: false, // initial completion status
            notes: notes, // task notes
            dueDate: dueDate, // due date
            locationDetails: locationDetails // location details
        )
        tasks.append(newTask) // add task to array
    }

    func toggleCompletion(for task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle() // toggle completion status
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets) // delete task at offset
    }

    func deleteTask(task: TaskItem) {
        tasks.removeAll(where: { $0.id == task.id }) // delete specific task
    }

    func updateTask(task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task // replace old task with updated one
        }
    }

    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksStorageKey) // save encoded tasks
        } else {
            print("Failed to encode tasks for saving.") // log encoding failure
        }
    }

    private func loadTasks() {
        if let savedTasksData = UserDefaults.standard.data(forKey: tasksStorageKey) {
            if let decodedTasks = try? JSONDecoder().decode([TaskItem].self, from: savedTasksData) {
                tasks = decodedTasks // load decoded tasks
                return
            } else {
                print("Failed to decode saved tasks.") // log decoding failure
            }
        }
        tasks = [] // initialize with empty array
    }
}
