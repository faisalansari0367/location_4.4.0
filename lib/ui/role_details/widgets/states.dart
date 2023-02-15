import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:flutter/material.dart';

class States extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool Function(String)? filterStates;
  final String? header;

  const States({
    super.key,
    required this.onChanged,
    this.filterStates,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    // final states = ['ACT', 'VIC', 'NSW', 'QLD', 'NT', 'WA', 'TAS', 'SA'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          header ?? Strings.selectState,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...states(context).map(
          (e) => ListTile(
            onTap: () {
              onChanged(e);
            },
            title: Text(
              e,
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }

  List<String> states(BuildContext context) {
    final states = ['ACT', 'VIC', 'NSW', 'QLD', 'NT', 'WA', 'TAS', 'SA'];
    states.sort((a, b) => a.compareTo(b));
    if (filterStates != null) {
      return states.where(filterStates!).toList();
    }

    if (context.read<Api>().getUserData()?.role == 'Government') {
      states.add('ALL');
    }

    return states;
  }
}
