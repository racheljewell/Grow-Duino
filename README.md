# GrowDuino

## Overview

GrowDuino is a mobile application designed to provide real-time monitoring and analysis of environmental data from a GrowDuino device. It allows users to track temperature, humidity, and light levels, enabling them to optimize conditions for plant growth.

## Key Features

*   **Real-Time Monitoring:** Displays current temperature, humidity, and light levels from the connected GrowDuino device.
*   **Statistical Analysis:** Provides insights through statistical analysis of temperature and humidity data (e.g., averages, trends).
*   **Data Visualization:** Presents temperature and humidity data visually using interactive charts.
*   **User-Friendly Interface:** Offers a clean and intuitive navigation experience.
*   **Dark Mode Support:** Includes a dark mode option for comfortable viewing in low-light conditions.
*   **Offline Data Caching:** Retains recent data even when the connection to the GrowDuino device is temporarily unavailable.

## Installation

**Prerequisites:**
Before installing GrowDuino, ensure that the following are installed on your machine:

*   [Flutter SDK](https://flutter.dev/docs/get-started/install): Flutter framework must be installed and configured.
*   [Firebase CLI](https://firebase.google.com/docs/cli): The Firebase command-line interface must be installed for Firebase-related operations.

**Installation Steps:**

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/racheljewell/Grow-Duino.git
    ```

2.  **Navigate to the Project Directory:**
    ```bash
    cd Grow-Duino
    ```

3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

4. **Firebase Setup:**

    *   If you have not done so already, add the firebase config json file (google-services.json for Android, GoogleService-Info.plist for iOS)
    *   Ensure that the necessary firebase extensions are enabled in your firebase project

5.  **Run the App:**
    ```bash
    flutter run
    ```

    *You will likely need to connect your physical device or an emulator for best results.*

## Technologies Used

*   **[Flutter](https://flutter.dev/)**:  Cross-platform framework for building natively compiled applications.
*   **[Dart](https://dart.dev/)**:  The programming language used by Flutter.
*   **[HTTP Package](https://pub.dev/packages/http)**: For making HTTP requests to fetch data from the GrowDuino server (e.g., REST API).
*   **[Provider Package](https://pub.dev/packages/provider)**: For managing application state efficiently.
*   **[FL Chart Package](https://pub.dev/packages/fl_chart)**: For creating beautiful and interactive charts to visualize data.
*   **[Firebase](https://firebase.google.com)**: For various backend services, including:
    *   Deployment (e.g., Firebase Hosting)
    *   User Authentication (e.g., Firebase Authentication)
    *   Database storage (e.g., Firestore or Realtime Database)
    *   Cloud Functions (for server-side logic, if applicable)
  
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

*   [Flutter](https://flutter.dev/): For providing a powerful framework for building beautiful apps.
*   [FL Chart package](https://pub.dev/packages/fl_chart): For providing charting capabilities.
*   [Firebase](https://firebase.google.com): For enabling backend services to be quickly and efficiently implemented

## Contributing

If you are interested in contributing to this project, feel free to fork the repository and submit pull requests. All contributions are welcome!

## Contact

If you have any questions or need further assistance, please contact [your email or team email here]

## Future Enhancements

*   **Push Notifications:** Send notifications based on configured thresholds
*   **Historical Data:** Store and display a longer period of historical data.
*   **Customization:** Allow users to customize the app interface and alerts.
*   **Multi-GrowDuino Support:** Support connection to multiple GrowDuino devices.
*   **Data Export:** Enable users to export their data in various formats
