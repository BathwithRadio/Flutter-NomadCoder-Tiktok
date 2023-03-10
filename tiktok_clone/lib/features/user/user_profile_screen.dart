import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text("Alsrl"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.gear,
                    size: Sizes.size20,
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    foregroundImage: NetworkImage(
                        "https://avatars.githubusercontent.com/u/86900125?v=4"),
                    child: Text("Alsrl"),
                  ),
                  Gaps.v20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "@Alsrl",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.size18,
                        ),
                      ),
                      Gaps.h5,
                      FaIcon(
                        FontAwesomeIcons.solidCircleCheck,
                        color: Colors.blue.shade500,
                        size: Sizes.size16,
                      )
                    ],
                  ),
                  Gaps.v24,
                  SizedBox(
                    height: Sizes.size48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const UserInfo(amount: "197", item: "Following"),
                        VerticalDivider(
                          width: Sizes.size40,
                          thickness: Sizes.size1,
                          color: Colors.grey.shade400,
                          indent: Sizes.size14,
                          endIndent: Sizes.size14,
                        ),
                        const UserInfo(amount: "10.5M", item: "Followers"),
                        VerticalDivider(
                          width: Sizes.size40,
                          thickness: Sizes.size1,
                          color: Colors.grey.shade400,
                          indent: Sizes.size14,
                          endIndent: Sizes.size14,
                        ),
                        const UserInfo(amount: "194.4M", item: "Likes"),
                      ],
                    ),
                  ),
                  Gaps.v14,
                  FractionallySizedBox(
                    widthFactor: 0.80,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size72,
                            vertical: Sizes.size18,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(Sizes.size4),
                            ),
                          ),
                          child: const Text(
                            "Follow",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Gaps.h5,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size14,
                            vertical: Sizes.size12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                Sizes.size4,
                              ),
                            ),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.youtube,
                            size: Sizes.size28,
                          ),
                        ),
                        Gaps.h5,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size12,
                            vertical: Sizes.size10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                Sizes.size4,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_drop_down,
                            size: Sizes.size32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.v14,
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.size32,
                    ),
                    child: Text(
                      "All highlights and where to watch live matches on FIFA+ I wonder how it would loook",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v14,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.link,
                        size: Sizes.size12,
                      ),
                      Gaps.h4,
                      Text(
                        "https://nomadcoders.co",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Gaps.v20,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: const TabBar(
                      labelPadding: EdgeInsets.symmetric(
                        vertical: Sizes.size10,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      tabs: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.size14,
                          ),
                          child: Icon(Icons.grid_4x4_rounded),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.size14,
                          ),
                          child: FaIcon(FontAwesomeIcons.heart),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ];
        },
        body: TabBarView(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: EdgeInsets.zero,
              // help you configure grid view
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // how many colums you have
                crossAxisCount: 3,
                crossAxisSpacing: Sizes.size2,
                mainAxisSpacing: Sizes.size2,
                childAspectRatio: 9 / 16,
              ),
              // 웹에서 이미지를 가져오는동안 placeholder를 띄워준다
              itemBuilder: (context, index) => Stack(
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
                  Positioned(
                    bottom: Sizes.size4,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.play_arrow_outlined,
                          color: Colors.white,
                          size: Sizes.size20,
                        ),
                        Gaps.h3,
                        Text(
                          "4.1M",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Center(
              child: Text("Page two"),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.amount,
    required this.item,
  }) : super(key: key);

  final String amount;
  final String item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          item,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
