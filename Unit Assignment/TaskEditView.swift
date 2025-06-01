// TaskEditView.swift
import SwiftUI
import CoreLocation // Import CoreLocation

struct TaskEditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var taskManager: TaskManager
    
    @State var taskToEdit: TaskItem?
    
    // Task properties
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var dueDate: Date? = nil
    @State private var includeDueDate: Bool = false
    @State private var locationInput: String = "" // This field will be for location

    // Location specific state
    @StateObject private var locationManager = LocationManager() // Manage location fetching
    @State private var isFetchingLocation: Bool = false
    @State private var showManualLocationEditIcon: Bool = false // To show 'edit' if GPS filled it

    var isEditing: Bool { taskToEdit != nil }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name (e.g., Meeting with Ugo)", text: $title)
                        .padding(.vertical, 5) // Slight padding adjustment
                }

                // Location Section
                Section(header: Text("Location or Video Call")) {
                    HStack {
                        if isFetchingLocation {
                            ProgressView()
                                .padding(.trailing, 5)
                            Text("Fetching current location...")
                                .foregroundColor(.gray)
                        } else {
                            TextField("Type a location or use current", text: $locationInput)
                                .onChange(of: locationInput) { _ in
                                    // If user types, assume manual entry, hide edit icon unless it was set by GPS
                                    if !isFetchingLocation { // Don't hide if GPS is still trying
                                        showManualLocationEditIcon = false
                                    }
                                }
                        }
                        Spacer()
                        // Button to trigger GPS location fetch
                        if !isFetchingLocation {
                            Button {
                                fetchCurrentLocation()
                            } label: {
                                Image(systemName: showManualLocationEditIcon ? "pencil.circle.fill" : "location.circle.fill")
                                    .foregroundColor(AppColors.accent)
                            }
                            .disabled(isFetchingLocation)
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header: Text("Date & Time")) { // Combined for better grouping
                    Toggle("Include Due Date", isOn: $includeDueDate.animation())
                    if includeDueDate {
                        DatePicker("Select Date", selection: Binding(
                            get: { dueDate ?? Date() },
                            set: { dueDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute]) // Added time component
                    }
                }
                
                Section(header: Text("Notes")) {
                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty && !isEditing { // Show placeholder only if notes are empty AND not editing existing
                             Text("Enter additional notes (optional)")
                                .foregroundColor(Color(UIColor.placeholderText))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                    }
                }

                Section {
                    Button(action: saveTask) {
                        Text(isEditing ? "Update Event" : "Create Event")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .listRowBackground(Color.clear)
                
                if isEditing {
                    Section {
                        Button(action: deleteTask) {
                            Text("Delete Event")
                                .foregroundColor(AppColors.destructive)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle(isEditing ? "Edit Event" : "Create New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppColors.accent)
                }
            }
            .onAppear {
                setupInitialValues()
                // Optionally, automatically try to fetch location on appear if it's a new event
                if !isEditing && locationInput.isEmpty { // Only for new events without location yet
                    fetchCurrentLocation()
                }
            }
            // Listen to changes from locationManager
            .onReceive(locationManager.$lastKnownLocation) { location in
                guard let newLocation = location, isFetchingLocation else { return }
                getPlacemark(for: newLocation)
            }
            .onReceive(locationManager.$locationError) { error in
                if error != nil {
                    isFetchingLocation = false // Stop spinner on error
                    showManualLocationEditIcon = false
                    // Optionally show an alert to the user about the location error
                }
            }
            .onReceive(locationManager.$authorizationStatus) { status in
                 if status == .denied || status == .restricted {
                    isFetchingLocation = false // Stop if permission denied during fetch
                    showManualLocationEditIcon = false
                 }
            }
        }
        .background(AppColors.primaryBackground.ignoresSafeArea())
    }

    private func setupInitialValues() {
        if let task = taskToEdit {
            title = task.title
            notes = task.notes ?? ""
            locationInput = task.locationDetails ?? "" // Populate from new field
            dueDate = task.dueDate
            includeDueDate = task.dueDate != nil
            showManualLocationEditIcon = !(task.locationDetails ?? "").isEmpty // Show edit if location was pre-filled
        }
    }

    private func fetchCurrentLocation() {
        isFetchingLocation = true
        showManualLocationEditIcon = false // Reset while fetching
        locationInput = "" // Clear previous input if re-fetching

        // Check permission status first
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Or manager.requestLocation() for one-off
        case .notDetermined:
            locationManager.requestLocationPermission()
            // We'll rely on onReceive for authorizationStatus to then start updating if granted
        case .denied, .restricted:
            isFetchingLocation = false
            // Optionally, inform user that location services are off / guide to settings
            print("Location permission denied or restricted.")
            // You might want to present an alert here.
        @unknown default:
            isFetchingLocation = false
        }
    }

    private func getPlacemark(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [self] (placemarks, error) in
            isFetchingLocation = false // Finished attempting geocode
            locationManager.stopUpdatingLocation() // Stop GPS updates

            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                self.locationInput = "Lat: \(String(format: "%.4f", location.coordinate.latitude)), Lon: \(String(format: "%.4f", location.coordinate.longitude))" // Fallback to coords
                showManualLocationEditIcon = true
                return
            }
            
            if let placemark = placemarks?.first {
                var addressString = ""
                if let name = placemark.name, !name.contains("Unnamed Road") { addressString += "\(name), " } // Often more specific
                else if let street = placemark.thoroughfare { addressString += "\(street), " }

                if let city = placemark.locality { addressString += "\(city), " }
                if let state = placemark.administrativeArea { addressString += "\(state) " }
                // if let zip = placemark.postalCode { addressString += "\(zip) " }
                // if let country = placemark.country { addressString += country }
                
                self.locationInput = addressString.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: [","])
                if self.locationInput.isEmpty { // Fallback if address is still empty
                    self.locationInput = "Lat: \(String(format: "%.4f", location.coordinate.latitude)), Lon: \(String(format: "%.4f", location.coordinate.longitude))"
                }
                showManualLocationEditIcon = true
            } else {
                self.locationInput = "Address not found. Lat: \(String(format: "%.4f", location.coordinate.latitude)), Lon: \(String(format: "%.4f", location.coordinate.longitude))"
                showManualLocationEditIcon = true
            }
        }
    }

    private func saveTask() {
        let finalDueDate = includeDueDate ? dueDate : nil
        let finalLocation = locationInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingTask = taskToEdit {
            var updatedTask = existingTask
            updatedTask.title = title
            updatedTask.notes = notes.isEmpty ? nil : notes
            updatedTask.dueDate = finalDueDate
            updatedTask.locationDetails = finalLocation.isEmpty ? nil : finalLocation // Save to new field
            taskManager.updateTask(task: updatedTask)
        } else {
            taskManager.addTask(
                title: title,
                notes: notes.isEmpty ? nil : notes,
                dueDate: finalDueDate,
                locationDetails: finalLocation.isEmpty ? nil : finalLocation // Save to new field
            )
        }
        dismiss()
    }
    
    private func deleteTask() {
        if let task = taskToEdit {
            taskManager.deleteTask(task: task)
            dismiss()
        }
    }
}

// Ensure your preview can work
struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        // For Add
        TaskEditView(taskManager: TaskManager(), taskToEdit: nil)
        
        // For Edit (example)
        // TaskEditView(taskManager: TaskManager(), taskToEdit: TaskItem(title: "Existing Event", locationDetails: "Some Place"))
    }
}
