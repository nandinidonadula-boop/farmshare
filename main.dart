import 'package:flutter/material.dart';

void main() {
  runApp(const FarmShareApp());
}

const green = Color(0xFF238344);
const paleGreen = Color(0xFFEAF5EC);

class FarmShareApp extends StatelessWidget {
  const FarmShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF7FAF6),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// Shared demo session and booking data.
// These reset when the app process is restarted.
class FarmData {
  static String name = 'Farmer';
  static String email = '';
  static String phone = '';
  static String address = '';

  static final List<Map<String, dynamic>> bookings = [];
}

class Equipment {
  final String name;
  final String description;
  final int price;
  final IconData icon;

  const Equipment(
    this.name,
    this.description,
    this.price,
    this.icon,
  );
}

const equipmentList = [
  Equipment('Tractor', 'Land preparation', 1500, Icons.agriculture),
  Equipment('Harvester', 'Crop harvesting', 2500, Icons.precision_manufacturing),
  Equipment('Rotavator', 'Soil cultivation', 1000, Icons.settings),
  Equipment('Seed Drill', 'Seed planting', 800, Icons.grass),
];

String dateText(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';

String money(int amount) => '₹$amount';

// ---------------- LOGIN + DEMO OTP ----------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool hidePassword = true;
  bool otpRequested = false;
  String demoOtp = '123456';
  String error = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void loginWithEmail() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Demo credentials only. Replace with a real authentication service.
    if (email == 'farmer@gmail.com' && password == '123456') {
      FarmData.email = email;
      FarmData.name = 'Farmer';
      setState(() => error = '');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      setState(() {
        error = 'Invalid demo credentials. Check the details below.';
      });
    }
  }

  void requestOtp() {
    final phone = phoneController.text.trim();
    if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(phone)) {
      setState(() => error = 'Enter a valid phone number (10–13 digits).');
      return;
    }

    // DEMO ONLY: this does NOT send an SMS.
    setState(() {
      FarmData.phone = phone;
      otpRequested = true;
      error = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo mode: use OTP 123456. No SMS was sent.'),
      ),
    );
  }

  void verifyOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpPage(
          phone: phoneController.text.trim(),
          expectedOtp: demoOtp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.agriculture, size: 85, color: green),
                  const SizedBox(height: 8),
                  const Text(
                    'FarmShare',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: green,
                    ),
                  ),
                  const Text(
                    'Farm equipment, shared simply.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Login with email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => hidePassword = !hidePassword),
                        icon: Icon(
                          hidePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: loginWithEmail,
                    style: FilledButton.styleFrom(
                      backgroundColor: green,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('LOGIN'),
                  ),
                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Login with phone OTP',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number with country code (optional)',
                      hintText: '+919876543210',
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: requestOtp,
                    icon: const Icon(Icons.sms_outlined),
                    label: const Text('Request demo OTP'),
                  ),
                  if (otpRequested) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Demo OTP: 123456 (not an SMS)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FilledButton(
                      onPressed: verifyOtp,
                      child: const Text('CONTINUE TO OTP VERIFICATION'),
                    ),
                  ],
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(error, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Demo email: farmer@gmail.com\nDemo password: 123456',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtpPage extends StatefulWidget {
  final String phone;
  final String expectedOtp;

  const OtpPage({
    super.key,
    required this.phone,
    required this.expectedOtp,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();
  String error = '';

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void verify() {
    if (otpController.text.trim() != widget.expectedOtp) {
      setState(() => error = 'Incorrect OTP. Please try again.');
      return;
    }

    FarmData.phone = widget.phone;
    FarmData.name = 'Farmer';

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify phone')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.verified_user, size: 70, color: green),
            const SizedBox(height: 16),
            const Text(
              'Enter your 6-digit OTP',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Phone: ${widget.phone}', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'OTP code'),
            ),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: verify,
              child: const Text('VERIFY & LOGIN'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Demo only: enter 123456. Real SMS verification is not enabled.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- MAIN NAVIGATION ----------------

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  void refreshBookings() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onBookingChanged: refreshBookings),
      BookingsPage(onChanged: refreshBookings),
      ProfilePage(onProfileChanged: refreshBookings),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ---------------- HOME / EQUIPMENT ----------------

class HomePage extends StatelessWidget {
  final VoidCallback onBookingChanged;

  const HomePage({super.key, required this.onBookingChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmShare 🌱'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome, ${FarmData.name}!',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Choose the equipment you need for your farm.'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: paleGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.agriculture, size: 55, color: green),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Save money by renting farming equipment when you need it.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Available equipment',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...equipmentList.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: paleGreen,
                      child: Icon(item.icon, color: green, size: 30),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(item.description),
                          Text(
                            '${money(item.price)} / day',
                            style: const TextStyle(
                              color: green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingFormPage(item: item),
                          ),
                        );
                        if (result == true) onBookingChanged();
                      },
                      child: const Text('Book'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- BOOKING FORM ----------------

class BookingFormPage extends StatefulWidget {
  final Equipment item;

  const BookingFormPage({super.key, required this.item});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  DateTime? startDate;
  DateTime? endDate;
  final locationController = TextEditingController();

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  Future<void> pickDate(bool isStart) async {
    final now = DateTime.now();
    final initial = isStart
        ? (startDate ?? now)
        : (endDate ?? startDate ?? now);

    final date = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null || !mounted) return;

    setState(() {
      if (isStart) {
        startDate = date;
        if (endDate != null && endDate!.isBefore(date)) {
          endDate = null;
        }
      } else {
        endDate = date;
      }
    });
  }

  void confirm() {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both dates.')),
      );
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be on or after start date.')),
      );
      return;
    }

    if (locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the delivery/farm location.')),
      );
      return;
    }

    final days = endDate!.difference(startDate!).inDays + 1;
    final total = days * widget.item.price;

    FarmData.bookings.add({
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'equipment': widget.item.name,
      'pricePerDay': widget.item.price,
      'start': startDate!,
      'end': endDate!,
      'days': days,
      'total': total,
      'location': locationController.text.trim(),
      'status': 'Confirmed',
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Booking confirmed!'),
        content: Text(
          '${widget.item.name}\n'
          'Duration: $days day(s)\n'
          'Estimated total: ${money(total)}\n'
          'Location: ${locationController.text.trim()}',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context, true);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = startDate != null && endDate != null &&
            !endDate!.isBefore(startDate!)
        ? endDate!.difference(startDate!).inDays + 1
        : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Equipment')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(widget.item.icon, size: 80, color: green),
          const SizedBox(height: 8),
          Text(
            widget.item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            '${money(widget.item.price)} per day',
            textAlign: TextAlign.center,
            style: const TextStyle(color: green, fontSize: 17),
          ),
          const SizedBox(height: 25),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.calendar_today, color: green),
            title: const Text('Start date'),
            subtitle: Text(startDate == null ? 'Select start date' : dateText(startDate!)),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () => pickDate(true),
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.event, color: green),
            title: const Text('End date'),
            subtitle: Text(endDate == null ? 'Select end date' : dateText(endDate!)),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () => pickDate(false),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: 'Farm / delivery location',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 18),
          if (days > 0)
            Card(
              color: paleGreen,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rental days: $days'),
                    const SizedBox(height: 5),
                    Text(
                      'Estimated total: ${money(days * widget.item.price)}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: confirm,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: green,
            ),
            child: const Text('CONFIRM BOOKING'),
          ),
        ],
      ),
    );
  }
}

// ---------------- MY BOOKINGS ----------------

class BookingsPage extends StatelessWidget {
  final VoidCallback onChanged;

  const BookingsPage({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = FarmData.bookings.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, size: 75, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No bookings yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Go to Home and book equipment.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final booking = items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.agriculture, color: green, size: 32),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                booking['equipment'] as String,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(booking['status'] as String),
                              backgroundColor: paleGreen,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Start: ${dateText(booking['start'] as DateTime)}'),
                        Text('End: ${dateText(booking['end'] as DateTime)}'),
                        Text('Days: ${booking['days']}'),
                        Text('Location: ${booking['location']}'),
                        const SizedBox(height: 6),
                        Text(
                          'Total: ${money(booking['total'] as int)}',
                          style: const TextStyle(
                            color: green,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (booking['status'] == 'Confirmed')
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () async {
                                final cancel = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Cancel booking?'),
                                    content: const Text(
                                      'Do you want to cancel this booking?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, false),
                                        child: const Text('Keep'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, true),
                                        child: const Text('Cancel booking'),
                                      ),
                                    ],
                                  ),
                                );

                                if (cancel == true) {
                                  booking['status'] = 'Cancelled';
                                  onChanged();
                                }
                              },
                              icon: const Icon(Icons.cancel_outlined),
                              label: const Text('Cancel booking'),
                            ),
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

// ---------------- PROFILE + EDIT ----------------

class ProfilePage extends StatefulWidget {
  final VoidCallback onProfileChanged;

  const ProfilePage({super.key, required this.onProfileChanged});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> editProfile() async {
    final name = TextEditingController(text: FarmData.name);
    final email = TextEditingController(text: FarmData.email);
    final phone = TextEditingController(text: FarmData.phone);
    final address = TextEditingController(text: FarmData.address);

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: address,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Farm address'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty || email.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Name and email are required.')),
                );
                return;
              }

              FarmData.name = name.text.trim();
              FarmData.email = email.text.trim();
              FarmData.phone = phone.text.trim();
              FarmData.address = address.text.trim();

              Navigator.pop(dialogContext, true);
            },
            child: const Text('Save changes'),
          ),
        ],
      ),
    );

    name.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();

    if (result == true && mounted) {
      setState(() {});
      widget.onProfileChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    }
  }

  void logout() {
    FarmData.bookings.clear();
    FarmData.name = 'Farmer';
    FarmData.email = '';
    FarmData.phone = '';
    FarmData.address = '';

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 54,
            backgroundColor: paleGreen,
            child: Icon(Icons.person, size: 65, color: green),
          ),
          const SizedBox(height: 14),
          Text(
            FarmData.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            FarmData.email.isEmpty ? 'No email added' : FarmData.email,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: green),
                  title: const Text('Full name'),
                  subtitle: Text(FarmData.name),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: green),
                  title: const Text('Email'),
                  subtitle: Text(
                    FarmData.email.isEmpty ? 'Not provided' : FarmData.email,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_outlined, color: green),
                  title: const Text('Phone'),
                  subtitle: Text(
                    FarmData.phone.isEmpty ? 'Not provided' : FarmData.phone,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined, color: green),
                  title: const Text('Farm address'),
                  subtitle: Text(
                    FarmData.address.isEmpty ? 'Not provided' : FarmData.address,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: editProfile,
            icon: const Icon(Icons.edit),
            label: const Text('EDIT PROFILE'),
            style: FilledButton.styleFrom(
              backgroundColor: green,
              padding: const EdgeInsets.all(15),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            label: const Text('LOGOUT'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.all(15),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Demo app: profile and booking data are kept in memory only.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}