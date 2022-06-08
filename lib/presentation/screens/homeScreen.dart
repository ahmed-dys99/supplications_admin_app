import 'package:flutter/material.dart';
import 'package:supplications_admin_app/presentation/screens/addCategoryScreen.dart';
import 'package:supplications_admin_app/presentation/widgets/homeCategories.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF2f2f2),
      appBar: AppBar(title: const Text('Admin App'), centerTitle: true, elevation: 1),
      body: const HomeCategories(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) => const AddCategoryScreen())),
        ),
      ),
    );
  }
}
