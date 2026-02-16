import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class BeADonorPage extends StatefulWidget {
  const BeADonorPage({super.key});

  @override
  State<BeADonorPage> createState() => _BeADonorPageState();
}

class _BeADonorPageState extends State<BeADonorPage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedDistrict;
  String selectedBloodGroup = "A+";
  String selectedGender = "Male";
  DateTime? lastDonationDate;
  bool isAvailable = true;

  bool isEditing = false;
  bool isLoading = true;
  bool isDataLoaded = false;

  final List<String> districts = {
    "Bagerhat","Bandarban","Barguna","Barisal","Bhola","Bogura",
    "Brahmanbaria","Chandpur","Chattogram","Chuadanga","Comilla",
    "Cox's Bazar","Dhaka","Dinajpur","Faridpur","Feni","Gaibandha",
    "Gazipur","Gopalganj","Habiganj","Jamalpur","Jashore",
    "Jhalokati","Jhenaidah","Joypurhat","Khagrachhari","Khulna",
    "Kishoreganj","Kurigram","Kushtia","Lakshmipur","Lalmonirhat",
    "Madaripur","Magura","Manikganj","Meherpur","Moulvibazar",
    "Munshiganj","Mymensingh","Naogaon","Narail","Narayanganj",
    "Narsingdi","Natore","Netrokona","Nilphamari","Noakhali",
    "Pabna","Panchagarh","Patuakhali","Pirojpur","Rajbari",
    "Rajshahi","Rangamati","Rangpur","Satkhira","Shariatpur",
    "Sherpur","Sirajganj","Sunamganj","Sylhet","Tangail","Thakurgaon",
  }.toList();

  final List<String> bloodGroups = [
    "A+","A-","B+","B-","O+","O-","AB+","AB-"
  ];

  @override
  void initState() {
    super.initState();
    loadDonor();
  }

  Future<void> loadDonor() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        isLoading = false;
        isDataLoaded = true;
      });
      return;
    }

    final data = await supabase
        .from('donors')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (data == null) {
      setState(() {
        isEditing = true;
        isLoading = false;
        isDataLoaded = true;
      });
      return;
    }

    setState(() {
      nameController.text = data['full_name'] ?? '';
      phoneController.text = data['phone'] ?? '';
      addressController.text = data['address'] ?? '';
      ageController.text = data['age']?.toString() ?? '';

      selectedDistrict = districts.contains(data['district'])
          ? data['district']
          : null;

      selectedBloodGroup = bloodGroups.contains(data['blood_group'])
          ? data['blood_group']
          : bloodGroups.first;

      selectedGender = ["Male", "Female", "Other"]
              .contains(data['gender'])
          ? data['gender']
          : "Male";

      isAvailable = data['is_available'] ?? true;

      if (data['last_donation_date'] != null) {
        lastDonationDate =
            DateTime.tryParse(data['last_donation_date']);
      }

      isEditing = false;
      isLoading = false;
      isDataLoaded = true;
    });
  }

  Future<void> saveDonor() async {
    if (!_formKey.currentState!.validate()) return;

    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => isLoading = true);

    await supabase.from('donors').upsert({
      'user_id': user.id,
      'full_name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'age': int.parse(ageController.text.trim()),
      'district': selectedDistrict,
      'blood_group': selectedBloodGroup,
      'gender': selectedGender,
      'last_donation_date': lastDonationDate == null
          ? null
          : DateFormat('yyyy-MM-dd').format(lastDonationDate!),
      'is_available': isAvailable,
    }, onConflict: 'user_id');

    setState(() {
      isEditing = false;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved Successfully")),
    );
  }

  Future<void> pickDate() async {
    if (!isEditing) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: lastDonationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => lastDonationDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded || isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Be A Donor"),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: nameController,
                enabled: isEditing,
                decoration: const InputDecoration(
                    labelText: "Full Name",
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: phoneController,
                enabled: isEditing,
                decoration: const InputDecoration(
                    labelText: "Phone Number",
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: addressController,
                enabled: isEditing,
                decoration: const InputDecoration(
                    labelText: "Address",
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: ageController,
                enabled: isEditing,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Age",
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedDistrict,
                items: districts
                    .map((d) =>
                        DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: isEditing
                    ? (value) => setState(() => selectedDistrict = value)
                    : null,
                decoration: const InputDecoration(
                    labelText: "District",
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedBloodGroup,
                items: bloodGroups
                    .map((b) =>
                        DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: isEditing
                    ? (value) =>
                        setState(() => selectedBloodGroup = value!)
                    : null,
                decoration: const InputDecoration(
                    labelText: "Blood Group",
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedGender,
                items: ["Male", "Female", "Other"]
                    .map((g) =>
                        DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: isEditing
                    ? (value) =>
                        setState(() => selectedGender = value!)
                    : null,
                decoration: const InputDecoration(
                    labelText: "Gender",
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 20),

              // LAST DONATION DATE
              GestureDetector(
                onTap: pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    lastDonationDate == null
                        ? "Select Last Donation Date"
                        : "Last Donated: ${DateFormat('dd MMM yyyy').format(lastDonationDate!)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // AVAILABLE SWITCH
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Available for Donation",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      activeColor: Colors.red,
                      value: isAvailable,
                      onChanged: isEditing
                          ? (value) =>
                              setState(() => isAvailable = value)
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: saveDonor,
                    child: const Text("Save"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}