# WorkforceOS - Enterprise HRMS & Workforce Management System

## Overview

WorkforceOS is a comprehensive Flutter-based Human Resource Management System (HRMS) and Workforce Management application designed for enterprise use. Built with modern architecture and responsive design principles, it provides a complete solution for managing employees, attendance, leaves, payroll, and more.

## Features (Planned)

### 🔐 Authentication & Security
- Multi-factor authentication (OTP, Email verification)
- Role-based access control (Employee, Manager, HR, Admin)
- Session management and security

### 👥 Employee Management
- Employee directory and profiles
- Department and hierarchy management
- Role and permission assignment
- Onboarding workflows

### ⏰ Attendance & Time Tracking
- Geo-fenced punch-in/out
- Attendance history and reports
- Leave application and approval workflows
- Calendar integration

### 💰 Payroll & Finance
- Salary structure management
- Payslip generation and distribution
- Earnings and deductions tracking
- Financial reporting

### 📋 Tasks & Projects
- Task assignment and tracking
- Project management (Kanban/List views)
- Due date and priority management
- Team collaboration

### 🏢 Company Administration
- Multi-tenant organization structure
- Department and team management
- Policy and document management
- Analytics and reporting

### 📱 Communication
- Notification center
- Announcements and updates
- Document library
- Messaging system

## Technical Architecture

### Frontend
- **Framework**: Flutter 3.16+ with Dart 3.2+
- **State Management**: BLoC pattern with flutter_bloc
- **Navigation**: Declarative routing with go_router
- **UI/UX**: Material Design 3 with custom enterprise theme
- **Responsive Design**: Adaptive layouts for mobile, tablet, and desktop

### Platform Support
- ✅ Android
- ✅ iOS & iPadOS  
- ✅ macOS
- ✅ Windows
- ✅ Web

### Key Dependencies
- `flutter_bloc` - State management
- `go_router` - Navigation and routing
- `google_fonts` - Typography (Inter font family)
- `fl_chart` - Data visualization
- `reactive_forms` - Form handling and validation
- `dio` & `retrofit` - HTTP client and API integration
- `hive` & `shared_preferences` - Local storage
- `geolocator` - Location services for attendance

## Project Structure

```
lib/
├── app/                    # App-level configuration
├── core/                   # Core utilities and services
│   ├── config/            # Configuration files
│   ├── theme/             # Design system and theming
│   ├── router/            # Navigation configuration
│   ├── network/           # HTTP client setup
│   ├── errors/            # Error handling
│   └── utils/             # Utility functions
├── shared/                 # Shared components
│   ├── widgets/           # Reusable UI widgets
│   ├── models/            # Data models
│   └── constants/         # App constants
└── features/              # Feature modules
    ├── auth/              # Authentication
    ├── dashboard/         # Dashboard screens
    ├── employees/         # Employee management
    ├── attendance/        # Attendance tracking
    ├── leaves/            # Leave management
    ├── payroll/           # Payroll system
    ├── tasks/             # Task management
    ├── projects/          # Project management
    ├── company/           # Company administration
    └── settings/          # App settings
```

## Design System

### Color Palette
- **Primary**: Blue 600 (#2563EB) - Professional and trustworthy
- **Secondary**: Purple 600 (#7C3AED) - Modern and innovative  
- **Success**: Emerald 600 (#059669) - Positive actions
- **Warning**: Amber 600 (#D97706) - Attention required
- **Error**: Red 600 (#DC2626) - Critical issues

### Typography
- **Font Family**: Inter - Clean, professional, and highly legible
- **Scale**: Material Design 3 typography scale
- **Responsive**: Adaptive sizing for different screen sizes

### Responsive Breakpoints
- **Mobile**: < 600px (Single column, bottom navigation)
- **Tablet**: 600px - 1200px (Two columns, navigation rail)
- **Desktop**: > 1200px (Multi-column, sidebar navigation)

## Development Status

### ✅ Phase 1: Foundation (Completed)
- [x] Project setup and dependencies
- [x] Core theme system with light/dark mode support
- [x] Responsive design utilities
- [x] Navigation structure with go_router
- [x] Basic app shell and routing

### ✅ Phase 2: Authentication & App Shell (Completed)
- [x] Complete authentication system with BLoC state management
- [x] Login screen with responsive design (mobile/tablet/desktop)
- [x] OTP verification screen for enhanced security
- [x] Splash screen with branding and animations
- [x] Role-based user models and permissions system
- [x] Mock authentication repository with demo users
- [x] Secure session management with SharedPreferences
- [x] Role-based dashboard with user-specific quick actions
- [x] Reusable UI component library (buttons, text fields, cards)
- [x] Loading states and error handling

### 🔄 Phase 3: Core Features (Next)
- [ ] Employee management screens
- [ ] Attendance tracking functionality
- [ ] Leave management system
- [ ] Enhanced navigation shell

### 🔄 Phase 4: Advanced Features (Planned)
- [ ] Payroll system
- [ ] Task and project management
- [ ] Company administration
- [ ] Analytics and reporting

## Getting Started

### Prerequisites
- Flutter SDK 3.16.0 or later
- Dart SDK 3.2.0 or later

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd workforces
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Demo Credentials

The application includes demo users for testing different roles:

| Role | Email | Password | Features |
|------|--------|----------|-----------|
| **Admin** | admin@workforceos.com | password123 | Full system access, requires OTP |
| **HR Manager** | hr@workforceos.com | password123 | Employee & payroll management |
| **Manager** | manager@workforceos.com | password123 | Team management & approvals |
| **Employee** | employee@workforceos.com | password123 | Personal dashboard & self-service |

**Note:** For OTP verification (Admin role), use any 6-digit number (e.g., 123456).

## Contributing

This is an enterprise application under active development. Please follow the established architecture patterns and design system when contributing.

### Code Style
- Follow Dart/Flutter conventions
- Use the existing design system components
- Implement proper error handling
- Write tests for new features
- Follow the feature-first architecture

## License

[License information to be added]

---

**Note**: This application is currently in active development. Features and documentation will be updated as development progresses.