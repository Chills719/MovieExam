import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'content_list_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TMDB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshCurrentTab,
          ),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Movies'),
            Tab(text: 'People'),
            Tab(text: 'TV'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          ContentListView(contentType: 'all'),
          ContentListView(contentType: 'movie'),
          ContentListView(contentType: 'person'),
          ContentListView(contentType: 'tv'),
        ],
      ),
    );
  }
}
