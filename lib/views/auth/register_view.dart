import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();
    final controller = AuthController.to;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text("Register", style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: 'Role (admin/user)'),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      final role = roleController.text.trim().toLowerCase();

                      if (!GetUtils.isEmail(email)) {
                        Get.snackbar('Invalid Email', 'Please enter a valid email address.');
                        return;
                      }

                      if (password.length < 6) {
                        Get.snackbar('Weak Password', 'Password must be at least 6 characters.');
                        return;
                      }

                      if (role != 'user' && role != 'admin') {
                        Get.snackbar('Invalid Role', 'Role must be either user or admin.');
                        return;
                      }

                      controller.register(email, password, role);
                    },

                    child: const Text("Register"),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
