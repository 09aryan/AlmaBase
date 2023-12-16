# Alumni App

## Overview

This is an Alumni App developed using Flutter and Node.js, aimed at connecting and engaging alumni of a particular institution. The app facilitates communication, event updates, and networking among the alumni community.

## Features

1. **User Authentication**: Secure user authentication ensures that only authorized alumni can access the app.

   ![io](https://github.com/09aryan/AlmaBase/assets/99637603/4df39807-ca7d-45ef-80f4-79f7d8c790f2)


3. **Profile Management**: Alumni can create and manage their profiles, providing information such as graduation year, current profession, and contact details.

   ![image6](https://github.com/09aryan/AlmaBase/assets/99637603/33d2f42f-8c65-485b-a6c0-f61926820771)

5. **News Feed**: Stay updated with the latest news, events, and achievements of fellow alumni and the alma mater.

   ![am7](https://github.com/09aryan/AlmaBase/assets/99637603/ed72b79c-cab3-4db2-bd6d-f0888df5a4c6)

7. **Events**: View and RSVP for alumni events, reunions, and networking opportunities.

   

9. **Directory**: Easily search and connect with other alumni based on various criteria such as graduation year, location, and profession.

10. **Messaging**: Private messaging allows alumni to communicate directly within the app, fostering networking and collaboration.

    

12. **Job Board**: Post and search for job opportunities within the alumni community.

13. **Push Notifications**: Receive instant updates on important announcements, events, and messages through push notifications.

## Getting Started

Follow these steps to get the app up and running on your local machine:

# Navigate to the project directory
cd alumni-app

# Install dependencies
flutter pub get

# Set up your Node.js server
1. Clone the server repository (if separate) or create your own Node.js server.
2. Configure the server to handle authentication, user profiles, and other required functionalities.

# Update the app to communicate with your Node.js server
- Modify API endpoints in the app to match your server routes.
- Update authentication and data fetching logic accordingly.

# Run the app
flutter run

# Configuration

## Update App and Server Details

Update the following configuration files with your server and app details:

- `lib/config/api_config.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'YOUR_SERVER_BASE_URL';
  // Add other API-related configurations as needed
}
