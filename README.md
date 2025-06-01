# Mobile Task Manager App

[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=flat-square&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![Xcode](https://img.shields.io/badge/Xcode-black?style=flat-square&logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)

This is a mobile application designed to help users efficiently manage their tasks and time. Built using SwiftUI for iOS, the app aims for a simple and intuitive user experience while leveraging device-specific features like GPS for enhanced functionality.

## Why I Made This App

As a junior developer exploring mobile app development, I wanted to create a practical tool that addresses a common need: effective task management. I chose to incorporate device functions, specifically GPS, to explore the capabilities of mobile platforms and to add a layer of context-awareness to task management. The goal was to build an app that not only helps users keep track of what needs to be done but also allows them to associate tasks with specific locations, potentially leading to more efficient workflows and reminders. This project served as a valuable learning experience in mobile app design, development, and the integration of device features.

## How the App Works

The app is structured around a few key screens and functionalities:

* **Task List:** This is the main screen where all your tasks are displayed. You can see the title of each task, its completion status, any associated notes, and the due date if set.
* **Add New Event / Edit Event:** This screen allows you to create new tasks or modify existing ones. You can enter the event name (title), add optional notes, set a due date and time, and specify a location.
* **Location Services:** When adding or editing a task, you have the option to associate a location with it. You can either type in an address or use your device's current GPS location. This allows you to have tasks that are relevant to specific places (e.g., "buy milk" when you are near the grocery store - future implementation for proactive reminders).
* **Completion Toggle:** On the task list, you can easily mark tasks as complete by tapping the circle next to the task title. Once completed, the task title will be struck through.
* **Deletion:** You can delete tasks by swiping left on a task in the task list and tapping the "Delete" button.

## How to Use the App

1.  **Launching the App:** Simply tap the app icon on your iOS device to open the Task Manager.
2.  **Viewing Tasks:** The main screen displays a list of all your current tasks.
3.  **Adding a New Task:**
    * Navigate to the "Create New Event" screen (usually accessible via a "+" button in the navigation bar).
    * Enter the title of your task in the "Event Name" field.
    * Add any additional details or reminders in the "Notes" section (optional).
    * Toggle the "Include Due Date" option if you want to set a specific date and time for the task. If enabled, use the date picker to select the desired date and time.
    * In the "Location or Video Call" section, you can either:
        * Type in a location or address in the text field.
        * Tap the location icon to use your device's current GPS location. The app will attempt to fetch and display the address based on your GPS coordinates. You can manually edit this if needed.
    * Tap the "Create Event" button to save your new task.
4.  **Marking a Task as Complete:** On the task list, tap the circle icon next to the task you want to mark as done. The icon will change to a checkmark, and the task title will be struck through.
5.  **Editing a Task:**
    * Tap on a task in the task list to open the "Edit Event" screen.
    * Modify the title, notes, due date, or location as needed.
    * Tap the "Update Event" button to save your changes.
6.  **Deleting a Task:**
    * On the task list, swipe left on the task you wish to delete.
    * A "Delete" button will appear. Tap it to remove the task.
7.  **Managing Your Profile:** (If implemented - based on provided code, this includes basic profile viewing and settings like notifications - the functionality of these settings might be placeholder in this version). Navigate to the "Profile" tab to view your basic information and potentially adjust app settings.

## Device Functions Utilized

This app utilizes the following device function:

* **GPS (CoreLocation):** The app can access your device's GPS to retrieve your current location when adding or editing a task. This allows you to associate tasks with specific places.

## Future Enhancements (Potential)

While the current version provides core task management and location awareness, future updates could include:

* **Notifications:** Implementing reminders based on task due dates and potentially location (e.g., reminding you to "buy milk" when you are near a grocery store).
* **Calendar Integration:** Allowing synchronization with the device's calendar to view tasks alongside scheduled events.
* **Task Categorization/Filtering:** Enabling users to organize and filter tasks by categories, priority, or location.
* **Cloud Synchronization:** Syncing tasks across multiple devices.

## For Educational Purposes

This project was developed to fulfill the requirements of the Pearson BTEC Level 3 Extended Certificate/Foundation Diploma/Diploma/Extended Diploma in Computing, specifically Unit 17 - Mobile Apps Development. It demonstrates the ability to:

* Design a mobile app that utilizes device functions (Learning Aim B).
* Develop a mobile app that utilizes device functions (Learning Aim C).

It encompasses the stages of design, development, testing, and evaluation, showcasing the application of mobile app development principles and the integration of device-specific features.
