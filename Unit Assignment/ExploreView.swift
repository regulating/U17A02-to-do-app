import SwiftUI

// model for explore event item
struct ExploreEventItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var location: String
    var dateDisplay: String // displayed date
    var dateActual: Date // actual date for sorting
    var imageName: String // image name
    var category: String
    var price: String? = nil // event price
    var isFeatured: Bool = false
}

// sample data generator
func generateSampleExploreEvents() -> [ExploreEventItem] {
    let today = Date()
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: today)!
    let twoWeeks = Calendar.current.date(byAdding: .day, value: 14, to: today)!

    return [
        ExploreEventItem(name: "Sunset Jazz Evening", location: "Marina Bay Sands", dateDisplay: "TONIGHT", dateActual: today, imageName: "music.mic.circle.fill", category: "Concerts", price: "Free", isFeatured: true),
        ExploreEventItem(name: "Future of AI Summit", location: "Tech Convention Center", dateDisplay: formatDate(tomorrow, format: "MMM dd"), dateActual: tomorrow, imageName: "brain.head.profile.fill", category: "Technology", price: "From £99"),
        ExploreEventItem(name: "Local Food Fest", location: "Downtown Plaza", dateDisplay: formatDate(nextWeek, format: "MMM dd"), dateActual: nextWeek, imageName: "fork.knife.circle.fill", category: "Food & Drink", isFeatured: true),
        ExploreEventItem(name: "Indie Film Screening", location: "The Art House Cinema", dateDisplay: formatDate(today, format: "MMM dd"), dateActual: today, imageName: "film.fill", category: "Arts & Culture", price: "£15"),
        ExploreEventItem(name: "Weekend Coding Bootcamp", location: "Online via Zoom", dateDisplay: "THIS WKND", dateActual: tomorrow, imageName: "laptopcomputer.and.iphone", category: "Workshops"),
        ExploreEventItem(name: "City Lights Marathon", location: "Riverside Park", dateDisplay: formatDate(twoWeeks, format: "MMM dd"), dateActual: twoWeeks, imageName: "figure.run.circle.fill", category: "Sports", price: "£50", isFeatured: true),
        ExploreEventItem(name: "Photography Walk", location: "Historic District", dateDisplay: formatDate(nextWeek, format: "MMM dd"), dateActual: nextWeek, imageName: "camera.fill", category: "Arts & Culture")
    ]
}


// helper to format dates
func formatDate(_ date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}


struct ExploreView: View {
    @State private var selectedFilter: String = "All"
    @State private var searchText: String = ""
    let allEvents = generateSampleExploreEvents()

    let filters = ["All", "Concerts", "Technology", "Food & Drink", "Arts & Culture", "Workshops", "Sports"] // filter categories

    var filteredEvents: [ExploreEventItem] {
        var events = allEvents
        if selectedFilter != "All" {
            events = events.filter { $0.category == selectedFilter } // filter by category
        }
        if !searchText.isEmpty {
            events = events.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.location.localizedCaseInsensitiveContains(searchText) } // filter by search text
        }
        return events
    }

    var featuredEvents: [ExploreEventItem] {
        allEvents.filter { $0.isFeatured && (selectedFilter == "All" || $0.category == selectedFilter) } // get featured events
    }

    var eventsNearYou: [ExploreEventItem] { // simple example for nearby events
        allEvents.shuffled().prefix(3).filter { selectedFilter == "All" || $0.category == selectedFilter }
    }


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // header
                    Text("Discover")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)

                    // search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search events, venues...", text: $searchText) // search text field
                    }
                    .padding(12)
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(filters, id: \.self) { filter in
                                FilterChip(label: filter, isSelected: selectedFilter == filter) {
                                    selectedFilter = filter // update selected filter
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // featured events
                    if !featuredEvents.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Featured")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(featuredEvents) { event in
                                        FeaturedEventCard(event: event) // featured event card
                                            .frame(width: UIScreen.main.bounds.width * 0.75)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            }
                        }
                    }

                    // events near you
                    if !eventsNearYou.isEmpty && selectedFilter == "All" { // show if all filter is selected
                        SectionView(title: "Near You", events: Array(eventsNearYou)) // nearby events section
                    }

                    // all filtered events
                    SectionView(title: selectedFilter == "All" ? "Popular Events" : selectedFilter, events: filteredEvents.filter { !$0.isFeatured && !eventsNearYou.contains($0) })


                    Spacer(minLength: 20) // bottom spacer
                }
            }
            .navigationBarHidden(true) // hide default nav bar
            .background(AppColors.primaryBackground.ignoresSafeArea())
        }
        .accentColor(AppColors.accent)
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Text(label)
            .font(.subheadline)
            .fontWeight(isSelected ? .bold : .medium)
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background(isSelected ? AppColors.accent : AppColors.secondaryBackground)
            .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            .cornerRadius(25)
            .onTapGesture(perform: action) // filter action
    }
}

struct FeaturedEventCard: View {
    let event: ExploreEventItem

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                Image(systemName: event.imageName) // featured event image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()

                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .center, endPoint: .bottom)

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.name) // featured event name
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(event.location) // featured event location
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(1)
                }
                .padding()
            }

            HStack {
                Label(event.dateDisplay, systemImage: "calendar") // featured event date
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                if let price = event.price {
                    Text(price) // featured event price
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(AppColors.accent.opacity(0.2))
                        .foregroundColor(AppColors.accent)
                        .cornerRadius(5)
                }
            }
            .padding([.horizontal, .bottom], 12)
            .padding(.top, 8)

        }
        .background(AppColors.secondaryBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

struct StandardEventCard: View {
    let event: ExploreEventItem

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: event.imageName) // standard event image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .clipped()
                .cornerRadius(10)
                .foregroundColor(AppColors.accent.opacity(0.7))


            VStack(alignment: .leading, spacing: 6) {
                Text(event.name) // standard event name
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                Text(event.location) // standard event location
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(1)

                HStack {
                    Label(event.dateDisplay, systemImage: "calendar") // standard event date
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    if let price = event.price {
                        Text(price) // standard event price
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
            Spacer() // push content to left
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct SectionView: View {
    let title: String
    let events: [ExploreEventItem]

    var body: some View {
        if !events.isEmpty {
            VStack(alignment: .leading) {
                Text(title) // section title
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                LazyVStack(spacing: 15) {
                    ForEach(events) { event in
                        NavigationLink(destination: EventDetailViewPlaceholder(event: event)) {
                            StandardEventCard(event: event) // standard event card
                        }
                        .buttonStyle(.plain) // remove button style
                    }
                }
                .padding(.horizontal)
            }
        } else {
            EmptyView() // don't show section if no events
        }
    }
}

// placeholder for event detail view
struct EventDetailViewPlaceholder: View {
    let event: ExploreEventItem
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(systemName: event.imageName) // event detail image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .overlay(alignment: .topLeading) {
                        // custom back button if needed
                    }

                VStack(alignment: .leading, spacing: 15) {
                    Text(event.name) // event detail name
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Label(event.location, systemImage: "location.fill") // event detail location
                        .font(.title3)

                    Label("\(event.dateDisplay) (Actual: \(event.dateActual, style: .date))", systemImage: "calendar") // event detail date
                        .font(.title3)

                    if let price = event.price {
                        Label(price, systemImage: "dollarsign.circle.fill") // event detail price
                            .font(.title3)
                    }

                    Text("Event details go here... Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.") // event details
                        .padding(.top)

                    Spacer()

                    Button("Buy Tickets") {
                        // action
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.bottom)

                }
                .padding()
            }
        }
        .navigationTitle(event.name) // detail view title
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView() // explore view preview
    }
}


class AppColorsPreviewDummy: ObservableObject {
    let accent = Color.green
    let primaryBackground = Color(UIColor.systemGroupedBackground)
    let secondaryBackground = Color(UIColor.secondarySystemGroupedBackground)
    let textPrimary = Color.primary
    let textSecondary = Color.secondary
}
