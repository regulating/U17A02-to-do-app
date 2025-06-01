import SwiftUI

struct ProfileView: View {
    @State private var notificationsEnabled = true // example toggle state

    var body: some View {
        NavigationView {
            Form { // grouped settings style
                Section { // profile header
                    HStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.fill") // profile icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(AppColors.accent.opacity(0.8))

                        VStack(alignment: .leading) {
                            Text("Jay Fitz") // placeholder name
                                .font(.title)
                                .fontWeight(.bold)
                            Text("jay.fitz@example.com") // placeholder email
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 10)
                }

                Section(header: Text("Account")) { // account settings
                    NavigationLink(destination: Text("Edit Profile Screen (Placeholder)")) {
                        Label("Edit Profile", systemImage: "pencil") // edit profile link
                    }
                    NavigationLink(destination: Text("Change Password Screen (Placeholder)")) {
                        Label("Change Password", systemImage: "lock.shield") // change password link
                    }
                    NavigationLink(destination: Text("Payment Methods Screen (Placeholder)")) {
                        Label("Payment Methods", systemImage: "creditcard") // payment methods link
                    }
                }

                Section(header: Text("Settings")) { // app settings
                    Toggle(isOn: $notificationsEnabled) { // notifications toggle
                        Label("Notifications", systemImage: "bell.badge")
                    }
                    NavigationLink(destination: Text("Appearance Settings Screen (Placeholder)")) {
                        Label("Appearance", systemImage: "paintbrush") // appearance settings link
                    }
                    NavigationLink(destination: Text("Privacy Settings Screen (Placeholder)")) {
                        Label("Privacy", systemImage: "hand.raised") // privacy settings link
                    }
                }

                Section(header: Text("Support")) { // support section
                    NavigationLink(destination: Text("Help Center (Placeholder)")) {
                        Label("Help Center", systemImage: "questionmark.circle") // help center link
                    }
                    NavigationLink(destination: Text("Contact Us (Placeholder)")) {
                        Label("Contact Us", systemImage: "bubble.left.and.bubble.right") // contact us link
                    }
                }

                Section { // sign out button
                    Button(action: {
                        // placeholder for sign-out action
                        print("Sign Out Tapped")
                    }) {
                        Text("Sign Out") // sign out text
                            .foregroundColor(AppColors.destructive)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Profile") // profile title
            .background(AppColors.primaryBackground.ignoresSafeArea()) // background color
        }
        .accentColor(AppColors.accent) // accent color
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView() // profile view preview
    }
}
