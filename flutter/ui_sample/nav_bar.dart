import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jointheway/screens/feeds.dart';

import '../screens/map.dart';
import '../shared/colors.dart';
import '../shared/text_styles.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

enum Page { feeds, map, chat }

class _NavBarState extends State<NavBar> {
  ScrollController scrollController = ScrollController();
  double _previousOffset = 0;
  bool showNav = true;
  Page selectedPage = Page.feeds;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double currentOffset = scrollController.offset;
      if (_previousOffset > currentOffset + 1 && !showNav) {
        setState(() {
          showNav = true;
        });
      }
      if (_previousOffset < currentOffset - 1 && showNav) {
        setState(() {
          showNav = false;
        });
      }
      _previousOffset = currentOffset;
    });
  }

  Widget pageShow() {
    if (selectedPage == Page.map)
      return MapPage();
    else
      return FeedsPage();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Material(
        child: SafeArea(
          child: Stack(
            children: [
              pageShow(),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: showNav
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: EdgeInsets.all(3),
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                color: AppColors.primaryDarker.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                option(
                                  icon: Icons.view_day_outlined,
                                  label: "Feeds",
                                  selected: true,
                                  page: Page.feeds,
                                ),
                                option(
                                  icon: Icons.public,
                                  label: "Map",
                                  selected: false,
                                  page: Page.map,
                                ),
                                option(
                                  icon: Icons.textsms_outlined,
                                  label: "Chat",
                                  selected: false,
                                  page: Page.chat,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget option({
    required IconData icon,
    required String label,
    required bool selected,
    required Page page,
  }) {
    return selectedPage == page
        ? Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColors.primaryDarker,
              ),
            ),
          )
        : Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedPage = page;
                });
              },
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Icon(
                  icon,
                  size: 24,
                  color: AppColors.neutralWhite,
                ),
              ),
            ),
          );
  }
}
