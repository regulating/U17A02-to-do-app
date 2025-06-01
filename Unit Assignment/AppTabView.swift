import SwiftUI

struct AppTabView: View {
    enum Tab {
        case explore, events, inbox, profile
    }
    @State private var selectedTab: Tab = .events

    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
                .tabItem { Label("Explore", systemImage: "safari") }
                .tag(Tab.explore)

            EventsListView() 
                .tabItem { Label("Events", systemImage: "list.bullet.rectangle.portrait") }
                .tag(Tab.events)

            InboxView()
                .tabItem { Label("Inbox", systemImage: "envelope") }
                .tag(Tab.inbox)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(Tab.profile)
        }
        .accentColor(AppColors.accent)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
