import 'package:flutter/material.dart';

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
          'Labubu Classic en color rosa, figura coleccionable oficial de POP MART. Perfecto para coleccionistas y amantes de los personajes kawaii. Incluye caja original y tarjeta de autenticidad.',
      'detailedDescription':
          'Esta adorable figura de Labubu en color rosa es parte de la colección clásica de POP MART. Fabricada con materiales de alta calidad, mide aproximadamente 8cm de altura. Ideal para decorar tu escritorio, estantería o como regalo especial para alguien que ama los coleccionables japoneses.',
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
          'Edición especial de Labubu en color azul, pieza limitada de colección con acabados premium y detalles únicos que la hacen perfecta para coleccionistas serios.',
      'detailedDescription':
          'Esta edición especial de Labubu presenta un hermoso color azul con acabados metalizados únicos. Producida en cantidades limitadas, incluye certificado de autenticidad numerado. Los detalles están cuidadosamente pintados a mano por artesanos especializados.',
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
      'name': 'Labubu Golden Limited Edition',
      'price': 55.00,
      'originalPrice': 65.00,
      'image': 'assets/images/products/labubu3.jpg',
      'category': 'Labubu',
      'brand': 'POP MART',
      'sku': 'LAB-003-GLD',
      'description':
          'La pieza más exclusiva de nuestra colección Labubu. Edición dorada ultra limitada con solo 500 unidades producidas mundialmente. Incluye base de exhibición y certificado numerado.',
      'detailedDescription':
          'Esta es la joya de la corona de cualquier colección Labubu. Con acabado dorado brillante y detalles en relieve, cada figura está numerada individualmente. Viene con una base de exhibición especial y un certificado de autenticidad firmado. Perfecta para inversión o como pieza central de tu colección.',
      'inStock': false,
      'stockQuantity': 0,
      'rating': 5.0,
      'reviews': 23,
      'dimensions': '9cm x 6.5cm x 5.5cm',
      'weight': '150g',
      'material': 'PVC premium con baño dorado',
      'ageRange': '18+ años (coleccionista)',
      'origin': 'China',
      'tags': [
        'ultra limitada',
        'dorada',
        'inversión',
        'exclusiva',
        'numerada',
      ],
      'features': [
        'Solo 500 unidades mundiales',
        'Baño dorado auténtico',
        'Base de exhibición incluida',
        'Certificado firmado',
        'Numeración individual',
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
          'Adorable Sonny Angel de la serie Animal, diseñado para traer alegría y buena suerte. Cada figura es una sorpresa hasta que abres la caja, haciendo cada compra una aventura emocionante.',
      'detailedDescription':
          'Los Sonny Angels son conocidos mundialmente por su capacidad de traer felicidad y buena suerte. Esta serie Animal presenta diferentes diseños de gorros con temática animal. Cada caja es una sorpresa, no sabes qué diseño obtendrás hasta abrirla. Perfecto para regalar o coleccionar.',
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
          'Suave peluche de unicornio con diseño kawaii, perfecto para abrazar y decorar. Fabricado con materiales hipoalergénicos y lavable en máquina para fácil cuidado.',
      'detailedDescription':
          'Este adorable peluche de unicornio combina suavidad extrema con un diseño kawaii irresistible. Relleno con fibra de poliéster de alta calidad que mantiene su forma después de muchos abrazos. Los ojos bordados garantizan seguridad para niños pequeños.',
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
      'id': 'cinamonroll1',
      'name': 'Cinnamoroll Original Sanrio',
      'price': 28.00,
      'originalPrice': 35.00,
      'image': 'assets/images/products/cinamonroll1.jpg',
      'category': 'Others',
      'brand': 'Sanrio',
      'sku': 'CIN-001-WHT',
      'description':
          'Figura oficial de Cinnamoroll de Sanrio, el adorable perrito blanco con orejas que parecen rollos de canela. Producto oficial con licencia Sanrio, perfecto para fans de Hello Kitty y personajes kawaii.',
      'detailedDescription':
          'Cinnamoroll es uno de los personajes más queridos de Sanrio. Esta figura oficial captura perfectamente su dulzura característica con detalles precisos y colores auténticos. Ideal para coleccionistas de Sanrio o como introducción al mundo de los personajes japoneses kawaii.',
      'inStock': true,
      'stockQuantity': 18,
      'rating': 4.8,
      'reviews': 134,
      'dimensions': '7cm x 8cm x 6cm',
      'weight': '110g',
      'material': 'PVC oficial Sanrio',
      'ageRange': '3+ años',
      'origin': 'Japón',
      'tags': ['sanrio', 'cinnamoroll', 'oficial', 'kawaii', 'perrito'],
      'features': [
        'Licencia oficial Sanrio',
        'Detalles auténticos',
        'Colores originales',
        'Fabricado en Japón',
        'Perfecto para coleccionar',
      ],
    },
    {
      'id': 'gummybearplush1',
      'name': 'Peluche Osito Gomita Gigante',
      'price': 22.00,
      'originalPrice': 28.00,
      'image': 'assets/images/products/gummybearplush1.jpg',
      'category': 'Plush',
      'brand': 'Sweet Dreams',
      'sku': 'PLU-002-GUM',
      'description':
          'Peluche gigante con forma de osito de goma, súper suave y perfecto para abrazar. Disponible en colores vibrantes que imitan las famosas gomitas. Ideal para decoración o como compañero de sueños.',
      'detailedDescription':
          'Este peluche único combina la nostalgia de los ositos de goma con la comodidad de un peluche gigante. Su textura especial imita la apariencia translúcida de las gomitas reales mientras mantiene la suavidad perfecta para abrazar. Perfecto para habitaciones con temática dulce.',
      'inStock': true,
      'stockQuantity': 48,
      'rating': 4.5,
      'reviews': 87,
      'dimensions': '35cm x 25cm x 20cm',
      'weight': '350g',
      'material': 'Felpa especial translúcida',
      'ageRange': '3+ años',
      'origin': 'China',
      'tags': ['osito', 'goma', 'gigante', 'dulce', 'translúcido'],
      'features': [
        'Tamaño gigante para abrazar',
        'Textura especial translúcida',
        'Colores vibrantes',
        'Súper suave',
        'Diseño único',
      ],
    },
    {
      'id': 'mokoko',
      'name': 'Mokoko Lost Ark Official',
      'price': 32.00,
      'originalPrice': 40.00,
      'image': 'assets/images/products/mokoko.jpg',
      'category': 'Others',
      'brand': 'Smilegate',
      'sku': 'MOK-001-GRN',
      'description':
          'Figura oficial de Mokoko del popular juego Lost Ark. Coleccionable premium para gamers y fans del MMORPG. Incluye base temática y viene en caja de coleccionista con arte exclusivo del juego.',
      'detailedDescription':
          'Para los verdaderos fans de Lost Ark, esta figura de Mokoko es imprescindible. Recreada fielmente del diseño del juego con todos los detalles característicos de esta adorable criatura. La base temática representa el mundo de Arkesia, haciendo de esta pieza un verdadero tesoro para cualquier gamer.',
      'inStock': true,
      'stockQuantity': 6,
      'rating': 4.9,
      'reviews': 45,
      'dimensions': '10cm x 8cm x 12cm (con base)',
      'weight': '280g',
      'material': 'PVC de alta calidad con base de resina',
      'ageRange': '14+ años',
      'origin': 'Corea del Sur',
      'tags': ['lost ark', 'mokoko', 'gaming', 'oficial', 'mmorpg'],
      'features': [
        'Producto oficial Lost Ark',
        'Base temática incluida',
        'Caja de coleccionista',
        'Arte exclusivo del juego',
        'Edición limitada para gamers',
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
          'El Ternurito clásico en su versión rosa original. Personaje icónico de la cultura kawaii latinoamericana, diseñado para transmitir ternura y alegría. Perfecto para iniciar tu colección Ternuritos.',
      'detailedDescription':
          'Los Ternuritos han conquistado corazones en toda Latinoamérica con su diseño único que combina elementos kawaii japoneses con sensibilidad latina. Este modelo clásico en rosa es donde todo comenzó, representando la pureza y dulzura que caracteriza a la marca.',
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
    {
      'id': 'ternuritos2',
      'name': 'Ternuritos Deluxe con Accesorios',
      'price': 28.00,
      'originalPrice': 35.00,
      'image': 'assets/images/products/ternuritos2.jpg',
      'category': 'Ternuritos',
      'brand': 'Ternuritos Official',
      'sku': 'TER-002-DLX',
      'description':
          'Versión deluxe del Ternurito con accesorios intercambiables y base de exhibición. Incluye múltiples expresiones faciales y elementos decorativos para personalizar tu figura.',
      'detailedDescription':
          'Esta versión deluxe lleva la experiencia Ternuritos al siguiente nivel. Incluye caritas intercambiables, pequeños accesorios temáticos y una base de exhibición especial. Perfecto para fans que quieren más opciones de personalización y exhibición.',
      'inStock': true,
      'stockQuantity': 14,
      'rating': 4.8,
      'reviews': 92,
      'dimensions': '8cm x 6.5cm x 5.5cm',
      'weight': '125g',
      'material': 'PVC premium con accesorios',
      'ageRange': '8+ años',
      'origin': 'México',
      'tags': [
        'deluxe',
        'accesorios',
        'intercambiable',
        'premium',
        'personalizable',
      ],
      'features': [
        'Accesorios intercambiables',
        'Múltiples expresiones',
        'Base de exhibición',
        'Versión deluxe',
        'Altamente personalizable',
      ],
    },
    {
      'id': 'ternuritos3',
      'name': 'Ternuritos Edición Especial Holográfica',
      'price': 45.00,
      'originalPrice': 55.00,
      'image': 'assets/images/products/ternuritos3.jpg',
      'category': 'Ternuritos',
      'brand': 'Ternuritos Official',
      'sku': 'TER-003-HOL',
      'description':
          'Edición especial holográfica del Ternurito, con efectos de luz únicos que cambian según el ángulo de visión. Pieza de colección limitada con certificado de autenticidad numerado.',
      'detailedDescription':
          'La pieza más espectacular de la línea Ternuritos. El acabado holográfico crea efectos de arcoíris que cambian con la luz, haciendo que cada ángulo revele nuevos colores. Producida en cantidades muy limitadas, es la joya de cualquier colección Ternuritos.',
      'inStock': false,
      'stockQuantity': 0,
      'rating': 4.9,
      'reviews': 38,
      'dimensions': '8.5cm x 6.8cm x 5.8cm',
      'weight': '140g',
      'material': 'PVC con acabado holográfico',
      'ageRange': '12+ años',
      'origin': 'México',
      'tags': ['holográfico', 'especial', 'limitada', 'arcoíris', 'exclusiva'],
      'features': [
        'Acabado holográfico único',
        'Efectos de arcoíris',
        'Edición muy limitada',
        'Certificado numerado',
        'Pieza de inversión',
      ],
    },
    {
      'id': 'wildcutieplush',
      'name': 'Wild Cutie Peluche Aventurero',
      'price': 19.00,
      'originalPrice': 24.00,
      'image': 'assets/images/products/wildcutieplush.jpg',
      'category': 'Plush',
      'brand': 'Wild Adventures',
      'sku': 'PLU-003-WLD',
      'description':
          'Peluche aventurero de la serie Wild Cutie, diseñado para pequeños exploradores. Con detalles de aventura como mochila bordada y sombrero removible. Perfecto compañero para juegos imaginativos.',
      'detailedDescription':
          'Este peluche único combina la ternura kawaii con el espíritu aventurero. Incluye accesorios bordados como mochila, brújula y sombrero removible. Diseñado para inspirar aventuras imaginarias y fomentar el juego creativo en los niños.',
      'inStock': true,
      'stockQuantity': 16,
      'rating': 4.6,
      'reviews': 78,
      'dimensions': '22cm x 18cm x 12cm',
      'weight': '180g',
      'material': 'Felpa suave con bordados',
      'ageRange': '3+ años',
      'origin': 'China',
      'tags': [
        'aventurero',
        'explorador',
        'accesorios',
        'imaginativo',
        'educativo',
      ],
      'features': [
        'Accesorios bordados',
        'Sombrero removible',
        'Fomenta imaginación',
        'Detalles de aventura',
        'Juego educativo',
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
          // Header with title and add button
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Listing',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showAddProductForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AFF9A),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Add New Product'),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0xFF5329C8).withOpacity(0.1),
                    checkmarkColor: const Color(0xFF5329C8),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF5329C8)
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF5329C8)
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Scrollable Table
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // Fixed Header
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: 800,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: Theme.of(context).colorScheme.surface,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  'Products',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Price',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Stock',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'Stock Level',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 170,
                                child: Text(
                                  'Manage',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Scrollable Content
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 800,
                            child: ListView.builder(
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return _buildHorizontalProductRow(
                                  context,
                                  product,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalProductRow(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    final stockLevel = product['stockQuantity'] ?? 0;
    final maxStock = 200;
    final stockPercentage = stockLevel / maxStock;

    Color stockLevelColor;
    if (stockPercentage > 0.7) {
      stockLevelColor = Colors.green;
    } else if (stockPercentage > 0.3) {
      stockLevelColor = Colors.orange;
    } else {
      stockLevelColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Products (200px width)
          SizedBox(
            width: 200,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product['brand'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Price (100px width)
          SizedBox(
            width: 100,
            child: Text(
              '\$${product['price'].toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // Stock (80px width)
          SizedBox(
            width: 80,
            child: Text(
              '${product['stockQuantity'] ?? 0}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Stock Level (150px width)
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: stockPercentage.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: stockLevelColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${stockLevel}/${maxStock}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Status (100px width)
          SizedBox(
            width: 100,
            child: Switch(
              value: product['inStock'] ?? false,
              onChanged: (value) {
                setState(() {
                  product['inStock'] = value;
                });
              },
              activeColor: Colors.green,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),

          // Manage (170px width)
          SizedBox(
            width: 170,
            child: OutlinedButton.icon(
              onPressed: () {
                _showProductDetails(context, product);
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Manage', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, Map<String, dynamic> product) {
    final stockLevel = product['stockQuantity'] ?? 0;
    final maxStock = 200; // You can adjust this based on your needs
    final stockPercentage = stockLevel / maxStock;

    Color stockLevelColor;
    if (stockPercentage > 0.7) {
      stockLevelColor = Colors.green;
    } else if (stockPercentage > 0.3) {
      stockLevelColor = Colors.orange;
    } else {
      stockLevelColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Products (Image + Name)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product['brand'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Price
          Expanded(
            flex: 2,
            child: Text(
              '\$${product['price'].toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // Stock
          Expanded(
            flex: 1,
            child: Text(
              '${product['stockQuantity'] ?? 0}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Stock Level (Progress bar)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: stockPercentage.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: stockLevelColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${stockLevel}/${maxStock}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Status (Toggle Switch)
          Expanded(
            flex: 1,
            child: Switch(
              value: product['inStock'] ?? false,
              onChanged: (value) {
                setState(() {
                  product['inStock'] = value;
                });
              },
              activeColor: Colors.green,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),

          // Manage (Button)
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () {
                _showProductDetails(context, product);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 16),
                  const SizedBox(width: 4),
                  Text('Manage', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to product details (to be implemented)
          _showProductDetails(context, product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        product['image'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.image_not_supported,
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            ),
                          );
                        },
                      ),

                      // Stock Status
                      if (!product['inStock'])
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Out of Stock',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product['name'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating and Reviews
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber[600]),
                        const SizedBox(width: 2),
                        Text(
                          '${product['rating']}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product['reviews']})',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Price
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5329C8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Product Image
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.image_not_supported,
                              color: Theme.of(context).colorScheme.primary,
                              size: 60,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product Name and Brand
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${product['brand']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price with discount
                  Row(
                    children: [
                      Text(
                        '\$${product['price'].toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5329C8),
                            ),
                      ),
                      const SizedBox(width: 8),
                      if (product['originalPrice'] != null &&
                          product['originalPrice'] > product['price'])
                        Text(
                          '\$${product['originalPrice'].toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                        ),
                      const Spacer(),
                      Text(
                        'SKU: ${product['sku']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rating and Reviews
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < product['rating'].floor()
                              ? Icons.star
                              : Icons.star_border,
                          size: 20,
                          color: Colors.amber[600],
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${product['rating']} (${product['reviews']} reviews)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stock Status and Quantity
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: product['inStock']
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product['inStock'] ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: product['inStock']
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (product['inStock'] &&
                          product['stockQuantity'] != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            '${product['stockQuantity']} disponibles',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['detailedDescription'] ?? product['description'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Specifications
                  Text(
                    'Especificaciones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSpecRow(context, 'Dimensiones', product['dimensions']),
                  _buildSpecRow(context, 'Peso', product['weight']),
                  _buildSpecRow(context, 'Material', product['material']),
                  _buildSpecRow(
                    context,
                    'Edad recomendada',
                    product['ageRange'],
                  ),
                  _buildSpecRow(context, 'Origen', product['origin']),
                  const SizedBox(height: 16),

                  // Features
                  if (product['features'] != null &&
                      (product['features'] as List).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Características',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...(product['features'] as List<String>)
                            .map(
                              (feature) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(
                                        color: Color(0xFF5329C8),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // Tags
                  if (product['tags'] != null &&
                      (product['tags'] as List).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Etiquetas',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: (product['tags'] as List<String>)
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF5329C8,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF5329C8,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFF5329C8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: product['inStock']
                          ? () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product['name']} added to cart!',
                                  ),
                                  backgroundColor: const Color(0xFF5329C8),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5329C8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        product['inStock'] ? 'Add to Cart' : 'Out of Stock',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddProductForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: AddProductForm(
            scrollController: scrollController,
            onProductAdded: (newProduct) {
              setState(() {
                products.add(newProduct);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${newProduct['name']} agregado exitosamente!'),
                  backgroundColor: const Color(0xFF5329C8),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

}

class AddProductForm extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Map<String, dynamic>) onProductAdded;

  const AddProductForm({
    super.key,
    required this.scrollController,
    required this.onProductAdded,
  });

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _detailedDescriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _weightController = TextEditingController();
  final _materialController = TextEditingController();
  final _ageRangeController = TextEditingController();
  final _originController = TextEditingController();
  final _featuresController = TextEditingController();
  final _tagsController = TextEditingController();

  String selectedCategory = 'Labubu';
  bool inStock = true;
  String? selectedImagePath;

  final List<String> categories = [
    'Labubu',
    'Plush',
    'Sonny Angel',
    'Ternuritos',
    'Others',
  ];

  final List<String> availableImages = [
    'assets/images/products/labubu1.jpg',
    'assets/images/products/labubu2.jpg',
    'assets/images/products/labubu3.jpg',
    'assets/images/products/sonnyangel1.jpg',
    'assets/images/products/plush1.jpg',
    'assets/images/products/cinamonroll1.jpg',
    'assets/images/products/gummybearplush1.jpg',
    'assets/images/products/mokoko.jpg',
    'assets/images/products/ternuritos1.jpg',
    'assets/images/products/ternuritos2.jpg',
    'assets/images/products/ternuritos3.jpg',
    'assets/images/products/wildcutieplush.jpg',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _descriptionController.dispose();
    _detailedDescriptionController.dispose();
    _stockController.dispose();
    _dimensionsController.dispose();
    _weightController.dispose();
    _materialController.dispose();
    _ageRangeController.dispose();
    _originController.dispose();
    _featuresController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                'Agregar Nuevo Producto',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Image Selection
              Text(
                'Imagen del Producto',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableImages.length,
                  itemBuilder: (context, index) {
                    final imagePath = availableImages[index];
                    final isSelected = selectedImagePath == imagePath;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImagePath = imagePath;
                        });
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF5329C8)
                                : Theme.of(context).dividerColor,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Basic Information
              Text(
                'Información Básica',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Producto *',
                  hintText: 'Ej: Labubu Classic Pink',
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del producto';
                  }
                  if (value.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        labelText: 'Marca *',
                        hintText: 'Ej: POP MART',
                        prefixIcon: const Icon(Icons.business_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa la marca';
                        }
                        if (value.length < 2) {
                          return 'Marca muy corta';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _skuController,
                      decoration: InputDecoration(
                        labelText: 'SKU *',
                        hintText: 'LAB-001-PNK',
                        prefixIcon: const Icon(Icons.qr_code_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el SKU';
                        }
                        if (value.length < 3) {
                          return 'SKU muy corto';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoría *',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        _getCategoryIcon(category),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pricing
              Text(
                'Precios',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Precio Actual *',
                        hintText: '25.00',
                        prefixIcon: const Icon(Icons.attach_money_outlined),
                        prefixText: '\$',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el precio';
                        }
                        final price = double.tryParse(value);
                        if (price == null) {
                          return 'Precio inválido';
                        }
                        if (price <= 0) {
                          return 'El precio debe ser mayor a 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _originalPriceController,
                      decoration: InputDecoration(
                        labelText: 'Precio Original',
                        hintText: '30.00',
                        prefixIcon: const Icon(Icons.local_offer_outlined),
                        prefixText: '\$',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final originalPrice = double.tryParse(value);
                          final currentPrice = double.tryParse(_priceController.text);
                          if (originalPrice == null) {
                            return 'Precio inválido';
                          }
                          if (currentPrice != null && originalPrice <= currentPrice) {
                            return 'Debe ser mayor al precio actual';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stock
              Text(
                'Inventario',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad en Stock',
                        hintText: '100',
                        prefixIcon: const Icon(Icons.inventory_outlined),
                        suffixText: 'unidades',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final stock = int.tryParse(value);
                          if (stock == null) {
                            return 'Cantidad inválida';
                          }
                          if (stock < 0) {
                            return 'No puede ser negativo';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SwitchListTile(
                      title: const Text('En Stock'),
                      value: inStock,
                      onChanged: (value) {
                        setState(() {
                          inStock = value;
                        });
                      },
                      activeColor: const Color(0xFF5329C8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Descriptions
              Text(
                'Descripciones',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción Corta *',
                  hintText: 'Descripción breve del producto para mostrar en listas',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                maxLines: 3,
                maxLength: 150,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa una descripción';
                  }
                  if (value.length < 10) {
                    return 'La descripción debe tener al menos 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _detailedDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción Detallada',
                  hintText: 'Descripción completa con características, beneficios y detalles técnicos',
                  prefixIcon: const Icon(Icons.article_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                maxLines: 4,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),

              // Specifications
              Text(
                'Especificaciones',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dimensionsController,
                      decoration: InputDecoration(
                        labelText: 'Dimensiones',
                        hintText: '8cm x 6cm x 5cm',
                        prefixIcon: const Icon(Icons.straighten_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Peso',
                        hintText: '120g',
                        prefixIcon: const Icon(Icons.scale_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _materialController,
                decoration: InputDecoration(
                  labelText: 'Material',
                  hintText: 'PVC de alta calidad',
                  prefixIcon: const Icon(Icons.texture_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageRangeController,
                      decoration: InputDecoration(
                        labelText: 'Edad Recomendada',
                        hintText: '14+ años',
                        prefixIcon: const Icon(Icons.child_care_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _originController,
                      decoration: InputDecoration(
                        labelText: 'Origen',
                        hintText: 'China',
                        prefixIcon: const Icon(Icons.public_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Features and Tags
              Text(
                'Características y Etiquetas',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _featuresController,
                decoration: InputDecoration(
                  labelText: 'Características',
                  hintText: 'Separar con comas: Figura oficial, Caja incluida, Material premium',
                  prefixIcon: const Icon(Icons.star_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                maxLines: 3,
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Etiquetas',
                  hintText: 'Separar con comas: coleccionable, kawaii, premium',
                  prefixIcon: const Icon(Icons.local_offer_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                maxLines: 2,
                maxLength: 100,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _saveProduct,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Producto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5329C8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (selectedImagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una imagen'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newProduct = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'originalPrice': _originalPriceController.text.isNotEmpty
            ? double.parse(_originalPriceController.text)
            : null,
        'image': selectedImagePath!,
        'category': selectedCategory,
        'brand': _brandController.text,
        'sku': _skuController.text,
        'description': _descriptionController.text,
        'detailedDescription': _detailedDescriptionController.text.isNotEmpty
            ? _detailedDescriptionController.text
            : _descriptionController.text,
        'inStock': inStock,
        'stockQuantity': _stockController.text.isNotEmpty
            ? int.parse(_stockController.text)
            : 0,
        'rating': 4.5,
        'reviews': 0,
        'dimensions': _dimensionsController.text,
        'weight': _weightController.text,
        'material': _materialController.text,
        'ageRange': _ageRangeController.text,
        'origin': _originController.text,
        'tags': _tagsController.text.isNotEmpty
            ? _tagsController.text.split(',').map((e) => e.trim()).toList()
            : <String>[],
        'features': _featuresController.text.isNotEmpty
            ? _featuresController.text.split(',').map((e) => e.trim()).toList()
            : <String>[],
      };

      widget.onProductAdded(newProduct    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case 'Labubu':
        return const Icon(Icons.toys, size: 16, color: Color(0xFF5329C8));
      case 'Plush':
        return const Icon(Icons.pets, size: 16, color: Color(0xFFFF6B6B));
      case 'Sonny Angel':
        return const Icon(Icons.child_friendly, size: 16, color: Color(0xFF4ECDC4));
      case 'Ternuritos':
        return const Icon(Icons.favorite, size: 16, color: Color(0xFFFFE66D));
      case 'Others':
        return const Icon(Icons.category, size: 16, color: Color(0xFF95A5A6));
      default:
        return const Icon(Icons.inventory_2, size: 16, color: Color(0xFF5329C8));
    }
  }
}
}
