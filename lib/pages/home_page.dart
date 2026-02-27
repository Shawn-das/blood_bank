import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/donar_card.dart';
import 'package:flutter_application_1/pages/dash_board.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  List donors = [];
  bool isLoading = true;

  String selectedBlood = "All";
  String selectedDistrict = "All";
  String searchText = "";

  final List<String> bloodGroups = [
    "All",
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-",
  ];

 
  final List<String> districts = [
    "All",
    "Bagerhat",
    "Bandarban",
    "Barguna",
    "Barisal",
    "Bhola",
    "Bogura",
    "Brahmanbaria",
    "Chandpur",
    "Chattogram",
    "Chuadanga",
    "Comilla",
    "Cox's Bazar",
    "Dhaka",
    "Dinajpur",
    "Faridpur",
    "Feni",
    "Gaibandha",
    "Gazipur",
    "Gopalganj",
    "Habiganj",
    "Jamalpur",
    "Jashore",
    "Jhalokati",
    "Jhenaidah",
    "Joypurhat",
    "Khagrachhari",
    "Khulna",
    "Kishoreganj",
    "Kurigram",
    "Kushtia",
    "Lakshmipur",
    "Lalmonirhat",
    "Madaripur",
    "Magura",
    "Manikganj",
    "Meherpur",
    "Moulvibazar",
    "Munshiganj",
    "Mymensingh",
    "Naogaon",
    "Narail",
    "Narayanganj",
    "Narsingdi",
    "Natore",
    "Netrokona",
    "Nilphamari",
    "Noakhali",
    "Pabna",
    "Panchagarh",
    "Patuakhali",
    "Pirojpur",
    "Rajbari",
    "Rajshahi",
    "Rangamati",
    "Rangpur",
    "Satkhira",
    "Shariatpur",
    "Sherpur",
    "Sirajganj",
    "Sunamganj",
    "Sylhet",
    "Tangail",
    "Thakurgaon",
  ];

  @override
  void initState() {
    super.initState();
    fetchDonors();
  }

  Future<void> fetchDonors() async {
  final user = supabase.auth.currentUser;

  if (user == null) {
    Navigator.pushReplacementNamed(context, '/login');
    return;
  }

  setState(() => isLoading = true);

  try {
    final response = await supabase
        .from('donors')
        .select()
        .order('created_at', ascending: false); // ✅ REMOVED availability filter

    List filtered = List.from(response);

    // Search filter
    if (searchText.isNotEmpty) {
      filtered = filtered.where((d) {
        return d['full_name']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase());
      }).toList();
    }

    // Blood filter
    if (selectedBlood != "All") {
      filtered = filtered
          .where((d) => d['blood_group'] == selectedBlood)
          .toList();
    }

    // District filter
    if (selectedDistrict != "All") {
      filtered = filtered
          .where((d) => d['district'] == selectedDistrict)
          .toList();
    }

    setState(() {
      donors = filtered;
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.dashboard,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DashboardPage(),
                            ),
                          );
                        },
                      ),
                      const Text(
                        "Find Blood Donor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      searchText = value;
                      fetchDonors();
                    },
                    decoration: InputDecoration(
                      hintText: "Search by name...",
                      prefixIcon:
                          const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bloodGroups.length,
                itemBuilder: (context, index) {
                  final group = bloodGroups[index];
                  final isSelected =
                      selectedBlood == group;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6),
                    child: ChoiceChip(
                      label: Text(group),
                      selected: isSelected,
                      selectedColor:
                          const Color(0xFFE53935),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (_) {
                        setState(() =>
                            selectedBlood = group);
                        fetchDonors();
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: selectedDistrict,
                decoration: InputDecoration(
                  labelText: "Filter by District",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                items: districts
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() =>
                      selectedDistrict = value!);
                  fetchDonors();
                },
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator())
                  : donors.isEmpty
                      ? const Center(
                          child:
                              Text("No Donors Found"))
                      : ListView.builder(
                          itemCount: donors.length,
                          itemBuilder:
                              (context, index) {
                            final donor =
                                donors[index];

                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: DonorCard(
                                  donor: donor),
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