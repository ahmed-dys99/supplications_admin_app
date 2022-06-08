import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplications_admin_app/data/models/supplication.dart';
import 'package:supplications_admin_app/logic/audio/audio_bloc.dart';
import 'package:supplications_admin_app/logic/supplications/supplications_bloc.dart';
import 'package:supplications_admin_app/presentation/screens/addSupplicationScreen.dart';
import 'package:supplications_admin_app/presentation/widgets/justAudioWidget.dart';
import 'package:supplications_admin_app/presentation/widgets/supplicationsAppBar.dart';
import 'package:supplications_admin_app/presentation/widgets/supplicationsCard.dart';

class SupplicationsListScreen extends StatelessWidget {
  final String category;
  final String categoryId;

  const SupplicationsListScreen({Key? key, required this.category, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2f2f2),
      appBar: SupplicationsAppBar(category: category),
      body: BlocBuilder<SupplicationsBloc, SupplicationsState>(
        builder: (context, state) {
          if (state is SupplicationsLoadedState) {
            if (state.supplications.isEmpty) {
              return const Center(child: Text('Nothing availaible for this category yet.'));
            }
            final List<Supplication> _supplications = state.supplications;
            _supplications.sort((a, b) => b.index.compareTo(a.index));

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: _supplications.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0 || index == _supplications.length + 1) {
                    return const SizedBox(height: 25);
                  }
                  return SupplicationCard(supplication: _supplications[index - 1]);
                },
              ),
            );
          }
          if (state is SupplicationsFailedState) {
            return const Center(child: Text('Please check your internet connection and try again later.'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (BuildContext context) => AddSupplicationScreen(categoryId: categoryId)),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<AudioBloc, AudioState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: const [
                BoxShadow(offset: Offset(0, -1), color: Colors.black26, blurRadius: 5),
              ],
            ),
            height: (state is AudioStartedState) ? 300 : 0,
            child: (state is AudioStartedState) ? JustAudioWidget(url: state.url) : const JustAudioWidget(url: ""),
          );
        },
      ),
    );
  }
}
