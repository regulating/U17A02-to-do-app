// CalendarManager.swift
import SwiftUI
import EventKit

class CalendarManager: ObservableObject {
    private let eventStore = EKEventStore() // central object for eventkit
    @Published var authorizationStatus: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: .event)
    @Published var calendarEvents: [EKEvent] = []
    @Published var accessGranted: Bool = false
    @Published var accessError: String? = nil

    init() {
        checkInitialAuthorization()
    }

    private func checkInitialAuthorization() {
        let currentStatus = EKEventStore.authorizationStatus(for: .event)
        self.authorizationStatus = currentStatus
        if currentStatus == .authorized {
            self.accessGranted = true
        }
    }

    func requestCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestFullAccessToEvents { [weak self] (granted, error) in
            DispatchQueue.main.async {
                self?.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
                self?.accessGranted = granted
                if !granted {
                    self?.accessError = "calendar access was denied or restricted."
                    if let error = error {
                        self?.accessError = error.localizedDescription
                    }
                } else {
                    self?.accessError = nil
                }
                completion(granted, error)
            }
        }
    }

    func fetchEvents(forNextDays days: Int = 7, from calendars: [EKCalendar]? = nil) {
        guard accessGranted else {
            print("calendar access not granted. cannot fetch events.")
            self.calendarEvents = [] // clear events if access is revoked
            return
        }

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: days, to: startDate) ?? startDate.addingTimeInterval(Double(days * 24 * 60 * 60))

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)

        let events = eventStore.events(matching: predicate)
        DispatchQueue.main.async {
            self.calendarEvents = events.sorted(by: { $0.startDate < $1.startDate })
        }
    }

    func addEventToCalendar(title: String, startDate: Date, endDate: Date, notes: String? = nil, completion: @escaping (Bool, Error?) -> Void) {
        guard accessGranted else {
            print("calendar access not granted. cannot add event.")
            completion(false, NSError(domain: "CalendarManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "calendar access not granted."]))
            return
        }

        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.title = title
        newEvent.startDate = startDate
        newEvent.endDate = endDate
        newEvent.notes = notes
        newEvent.calendar = eventStore.defaultCalendarForNewEvents // or let the user choose a calendar

        do {
            try eventStore.save(newEvent, span: .thisEvent, commit: true)
            DispatchQueue.main.async {
                self.fetchEvents() // refresh fetched events
                completion(true, nil)
            }
        } catch let error {
            DispatchQueue.main.async {
                print("error saving event: \(error.localizedDescription)")
                self.accessError = "failed to save event: \(error.localizedDescription)"
                completion(false, error)
            }
        }
    }

    func getAvailableCalendars() -> [EKCalendar] {
        guard accessGranted else { return [] }
        return eventStore.calendars(for: .event)
    }
}
