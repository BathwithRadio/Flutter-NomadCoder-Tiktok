import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoint.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

final tabs = ['Top', 'Users', 'Videos', 'Sounds', 'LIVE', 'Shopping', 'Brands'];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  bool _isWriting = false;
  final TextEditingController _textEditingController = TextEditingController();

  late String currentTap;

  void _onSearchChanged(String value) {
    print("Searching form $value");
  }

  void _onSearchSubmitted(String value) {
    print("Submitted value $value");
  }

  void _onStopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      // Controller.clear 로 textfield를 비울 수 있다
      _textEditingController.clear();
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _onBackToMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainNavigatoinScreen(),
      ),
      (route) {
        return false;
      },
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          // default controller setting
          final tabController = DefaultTabController.of(context)!;
          tabController.addListener(() {
            if (tabController.indexIsChanging) {
              FocusScope.of(context).unfocus();
            }
          });
          return Scaffold(
            // 키보드 올라올 때 리사이즈 해제
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 1,
              title: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.sm,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _onBackToMain,
                      child: const FaIcon(
                        FontAwesomeIcons.angleLeft,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.h10,
                    Expanded(
                      child: SizedBox(
                        // 텍스트 박스 높이 변경은 이런방식밖에 지원되지 않는다.
                        height: Sizes.size44,
                        child: TextField(
                          controller: _textEditingController,
                          onTap: _onStartWriting,
                          expands: true,
                          minLines: null,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: Sizes.size14,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    size: Sizes.size20,
                                    color: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                            hintText: "Search",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Sizes.size12,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size12,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                right: Sizes.size14,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isWriting)
                                    GestureDetector(
                                      onTap: _onStopWriting,
                                      child: FaIcon(
                                        FontAwesomeIcons.solidCircleXmark,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  Gaps.h8,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gaps.h10,
                    FaIcon(
                      FontAwesomeIcons.server,
                      color: Colors.grey.shade900,
                    ),
                  ],
                ),
              ),
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
            body: TabBarView(
              children: [
                // builder 가 children을 양산하는 것 보다 성능이 더 좋다
                GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: 20,
                  padding: const EdgeInsets.all(
                    Sizes.size6,
                  ),
                  // help you configure grid view
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // how many colums you have
                    crossAxisCount: width > Breakpoints.lg ? 5 : 2,
                    crossAxisSpacing: Sizes.size10,
                    mainAxisSpacing: Sizes.size10,
                    childAspectRatio: 9 / 20,
                  ),
                  // 웹에서 이미지를 가져오는동안 placeholder를 띄워준다
                  itemBuilder: (context, index) => LayoutBuilder(
                    builder: (context, constraint) => Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Sizes.size4,
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.fitHeight,
                              placeholder: "assets/images/placeholder.jpg",
                              image:
                                  "https://images.unsplash.com/photo-1677549254885-cf55be3e552b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
                            ),
                          ),
                        ),
                        Gaps.v10,
                        Text(
                          "${constraint.maxWidth}This is a very long caption for my ticktok so I'm uploading no currently.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: Sizes.size16 + Sizes.size2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.v8,
                        if (constraint.maxWidth < 200 ||
                            constraint.maxWidth > 250)
                          DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                      "https://avatars.githubusercontent.com/u/86900125?v=4"),
                                ),
                                Gaps.h4,
                                const Expanded(
                                  child: Text(
                                    "My avatar is gonna be very long!!",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: Sizes.size16,
                                  color: Colors.grey.shade600,
                                ),
                                Gaps.h2,
                                const Text("2.5M")
                              ],
                            ),
                          )
                      ],
                    ),
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
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
