import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/avatar_profile.dart';
import 'package:avatar_plus/avatar_plus.dart';

class ProfileScreen extends ConsumerWidget {
   ProfileScreen({super.key});

  final List<String> seeds = [
    "seed1",
    "seed2",
    "seed3",
    "seed4",
    "seed5",
    "seed6",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSeed = ref.watch(avatarProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 👤 Selected Avatar
          AvatarPlus(
            selectedSeed,
            height: 100,
            width: 100,
          ),

          const SizedBox(height: 20),

          const Text(
            "Choose Avatar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // 🧩 Avatar Grid (dynamic)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: seeds.length,
              itemBuilder: (context, index) {
                final seed = seeds[index];

                return GestureDetector(
                  onTap: () {
                    ref.read(avatarProvider.notifier).state = seed;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedSeed == seed
                            ? Colors.deepPurple
                            : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AvatarPlus(seed),
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