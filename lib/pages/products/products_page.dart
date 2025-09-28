import 'package:flutter/material.dart';
import 'components/products_header.dart';
import 'components/product_table.dart';
import 'components/product_details_modal.dart';
import 'components/add_product_form.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Labubu',
    'Plush',
    'Sonny Angel',
    'Ternuritos',
    'Others',
  ];

  final List<Map<String, dynamic>> products = [
    {
      'id': 'labubu1',
      'name': 'Labubu Classic Pink',
      'price': 25.00,
      'originalPrice': 30.00,
      'image': 'assets/images/products/labubu1.jpg',
      'category': 'Labubu',
      'brand': 'POP MART',
      'sku': 'LAB-001-PNK',
      'description':
          'Labubu Classic en color rosa, figura coleccionable oficial de POP MART.',
      'detailedDescription':
          'Esta adorable figura de Labubu en color rosa es parte de la colección clásica de POP MART. Fabricada con materiales de alta calidad, mide aproximadamente 8cm de altura.',
      'inStock': true,
      'stockQuantity': 105,
      'rating': 4.9,
      'reviews': 89,
      'dimensions': '8cm x 6cm x 5cm',
      'weight': '120g',
      'material': 'PVC de alta calidad',
      'ageRange': '14+ años',
      'origin': 'China',
      'tags': ['coleccionable', 'kawaii', 'pop mart', 'labubu', 'rosa'],
      'features': [
        'Figura oficial de POP MART',
        'Caja original incluida',
        'Tarjeta de autenticidad',
        'Material PVC premium',
        'Detalles pintados a mano',
      ],
    },
    {
      'id': 'labubu2',
      'name': 'Labubu Special Edition Blue',
      'price': 35.00,
      'originalPrice': 42.00,
      'image': 'assets/images/products/labubu2.jpg',
      'category': 'Labubu',
      'brand': 'POP MART',
      'sku': 'LAB-002-BLU',
      'description':
          'Edición especial de Labubu en color azul, pieza limitada de colección.',
      'detailedDescription':
          'Esta edición especial de Labubu presenta un hermoso color azul con acabados metalizados únicos. Producida en cantidades limitadas.',
      'inStock': true,
      'stockQuantity': 80,
      'rating': 4.8,
      'reviews': 67,
      'dimensions': '8.5cm x 6.2cm x 5.2cm',
      'weight': '135g',
      'material': 'PVC premium con acabados metalizados',
      'ageRange': '14+ años',
      'origin': 'China',
      'tags': ['edición especial', 'limitada', 'azul', 'metalizado', 'premium'],
      'features': [
        'Edición limitada numerada',
        'Acabados metalizados',
        'Certificado de autenticidad',
        'Caja de coleccionista',
        'Pintado a mano',
      ],
    },
    {
      'id': 'sonnyangel1',
      'name': 'Sonny Angel Animal Series',
      'price': 18.00,
      'originalPrice': 22.00,
      'image': 'assets/images/products/sonnyangel1.jpg',
      'category': 'Sonny Angel',
      'brand': 'Dreams Inc.',
      'sku': 'SA-001-ANM',
      'description':
          'Adorable Sonny Angel de la serie Animal, diseñado para traer alegría y buena suerte.',
      'detailedDescription':
          'Los Sonny Angels son conocidos mundialmente por su capacidad de traer felicidad y buena suerte. Esta serie Animal presenta diferentes diseños de gorros con temática animal.',
      'inStock': true,
      'stockQuantity': 178,
      'rating': 4.7,
      'reviews': 156,
      'dimensions': '6cm x 4cm x 4cm',
      'weight': '80g',
      'material': 'PVC suave al tacto',
      'ageRange': '6+ años',
      'origin': 'Japón',
      'tags': ['sonny angel', 'suerte', 'sorpresa', 'animal', 'japonés'],
      'features': [
        'Diseño sorpresa',
        'Trae buena suerte',
        'Serie Animal completa',
        'Fabricado en Japón',
        'Coleccionable oficial',
      ],
    },
    {
      'id': 'plush1',
      'name': 'Peluche Kawaii Unicornio',
      'price': 15.00,
      'originalPrice': 20.00,
      'image': 'assets/images/products/plush1.jpg',
      'category': 'Plush',
      'brand': 'Kawaii Dreams',
      'sku': 'PLU-001-UNI',
      'description':
          'Suave peluche de unicornio con diseño kawaii, perfecto para abrazar y decorar.',
      'detailedDescription':
          'Este adorable peluche de unicornio combina suavidad extrema con un diseño kawaii irresistible. Relleno con fibra de poliéster de alta calidad.',
      'inStock': true,
      'stockQuantity': 200,
      'rating': 4.6,
      'reviews': 203,
      'dimensions': '25cm x 20cm x 15cm',
      'weight': '200g',
      'material': 'Felpa suave hipoalergénica',
      'ageRange': '0+ años',
      'origin': 'China',
      'tags': ['peluche', 'unicornio', 'kawaii', 'suave', 'lavable'],
      'features': [
        'Material hipoalergénico',
        'Lavable en máquina',
        'Ojos bordados seguros',
        'Relleno de calidad premium',
        'Diseño kawaii auténtico',
      ],
    },
    {
      'id': 'ternuritos1',
      'name': 'Ternuritos Clásico Rosa',
      'price': 20.00,
      'originalPrice': 25.00,
      'image': 'assets/images/products/ternuritos1.jpg',
      'category': 'Ternuritos',
      'brand': 'Ternuritos Official',
      'sku': 'TER-001-PNK',
      'description':
          'El Ternurito clásico en su versión rosa original. Personaje icónico de la cultura kawaii latinoamericana.',
      'detailedDescription':
          'Los Ternuritos han conquistado corazones en toda Latinoamérica con su diseño único que combina elementos kawaii japoneses con sensibilidad latina.',
      'inStock': true,
      'stockQuantity': 20,
      'rating': 4.7,
      'reviews': 167,
      'dimensions': '7.5cm x 6cm x 5cm',
      'weight': '95g',
      'material': 'PVC con acabado mate',
      'ageRange': '8+ años',
      'origin': 'México',
      'tags': ['ternuritos', 'clásico', 'rosa', 'kawaii', 'latino'],
      'features': [
        'Diseño original Ternuritos',
        'Acabado mate premium',
        'Fabricado en México',
        'Personaje icónico',
        'Perfecto para coleccionar',
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product['name'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesCategory =
          selectedCategory == 'All' || product['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProductsHeader(
            searchQuery: searchQuery,
            selectedCategory: selectedCategory,
            categories: categories,
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            onCategoryChanged: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
            onAddProduct: () => _showAddProductForm(context),
          ),
          Expanded(
            child: ProductTable(
              products: filteredProducts,
              onProductTap: (product) => _showProductDetails(context, product),
              onStockToggle: (product, inStock) {
                setState(() {
                  product['inStock'] = inStock;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    ProductDetailsModal.show(context, product);
  }

  void _showAddProductForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: AddProductForm(
                scrollController: controller,
                onProductAdded: (newProduct) {
                  setState(() {
                    products.add(newProduct);
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
