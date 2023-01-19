import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/provider/provider.dart';
import 'package:bioplus/ui/role_details/widgets/states.dart';
import 'package:bioplus/widgets/my_listTile.dart';
import 'package:flutter/material.dart';

/// {@template livestock_waybill_body}
/// Body of the LivestockWaybillPage.
///
/// Add what it does
/// {@endtemplate}
class LivestockWaybillBody extends StatelessWidget {
  /// {@macro livestock_waybill_body}
  const LivestockWaybillBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LivestockWaybillNotifier>(
      builder: (context, state, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: kPadding,
              child: _buildHeader(state, context),
            ),
            Expanded(child: _buildStates(state)),
          ],
        );
      },
    );
  }

  Widget _buildStates(LivestockWaybillNotifier state) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: state.pdfs.keys.length,
      padding: kPadding,
      itemBuilder: (context, index) {
        final item = state.pdfs.keys.elementAt(index);
        return MyListTile(
          text: item.toUpperCase(),
          onTap: () async => state.selectState(item),
        );
      },
    );
  }

  States _selectState(LivestockWaybillNotifier state) {
    return States(
      header: 'Please select origin state',
      onChanged: state.selectState,
      filterStates: (p0) => state.pdfs.keys
          .map((e) => e.toLowerCase())
          .contains(p0.toLowerCase()),
    );
  }

  Widget _buildBody(LivestockWaybillNotifier state) {
    return Container();
  }

  Text _buildHeader(LivestockWaybillNotifier state, BuildContext context) {
    return Text(
      'Please select Origin State',
      style: context.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
