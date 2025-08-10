import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'content_controller.dart';

class MainController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final ContentController contentController = Get.find<ContentController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    
    // 监听标签页切换
    tabController.addListener(_onTabChanged);
  }

  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    super.onClose();
  }

  void _onTabChanged() {
    if (!tabController.indexIsChanging) {
      // 根据当前标签页懒加载数据
      switch (tabController.index) {
        case 0: // All
          // All标签页在初始化时已经加载
          break;
        case 1: // Movies
          contentController.fetchMovieContent();
          break;
        case 2: // People
          contentController.fetchPersonContent();
          break;
        case 3: // TV
          //contentController.fetchTvContent();
          break;
      }
    }
  }

  void refreshCurrentTab() {
    switch (tabController.index) {
      case 0:
        contentController.refreshContent('all');
        break;
      case 1:
        contentController.refreshContent('movie');
        break;
      case 2:
        contentController.refreshContent('person');
        break;
      case 3:
        //contentController.refreshContent('tv');
        break;
    }
  }
}
