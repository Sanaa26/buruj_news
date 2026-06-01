import 'package:avatar_plus/avatar_plus.dart';
import 'package:buruj_news/presentation/profile.dart';
import 'package:buruj_news/presentation/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_config.dart';
import '../providers/avatar_profile.dart';
import '../providers/news_provider.dart';
import '../providers/theme_provider.dart';

class NewsScreen extends ConsumerWidget {
  NewsScreen({super.key});

  final List<String> categories = ['General', 'Fitness', 'Technology', 'Business', 'Sports'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(appConfigProvider);
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            // 👤 Profile Header
            UserAccountsDrawerHeader(
              accountName: const Text("Sana Khan"),
              accountEmail: Text("sana@gmail.com • Env: ${appConfig.flavor.name.toUpperCase()}"),
              currentAccountPicture: Consumer(
                builder: (context, ref, _) {
                  final seed = ref.watch(avatarProvider);
                  return CircleAvatar(
                    child: AvatarPlus(seed, height: 40, width: 40),
                  );
                },
              ),
            ),

            // 🌗 Theme Toggle
            Consumer(
              builder: (context, ref, _) {
                final isDark = ref.watch(themeProvider);
                return SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).state = value;
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.pink),
              ),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),

            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.app_registration, color: Colors.red),
              ),
              title: const Text("Registration"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegistrationScreen()),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.track_changes, color: Colors.orange),
              ),
              title: const Text("Goals"),
            ),
            // 💬 Feedback
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.dynamic_feed, color: Colors.blue),
              ),
              title: const Text("Feedback"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Feedback"),
                      content: const Text("Thanks for your feedback! 😊"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            // ℹ️ About Us
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info, color: Colors.green),
              ),
              title: const Text("About Us"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: appConfig.appName,
                  applicationVersion: "1.0.0",
                  children: [
                    Text("This is a news app built using Flutter & Riverpod."),
                    const SizedBox(height: 8),
                    Text("Active Environment: ${appConfig.flavor.name.toUpperCase()}"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(appConfig.appName),
            if (appConfig.flavor == AppFlavor.dev) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "DEV",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        ),
        bottom: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent, // Removes the bottom line
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [Colors.pink, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey, // Unselected color
          tabs: categories.map((cat) => Tab(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    cat,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )).toList(),
        ),
      ),
      body: TabBarView(
        children: categories.map((cat) {
          return NewsListTab(category: cat.toLowerCase());
        }).toList(),
      ),
    ));
  }
}

class NewsListTab extends ConsumerWidget {
  final String category;

  const NewsListTab({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider(category));

    return newsAsync.when(
      data: (data) {
        final articles = data.articles ?? [];

        if (articles.isEmpty) {
          return const Center(child: Text("No news found for this category."));
        }

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼 Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: article.urlToImage != null && article.urlToImage!.isNotEmpty
                          ? Image.network(
                              article.urlToImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, color: Colors.grey, size: 40),
                                );
                              },
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey, size: 40),
                            ),
                    ),

                    const SizedBox(width: 10),

                    // 📄 Text Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 📰 Title
                          Text(
                            article.title ?? "No Title",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // 📝 Description
                          Text(
                            article.description ?? "No Description",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // 👇 Row for author + date
                          Row(
                            children: [
                              // ✍️ Author
                              Expanded(
                                child: Text(
                                  article.author ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),

                              // 📅 Date
                              Text(
                                article.publishedAt?.split("T")[0] ?? "",
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          // 🏷 Source Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              article.source?.name ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
