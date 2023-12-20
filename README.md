# Alumni App

## Overview

This Alumni App, developed using Flutter and Node.js, serves as a platform to connect and engage alumni. It facilitates communication, provides event updates, and encourages networking among the alumni community.

## Features

1. **User Authentication**: Ensure secure access to the app by implementing user authentication, allowing only authorized alumni to log in.

   <p align="center">
     <img src="https://github.com/09aryan/AlmaBase/assets/99637603/4df39807-ca7d-45ef-80f4-79f7d8c790f2" alt="User Authentication" width="200">
   </p>

2. **Profile Management**: Alumni can create and manage their profiles, sharing information such as graduation year, current profession, and contact details.

   <p align="center">
     <img src="https://github.com/09aryan/AlmaBase/assets/99637603/33d2f42f-8c65-485b-a6c0-f61926820771" alt="Profile Management" width="200">
   </p>

3. **News Feed**: Stay updated with the latest news, events, and achievements of fellow alumni and the alma mater.

   <p align="center">
     <img src="https://github.com/09aryan/AlmaBase/assets/99637603/ed72b79c-cab3-4db2-bd6d-f0888df5a4c6" alt="News Feed" width="200">
   </p>

4. **Directory**: Easily search and connect with other alumni based on various criteria such as graduation year, location, and profession.

   <p align="center">
     <img src="https://github.com/09aryan/AlmaBase/assets/99637603/49cbc0bf-ee6f-486b-91ab-8356585d9063" alt="Directory" width="200">
   </p>

5. **Messaging**: Foster networking and collaboration through private messaging, allowing alumni to communicate directly within the app.

   <p align="center">
     <img src="https://github.com/09aryan/AlmaBase/assets/99637603/5d02219e-c683-40d7-8406-e48d55ebfbee" alt="Messaging" width="200">
   </p>

## Getting Started

Follow these steps to set up the app on your local machine:

```bash
# Navigate to the project directory
cd alumni-app

# Install dependencies
flutter pub get

### Set up your Node.js server

1. Clone the server repository (if separate) or create your own Node.js server.
2. Configure the server to handle authentication, user profiles, and other required functionalities.

### Update the app to communicate with your Node.js server

1. Modify API endpoints in the app to match your server routes.

   - **Update authentication screen (`lib/screens/authentication_screen.dart`):**

     ```dart
     // lib/screens/authentication_screen.dart

     // Add your authentication screen implementation here
     // Update API endpoints for authentication
     // ...
     ```

   - **Update profile screen (`lib/screens/profile_screen.dart`):**

     ```dart
     // lib/screens/profile_screen.dart

     // Add your profile screen implementation here
     // Update API endpoints for user profile
     // ...
     ```

   - **Update news feed screen (`lib/screens/news_feed_screen.dart`):**

     ```dart
     // lib/screens/news_feed_screen.dart

     // Add your news feed screen implementation here
     // Update API endpoints for fetching news feed
     // ...
     ```

   - **Update directory screen (`lib/screens/directory_screen.dart`):**

     ```dart
     // lib/screens/directory_screen.dart

     // Add your directory screen implementation here
     // Update API endpoints for searching alumni
     // ...
     ```

   - **Update messaging screen (`lib/screens/messaging_screen.dart`):**

     ```dart
     // lib/screens/messaging_screen.dart

     // Add your messaging screen implementation here
     // Update API endpoints for private messaging
     // ...
     ```

   - **Update notification screen (`lib/screens/notification_screen.dart`):**

     ```dart
     // lib/screens/notification_screen.dart

     // Add your notification screen implementation here
     // Update API endpoints for handling notifications
     // ...
     ```

2. Update authentication and data fetching logic accordingly.

   - Review and modify the logic in each screen file to handle authentication and data fetching based on the updated API endpoints.

3. Run the app:

   ```bash
   flutter run
