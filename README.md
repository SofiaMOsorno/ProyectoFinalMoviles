# QueueUp

**QueueUp** is a mobile application developed with Flutter and Dart that provides a virtual queue management system for businesses and customers. It allows users to join existing queues, create new ones, and register their businesses to manage customer access efficiently.

This project was developed as the final project for the **Mobile Application Development** course during the seventh semester of the Software Development Engineering degree.

## Overview

QueueUp aims to improve the waiting experience by replacing traditional physical lines with virtual queues. Businesses can manage customer access, while users can join queues remotely and receive notifications when their turn is approaching.

The application is designed for different scenarios, including:
- Ticket purchasing and event access.
- Restaurants with high customer demand.
- Businesses with limited capacity.
- Any establishment that needs to organize customer access through a waiting list.

To use the service, users must have the QueueUp application installed on their mobile devices.

## Features

- **Join a Queue:** Users can join an existing virtual queue.
- **Create a Queue:** Users can create and manage their own queues.
- **Business Registration:** Business owners can register their establishments to provide queue management services.
- **QR Code Generation:** Each queue generates a QR code that can be scanned to access it.
- **Text Code Generation:** Each queue also provides a unique text code that can be copied and shared.
- **Notifications:** Users receive notifications regarding their position and access availability.
- **Virtual Queue Management:** Businesses can organize customer access without requiring physical waiting lines.

## Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application framework |
| Dart | Main programming language |
| Android Studio | Development environment |
| Android Phone Emulator | Application testing and execution |

## Prerequisites

Before running the project, make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- [Android Studio](https://developer.android.com/studio)
- Android SDK and the required Android development tools.
- An Android Virtual Device (AVD) configured through Android Studio.
- [Git](https://git-scm.com/) to clone the repository.

You should also verify that your Flutter installation is properly configured by running:

```bash
flutter doctor
```

Resolve any required dependencies or configuration issues before proceeding.

## Installation and Setup

Follow these steps to run QueueUp locally.

### 1. Clone the repository

```bash
git clone [<REPOSITORY_URL>]
```

Navigate to the project directory:

```bash
cd proyecto_final
```

### 2. Install dependencies

Download the project's required Flutter packages:

```bash
flutter pub get
```

### 3. Configure the Android Emulator

1. Open Android Studio.
2. Navigate to **Tools → Device Manager**.
3. Create or select an Android Virtual Device.
4. Start the emulator and wait until it finishes booting.

### 4. Run the application

Make sure the emulator is running, then execute:

```bash
flutter run
```

Alternatively, you can open the project in Android Studio or Visual Studio Code and run it using the available Flutter development tools.

## Project Structure

The project follows the standard Flutter application structure:

```text
QueueUp/
├── android/          # Android-specific configuration
├── ios/              # iOS-specific configuration
├── lib/              # Main Dart source code
├── test/             # Application tests
├── assets/           # Application resources (if applicable)
├── pubspec.yaml      # Project dependencies and configuration
└── README.md
```

*Note: The structure above represents the standard Flutter project organization. Some directories may vary depending on the current project implementation.*

## Usage

1. Install and launch QueueUp on your Android device or emulator.
2. Register or access the application.
3. Choose whether to join an existing queue, create a new one, or register a business.
4. To join a queue, scan its QR code or enter the corresponding text code.
5. Follow your queue status and wait for the corresponding notifications.
6. Businesses can manage their queues and organize customer access through the application.

## Project Information

| Detail | Description |
|---|---|
| Project Name | QueueUp |
| Project Type | Mobile Application |
| Academic Context | Final Project – Mobile Application Development |
| Semester | Seventh Semester |
| Framework | Flutter |
| Programming Language | Dart |
| Development Environment | Android Studio |
| Current Testing Environment | Android Phone Emulator |

## Disclaimer

QueueUp was developed as an academic project. Its current implementation and available features reflect the scope and requirements of the original university assignment. Some functionality may require additional configuration or services depending on the project environment.

## License

No license has been specified for this project. All rights are reserved by the author unless otherwise stated.
