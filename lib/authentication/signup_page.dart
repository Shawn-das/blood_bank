import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/login_page.dart';
import 'package:flutter_application_1/authentication/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController(); // ✅ Added password
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool _isPasswordVisible = false; // ✅ Password visibility
  bool _isLoading = false;

  String selectedBloodGroup = "A Positive (A+)";
  List<String> bloodGroups = [
    "A Positive (A+)",
    "A Negative (A-)",
    "B Positive (B+)",
    "B Negative (B-)",
    "O Positive (O+)",
    "O Negative (O-)",
    "AB Positive (AB+)",
    "AB Negative (AB-)",
  ];

  final AuthService _authService = AuthService();

  Future<void> _register() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final phone = phoneController.text.trim();
  final address = addressController.text.trim();
  final password = passwordController.text.trim();
  final bloodGroup = selectedBloodGroup;

  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name, Email and Password are required')),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    //  Register user
    final response =
        await _authService.signUpWithEmailPassword(email, password);

    final user = response.user;

    if (user == null) {
      throw Exception("User registration failed");
    }

    // Insert profile into Supabase
    await Supabase.instance.client.from('profile').insert({
      'id': user.id, 
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'blood_group': bloodGroup,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE53935),
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              "Give Hope, Give Life.\nDonate Blood",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "REGISTER",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    decoration: _inputDecoration('Name'),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField(
                    value: selectedBloodGroup,
                    items: bloodGroups
                        .map((bg) => DropdownMenuItem(
                              value: bg,
                              child: Text(bg),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedBloodGroup = value!),
                    decoration: _inputDecoration('Blood Group'),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: emailController,
                    decoration: _inputDecoration('Email'),
                  ),

                  const SizedBox(height: 12),

                  // ✅ Password Field Added
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: _inputDecoration(
                      'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: phoneController,
                    decoration: _inputDecoration('Phone'),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: addressController,
                    decoration: _inputDecoration(
                      'Address',
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text("Register",
                              style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label,
      {Widget? suffixIcon, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }
}
