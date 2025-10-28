# Technical Documentation

## HRM

### Architecture Overview

The HRM application is a Flutter-based mobile application designed for managing employee attendance and expenses. The architecture of the application is modular, with clear separation of concerns between different modules such as authentication, employee management, attendance tracking, and expense management.

### Setup & Installation

#### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio or Xcode
- A code editor (e.g., Visual Studio Code)

#### Steps to Set Up the Project

1. **Clone the Repository**
   ```sh
   git clone https://github.com/your-repo/HRM.git
   cd HRM
   ```

2. **Install Dependencies**
   ```sh
   flutter pub get
   ```

3. **Configure Environment Variables**
   - Create a `.env` file in the root directory with the following content:
     ```env
     BASE_URL=https://your-api-url.com
     ENABLE_LOGGING=true
     ```

4. **Run the Application**
   ```sh
   flutter run
   ```

### API Documentation

#### Authentication
- **Login**
  - **Endpoint:** `/api/auth/login`
  - **Method:** `POST`
  - **Request Body:**
    ```json
    {
      "email": "user@example.com",
      "password": "password"
    }
    ```
  - **Response:**
    ```json
    {
      "token": "your-token",
      "refreshToken": "your-refresh-token",
      "user": {
        "id": 1,
        "name": "John Doe",
        "email": "user@example.com",
        "type": "employee"
      }
    }
    ```

#### Employee Management
- **Get Employee List**
  - **Endpoint:** `/api/employee`
  - **Method:** `GET`
  - **Response:**
    ```json
    {
      "success": true,
      "data": [
        {
          "id": 1,
          "name": "John Doe",
          "email": "john.doe@example.com",
          "type": "employee"
        },
        ...
      ]
    }
    ```

#### Attendance Tracking
- **Get Attendance List**
  - **Endpoint:** `/api/attendance`
  - **Method:** `GET`
  - **Response:**
    ```json
    {
      "success": true,
      "data": [
        {
          "id": 1,
          "date": "2023-10-01",
          "status": "present",
          "clockIn": "09:00",
          "clockOut": "17:00",
          "late": "0",
          "earlyLeaving": "0",
          "overtime": "0",
          "totalRest": "0",
          "reason": "None",
          "createdBy": 1,
          "shift": {
            "id": 1,
            "name": "Day Shift"
          },
          "employee": {
            "id": 1,
            "name": "John Doe",
            "email": "john.doe@example.com",
            "type": "employee"
          }
        },
        ...
      ]
    }
    ```

#### Expense Management
- **Get Expense List**
  - **Endpoint:** `/api/expense`
  - **Method:** `GET`
  - **Response:**
    ```json
    {
      "success": true,
      "data": [
        {
          "id": 1,
          "branchId": 1,
          "paymentDate": "2023-10-01",
          "subtotal": 100.0,
          "taxTotal": 10.0,
          "totalAmount": 110.0,
          "paymentsStatus": "paid",
          "createdBy": 1,
          "categoryId": 1,
          "description": "Lunch",
          "document": "document.pdf",
          "isDeleted": false,
          "createdAt": "2023-10-01T10:00:00Z",
          "updatedAt": "2023-10-01T10:00:00Z",
          "creator": {
            "id": 1,
            "name": "John Doe"
          },
          "branch": {
            "id": 1,
            "name": "Main Branch"
          }
        },
        ...
      ]
    }
    ```

### Database Schema (if applicable)

The application uses a RESTful API for data management. The database schema is not explicitly defined in the codebase but can be inferred from the API endpoints and their responses.

### Configuration

#### Environment Variables
- **BASE_URL:** The base URL of the API server.
- **ENABLE_LOGGING:** A boolean flag to enable or disable logging.

#### Configuration Files
- **.env.dev:** Environment variables for development.
- **.env.staging:** Environment variables for staging.
- **.env.prod:** Environment variables for production.

### Development Guidelines

#### Coding Standards
- Follow the Dart coding standards.
- Use meaningful variable and function names.
- Keep functions small and focused on a single responsibility.

#### Testing
- Write unit tests for each module.
- Use the `flutter_test` package for testing Flutter widgets.

#### Code Reviews
- Conduct code reviews to ensure code quality and adherence to coding standards.

### Deployment Instructions

#### Android
1. **Build the APK**
   ```sh
   flutter build apk
   ```

2. **Sign the APK**
   ```sh
   flutter build apk --release
   ```

3. **Deploy to Google Play Store**
   - Follow the Google Play Store guidelines for app submission.

#### iOS
1. **Build the IPA**
   ```sh
   flutter build ios
   ```

2. **Archive the App**
   - Open the project in Xcode.
   - Select the target device.
   - Archive the app.

3. **Upload to App Store**
   - Follow the Apple App Store guidelines for app submission.

### Conclusion

The HRM application provides a comprehensive solution for managing employee attendance and expenses. With a modular architecture and clear separation of concerns, the application is easy to maintain and extend. The API documentation and development guidelines ensure that developers can effectively contribute to the project.
