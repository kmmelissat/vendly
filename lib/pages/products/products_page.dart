import 'package:flutter/material.dart';
import 'components/products_header.dart';
import 'components/product_cards_view.dart';
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
      'id': 'labubu3',
      'name': 'Labubu Golden Edition',
      'price': 45.00,
      'originalPrice': 55.00,
      'image': 'assets/images/products/labubu3.jpg',
      'category': 'Labubu',
      'brand': 'POP MART',
      'sku': 'LAB-003-GLD',
      'description':
          'Edición dorada ultra limitada de Labubu, pieza de coleccionista premium.',
      'detailedDescription':
          'La edición más exclusiva de Labubu con acabados dorados y detalles únicos. Solo 500 unidades producidas mundialmente.',
      'inStock': true,
      'stockQuantity': 15,
      'rating': 5.0,
      'reviews': 23,
      'dimensions': '8.5cm x 6.2cm x 5.2cm',
      'weight': '150g',
      'material': 'PVC premium con baño dorado',
      'ageRange': '14+ años',
      'origin': 'China',
      'tags': [
        'ultra limitada',
        'dorada',
        'premium',
        'coleccionista',
        'exclusiva',
      ],
      'features': [
        'Edición ultra limitada',
        'Baño dorado real',
        'Numerada individualmente',
        'Caja de lujo',
        'Certificado premium',
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
      'id': 'cinamonroll1',
      'name': 'Cinnamoroll Plush Deluxe',
      'price': 22.00,
      'originalPrice': 28.00,
      'image': 'assets/images/products/cinamonroll1.jpg',
      'category': 'Plush',
      'brand': 'Sanrio',
      'sku': 'CN-001-PLU',
      'description':
          'Peluche oficial de Cinnamoroll, suave y adorable para abrazar.',
      'detailedDescription':
          'Peluche premium de Cinnamoroll con materiales ultra suaves y detalles bordados. Perfecto para coleccionistas y fans de Sanrio.',
      'inStock': true,
      'stockQuantity': 95,
      'rating': 4.8,
      'reviews': 142,
      'dimensions': '25cm x 20cm x 15cm',
      'weight': '300g',
      'material': 'Felpa ultra suave',
      'ageRange': '3+ años',
      'origin': 'Japón',
      'tags': ['sanrio', 'cinnamoroll', 'peluche', 'suave', 'kawaii'],
      'features': [
        'Material ultra suave',
        'Detalles bordados',
        'Licencia oficial Sanrio',
        'Lavable a máquina',
        'Hipoalergénico',
      ],
    },
    {
      'id': 'gummybearplush1',
      'name': 'Gummy Bear Plush Giant',
      'price': 28.00,
      'originalPrice': 35.00,
      'image': 'assets/images/products/gummybearplush1.jpg',
      'category': 'Plush',
      'brand': 'Sweet Dreams',
      'sku': 'GB-001-GNT',
      'description':
          'Peluche gigante de osito gomoso, perfecto para abrazar y decorar.',
      'detailedDescription':
          'Peluche extra grande inspirado en los ositos gomosos. Con colores vibrantes y textura súper suave que simula la apariencia translúcida de las gomitas.',
      'inStock': true,
      'stockQuantity': 42,
      'rating': 4.6,
      'reviews': 78,
      'dimensions': '40cm x 30cm x 25cm',
      'weight': '800g',
      'material': 'Felpa translúcida especial',
      'ageRange': '3+ años',
      'origin': 'Corea del Sur',
      'tags': ['gummy', 'gigante', 'colorido', 'translúcido', 'abrazo'],
      'features': [
        'Tamaño gigante',
        'Textura translúcida',
        'Colores vibrantes',
        'Extra suave',
        'Resistente al lavado',
      ],
    },
    {
      'id': 'mokoko1',
      'name': 'Mokoko Seed Collectible',
      'price': 12.00,
      'originalPrice': 16.00,
      'image': 'assets/images/products/mokoko.jpg',
      'category': 'Others',
      'brand': 'Lost Ark',
      'sku': 'MK-001-SED',
      'description':
          'Figura coleccionable de Mokoko Seed del popular juego Lost Ark.',
      'detailedDescription':
          'Réplica oficial de las famosas Mokoko Seeds del juego Lost Ark. Perfecta para gamers y coleccionistas de memorabilia gaming.',
      'inStock': true,
      'stockQuantity': 67,
      'rating': 4.4,
      'reviews': 89,
      'dimensions': '5cm x 5cm x 8cm',
      'weight': '90g',
      'material': 'Resina de alta calidad',
      'ageRange': '12+ años',
      'origin': 'Corea del Sur',
      'tags': ['gaming', 'lost ark', 'mokoko', 'coleccionable', 'oficial'],
      'features': [
        'Licencia oficial',
        'Detalles precisos',
        'Base incluida',
        'Edición limitada',
        'Para gamers',
      ],
    },
    {
      'id': 'plush1',
      'name': 'Kawaii Unicorn Plush',
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
      'name': 'Ternuritos Classic Pink',
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
      'stockQuantity': 85,
      'rating': 4.7,
      'reviews': 167,
      'dimensions': '7.5cm x 6cm x 5cm',
      'weight': '95g',
      'material': 'PVC con acabado mate',
      'ageRange': '8+ años',
      'origin': 'México',
      'tags': ['ternuritos', 'kawaii', 'latino', 'coleccionable', 'rosa'],
      'features': [
        'Diseño original latino',
        'Acabado mate premium',
        'Colección completa',
        'Personaje icónico',
        'Edición clásica',
      ],
    },
    {
      'id': 'ternuritos2',
      'name': 'Ternuritos Blue Edition',
      'price': 22.00,
      'originalPrice': 27.00,
      'image': 'assets/images/products/ternuritos2.jpg',
      'category': 'Ternuritos',
      'brand': 'Ternuritos Official',
      'sku': 'TER-002-BLU',
      'description':
          'Ternurito en edición especial azul, con detalles únicos y acabados premium.',
      'detailedDescription':
          'Esta edición especial presenta colores azules vibrantes con acabados metalizados que lo hacen único en la colección.',
      'inStock': true,
      'stockQuantity': 62,
      'rating': 4.8,
      'reviews': 134,
      'dimensions': '7.5cm x 6cm x 5cm',
      'weight': '98g',
      'material': 'PVC con detalles metalizados',
      'ageRange': '8+ años',
      'origin': 'México',
      'tags': [
        'ternuritos',
        'edición especial',
        'azul',
        'metalizado',
        'premium',
      ],
      'features': [
        'Edición especial',
        'Detalles metalizados',
        'Colores vibrantes',
        'Numerado',
        'Caja especial',
      ],
    },
    {
      'id': 'ternuritos3',
      'name': 'Ternuritos Rainbow Edition',
      'price': 25.00,
      'originalPrice': 32.00,
      'image': 'assets/images/products/ternuritos3.jpg',
      'category': 'Ternuritos',
      'brand': 'Ternuritos Official',
      'sku': 'TER-003-RBW',
      'description':
          'Ternurito edición arcoíris, la más colorida y alegre de toda la colección.',
      'detailedDescription':
          'La edición arcoíris celebra la diversidad y alegría con una paleta de colores vibrantes que representa la inclusión y felicidad.',
      'inStock': true,
      'stockQuantity': 38,
      'rating': 4.9,
      'reviews': 98,
      'dimensions': '7.5cm x 6cm x 5cm',
      'weight': '100g',
      'material': 'PVC multicolor premium',
      'ageRange': '8+ años',
      'origin': 'México',
      'tags': ['ternuritos', 'arcoíris', 'diversidad', 'colorido', 'alegría'],
      'features': [
        'Edición arcoíris',
        'Colores vibrantes',
        'Mensaje de inclusión',
        'Acabado brillante',
        'Colección pride',
      ],
    },
    {
      'id': 'wildcutieplush1',
      'name': 'Wild Cutie Plush Forest',
      'price': 19.00,
      'originalPrice': 24.00,
      'image': 'assets/images/products/wildcutieplush.jpg',
      'category': 'Plush',
      'brand': 'Wild Cuties',
      'sku': 'WC-001-FOR',
      'description':
          'Adorable peluche de la serie Wild Cuties, inspirado en animales del bosque.',
      'detailedDescription':
          'Los Wild Cuties combinan la ternura de los peluches tradicionales con diseños inspirados en la vida salvaje, creando personajes únicos y adorables.',
      'inStock': true,
      'stockQuantity': 73,
      'rating': 4.5,
      'reviews': 156,
      'dimensions': '20cm x 15cm x 12cm',
      'weight': '250g',
      'material': 'Felpa ecológica',
      'ageRange': '3+ años',
      'origin': 'Estados Unidos',
      'tags': ['wild cuties', 'bosque', 'ecológico', 'naturaleza', 'aventura'],
      'features': [
        'Material ecológico',
        'Diseño de vida salvaje',
        'Textura suave',
        'Colores naturales',
        'Serie coleccionable',
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
            child: ProductCardsView(
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
