import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorCard extends StatelessWidget {
  final Map donor;

  const DonorCard({super.key, required this.donor});

  @override
  Widget build(BuildContext context) {
    final lastDonated = donor['last_donation_date'];
    String formattedDate = "Not Available";

    if (lastDonated != null) {
      formattedDate = DateFormat('dd MMM yyyy')
          .format(DateTime.parse(lastDonated.toString()));
    }

    final bool isAvailable = donor['is_available'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name + Blood Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                donor['full_name'] ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.red,
                child: Text(
                  donor['blood_group'] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "${donor['district'] ?? ''} • ${donor['phone'] ?? ''}",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 6),

          /// Last Donated
          Text(
            "Last Donated: $formattedDate",
            style: const TextStyle(fontSize: 13),
          ),

          const SizedBox(height: 6),

          /// Availability
          Row(
            children: [
              Icon(
                Icons.circle,
                color: isAvailable ? Colors.green : Colors.red,
                size: 10,
              ),
              const SizedBox(width: 6),
              Text(
                isAvailable ? "Available" : "Not Available",
                style: TextStyle(
                  color: isAvailable ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Call Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final Uri phoneUri =
                  Uri.parse("tel:${donor['phone']}");

              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              }
            },
            icon: const Icon(Icons.phone),
            label: const Text("Call"),
          )
        ],
      ),
    );
  }
}
