import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AmbulancePage extends StatefulWidget {
  const AmbulancePage({super.key});

  @override
  State<AmbulancePage> createState() => _AmbulancePageState();
}

class _AmbulancePageState extends State<AmbulancePage> {
  final supabase = Supabase.instance.client;

  List ambulances = [];
  bool isLoading = true;

  String selectedDistrict = "All";
  final List<String> districts = [
    "All",
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
  void initState() {
    super.initState();
    fetchAmbulances();
  }

  Future<void> fetchAmbulances() async {
    setState(() => isLoading = true);

    var query = supabase.from('ambulances').select();

    if (selectedDistrict != "All") {
      query = query.eq('district', selectedDistrict);
    }

    final response = await query.order('created_at', ascending: false);

    setState(() {
      ambulances = response;
      isLoading = false;
    });
  }

  Future<void> callNumber(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot launch phone app")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        title: const Text("Find Ambulance"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),

          // District Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField(
              value: selectedDistrict,
              decoration: InputDecoration(
                labelText: "Filter by District",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: districts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedDistrict = value.toString());
                fetchAmbulances();
              },
            ),
          ),

          const SizedBox(height: 15),

          // Ambulance List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ambulances.isEmpty
                    ? const Center(child: Text("No Ambulance Found"))
                    : ListView.builder(
                        itemCount: ambulances.length,
                        itemBuilder: (context, index) {
                          final ambulance = ambulances[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              title: Text(
                                ambulance['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(ambulance['district']),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.call,
                                  color: Color(0xFFE53935),
                                ),
                                onPressed: () =>
                                    callNumber(ambulance['phone']),
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
}
