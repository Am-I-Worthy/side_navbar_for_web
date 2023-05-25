import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Model to handle hover states..
class NavBarModel extends ChangeNotifier {
  List<String> titles = ['About', 'Portfolio', 'Services', 'Contact'];
  String? hoveredTitle;

  void setHoveredTitle(String? title) {
    hoveredTitle = title;
    notifyListeners();
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  bool isSideNavOpen = false;

  late AnimationController animationController;
  late Animation<double> iconAnimation;

  NavBarModel navBar = NavBarModel();

  double navBarSize = 300.0;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));
    iconAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: navBarSize,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
            left: isSideNavOpen ? 0.0 : -navBarSize,
            child: AnimatedOpacity(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
              opacity: isSideNavOpen ? 1.0 : 0.0,
              child: AnimatedContainer(
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
                height: MediaQuery.of(context).size.height,
                width: navBarSize,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.horizontal(
                      right: Radius.elliptical(isSideNavOpen ? 0.0 : navBarSize,
                          MediaQuery.of(context).size.height / 2)),
                ),
                child: SizedBox(
                  child: ListenableBuilder(
                      listenable: navBar,
                      builder: (context, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: navBar.titles.map<Widget>((title) {
                            return MouseRegion(
                              key: ValueKey(title),
                              onEnter: (value) {
                                navBar.setHoveredTitle(title);
                              },
                              onExit: (value) {
                                navBar.setHoveredTitle(null);
                              },
                              child: SizedBox(
                                width: navBarSize - 70.0,
                                child: EntryAnimation(
                                  isTriggered: isSideNavOpen,
                                  delay: navBar.titles.indexOf(title) * 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AnimatedDefaultTextStyle(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        style: navBar.hoveredTitle == null
                                            ? GoogleFonts.comfortaa(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w500,
                                              )
                                            : navBar.hoveredTitle == title
                                                ? GoogleFonts.comfortaa(
                                                    color: Colors.white,
                                                    fontSize: 24.0,
                                                    fontWeight: FontWeight.w500,
                                                  )
                                                : GoogleFonts.comfortaa(
                                                    color: Colors.white60,
                                                    fontSize: 24.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                        child: Text(
                                          title,
                                        ),
                                      ),
                                      AnimatedContainer(
                                        margin: const EdgeInsets.only(
                                            top: 5.0, bottom: 30.0),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: 3.0,
                                        width: navBar.hoveredTitle == title
                                            ? 280.0
                                            : 0.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
            width: 50.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSideNavOpen = !isSideNavOpen;
                    if (isSideNavOpen) {
                      animationController.forward();
                    } else {
                      animationController.reverse();
                    }
                  });
                },
                child: Center(
                  child: AnimatedIcon(
                    progress: iconAnimation,
                    icon: AnimatedIcons.menu_close,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Entry animation for NavBarElements, you can reuse it
/// to anywidget to make its entry animated.
class EntryAnimation extends StatefulWidget {
  final int delay;
  final Widget child;
  final bool isTriggered;
  const EntryAnimation(
      {super.key,
      required this.delay,
      required this.child,
      required this.isTriggered});

  @override
  State<EntryAnimation> createState() => _EntryAnimationState();
}

class _EntryAnimationState extends State<EntryAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTriggered) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        animationController.forward();
      });
    } else {
      animationController.reverse().then((value) {
        animationController.reset();
      });
    }
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: Alignment(-(2.0 - animation.value), 0.0),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
