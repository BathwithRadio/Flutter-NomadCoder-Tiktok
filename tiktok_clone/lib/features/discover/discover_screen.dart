import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

final tabs = ['Top', 'Users', 'Videos', 'Sounds', 'LIVE', 'Shopping', 'Brands'];

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text("Discover"),
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: TabBarView(children: [
          // builder 가 children을 양산하는 것 보다 성능이 더 좋다
          GridView.builder(
            itemCount: 20,
            padding: const EdgeInsets.all(
              Sizes.size6,
            ),
            // help you configure grid view
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // how many colums you have
              crossAxisCount: 2,
              crossAxisSpacing: Sizes.size10,
              mainAxisSpacing: Sizes.size10,
              childAspectRatio: 9 / 16,
            ),
            // 웹에서 이미지를 가져오는동안 placeholder를 띄워준다
            itemBuilder: (context, index) => Column(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 16,
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholderFit: BoxFit.fitHeight,
                    placeholder: "assets/images/placeholder.jpg",
                    image:
                        "https://images.unsplash.com/photo-1677549254885-cf55be3e552b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
                  ),
                ),
              ],
            ),
          ),
          for (var tab in tabs.skip(1))
            Center(
              child: Text(
                tab,
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            )
        ]),
      ),
    );
  }
}
