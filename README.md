# Vendly - Local E-commerce Platform for El Salvador

Vendly is a comprehensive e-commerce platform built with Flutter, designed specifically for Salvadoran entrepreneurs. It functions as a "local Shopify" that enables small and medium-sized businesses to create their digital stores in minutes, integrating local payment methods and national logistics for a complete ecosystem.

## Core Value Proposition

**Main Idea**: Vendly is a local Shopify alternative designed for Salvadoran entrepreneurs to digitize their businesses quickly and efficiently. The platform integrates local payment methods and national logistics, offering an all-in-one ecosystem that eliminates the need to manage multiple service providers.

**Purpose**: Enable local vendors to easily digitize their businesses, allowing them to sell online with security and speed, while customers can purchase from anywhere in the country using reliable payment methods and delivery services.

## Key Features

### 🏪 For Sellers (Local Entrepreneurs)

- **Quick Store Setup**: Create your digital store in minutes with custom branding
- **Product Management**: Add, edit, and manage products with image support
- **Inventory Control**: Real-time stock monitoring and product status tracking
- **Order Processing**: Streamlined order management and fulfillment
- **Sales Analytics**: Track revenue, sales trends, and customer insights
- **Multi-channel Sharing**: Share product links directly on WhatsApp, Instagram, and Facebook

### 🛒 For Buyers

- **Marketplace Discovery**: Browse products from multiple local stores
- **Advanced Search**: Find products by name, category, price, or location
- **Secure Shopping**: Safe and reliable purchasing experience
- **Multiple Payment Options**: Choose from various local payment methods
- **Order Tracking**: Real-time delivery status updates
- **Favorites & Wishlist**: Save products for future purchases

### 💳 Local Payment Integration

- **Wompi**: Digital wallet payments
- **n1co**: Mobile payment solutions
- **Bank Transfers**: Direct bank-to-bank transfers
- **Cash on Delivery**: Pay when you receive your order
- **Credit/Debit Cards**: Secure card processing

### 📦 National Logistics Network

- **Boxful**: Nationwide delivery service
- **PedidosYa**: Food and product delivery
- **Express**: Fast courier services
- **Forza**: Reliable shipping solutions
- **Automatic Integration**: Seamless connection with delivery partners

## Why Vendly Over Global Solutions?

While platforms like Shopify work globally, they're not adapted to Salvadoran reality. Vendly understands local needs:

- **Local Payment Methods**: Integration with payment systems that actually work in El Salvador
- **National Delivery Network**: Connection with local courier services that deliver nationwide
- **Affordable Pricing**: Competitive rates designed for the Salvadoran market
- **Spanish Support**: Complete platform and customer service in Spanish
- **Local Business Understanding**: Features designed for how Salvadoran businesses operate

## Technical Architecture

### 📱 Flutter Framework

- **Cross-platform**: Single codebase for iOS and Android
- **Modern UI**: Material Design 3 with custom Salvadoran-inspired themes
- **Performance**: Optimized for smooth user experience

### 🎨 UI/UX Design

- **Glassmorphism**: Modern glass effect design elements
- **Smooth Animations**: Micro-interactions and transitions
- **Responsive Layout**: Optimized for all screen sizes
- **Accessibility**: Designed for users of all technical levels

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
   cd vendly
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Development & Deployment

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Local Development Setup

```bash
# Enable developer mode
flutter config --enable-web

# Run on specific device
flutter run -d <device-id>

# Hot reload during development
flutter run --hot
```
