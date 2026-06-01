import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:avatar_plus/avatar_plus.dart';

import '../../../../app_config.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../domain/entities/article.dart';
import '../providers/news_provider.dart';
import '../../../profile/presentation/pages/profile.dart';
import '../../../profile/presentation/providers/avatar_profile.dart';
import '../../../auth/presentation/pages/registration_screen.dart';

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
            Consumer(
              builder: (context, ref, _) {
                final isDark = ref.watch(themeProvider);
                return SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).setTheme(value);
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
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
               colors: [Colors.pink, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
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

  void _showArticleDetails(BuildContext context, Article article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 250,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            article.urlToImage != null && article.urlToImage!.isNotEmpty
                                ? Image.network(
                                    article.urlToImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                                  )
                                : Container(color: Colors.grey),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black87, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(20),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  article.source.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                article.publishedAt.split("T")[0],
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            article.title,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.pink.withOpacity(0.2),
                                child: const Icon(Icons.person, color: Colors.pink),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  article.author ?? "Unknown Author",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            article.description ?? article.content ?? "No content available.",
                            style: const TextStyle(fontSize: 16, height: 1.6),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Article article) {
    return GestureDetector(
      onTap: () => _showArticleDetails(context, article),
      child: Container(
        height: 240,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: (article.urlToImage != null && article.urlToImage!.isNotEmpty
                ? NetworkImage(article.urlToImage!)
                : const AssetImage('assets/placeholder.png')) as ImageProvider,
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {},
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.pink, Colors.orange]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  article.source.name,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardCard(BuildContext context, Article article) {
    return GestureDetector(
      onTap: () => _showArticleDetails(context, article),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: article.urlToImage != null && article.urlToImage!.isNotEmpty
                  ? Image.network(
                      article.urlToImage!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 110,
                        height: 110,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      article.source.name,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        article.publishedAt.split("T")[0],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider(category));

    return newsAsync.when(
      data: (articles) {
        if (articles.isEmpty) {
          return const Center(child: Text("No news found for this category."));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            if (index == 0) {
              return _buildFeaturedCard(context, article);
            }
            return _buildStandardCard(context, article);
          },
        );
      },
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Curating the latest news...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ],
        ),
      ),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
