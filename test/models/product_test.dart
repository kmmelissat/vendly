import 'package:flutter_test/flutter_test.dart';
import 'package:vendly/models/product.dart';

void main() {
  group('Product.fromJson', () {
    test('should parse product with image objects correctly', () {
      final json = {
        "name": "1989 (Taylor's Version) Tote Bag",
        "short_description": "Bolso tote con diseño 1989 TV.",
        "long_description": "Bolso de lona color azul pastel con arte de 1989 (Taylor's Version) impreso.",
        "price": 19.99,
        "production_cost": 0.0,
        "discount_price": null,
        "discount_end_date": null,
        "stock": 48,
        "is_active": true,
        "id": 24,
        "store_id": 7,
        "category_id": 1,
        "created_at": "2025-11-08T18:42:28.951309",
        "updated_at": "2025-11-09T22:36:04.658090",
        "tags": [],
        "images": [
          {
            "image_url": "https://vendly-uploads.s3.us-east-1.amazonaws.com/product-images/product-24/20251109_172020_59391815.jpg",
            "id": 9,
            "product_id": 24,
            "created_at": "2025-11-09T17:20:23.332847",
            "updated_at": "2025-11-09T17:20:23.332852"
          },
          {
            "image_url": "https://vendly-uploads.s3.us-east-1.amazonaws.com/product-images/product-24/20251110_023404_f726d59b.webp",
            "id": 10,
            "product_id": 24,
            "created_at": "2025-11-10T02:34:04.886046",
            "updated_at": "2025-11-10T02:34:04.886050"
          }
        ],
        "has_active_offer": false,
        "effective_price": 19.99,
        "discount_percentage": null
      };

      final product = Product.fromJson(json);

      expect(product.id, 24);
      expect(product.name, "1989 (Taylor's Version) Tote Bag");
      expect(product.images.length, 2);
      expect(product.images.first, "https://vendly-uploads.s3.us-east-1.amazonaws.com/product-images/product-24/20251109_172020_59391815.jpg");
      expect(product.image, "https://vendly-uploads.s3.us-east-1.amazonaws.com/product-images/product-24/20251109_172020_59391815.jpg");
    });

    test('should handle empty images array', () {
      final json = {
        "name": "Test Product",
        "short_description": "Test",
        "long_description": "Test long",
        "price": 10.0,
        "production_cost": 0.0,
        "discount_price": null,
        "discount_end_date": null,
        "stock": 10,
        "is_active": true,
        "id": 1,
        "store_id": 1,
        "category_id": 1,
        "created_at": "2025-11-08T18:42:28.951309",
        "updated_at": "2025-11-09T22:36:04.658090",
        "tags": [],
        "images": [],
        "has_active_offer": false,
        "effective_price": 10.0,
        "discount_percentage": null
      };

      final product = Product.fromJson(json);

      expect(product.images.length, 0);
      expect(product.image, null);
    });

    test('toLegacyFormat should include image', () {
      final json = {
        "name": "Test Product",
        "short_description": "Test",
        "long_description": "Test long",
        "price": 10.0,
        "production_cost": 0.0,
        "discount_price": null,
        "discount_end_date": null,
        "stock": 10,
        "is_active": true,
        "id": 1,
        "store_id": 1,
        "category_id": 1,
        "created_at": "2025-11-08T18:42:28.951309",
        "updated_at": "2025-11-09T22:36:04.658090",
        "tags": [],
        "images": [
          {
            "image_url": "https://example.com/image.jpg",
            "id": 1,
            "product_id": 1,
            "created_at": "2025-11-09T17:20:23.332847",
            "updated_at": "2025-11-09T17:20:23.332852"
          }
        ],
        "has_active_offer": false,
        "effective_price": 10.0,
        "discount_percentage": null
      };

      final product = Product.fromJson(json);
      final legacy = product.toLegacyFormat();

      expect(legacy['image'], "https://example.com/image.jpg");
    });
  });
}

