import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/store_model.dart';
import '../../shared/models/product_model.dart';

class SampleDataGenerator {
  static final DatabaseService _databaseService = DatabaseService();
  static final AuthService _authService = AuthService();

  static Future<void> generateSampleData() async {
    try {
      // Create sample seller
      final sellerResult = await _authService.signUp(
        email: 'seller@example.com',
        firstName: 'John',
        lastName: 'Seller',
        role: UserRole.seller,
        phoneNumber: '+1234567890',
      );

      if (!sellerResult.isSuccess || sellerResult.user == null) {
        print('Failed to create sample seller');
        return;
      }

      final seller = sellerResult.user!;

      // Create sample store
      final store = Store(
        sellerId: seller.id,
        name: 'TechHub Electronics',
        description:
            'Your one-stop shop for the latest electronics and gadgets. We offer high-quality products at competitive prices.',
        category: 'Electronics',
        address: '123 Tech Street, Silicon Valley, CA 94000',
        phoneNumber: '+1-555-TECH-HUB',
        website: 'https://techhub.example.com',
        status: StoreStatus.active,
        rating: 4.8,
        totalReviews: 156,
      );

      await _databaseService.insertStore(store);

      // Create sample products
      final products = [
        Product(
          storeId: store.id,
          name: 'Wireless Bluetooth Headphones',
          description:
              'Premium quality wireless headphones with noise cancellation and 30-hour battery life. Perfect for music lovers and professionals.',
          imageUrls: [
            'https://via.placeholder.com/400x400/3B82F6/FFFFFF?text=Headphones',
          ],
          price: 89.99,
          originalPrice: 129.99,
          category: 'Electronics',
          tags: ['wireless', 'bluetooth', 'headphones', 'audio'],
          stockQuantity: 25,
          status: ProductStatus.active,
          rating: 4.5,
          totalReviews: 42,
          totalSales: 18,
        ),
        Product(
          storeId: store.id,
          name: 'Smart Fitness Watch',
          description:
              'Advanced fitness tracker with heart rate monitoring, GPS, and 7-day battery life. Track your health and fitness goals.',
          imageUrls: [
            'https://via.placeholder.com/400x400/60A5FA/FFFFFF?text=Watch',
          ],
          price: 199.99,
          category: 'Electronics',
          tags: ['smartwatch', 'fitness', 'health', 'gps'],
          stockQuantity: 15,
          status: ProductStatus.active,
          rating: 4.8,
          totalReviews: 67,
          totalSales: 23,
        ),
        Product(
          storeId: store.id,
          name: 'USB-C Fast Charger',
          description:
              'High-speed 65W USB-C charger compatible with laptops, tablets, and smartphones. Compact design for travel.',
          imageUrls: [
            'https://via.placeholder.com/400x400/1E3A8A/FFFFFF?text=Charger',
          ],
          price: 29.99,
          originalPrice: 39.99,
          category: 'Electronics',
          tags: ['charger', 'usb-c', 'fast-charging', 'portable'],
          stockQuantity: 50,
          status: ProductStatus.active,
          rating: 4.3,
          totalReviews: 89,
          totalSales: 45,
        ),
        Product(
          storeId: store.id,
          name: 'Mechanical Gaming Keyboard',
          description:
              'RGB backlit mechanical keyboard with blue switches. Perfect for gaming and typing with customizable lighting effects.',
          imageUrls: [
            'https://via.placeholder.com/400x400/8B5CF6/FFFFFF?text=Keyboard',
          ],
          price: 149.99,
          category: 'Electronics',
          tags: ['keyboard', 'gaming', 'mechanical', 'rgb'],
          stockQuantity: 12,
          status: ProductStatus.active,
          rating: 4.7,
          totalReviews: 34,
          totalSales: 8,
        ),
        Product(
          storeId: store.id,
          name: '4K Webcam',
          description:
              'Ultra HD 4K webcam with auto-focus and built-in microphone. Ideal for video conferencing and content creation.',
          imageUrls: [
            'https://via.placeholder.com/400x400/10B981/FFFFFF?text=Webcam',
          ],
          price: 79.99,
          category: 'Electronics',
          tags: ['webcam', '4k', 'video', 'streaming'],
          stockQuantity: 8,
          status: ProductStatus.active,
          rating: 4.4,
          totalReviews: 28,
          totalSales: 12,
        ),
      ];

      for (final product in products) {
        await _databaseService.insertProduct(product);
      }

      // Create sample buyer
      await _authService.signUp(
        email: 'buyer@example.com',
        firstName: 'Jane',
        lastName: 'Buyer',
        role: UserRole.buyer,
        phoneNumber: '+1987654321',
      );

      print('Sample data generated successfully!');
    } catch (e) {
      print('Error generating sample data: $e');
    }
  }
}
