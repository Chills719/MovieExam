import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_controller.dart';
import '../models/media_content.dart';
import '../widgets/content_card.dart';

class ContentListView extends StatelessWidget {
  final String contentType;
  
  const ContentListView({super.key, required this.contentType});

  @override
  Widget build(BuildContext context) {
    final ContentController controller = Get.find<ContentController>();
    
    return GetBuilder<ContentController>(
      builder: (controller) {
        return _buildBody(controller);
      },
    );
  }

  Widget _buildBody(ContentController controller) {
    final isLoading = controller.getLoadingStateByType(contentType);
    final error = controller.getErrorByType(contentType);
    final contents = controller.getContentsByType(contentType);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.refreshContent(contentType),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshContent(contentType),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          final content = contents[index];
          return ContentCard(content: content);
        },
      ),
    );
  }
}
