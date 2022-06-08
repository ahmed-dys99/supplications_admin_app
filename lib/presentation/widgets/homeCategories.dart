import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supplications_admin_app/logic/categories/categories_bloc.dart';
import 'package:supplications_admin_app/logic/categories_upload/categories_upload_bloc.dart';
import 'package:supplications_admin_app/logic/supplications/supplications_bloc.dart';
import 'package:supplications_admin_app/presentation/screens/addCategoryScreen.dart';
import 'package:supplications_admin_app/presentation/screens/supplicationsListScreen.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({Key? key}) : super(key: key);

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  Offset? _tapDownPosition;

  _openEdit(String categoryId) {
    Future.delayed(
      const Duration(seconds: 0),
      () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) => AddCategoryScreen(categoryId: categoryId)),
      ),
    );
  }

  _openDelete(String categoryId) {
    Future.delayed(
      const Duration(seconds: 0),
      () => showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Are you sure want to delete this category?', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                SizedBox(height: 16),
                Text('All duas for this category will also be deleted', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
              ],
            ),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('No')),
              TextButton(
                onPressed: () {
                  context.read<CategoriesUploadBloc>().add(CategoriesUploadDeleteEvent(categoryId: categoryId));
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesInitialState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CategoriesFetchedState) {
          state.categories.sort(((a, b) => a.index.compareTo(b.index)));

          return SafeArea(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
              itemCount: state.categories.length,
              padding: const EdgeInsets.only(left: 25, right: 25, top: 35, bottom: 40),
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTapDown: (details) => _tapDownPosition = details.globalPosition,
                  child: Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey, width: 0.2),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        context.read<SupplicationsBloc>().add(SupplicationsOpenEvent(categoryId: state.categories[index].categoryId));
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SupplicationsListScreen(
                              category: state.categories[index].name,
                              categoryId: state.categories[index].categoryId,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        final RenderBox? overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            _tapDownPosition!.dx,
                            _tapDownPosition!.dy,
                            overlay!.size.width - _tapDownPosition!.dx,
                            overlay.size.height - _tapDownPosition!.dy,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          items: [
                            PopupMenuItem(
                              onTap: () {
                                _openEdit.call(state.categories[index].categoryId);
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.edit, size: 22, color: Color(0xFF666666)),
                                  SizedBox(width: 8),
                                  Text("Edit", style: TextStyle(color: Color(0xFF666666), fontSize: 15)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                _openDelete.call(state.categories[index].categoryId);
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.delete, size: 22, color: Color(0xFF666666)),
                                  SizedBox(width: 8),
                                  Text("Delete", style: TextStyle(color: Color(0xFF666666), fontSize: 15)),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CachedNetworkImage(
                              imageUrl: state.categories[index].image,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              width: 60,
                            ),
                            const SizedBox(),
                            Text(
                              state.categories[index].name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF484848), fontSize: 14, fontWeight: FontWeight.w500, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: Text('Please check your internet connection and try again later.'));
      },
    );
  }
}
