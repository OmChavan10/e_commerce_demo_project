import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    required this.products,
    required this.onOrderPlaced,
    super.key,
  });

  final List<Map<String, dynamic>> products;
  final VoidCallback onOrderPlaced;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'UPI';
  bool _orderPlaced = false;
  late final String _orderNumber;
  late final double _total;

  @override
  void initState() {
    super.initState();
    _orderNumber = 'EC${DateTime.now().millisecondsSinceEpoch % 1000000}';
    _total = widget.products.fold<double>(
      0,
      (sum, product) => sum + _priceValue(product['price'] as String),
    );
  }

  double _priceValue(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  void _placeOrder() {
    widget.onOrderPlaced();
    setState(() {
      _orderPlaced = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text(_orderPlaced ? 'Order placed' : 'Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepOrange,
      ),
      body: _orderPlaced ? _buildOrderConfirmation() : _buildCheckoutForm(),
    );
  }

  Widget _buildCheckoutForm() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionTitle(
                'Delivery address',
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              _buildPanel(
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.home_outlined, color: Colors.deepOrange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Om Chavan  ·  Home',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text('Flat 12, Green Park Apartments'),
                          Text('Pune, Maharashtra 411001'),
                          SizedBox(height: 4),
                          Text('+91 98765 43210'),
                        ],
                      ),
                    ),
                    Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Payment method', Icons.payment_outlined),
              const SizedBox(height: 12),
              _buildPaymentMethod(
                'UPI',
                Icons.qr_code_2,
                'Pay using any UPI app',
              ),
              const SizedBox(height: 10),
              _buildPaymentMethod(
                'Card',
                Icons.credit_card_outlined,
                'Credit or debit card',
              ),
              const SizedBox(height: 10),
              _buildPaymentMethod(
                'Cash on delivery',
                Icons.payments_outlined,
                'Pay when your order arrives',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Order summary', Icons.receipt_long_outlined),
              const SizedBox(height: 12),
              _buildPanel(
                child: Column(
                  children: [
                    for (final product in widget.products)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(child: Text(product['name'] as String)),
                            Text(product['price'] as String),
                          ],
                        ),
                      ),
                    const Divider(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '₹${_total.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Demo checkout: no real payment will be processed.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            color: Colors.white,
            child: ElevatedButton.icon(
              onPressed: widget.products.isEmpty ? null : _placeOrder,
              icon: const Icon(Icons.lock_outline),
              label: Text('Pay ₹${_total.toStringAsFixed(0)} and place order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String value, IconData icon, String description) {
    final selected = _paymentMethod == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _paymentMethod = value),
      child: _buildPanel(
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(description, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Colors.deepOrange : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderConfirmation() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 88),
            const SizedBox(height: 18),
            const Text(
              'Payment successful',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been placed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            _buildPanel(
              child: Column(
                children: [
                  _confirmationRow('Order number', _orderNumber),
                  const SizedBox(height: 12),
                  _confirmationRow('Items', '${widget.products.length}'),
                  const SizedBox(height: 12),
                  _confirmationRow('Payment method', _paymentMethod),
                  const Divider(height: 24),
                  _confirmationRow(
                    'Total paid',
                    '₹${_total.toStringAsFixed(0)}',
                    bold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Continue shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPanel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _confirmationRow(String title, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
