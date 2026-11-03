import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() => runApp(const KanavilApp());

class Product {
  final String name;
  final String category;
  final String unit;
  final String emoji;
  const Product(this.name, this.category, this.unit, this.emoji);
}

// Catalogue suggestions requested by the shop owner. Availability and prices
// must be confirmed with Cochin Trading Co., Pattimattom before launch.
const products = <Product>[
  // Vegetables
  Product('Potato', 'Vegetables', '1 kg', '🥔'),
  Product('Onion', 'Vegetables', '1 kg', '🧅'),
  Product('Tomato', 'Vegetables', '1 kg', '🍅'),
  Product('Green chilli', 'Vegetables', '250 g', '🌶️'),
  Product('Carrot', 'Vegetables', '500 g', '🥕'),
  Product('Beetroot', 'Vegetables', '500 g', '🫜'),
  Product('Cabbage', 'Vegetables', '1 pc', '🥬'),
  Product('Cauliflower', 'Vegetables', '1 pc', '🥦'),
  Product('Cucumber', 'Vegetables', '500 g', '🥒'),
  Product('Ladies finger', 'Vegetables', '500 g', '🥬'),
  Product('Brinjal', 'Vegetables', '500 g', '🍆'),
  Product('Drumstick', 'Vegetables', '250 g', '🌿'),
  Product('Bottle gourd', 'Vegetables', '1 pc', '🥒'),
  Product('Bitter gourd', 'Vegetables', '500 g', '🥒'),
  Product('Snake gourd', 'Vegetables', '500 g', '🥒'),
  Product('Ridge gourd', 'Vegetables', '500 g', '🥒'),
  Product('Pumpkin', 'Vegetables', '500 g', '🎃'),
  Product('Ash gourd', 'Vegetables', '1 kg', '🥬'),
  Product('Raw banana', 'Vegetables', '500 g', '🍌'),
  Product('Green peas', 'Vegetables', '250 g', '🫛'),
  Product('Beans', 'Vegetables', '500 g', '🫘'),
  Product('Cluster beans', 'Vegetables', '250 g', '🫘'),
  Product('Yam', 'Vegetables', '500 g', '🥔'),
  Product('Tapioca', 'Vegetables', '1 kg', '🥔'),
  Product('Sweet potato', 'Vegetables', '500 g', '🍠'),
  Product('Spinach', 'Vegetables', '1 bunch', '🥬'),
  Product('Coriander leaves', 'Vegetables', '1 bunch', '🌿'),
  Product('Curry leaves', 'Vegetables', '1 bunch', '🌿'),
  Product('Mint leaves', 'Vegetables', '1 bunch', '🌿'),
  Product('Spring onion', 'Vegetables', '1 bunch', '🧅'),
  Product('Capsicum', 'Vegetables', '500 g', '🫑'),
  Product('Mushroom', 'Vegetables', '200 g', '🍄'),
  // Fruits requested by the shop owner
  Product('Apple', 'Fruits', '1 kg', '🍎'),
  Product('Orange', 'Fruits', '1 kg', '🍊'),
  Product('Kiran', 'Fruits', '1 kg', '🍈'), // Confirm exact fruit name with the shop.
  Product('Grapes', 'Fruits', '500 g', '🍇'),
  Product('Pineapple', 'Fruits', '1 pc', '🍍'),
  Product('Pomegranate (Mathala naranga)', 'Fruits', '1 kg', '❤️'),
  Product('Guava (Perakka)', 'Fruits', '1 kg', '🍐'),
  Product('Mango (Manga pazham)', 'Fruits', '1 kg', '🥭'),
  // Starter grocery examples; verify supplier stock before launch.
  Product('Rice', 'Staples', '1 kg', '🍚'),
  Product('Wheat flour', 'Staples', '1 kg', '🌾'),
  Product('Sugar', 'Staples', '1 kg', '🍬'),
  Product('Cooking oil', 'Oil & masala', '1 L', '🫗'),
  Product('Chilli powder', 'Oil & masala', '100 g', '🌶️'),
  Product('Bath soap', 'Home care', '1 pc', '🧼'),
  Product('Detergent', 'Home care', '1 kg', '🧺'),
];

const deliveryAreas = [
  'Pallikkara', 'Pattimattom', 'Pazhamthottam', 'Morakkala',
  'Sunithapadi', 'Parakkode', 'Vembilly', 'Pancode',
  'Pulinchuvadu', 'Kadayiruppu', 'Kizhakkambalam',
  'Entire Ikkaranad', 'Entire Kunnathunad',
];

class KanavilApp extends StatelessWidget {
  const KanavilApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'KANAVIL STORES',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16834A)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7FAF7),
    ),
    home: const StoreHome(),
  );
}

class StoreHome extends StatefulWidget {
  const StoreHome({super.key});
  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  final Map<Product, int> cart = {};
  String category = 'All';
  String search = '';
  bool malayalam = false;
  String paymentMethod = 'PhonePe QR';

  String tr(String en, String ml) => malayalam ? ml : en;
  List<Product> get visible => products.where((p) =>
    (category == 'All' || p.category == category) &&
    p.name.toLowerCase().contains(search.toLowerCase())).toList();
  int get count => cart.values.fold(0, (a, b) => a + b);

  Future<void> orderWhatsApp({String method = 'PhonePe QR'}) async {
    if (cart.isEmpty) return;
    final lines = cart.entries.map((e) => '${e.key.name} x ${e.value}').join('\n');
    final msg = 'Hello KANAVIL STORES, I would like to order:\n$lines\n'
      'Payment method: $method\n'
      'UPI ID: Q667834682@ybl\n'
      'Please confirm availability, total price and delivery details.';
    final uri = Uri.parse('https://wa.me/917736372947?text=${Uri.encodeComponent(msg)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...products.map((p) => p.category).toSet()];
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('KANAVIL STORES', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Freshness for Healthy Life', style: TextStyle(fontSize: 11)),
        ]),
        actions: [
          TextButton(
            onPressed: () => setState(() => malayalam = !malayalam),
            child: Text(malayalam ? 'EN' : 'മലയാളം'),
          ),
          IconButton(
            tooltip: 'Cart',
            onPressed: showCart,
            icon: Badge(label: Text('$count'), child: const Icon(Icons.shopping_cart_outlined)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE4F4E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(children: [
              const Text('🛒', style: TextStyle(fontSize: 42)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr('Fresh groceries at your doorstep', 'പുതിയ പലചരക്ക് സാധനങ്ങൾ വീട്ടിലെത്തിക്കുന്നു'),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(tr('Vegetables, fruits and daily essentials', 'പച്ചക്കറികൾ, പഴങ്ങൾ, നിത്യോപയോഗ സാധനങ്ങൾ')),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
          TextField(
            decoration: InputDecoration(
              hintText: tr('Search grocery items', 'സാധനങ്ങൾ തിരയുക'),
              prefixIcon: const Icon(Icons.search),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => search = v),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 42, child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories.map((c) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text(c), selected: category == c,
                onSelected: (_) => setState(() => category = c)),
            )).toList(),
          )),
          const SizedBox(height: 8),
          Text(tr('Products', 'ഉൽപ്പന്നങ്ങൾ'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...visible.map((p) => Card(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFFEAF5EC),
                child: Text(p.emoji, style: const TextStyle(fontSize: 23))),
              title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${p.unit} • ${tr('Price and stock to be confirmed', 'വിലയും സ്റ്റോക്കും സ്ഥിരീകരിക്കണം')}'),
              trailing: IconButton(
                onPressed: () => setState(() => cart[p] = (cart[p] ?? 0) + 1),
                icon: const Icon(Icons.add_circle, color: Color(0xFF16834A), size: 30),
              ),
            ),
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: showAreas,
            icon: const Icon(Icons.location_on_outlined),
            label: Text(tr('Check delivery areas', 'ഡെലിവറി സ്ഥലങ്ങൾ കാണുക')),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: count == 0 ? null : showCart,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('${tr('View cart', 'കാർട്ട് കാണുക')} ($count)'),
          ),
          const SizedBox(height: 18),
          Text(tr(
            'Catalogue items are suggestions. Cochin Trading Co. stock and prices must be verified before customer launch.',
            'ഈ പട്ടികയിലെ സാധനങ്ങളുടെ സ്റ്റോക്കും വിലയും Cochin Trading Co.-യിൽ സ്ഥിരീകരിച്ച ശേഷം മാത്രം ഉപഭോക്താക്കൾക്ക് ലഭ്യമാക്കുക.'),
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  void showCart() {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) =>
      StatefulBuilder(builder: (ctx, setSheet) => Padding(
        padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr('Your cart', 'നിങ്ങളുടെ കാർട്ട്'), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          if (cart.isEmpty) Padding(padding: const EdgeInsets.all(20), child: Text(tr('Your cart is empty.', 'കാർട്ട് കാലിയാണ്.'))),
          ...cart.entries.map((e) => ListTile(
            title: Text(e.key.name), subtitle: Text(e.key.unit),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(onPressed: () { setState(() { if (e.value <= 1) { cart.remove(e.key); } else { cart[e.key] = e.value - 1; } }); setSheet(() {}); },
                icon: const Icon(Icons.remove_circle_outline)),
              Text('${e.value}'),
              IconButton(onPressed: () { setState(() => cart[e.key] = e.value + 1); setSheet(() {}); },
                icon: const Icon(Icons.add_circle_outline)),
            ]),
          )),
          const SizedBox(height: 10),
          const SizedBox(height: 8),
          Text(tr('Choose payment method', 'പണമടയ്ക്കുന്ന രീതി തിരഞ്ഞെടുക്കുക'), style: const TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(contentPadding: EdgeInsets.zero, title: const Text('PhonePe / UPI QR'), value: 'PhonePe QR', groupValue: paymentMethod, onChanged: (v) => setState(() { paymentMethod = v!; setSheet(() {}); })),
          RadioListTile<String>(contentPadding: EdgeInsets.zero, title: Text(tr('Cash on Delivery', 'സാധനം ലഭിക്കുമ്പോൾ പണം നൽകുക')), value: 'Cash on Delivery', groupValue: paymentMethod, onChanged: (v) => setState(() { paymentMethod = v!; setSheet(() {}); })),
          if (paymentMethod == 'PhonePe QR') ...[
            Center(child: Image.asset('phonepe_qr.jpg', height: 190, fit: BoxFit.contain)),
            const Center(child: Text('UPI ID: Q667834682@ybl', style: TextStyle(fontWeight: FontWeight.bold))),
            Center(child: TextButton.icon(onPressed: () { Clipboard.setData(const ClipboardData(text: 'Q667834682@ybl')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UPI ID copied'))); }, icon: const Icon(Icons.copy), label: const Text('Copy UPI ID'))),
            const Text('Pay the confirmed amount and send the payment screenshot in WhatsApp. The store will verify payment manually.', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
          SizedBox(width: double.infinity, child: FilledButton.icon(
            onPressed: cart.isEmpty ? null : () async { final method = paymentMethod; Navigator.pop(ctx); await orderWhatsApp(method: method); },
            icon: const Icon(Icons.chat), label: Text(tr('Continue order in WhatsApp', 'WhatsApp വഴി ഓർഡർ തുടരുക')),
          )),
          Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(tr('Final availability and prices will be confirmed by the store.', 'സ്റ്റോർ സ്റ്റോക്കും വിലയും സ്ഥിരീകരിക്കും.'), style: const TextStyle(fontSize: 12))),
        ]),
      )),
    );
  }

  void showAreas() => showModalBottomSheet(context: context, builder: (ctx) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Text(tr('Delivery areas', 'ഡെലിവറി സ്ഥലങ്ങൾ'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Text(tr('Selected Ernakulam locations only', 'എറണാകുളത്തെ തിരഞ്ഞെടുത്ത സ്ഥലങ്ങളിൽ മാത്രം')),
      ...deliveryAreas.map((a) => ListTile(leading: const Icon(Icons.location_on_outlined), title: Text(a))),
    ],
  ));
}
