import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  final ScrollController scrollController;

  const HomeAppBar({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  _listener() {
    if (widget.scrollController.offset > 100) {
      paddingCollapsed.value = true;
    } else {
      paddingCollapsed.value = false;
    }
  }

  ValueNotifier paddingCollapsed = ValueNotifier(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.scrollController.addListener(_listener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      elevation: 1,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu, color: Colors.white, size: 22),
      ),
      flexibleSpace: ValueListenableBuilder(
        valueListenable: paddingCollapsed,
        builder: (context, value, child) {
          return FlexibleSpaceBar(
            centerTitle: true,
            title: Text("Supplications", style: TextStyle(color: (value == true) ? Colors.transparent : Colors.white, fontSize: 20.0)),
            expandedTitleScale: 1.25,
            titlePadding: const EdgeInsets.only(bottom: 30),
            background: child,
          );
        },
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mosque.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcOver),
            ),
          ),
        ),
      ),
    );
  }
}
