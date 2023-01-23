import 'package:bioplus/constants/index.dart';
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
          style: context.textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...states()
            .map(
              (e) => ListTile(
                contentPadding: const EdgeInsets.symmetric(),
                onTap: () {
                  onChanged(e);
                },
                title: Text(
                  e,
                  style: context.textTheme.subtitle1?.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList()
      ],
    );
  }

  List<String> states() {
    final states = ['ACT', 'VIC', 'NSW', 'QLD', 'NT', 'WA', 'TAS', 'SA'];
    states.sort((a, b) => a.compareTo(b));
    if (filterStates != null) {
      return states.where(filterStates!).toList();
    }
    states.add('ALL');
    return states;
  }
}
