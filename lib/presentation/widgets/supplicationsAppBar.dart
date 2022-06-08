import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplications_admin_app/logic/supplications/supplications_bloc.dart';

class SupplicationsAppBar extends StatelessWidget with PreferredSizeWidget {
  const SupplicationsAppBar({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 22),
        onPressed: () {
          context.read<SupplicationsBloc>().add(SupplicationsCloseEvent());
          Navigator.of(context).pop();
        },
      ),
      title: Text(category, style: const TextStyle(fontSize: 17)),
      centerTitle: false,
      titleSpacing: 4,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
