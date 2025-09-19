# LinkUp - Marketplace Mobile Application

LinkUp is a comprehensive marketplace mobile application built with Flutter that allows entrepreneurs to create their own mini-shops and sell products while providing buyers with a seamless shopping experience.

## Features

### For Sellers (Entrepreneurs)

- **Store Creation**: Set up your own mini-shop with custom branding
- **Product Management**: Add, edit, and manage products with images
- **Inventory Tracking**: Monitor stock levels and product status
- **Order Management**: View and manage incoming orders
- **Analytics Dashboard**: Track sales, revenue, and customer data
- **Category Management**: Organize products by categories

### For Buyers

- **Product Discovery**: Browse products from multiple stores
- **Search & Filter**: Find products by name, category, or keywords
- **Category Browsing**: Explore products by different categories
- **Favorites**: Save products for later viewing
- **Shopping Cart**: Add products and manage orders

### Authentication System

- **Dual Role Support**: Separate flows for buyers and sellers
- **User Profiles**: Manage personal information and preferences
- **Secure Login**: Email-based authentication system

## Technical Architecture

### Database

- **SQLite**: Local database for data persistence
- **Models**: User, Store, Product, Order, and Analytics models
- **Services**: Database service for CRUD operations

### State Management

- **Provider Pattern**: Used for state management across the app
- **Stream-based Auth**: Real-time authentication state updates

### UI/UX

- **Glass Morphism**: Modern glass effect design elements
- **Animations**: Smooth transitions and micro-interactions
- **Responsive Design**: Optimized for different screen sizes
- **Material Design 3**: Following latest design guidelines

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd link_up
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Sample Data

The app includes a sample data generator for testing purposes:

1. Launch the app
2. On the login screen, tap the "Add Sample Data" button
3. Use these test accounts:
   - **Seller**: `seller@example.com`
   - **Buyer**: `buyer@example.com`

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configurations
│   ├── services/           # Database and authentication services
│   ├── theme/             # App theme and styling
│   └── utils/             # Utility functions and helpers
├── features/
│   ├── auth/              # Authentication screens and logic
│   ├── home/              # Home screen and components
│   ├── products/          # Product browsing and search
│   ├── profile/           # User profile management
│   └── seller/            # Seller-specific features
└── shared/
    ├── models/            # Data models
    └── widgets/           # Reusable UI components
```

## Key Dependencies

- **flutter**: UI framework
- **sqflite**: Local database
- **image_picker**: Image selection
- **animate_do**: Animations
- **google_fonts**: Typography
- **provider**: State management
- **fl_chart**: Analytics charts
- **glassmorphism**: Glass effect UI

## Features Implemented

✅ **Authentication System**

- User registration and login
- Role-based access (Buyer/Seller)
- Profile management

✅ **Seller Features**

- Store setup and management
- Product CRUD operations
- Image upload support
- Seller dashboard
- Product inventory management

✅ **Buyer Features**

- Product browsing
- Category filtering
- Search functionality
- Modern UI/UX

✅ **Database Integration**

- SQLite local storage
- Data models and relationships
- CRUD operations

## Upcoming Features

🔄 **Order Management**

- Complete order processing flow
- Order status tracking
- Payment integration

🔄 **Analytics Dashboard**

- Sales charts and metrics
- Revenue tracking
- Customer insights

🔄 **Enhanced Features**

- Product reviews and ratings
- Push notifications
- Advanced search filters
- Wishlist functionality

## Development

### Running Tests

```bash
flutter test
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository or contact the development team.
