import 'package:animations/animations.dart';
import 'package:api_repo/api_repo.dart';
import 'package:background_location/features/drawer/models/drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../cubit/my_drawer_controller.dart';
import 'widgets/drawer_menu.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 500);
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _slideTransition;

  late Animation<double> _borderRadius;
  late Animation<double> _scaleAnimation;
  late DrawerItems drawerItems;

  void initController() {
    final drawer = context.read<DrawerCubit>();
    drawerItems = DrawerItems(context.read<Api>(), drawer: drawer);
    _controller = AnimationController(vsync: this, duration: duration);
    final curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(curvedAnimation);
    _slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(curvedAnimation);
    _slideTransition = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.7, 0)).animate(curvedAnimation);
    _borderRadius = Tween<double>(begin: 0, end: 25).animate(_controller);

    // borderradius tween
    // _borderRadius = Tween<double>(begin: 0.0, end: 25.0).animate(curvedAnimation);
    drawer.setController(_controller);
    if (context.read<Api>().getUserData() != null) {
      // drawer.setSelectedPage(2);
      
    }
  }

  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // MyConnectivity(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // MyConnectivity.subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawer = context.read<DrawerCubit>();

    return Scaffold(
      body: WillPopScope(
        onWillPop: drawer.goBackToHome,
        child: Stack(
          children: [
            Container(
              // color: Color.fromARGB(255, 72, 124, 255),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.theme.primaryColor,
                    const Color.fromARGB(255, 146, 154, 244),
                  ],
                ),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SlideTransition(
                    position: _slideAnimation,
                    child: child,
                  );
                },
                child: Selector<DrawerCubit, int>(
                  selector: (p0, p1) => p1.selectedIndex,
                  builder: (context, value, child) => DrawerMenu(
                    // items: drawerItems.items,
                    selectedIndex: drawer.selectedIndex,
                    onItemSelected: (page) {
                      drawer.closeDrawer();
                      drawer.setSelectedPage(page);
                      // if (page == null) return;
                      // Get.to(page, transition: Transition.cupertino);
                    },
                  ),
                ),
              ),
            ),
            // DrawerMenu(),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return ScaleTransition(
                  scale: _scaleAnimation,
                  child: SlideTransition(
                    position: _slideTransition,
                    child: child,
                  ),
                );
              },
              child: Selector<DrawerCubit, bool>(
                selector: (context, state) => state.isOpen,
                builder: (context, value, child) {
                  return GestureDetector(
                    onTap: value ? drawer.closeDrawer : null,
                    child: AbsorbPointer(
                      absorbing: value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.5),
                        blurRadius: 100, // soften the shadow
                        spreadRadius: 1, //extend the shadow
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _borderRadius,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(_borderRadius.value),
                        child: child,
                      );
                    },
                    child: Selector<DrawerCubit, int>(
                      selector: (p0, p1) => p1.selectedIndex,
                      builder: _builder,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builder(BuildContext context,int value,Widget? child) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: drawerItems.items.elementAt(value).page,
    );
  }

}
