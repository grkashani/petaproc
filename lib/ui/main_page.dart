import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petaproc/ui/notifications/notifications_page.dart';
import 'package:petaproc/ui/post/post_page.dart';
import 'package:petaproc/ui/widgets/drawer_widget.dart';
import 'package:petaproc/ui/home/home_page.dart';
import 'package:petaproc/providers/my_providers.dart';
import '../core/constant/constants.dart';
import '../core/themes/styles.dart';
import '../providers/menu_app_ontroller.dart';
import '../zetaproc/widgets/app_bar_widget.dart';
import 'jobs/jobs_page.dart';
import 'network/network_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  Widget getPage(MainPageState mainPageState) {
    switch (mainPageState) {
      case MainPageState.home:
        return const HomePage();
      case MainPageState.network:
        return const NetworkPage();
      case MainPageState.post:
        return const PostPage();
      case MainPageState.notifications:
        return const NotificationsPage();
      case MainPageState.jobs:
        return const JobsPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainPageState = ref.watch(MyPrividers.mainPageProvider).mainPageState;
    final isNotification = mainPageState == MainPageState.home;
    return Scaffold(
      drawer:  isNotification? null:const DrawerWidget(),
      key: ref.watch(menuAppController).scaffoldState,
      appBar: isNotification? null: appBarWidget(
        context: context,
        ref: ref,
        title: mainPageState == MainPageState.jobs ? "Search Jobs" : "Search",
        isJobsTab: mainPageState == MainPageState.jobs,
        onLeadingTapClickListener: () {
          if (ref.watch(menuAppController).scaffoldState.currentState != null) {
            ref.watch(menuAppController).scaffoldState.currentState!.openDrawer();
          }
        },
      ),

      body: getPage(mainPageState),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: linkedInBlack000000,
        selectedLabelStyle: const TextStyle(color: linkedInBlack000000),
        unselectedItemColor: linkedInMediumGrey86888A,
        unselectedLabelStyle: const TextStyle(color: linkedInMediumGrey86888A),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userGroup),
            label: "Network",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              size: 30,
            ),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              size: 30,
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.briefcase),
            label: "Jobs",
          ),
        ],
        onTap: (index) {
          switch (index){
            case 0:
              ref.read(MyPrividers.mainPageProvider).updateMainState(MainPageState.home);
            case 1:
              ref.read(MyPrividers.mainPageProvider).updateMainState(MainPageState.network);
            case 2:
              ref.read(MyPrividers.mainPageProvider).updateMainState(MainPageState.post);
            case 3:
              ref.read(MyPrividers.mainPageProvider).updateMainState(MainPageState.notifications);
            default:
              ref.read(MyPrividers.mainPageProvider).updateMainState(MainPageState.jobs);

          }
        },
      ),
    );
  }
}
