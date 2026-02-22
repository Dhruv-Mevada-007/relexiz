import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/pages/thoughts_list_screen.dart';
import '../providers/access_provider.dart';

class AccessGateScreen extends StatefulWidget {
  const AccessGateScreen({super.key});

  @override
  State<AccessGateScreen> createState() => _AccessGateScreenState();
}

class _AccessGateScreenState extends State<AccessGateScreen> {
  final _name = TextEditingController();
  final _code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AccessProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1321),
      body: Stack(
        children: [
          _background(),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  width: 330,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Text(
                        "Enter Access",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: _name,
                        decoration: _input("Your Name"),
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 14),

                      if (ap.user != null)
                        TextField(
                          controller: _code,
                          decoration: _input("Access Code"),
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                        ),

                      const SizedBox(height: 20),

                      if (ap.error != null)
                        Text(
                          ap.error!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: () {
                          if (ap.user == null) {
                            ap.checkName(_name.text);
                          } else if (ap.needsCodeSetup) {
                            ap.createCode(_code.text);
                          } else {
                            ap.verifyCode(_code.text);
                          }

                          if (ap.isVerified) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ThoughtsListScreen(),
                              ),
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFB794F6),
                                    Color(0xFFD6BCFA),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purpleAccent.withOpacity(0.45),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Text(
                                ap.user == null
                                    ? "Continue"
                                    : ap.needsCodeSetup
                                    ? "Create Code"
                                    : "Unlock",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )



                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D1321),
                Color(0xFF1B2A49),
                Color(0xFF0D1321),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Purple glow
        Positioned(
          top: 120,
          left: -60,
          child: _glow(160, Colors.purpleAccent.withOpacity(0.22)),
        ),

        // Blue glow
        Positioned(
          bottom: 120,
          right: -60,
          child: _glow(180, Colors.blueAccent.withOpacity(0.22)),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 90,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }

}
