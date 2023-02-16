import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:bioplus/ui/envd/cubit/envd_cubit.dart';
// import 'package:bioplus/ui/envd/models/envd_model.dart';
import 'package:bioplus/ui/envd/view/envd_list_item.dart';
import 'package:bioplus/widgets/empty_screen.dart';
import 'package:bioplus/widgets/fetching_screen.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class EnvdView extends StatefulWidget {
  const EnvdView({super.key});

  @override
  State<EnvdView> createState() => _EnvdViewState();
}

class _EnvdViewState extends State<EnvdView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('eNVDs'),
        elevation: 3,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/export.png',
              width: 30,
            ),
            onPressed: context.read<EnvdCubit>().generateCsv,
          ),
        ],
      ),
      body: Consumer<EnvdCubit>(
        // stream: context.read<EnvdCubit>().picsStream,
        // builder: _builder,
        builder: (context, value, child) {
          return AnimatedSwitcher(
            duration: kDuration,
            child: _handleState(value),
          );
        },
      ),
    );
  }

  ListView _buildList(EnvdCubit value) {
    return ListView.separated(
      padding: kPadding,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: value.consignments.length,
      itemBuilder: (context, index) => EnvdListItem(
        items: value.consignments[index],
      ),
    );
  }

  Widget _handleState(EnvdCubit value) {
    if (value.isLoading) {
      return const FetchingScreen();
    }

    if (value.consignments.isEmpty) {
      return const Center(
        child: EmptyScreen(
          message: 'No Records Found',
        ),
      );
    }

    return _buildList(value);
  }
}
