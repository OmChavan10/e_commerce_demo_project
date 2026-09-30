import 'dart:io';

import 'package:flutter/material.dart';
import 'package:e_commerce_demo_project/checkout_page.dart';
import 'package:e_commerce_demo_project/login_page.dart';
import 'package:e_commerce_demo_project/qr_scanner_screen.dart';
import 'package:e_commerce_demo_project/user_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.account});

  final Map<String, dynamic>? account;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;
  int bottomIndex = 0;
  late Map<String, dynamic> _account;
  final ImagePicker _imagePicker = ImagePicker();

  final PageController pageController = PageController();

  final List<String> categories = [
    "Fashion",
    "Mobiles",
    "Electronics",
    "Beauty",
    "Home",
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "Running Shoes",
      "category": "Fashion",
      "price": "₹1,999",
      "oldPrice": "₹3,999",
      "discount": "50% OFF",
      "image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
    },
    {
      "name": "Smart Watch",
      "category": "Mobiles",
      "price": "₹2,499",
      "oldPrice": "₹5,999",
      "discount": "58% OFF",
      "image": "https://images.unsplash.com/photo-1523275335684-37898b6baf30",
    },
    {
      "name": "Wireless Headphones",
      "category": "Electronics",
      "price": "₹1,799",
      "oldPrice": "₹3,499",
      "discount": "49% OFF",
      "image": "https://images.unsplash.com/photo-1505740420928-5e560c06d30e",
    },
    {
      "name": "Men's Jacket",
      "category": "Fashion",
      "price": "₹2,299",
      "oldPrice": "₹4,999",
      "discount": "54% OFF",
      "image": "https://images.unsplash.com/photo-1551028719-00167b16eac5",
    },
    {
      "name": "Smartphone",
      "category": "Mobiles",
      "price": "₹18,999",
      "oldPrice": "₹22,999",
      "discount": "17% OFF",
      "image": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9",
    },
    {
      "name": "Bluetooth Speaker",
      "category": "Electronics",
      "price": "₹1,299",
      "oldPrice": "₹2,499",
      "discount": "48% OFF",
      "image": "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1",
    },
    {
      "name": "Skincare Kit",
      "category": "Beauty",
      "price": "₹899",
      "oldPrice": "₹1,499",
      "discount": "40% OFF",
      "image": "https://images.unsplash.com/photo-1556228578-8c89e6adf883",
    },
    {
      "name": "Table Lamp",
      "category": "Home",
      "price": "₹799",
      "oldPrice": "₹1,599",
      "discount": "50% OFF",
      "image": "https://images.unsplash.com/photo-1507473885765-e6ed057f782c",
    },
  ];

  final List<Map<String, dynamic>> wishlistProducts = [];
  final List<Map<String, dynamic>> cartProducts = [];

  @override
  void initState() {
    super.initState();
    _account = Map<String, dynamic>.from(
      widget.account ??
          {
            'full_name': 'Guest User',
            'phone': '',
            'username': '',
            'photo_path': null,
          },
    );
    wishlistProducts.addAll([products[0], products[2]]);
  }

  Future<void> _pickAccountPhoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final extension = path.extension(image.path).isEmpty
        ? '.jpg'
        : path.extension(image.path);
    final userId = _account['id'];
    final imageName =
        'profile_${userId ?? 'local'}_'
        '${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedImage = await File(
      image.path,
    ).copy(path.join(documentsDirectory.path, imageName));

    final id = userId;
    if (id is int) {
      await UserDatabase.instance.updatePhotoPath(id, savedImage.path);
    }
    if (!mounted) return;
    setState(() => _account['photo_path'] = savedImage.path);
  }

  void selectCategory(int index) {
    setState(() {
      selectedCategory = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _toggleWishlist(Map<String, dynamic> product) {
    setState(() {
      if (wishlistProducts.contains(product)) {
        wishlistProducts.remove(product);
      } else {
        wishlistProducts.add(product);
      }
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    if (cartProducts.contains(product)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This product is already in your cart')),
      );
      return;
    }

    setState(() {
      cartProducts.add(product);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added to cart')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      extendBodyBehindAppBar: true,
      body: bottomIndex == 0
          ? Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 175,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 186, 82),
                          Color.fromARGB(255, 248, 165, 39),
                          Color.fromARGB(255, 248, 139, 6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      _buildHeader(),

                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: categories.length,
                          onPageChanged: (index) {
                            setState(() {
                              selectedCategory = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return _buildCategoryPage(categories[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _buildSecondaryPage(),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSecondaryPage() {
    switch (bottomIndex) {
      case 1:
        return _buildWishlistPage();
      case 2:
        return _buildAccountPage();
      case 3:
        return _buildCartPage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 186, 82),
            Color.fromARGB(255, 248, 165, 39),
            Color.fromARGB(255, 248, 139, 6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistPage() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildSectionHeader('Wishlist', Icons.favorite),
          Expanded(
            child: wishlistProducts.isEmpty
                ? _buildEmptyState(
                    Icons.favorite_border,
                    'Your wishlist is empty',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: .64,
                        ),
                    itemCount: wishlistProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(wishlistProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountPage() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildSectionHeader('Account', Icons.person),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _pickAccountPhoto,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.orange.shade100,
                                backgroundImage:
                                    _account['photo_path'] is String
                                    ? FileImage(File(_account['photo_path']))
                                    : null,
                                child: _account['photo_path'] is String
                                    ? null
                                    : Icon(
                                        Icons.person,
                                        size: 38,
                                        color: Colors.orange.shade700,
                                      ),
                              ),
                              const Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Colors.deepOrange,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _account['full_name'] ?? 'User',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('@${_account['username'] ?? ''}'),
                              Text(_account['phone'] ?? ''),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Previous orders',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderTile(
                    'Order #EC1024',
                    'Running Shoes and 1 more item',
                    'Delivered',
                    '₹3,998',
                  ),
                  _buildOrderTile(
                    'Order #EC0987',
                    'Wireless Headphones',
                    'Delivered',
                    '₹1,799',
                  ),
                  const SizedBox(height: 20),
                  _buildAccountAction(
                    Icons.location_on_outlined,
                    'Saved addresses',
                  ),
                  _buildAccountAction(
                    Icons.payment_outlined,
                    'Payment methods',
                  ),
                  _buildAccountAction(Icons.help_outline, 'Help and support'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Log out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                        side: const BorderSide(color: Colors.deepOrange),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildOrderTile(
    String orderNumber,
    String description,
    String status,
    String amount,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAccountAction(IconData icon, String label) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.orange.shade700),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _buildCartPage() {
    final total = cartProducts.fold<double>(
      0,
      (sum, product) => sum + _priceValue(product['price']),
    );

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildSectionHeader('Cart', Icons.shopping_cart),
          Expanded(
            child: cartProducts.isEmpty
                ? _buildEmptyState(
                    Icons.shopping_cart_outlined,
                    'Your cart is empty',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: cartProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product['image'],
                                width: 82,
                                height: 82,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product['price'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remove from cart',
                              onPressed: () {
                                setState(() {
                                  cartProducts.remove(product);
                                });
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (cartProducts.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total  ₹${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(
                            products: List<Map<String, dynamic>>.of(
                              cartProducts,
                            ),
                            onOrderPlaced: () {
                              setState(() {
                                cartProducts.clear();
                                bottomIndex = 0;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  double _priceValue(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 186, 82),
            Color.fromARGB(255, 248, 165, 39),
            Color.fromARGB(255, 248, 139, 6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search for products",
                      prefixIcon: Icon(Icons.search, size: 30),
                      suffixIcon: Icon(Icons.mic_none, size: 28),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                  );
                },
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final selected = selectedCategory == index;

                return GestureDetector(
                  onTap: () {
                    selectCategory(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Column(
                      children: [
                        Text(
                          categories[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),

                        const SizedBox(height: 7),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 3,
                          width: selected ? 55 : 0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CATEGORY PAGE
  // ----------------------------------------------------------

  Widget _buildCategoryPage(String category) {
    final categoryProducts = products
        .where((product) => product["category"] == category)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "${categoryProducts.length} Products",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        Expanded(
          child: categoryProducts.isEmpty
              ? const Center(
                  child: Text(
                    "No products available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: .64,
                  ),
                  itemCount: categoryProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(categoryProducts[index]);
                  },
                ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // PRODUCT CARD
  // ----------------------------------------------------------

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Image.network(
                  product["image"],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(0.5),
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: wishlistProducts.contains(product)
                          ? 'Remove from wishlist'
                          : 'Add to wishlist',
                      onPressed: () => _toggleWishlist(product),
                      icon: Icon(
                        wishlistProducts.contains(product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wishlistProducts.contains(product)
                            ? Colors.red
                            : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product["discount"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["name"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product["price"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            product["oldPrice"],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Add to cart',
                        onPressed: () => _addToCart(product),
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.orange,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // BOTTOM NAVIGATION
  // ----------------------------------------------------------

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: StylishBottomBar(
        option: BubbleBarOptions(
          barStyle: BubbleBarStyle.horizontal,
          bubbleFillStyle: BubbleFillStyle.fill,
          opacity: 0.2,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: bottomIndex,
        borderRadius: BorderRadius.circular(30),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            title: const Text('Home'),
            backgroundColor: Colors.deepOrange,
            selectedColor: Colors.deepOrange,
            unSelectedColor: Colors.deepOrange,
          ),
          BottomBarItem(
            icon: const Icon(Icons.favorite_border_rounded),
            selectedIcon: const Icon(Icons.favorite_rounded),
            title: const Text('Wishlist'),
            backgroundColor: Colors.deepOrange,
            selectedColor: Colors.deepOrange,
            unSelectedColor: Colors.deepOrange,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            title: const Text('Account'),
            backgroundColor: Colors.deepOrange,
            selectedColor: Colors.deepOrange,
            unSelectedColor: Colors.deepOrange,
          ),
          BottomBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            selectedIcon: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            backgroundColor: Colors.deepOrange,
            selectedColor: Colors.deepOrange,
            unSelectedColor: Colors.deepOrange,
          ),
        ],
        onTap: (index) {
          setState(() {
            bottomIndex = index;
          });
        },
      ),
    );
  }
}
