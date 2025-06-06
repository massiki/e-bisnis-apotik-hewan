import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initHive();
  runApp(const PuthiPetCareApp());
}

class PuthiPetCareApp extends StatelessWidget {
  const PuthiPetCareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PuthiPetCare',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const BerandaPage(),
    const ObatPage(),
    const KonsultasiPage(),
    const PerawatanPage(),
    const ChatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // BottomNavigationBar with 5 items
    return Scaffold(
      appBar: AppBar(
        title: const Text('PuthiPetCare'),
        centerTitle: true,
        elevation: 1,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex >= _pages.length ? 0 : _selectedIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index >= _pages.length) return;
          _onItemTapped(index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Obat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Konsultasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.healing),
            label: 'Perawatan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({Key? key}) : super(key: key);

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentPromoIndex = 0;

  final List<String> _promoMessages = [
    'Diskon 20% untuk semua obat hewan sampai akhir bulan!',
    'Konsultasi gratis dengan dokter hewan setiap hari Sabtu!',
    'Gratis antar obat untuk pembelian di atas 200 ribu!',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 4), _changePromoMessage);
  }

  void _changePromoMessage() {
    if (!mounted) return;
    setState(() {
      _currentPromoIndex = (_currentPromoIndex + 1) % _promoMessages.length;
    });

    Future.delayed(const Duration(seconds: 4), _changePromoMessage);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onServiceTap(String label) {
    // Navigate to respective page based on label
    switch (label) {
      case 'Obat Hewan':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const ObatPage()));
        break;
      case 'Konsultasi Dokter':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const KonsultasiPage()));
        break;
      case 'Perawatan Hewan':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const PerawatanPage()));
        break;
      default:
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Anda memilih layanan: $label'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green[600],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Animated animal logo replacing previous icon stack
          ScaleTransition(
            scale: _scaleAnimation,
            child: const AnimatedAnimalLogo(),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Layanan Kami',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              GestureDetector(
                onTap: () => _onServiceTap('Obat Hewan'),
                child: ServiceItem(
                  icon: Icons.poll,
                  label: 'Obat Hewan',
                  color: Colors.green[600]!,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _onServiceTap('Konsultasi Dokter'),
                child: ServiceItem(
                  icon: Icons.medical_services,
                  label: 'Konsultasi Dokter',
                  color: Colors.green[600]!,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _onServiceTap('Perawatan Hewan'),
                child: ServiceItem(
                  icon: Icons.pets,
                  label: 'Perawatan Hewan',
                  color: Colors.green[600]!,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Promo Terbaru',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: const Offset(0, 0),
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Container(
              key: ValueKey(_currentPromoIndex),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _promoMessages[_currentPromoIndex],
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedAnimalLogo extends StatefulWidget {
  const AnimatedAnimalLogo({Key? key}) : super(key: key);

  @override
  State<AnimatedAnimalLogo> createState() => _AnimatedAnimalLogoState();
}

class _AnimatedAnimalLogoState extends State<AnimatedAnimalLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _eyeBlinkAnimation;
  late Animation<double> _tailWagAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _eyeBlinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0, // eyes closed
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeInOut),
      ),
    );

    _tailWagAnimation = Tween<double>(
      begin: -0.15,
      end: 0.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _AnimalLogoPainter(
              eyeBlinkValue: _eyeBlinkAnimation.value,
              tailWagValue: _tailWagAnimation.value,
            ),
          );
        },
      ),
    );
  }
}

class _AnimalLogoPainter extends CustomPainter {
  final double eyeBlinkValue;
  final double tailWagValue;

  _AnimalLogoPainter({required this.eyeBlinkValue, required this.tailWagValue});

  @override
  void paint(Canvas canvas, Size size) {
    final facePaint = Paint()..color = Colors.green[400]!;

    // Draw face - oval shape
    final faceRect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.25,
      size.width * 0.6,
      size.height * 0.5,
    );
    canvas.drawOval(faceRect, facePaint);

    final earPaint = Paint()..color = Colors.green[700]!;

    // Draw ears (triangles) with slight tilt
    final leftEarPath = Path();
    leftEarPath.moveTo(size.width * 0.2, size.height * 0.3);
    leftEarPath.lineTo(size.width * 0.1, size.height * 0.05);
    leftEarPath.lineTo(size.width * 0.3, size.height * 0.15);
    leftEarPath.close();
    canvas.drawPath(leftEarPath, earPaint);

    final rightEarPath = Path();
    rightEarPath.moveTo(size.width * 0.8, size.height * 0.3);
    rightEarPath.lineTo(size.width * 0.9, size.height * 0.05);
    rightEarPath.lineTo(size.width * 0.7, size.height * 0.15);
    rightEarPath.close();
    canvas.drawPath(rightEarPath, earPaint);

    // Draw eyes - simulate blinking by changing eye height
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;

    final eyeWidth = size.width * 0.15;
    final eyeHeightMax = size.height * 0.1;
    final eyeHeight = eyeHeightMax * eyeBlinkValue.clamp(0.05, 1.0);

    final leftEyeRect = Rect.fromCenter(
      center: Offset(size.width * 0.38, size.height * 0.45),
      width: eyeWidth,
      height: eyeHeight,
    );
    final rightEyeRect = Rect.fromCenter(
      center: Offset(size.width * 0.62, size.height * 0.45),
      width: eyeWidth,
      height: eyeHeight,
    );

    canvas.drawOval(leftEyeRect, eyePaint);
    canvas.drawOval(rightEyeRect, eyePaint);

    // Pupils when eyes open
    if (eyeBlinkValue > 0.1) {
      final pupilRadius = eyeHeight * 0.3;
      canvas.drawCircle(leftEyeRect.center, pupilRadius, pupilPaint);
      canvas.drawCircle(rightEyeRect.center, pupilRadius, pupilPaint);
    }

    // Nose - small triangle
    final nosePaint = Paint()..color = Colors.black;
    final nosePath = Path();
    nosePath.moveTo(size.width * 0.5, size.height * 0.57);
    nosePath.lineTo(size.width * 0.47, size.height * 0.63);
    nosePath.lineTo(size.width * 0.53, size.height * 0.63);
    nosePath.close();
    canvas.drawPath(nosePath, nosePaint);

    // Mouth - subtle smile curve
    final mouthPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final mouthPath = Path();
    mouthPath.moveTo(size.width * 0.42, size.height * 0.68);
    mouthPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.74,
      size.width * 0.58,
      size.height * 0.68,
    );
    canvas.drawPath(mouthPath, mouthPaint);

    // Tail - wagging animation on left bottom side
    final tailPaint = Paint()..color = Colors.green[700]!;
    final tailCenter = Offset(size.width * 0.15, size.height * 0.65);

    // Draw tail as an arc swinging based on tailWagValue
    final tailRect = Rect.fromCircle(
      center: tailCenter,
      radius: size.width * 0.15,
    );
    final startAngle = 3.14 / 2 + tailWagValue;
    final sweepAngle = 3.14 / 3;
    canvas.drawArc(
      tailRect,
      startAngle,
      sweepAngle,
      false,
      tailPaint
        ..strokeWidth = 12
        ..style = PaintingStyle.stroke,
    );

    // Body shape - simple ellipse
    final bodyPaint = Paint()..color = Colors.green[300]!;
    final bodyRect = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.3,
    );
    canvas.drawOval(bodyRect, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant _AnimalLogoPainter oldDelegate) {
    return oldDelegate.eyeBlinkValue != eyeBlinkValue ||
        oldDelegate.tailWagValue != tailWagValue;
  }
}

class Doctor {
  final String name;
  final String specialty;

  const Doctor({required this.name, required this.specialty});
}

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({Key? key}) : super(key: key);

  static const List<Doctor> _doctors = [
    Doctor(name: 'Dr. Ani', specialty: 'Dokter Hewan Umum'),
    Doctor(name: 'Dr. Budi', specialty: 'Spesialis Penyakit Dalam Hewan'),
    Doctor(name: 'Dr. Sari', specialty: 'Dokter Hewan Bedah'),
    Doctor(name: 'Dr. Joko', specialty: 'Spesialis Nutrisi Hewan'),
    Doctor(name: 'Dr. Maya', specialty: 'Dokter Hewan Gigi'),
  ];

  @override
  State<KonsultasiPage> createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedAvatar(String doctorName) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CircleAvatar(
        backgroundColor: Colors.green[600],
        child: Text(
          doctorName[0],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konsultasi Hewan')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: KonsultasiPage._doctors.length,
        itemBuilder: (context, index) {
          final doctor = KonsultasiPage._doctors[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: _animatedAvatar(doctor.name),
              title: Text(
                doctor.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(doctor.specialty),
              trailing: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Konsultasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate to chat consultation page
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;

  const ServiceItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class Medicine {
  final String name;
  final String description;
  final double price;

  Medicine({
    required this.name,
    required this.description,
    required this.price,
  });
}

class ObatPage extends StatefulWidget {
  const ObatPage({Key? key}) : super(key: key);

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  final List<Medicine> _allMedicines = [
    Medicine(
      name: 'Paracetamol Hewan',
      description: 'Obat penurun panas untuk hewan',
      price: 50000,
    ),
    Medicine(
      name: 'Antibiotik Hewan',
      description: 'Obat untuk mengatasi infeksi bakteri',
      price: 75000,
    ),
    Medicine(
      name: 'Vitamin K',
      description: 'Meningkatkan kesehatan dan daya tahan hewan',
      price: 30000,
    ),
    Medicine(
      name: 'Obat Cacing',
      description: 'Mencegah dan mengobati cacing pada hewan',
      price: 60000,
    ),
    Medicine(
      name: 'Salep Luka',
      description: 'Untuk menyembuhkan luka luar pada hewan',
      price: 40000,
    ),
  ];

  List<Medicine> _displayedMedicines = [];
  final List<Medicine> _cart = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayedMedicines = List.from(_allMedicines);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedMedicines = _allMedicines.where((medicine) {
        final name = medicine.name.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  void _addToCart(Medicine medicine) {
    if (!_cart.contains(medicine)) {
      setState(() {
        _cart.add(medicine);
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Obat "${medicine.name}" ditambahkan ke keranjang'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Obat "${medicine.name}" sudah ada di keranjang'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeFromCart(Medicine medicine) {
    setState(() {
      _cart.remove(medicine);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Obat "${medicine.name}" dihapus dari keranjang'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBuyDialog(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Pembelian'),
          content: Text(
            'Apakah Anda yakin ingin membeli "${medicine.name}" seharga Rp ${medicine.price.toStringAsFixed(0)}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addToCart(medicine);
                Navigator.of(context).pop();
              },
              child: const Text('Masukkan Keranjang'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // tutup dialog
                final String whatsappUrl = Uri.encodeFull(
                  "https://wa.me/6285795082922?text=Saya ingin membeli ${medicine.name} seharga Rp ${medicine.price.toStringAsFixed(0)}",
                );
                if (await canLaunch(whatsappUrl)) {
                  await launch(whatsappUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak dapat membuka WhatsApp'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Beli'),
            ),
          ],
        );
      },
    );
  }

  void _goToCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartItems: _cart,
          onRemove: _removeFromCart,
          onCheckout: () {
            setState(() {
              _cart.clear();
            });
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pembelian berhasil! Terima kasih.'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _desc;
  String? _price;

  void _saveData(String name, String desc, double price) async {
    await DBHelper.insertData(
        DataModel(name: name, desc: desc, price: price.toString()));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Berhasil menambahkan obat')));
  }

  @override
  Widget build(BuildContext context) {
    // Marketplace with medicine items, search, buy button, buy cart dialog, and cart page
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obat Hewan'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _goToCart,
              ),
              if (DBHelper.getData().isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      DBHelper.getData().length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Obat',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _displayedMedicines.isEmpty
                  ? const Center(child: Text('Tidak ada obat ditemukan'))
                  : ListView.builder(
                      itemCount: _displayedMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = _displayedMedicines[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(
                              Icons.medical_services,
                              color: Colors.green,
                            ),
                            title: Text(
                              medicine.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(medicine.description),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.green,
                              ),
                              onPressed: () => _saveData(medicine.name,
                                  medicine.description, medicine.price),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Medicine> cartItems;
  final ValueChanged<Medicine> onRemove;
  final VoidCallback onCheckout;

  const CartPage({
    Key? key,
    required this.cartItems,
    required this.onRemove,
    required this.onCheckout,
  }) : super(key: key);

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);

  void _openWhatsApp(BuildContext context) async {
    final String message = "Saya ingin membeli:\n" +
        cartItems
            .map((item) => "${item.name} - Rp ${item.price.toStringAsFixed(0)}")
            .join("\n") +
        "\nTotal: Rp ${totalPrice.toStringAsFixed(0)}";
    final String whatsappUrl = Uri.encodeFull(
      "https://wa.me/6285795082922?text=$message",
    );

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka WhatsApp'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: ListView.builder(
        itemCount: DBHelper.getData().length,
        itemBuilder: (context, index) {
          final medicine = DBHelper.getData()[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.medical_services,
                color: Colors.green,
              ),
              title: Text(
                medicine.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(medicine.desc),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rp ${medicine.price}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => DBHelper.deleteData(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PerawatanPage extends StatelessWidget {
  const PerawatanPage({Key? key}) : super(key: key);

  final List<_CareItem> careItems = const [
    _CareItem(
      title: 'Memandikan Hewan',
      description:
          'Memandikan hewan secara rutin membantu menjaga kebersihan dan kesehatan kulit.',
      icon: Icons.bathroom,
    ),
    _CareItem(
      title: 'Memberi Makan Sehat',
      description:
          'Pastikan makanan mengandung nutrisi lengkap sesuai jenis dan usia hewan.',
      icon: Icons.restaurant,
    ),
    _CareItem(
      title: 'Vaksinasi',
      description:
          'Lakukan vaksinasi sesuai jadwal untuk mencegah penyakit menular pada hewan.',
      icon: Icons.local_hospital,
    ),
    _CareItem(
      title: 'Perawatan Gigi',
      description:
          'Sikat gigi hewan secara teratur untuk menghindari masalah mulut dan gigi.',
      icon: Icons.cleaning_services,
    ),
    _CareItem(
      title: 'Olahraga',
      description:
          'Berikan waktu untuk berolahraga agar hewan tetap sehat dan aktif.',
      icon: Icons.directions_run,
    ),
    _CareItem(
      title: 'Pemeriksaan Berkala',
      description:
          'Kunjungi dokter hewan untuk pemeriksaan rutin dan deteksi dini masalah kesehatan.',
      icon: Icons.medical_services,
    ),
  ];

  void _showCareDetail(BuildContext context, _CareItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.title),
          content: Text(item.description),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perawatan Hewan')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: careItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = careItems[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: Icon(item.icon, color: Colors.green, size: 32),
              title: Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onTap: () => _showCareDetail(context, item),
            ),
          );
        },
      ),
    );
  }
}

class _CareItem {
  final String title;
  final String description;
  final IconData icon;

  const _CareItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Selamat datang di layanan chat PuthiPetCare!',
      isUser: false,
    ),
  ];

  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesan tidak boleh kosong!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _messageController.clear();

    // Simulate bot response delayed
    Future.delayed(const Duration(seconds: 1), () {
      final botResponse = _getBotResponse(text);
      setState(() {
        _messages.add(_ChatMessage(text: botResponse, isUser: false));
        _isTyping = false;
      });
    });
  }

  String _getBotResponse(String userMessage) {
    final msg = userMessage.toLowerCase();

    if (msg.contains('jam') && msg.contains('operasional')) {
      return 'Jam operasional PuthiPetCare adalah dari pukul 08.00 sampai 17.00 setiap hari.';
    }
    if (msg.contains('promo') || msg.contains('diskon')) {
      return 'Saat ini kami memiliki diskon 20% untuk semua obat hewan sampai akhir bulan!';
    }
    if (msg.contains('konsultasi')) {
      return 'Konsultasi dengan dokter hewan tersedia setiap hari Sabtu secara gratis.';
    }
    if (msg.contains('antar') || msg.contains('pengiriman')) {
      return 'Kami menyediakan gratis antar obat untuk pembelian di atas 200 ribu.';
    }
    if (msg.contains('terima kasih') || msg.contains('thanks')) {
      return 'Sama-sama! Jika ada pertanyaan lain, silakan hubungi kami.';
    }

    // Default response
    return 'Maaf, saya belum mengerti pertanyaan Anda. Silakan coba tanyakan hal lain.';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildMessage(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.green[300] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(message.isUser ? 12 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 12),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text('...'),
                    ),
                  );
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Ketik pesan...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}
