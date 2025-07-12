import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final controller = Get.put(AuthController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text("Login", style: TextStyle(fontSize: 24)),
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
                  const SizedBox(height: 20),
                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      controller.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    child: const Text("Login"),
                  )),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.register),
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
