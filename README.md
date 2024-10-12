
# IoT Lift Access Control System

## Overview

This project implements an IoT-based lift access control system using ESP8266 microcontroller, Firebase for real-time database management, and mobile app development for user interaction. The system utilizes RFID for user authentication, a keypad for selecting lift destinations, and integrates with a mobile application for remote control and monitoring.

## Features

- **RFID User Authentication:** Users can gain access by scanning their RFID cards.
- **Keypad Input:** Users can select lift destinations using a numeric keypad.
- **Mobile Application:** A companion mobile app (developed using Flutter) allows users to control and monitor the lift system remotely.
- **Real-time Database:** Firebase is used to store user data, lift positions, and usage statistics.

## Hardware Requirements

- ESP8266 Development Board (e.g., NodeMCU, Wemos D1 Mini)
- RFID Reader Module (e.g., MFRC522)
- Keypad Module (4x3 or similar)
- Jumper Wires
- Breadboard (optional)
- Power Source (USB or battery)

## Software Requirements

- Arduino IDE with ESP8266 Board Support
- Firebase Project for real-time database
- Flutter SDK for mobile app development

## Setup Instructions

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/GaneshAdimalupu/your-repo-name.git
cd your-repo-name
```

### 2. Configure Firebase

1. Create a new project in [Firebase Console](https://console.firebase.google.com/).
2. Add a Realtime Database to your project and set the necessary rules for read/write access.
3. Obtain the API key and project ID from the project settings.
4. Enable email/password authentication in the Authentication section.

### 3. Install Arduino IDE and Set Up ESP8266

1. Download and install the [Arduino IDE](https://www.arduino.cc/en/software).
2. Open the Arduino IDE and go to `File` > `Preferences`.
3. Add the following URL to the "Additional Board Manager URLs":

   ```
   http://arduino.esp8266.com/stable/package_esp8266com_index.json
   ```

4. Go to `Tools` > `Board` > `Boards Manager`, search for `esp8266`, and install the package.
5. Install the required libraries:

   - Firebase ESP Client
   - Keypad
   - MFRC522
   - NTPClient
   - TimeLib

   You can install these libraries via the Library Manager (`Sketch` > `Include Library` > `Manage Libraries`).

### 4. Upload the Code to ESP8266

1. Open the `lift_access_control.ino` file in Arduino IDE.
2. Update the following variables in the code with your Firebase and Wi-Fi credentials:

   ```cpp
   #define WIFI_SSID "Your_SSID"
   #define WIFI_PASSWORD "Your_Password"
   #define API_KEY "Your_Firebase_API_Key"
   #define FIREBASE_PROJECT_ID "Your_Firebase_Project_ID"
   #define USER_EMAIL "Your_Email"
   #define USER_PASSWORD "Your_Password"
   ```

3. Connect your ESP8266 board to your computer via USB.
4. Select the correct board and port in `Tools` > `Board` and `Tools` > `Port`.
5. Upload the code by clicking on the upload button (→).

### 5. Set Up the Mobile App

1. Ensure you have [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
2. Navigate to the mobile app directory in your terminal:

   ```bash
   cd mobile_app_directory
   ```

3. Update the Firebase configuration in the Flutter app with your project details.
4. Run the mobile app:

   ```bash
   flutter run
   ```

## How to Use

1. Power on the ESP8266 board. It will connect to Wi-Fi and Firebase.
2. Scan an RFID card to authenticate the user. The system will display a welcome message for authorized users.
3. Use the keypad to enter the lift destination.
4. Monitor and control the system via the mobile app.

## Career Highlights

- Developed and deployed a smart home automation system using ESP8266 and Firebase.
- Led the creation of a wearable health monitoring device with real-time processing and cloud storage.
- Implemented an IoT-based asset tracking system for logistics, improving inventory management.

## Contributions

Feel free to contribute to this project by opening issues or submitting pull requests. Collaboration is welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### [Live Preview 🔴 ](https://abuanwar072.github.io/Welcome-Login-Signup-Page-Flutter/#/)

### [Watch it on YouTube](https://youtu.be/8gJ_WRmxyW0)

**Packages we are using:**

- flutter_svg: [link](https://pub.dev/packages/flutter_svg)

We design 3 responsive screens first one is a welcome screen the user opens your app it shows then users have two options if the user has an account then press the login button and it just shifts the user to the login screen, or if they don't have an account then press signup button its transfers to the signup screen. All of those screens work perfectly on Android, iOS, Web, and Desktop.

**Specal Thanks to: Muhammad Hamza (@mhmzdev)**

### Auth UI

![Preview UI](/preview.gif)
![App UI](/UI.png)
