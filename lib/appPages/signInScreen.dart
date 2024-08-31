import 'package:ecommerceapp/appPages/product_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceapp/appPages/signUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool hiddenPassword = true;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadCachedData();
  }

  Future<void> loadCachedData() async {
    prefs = await SharedPreferences.getInstance();
    phoneController.text = prefs.getString('phone') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign in'),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const Image(
                width: 200,
                height: 200,
                image: NetworkImage(
                    'https://img.freepik.com/premium-vector/fast-message-icon-logo-design-template_412311-3778.jpg?w=2000 '),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (value != null &&
                        !(value.length >= 9 && value.length < 13)) {
                      return 'Must contain 9-12 digits';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              //phone validation

              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  obscureText: hiddenPassword,
                  controller: passController,
                  validator: (value) {
                    if (value != null &&
                        !(value.length >= 8 && value.length < 16)) {
                      return 'Must contain 8-15 digits';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Password",
                  suffixIcon: IconButton(
                      onPressed: () {
                        togglePassword();
                      },
                      splashRadius: 15,
                      icon: Icon(hiddenPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save phone number to cache
                    savePhoneToCache(phoneController.text);
                    // Check credentials
                    checkCredentials();
                  }
                },
                child: const Text('Sign in'),
              ),
              //pass validation
              const SizedBox(height: 25),
              //link to signup screen
              const Text("Don't have an account?"),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Signup(),
                    ),
                  );
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],),
        ),
      ),
    );
  }

  togglePassword() {
    setState(() {
      hiddenPassword = !hiddenPassword;
    });
  }

  Future<void> savePhoneToCache(String phone) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone);
  }

  void checkCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhone = prefs.getString('phone');
    String? savedPassword = prefs.getString('password');

    if (savedPhone == phoneController.text &&
        savedPassword == passController.text) {
      // Credentials match
      SnackBar snackBar = const SnackBar(
        content: Text("You are signed in!"),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyProduct(),
        ),
      );
    } else {
      // Credentials do not match
      SnackBar snackBar = const SnackBar(
        content: Text("Invalid credentials!"),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
