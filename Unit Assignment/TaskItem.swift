// TaskItem.swift
import Foundation

struct TaskItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var notes: String? = nil
    var dueDate: Date? = nil
    var locationDetails: String? = nil // crucial for location
}
