import 'package:flutter/material.dart';
import 'my_bookings_page.dart';

class BookingPage extends StatefulWidget {
  final String equipmentName;
  final String price;

  const BookingPage({
    super.key,
    required this.equipmentName,
    required this.price,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> selectDate(bool start) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date != null) {
      setState(() {
        if (start) {
          startDate = date;
        } else {
          endDate = date;
        }
      });
    }
  }

  void confirmBooking() {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both dates'),
        ),
      );
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date must be after start date'),
        ),
      );
      return;
    }

    bookings.add({
      'equipment': widget.equipmentName,
      'price': widget.price,
      'start': startDate!,
      'end': endDate!,
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Confirmed ✅'),
          content: Text(
            '${widget.equipmentName} has been booked successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'Select Date';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Equipment'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.agriculture,
                size: 100,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 15),

            Center(
              child: Text(
                widget.equipmentName,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                widget.price,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 35),

            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.white,
              leading: const Icon(
                Icons.calendar_today,
                color: Colors.green,
              ),
              title: const Text('Start Date'),
              subtitle: Text(formatDate(startDate)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => selectDate(true),
            ),

            const SizedBox(height: 15),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.white,
              leading: const Icon(
                Icons.event,
                color: Colors.green,
              ),
              title: const Text('End Date'),
              subtitle: Text(formatDate(endDate)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => selectDate(false),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'CONFIRM BOOKING',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}