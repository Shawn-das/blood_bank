import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../authentication/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();

  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isAvailable = false;
  bool isEditing = false;

  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('profile')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        userData = response;
        isAvailable = response['is_available'] ?? false;
        phoneController.text = response['phone'] ?? "";
        addressController.text = response['address'] ?? "";
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleAvailability(bool value) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => isAvailable = value);

    await supabase.from('profile').update({
      'is_available': value,
    }).eq('id', user.id);
  }

  Future<void> saveProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('profile').update({
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
    }).eq('id', user.id);

    setState(() {
      isEditing = false;
    });

    fetchProfile();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );
  }

  void logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget buildInfoTile(String title, Widget child, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFE53935)),
          const SizedBox(width: 15),
          Expanded(child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // HEADER WITH BACK BUTTON
                Container(
                  padding: const EdgeInsets.only(
                      top: 60, bottom: 20, left: 15, right: 15),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Back Button Row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          const Text(
                            "Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const SizedBox(width: 24),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 50,
                            color: Color(0xFFE53935)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userData?['name'] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userData?['blood_group'] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        // Email (not editable)
                        buildInfoTile(
                          "Email",
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text("Email",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              Text(
                                userData?['email'] ?? "",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold),
                              ),
                            ],
                          ),
                          Icons.email,
                        ),

                        // Phone
                        buildInfoTile(
                          "Phone",
                          isEditing
                              ? TextField(
                                  controller:
                                      phoneController,
                                  decoration:
                                      const InputDecoration(
                                    labelText:
                                        "Phone Number",
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Text("Phone",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors
                                                .grey)),
                                    Text(
                                      phoneController.text,
                                      style:
                                          const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                          Icons.phone,
                        ),

                        // Address
                        buildInfoTile(
                          "Address",
                          isEditing
                              ? TextField(
                                  controller:
                                      addressController,
                                  decoration:
                                      const InputDecoration(
                                    labelText: "Address",
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Text("Address",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors
                                                .grey)),
                                    Text(
                                      addressController.text,
                                      style:
                                          const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                          Icons.location_on,
                        ),

                        const SizedBox(height: 20),

                        // Edit / Save Button
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFE53935),
                            minimumSize:
                                const Size(double.infinity,
                                    50),
                          ),
                          onPressed: () {
                            if (isEditing) {
                              saveProfile();
                            } else {
                              setState(() {
                                isEditing = true;
                              });
                            }
                          },
                          child: Text(
                            isEditing
                                ? "Save Changes"
                                : "Edit Profile",
                                style: TextStyle(color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Availability Toggle
                        

                        // const SizedBox(height: 30),

                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFE53935),
                            minimumSize:
                                const Size(double.infinity,
                                    50),
                          ),
                          onPressed: logout,
                          child: const Text("Logout",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
