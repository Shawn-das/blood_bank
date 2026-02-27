import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAmbulancePage extends StatefulWidget {
  const AdminAmbulancePage({super.key});

  @override
  State<AdminAmbulancePage> createState() => _AdminAmbulancePageState();
}

class _AdminAmbulancePageState extends State<AdminAmbulancePage> {
  final supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedDistrict;

  final List<String> districts = [
    "Bagerhat","Bandarban","Barguna","Barisal","Bhola","Bogra",
    "Brahmanbaria","Chandpur","Chapai Nawabganj","Chattogram","Chuadanga",
    "Comilla","Cox's Bazar","Dhaka","Dinajpur","Faridpur","Feni","Gaibandha",
    "Gazipur","Gopalganj","Habiganj","Jamalpur","Jashore","Jhalokati",
    "Jhenaidah","Joypurhat","Khagrachhari","Khulna","Kishoreganj","Kurigram",
    "Kushtia","Lakshmipur","Lalmonirhat","Madaripur","Magura","Manikganj",
    "Meherpur","Moulvibazar","Munshiganj","Mymensingh","Naogaon","Narail",
    "Narsingdi","Natore","Nawabganj","Netrokona","Nilphamari","Noakhali",
    "Pabna","Panchagarh","Patuakhali","Pirojpur","Rajbari","Rajshahi",
    "Rangamati","Rangpur","Satkhira","Shariatpur","Sherpur","Sirajganj",
    "Sunamganj","Sylhet","Tangail","Thakurgaon"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Add Ambulance"),
        backgroundColor: const Color(0xFFE53935),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ambulance Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Ambulance Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Phone
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            // District Dropdown
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: const InputDecoration(
                labelText: "District",
                border: OutlineInputBorder(),
              ),
              items: districts.map((d) => DropdownMenuItem(
                value: d,
                child: Text(d),
              )).toList(),
              onChanged: (val) {
                setState(() => selectedDistrict = val);
              },
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                
                  if (nameController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      selectedDistrict == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  // Supabase insert 
                  
                  supabase.from('ambulances').insert({
                    'name': nameController.text.trim(),
                    'phone': phoneController.text.trim(),
                    'district': selectedDistrict,
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ambulance added successfully")),
                    );
                    // Clear fields
                    nameController.clear();
                    phoneController.clear();
                    setState(() => selectedDistrict = null);
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Add Ambulance",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
