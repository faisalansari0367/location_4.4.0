import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/geofence_delegation/provider/provider.dart';
import 'package:flutter/material.dart';

/// {@template geofence_delegation_body}
/// Body of the GeofenceDelegationPage.
///
/// Add what it does
/// {@endtemplate}
class GeofenceDelegationBody extends StatelessWidget {
  /// {@macro geofence_delegation_body}
  const GeofenceDelegationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeofenceDelegationNotifier>(
      builder: (context, state, child) {
        return SingleChildScrollView(
          padding: kPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _storyBox(context),
              const SizedBox(height: 20),
              _assignGeofencesFunctions(context, state),
              const SizedBox(height: 20),
              // MyElevatedButton(
              //   text: 'Show delegated users',

              // ),
              if (state.isTemporaryOwner)
                Container(
                  padding: kPadding,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: kBorderRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delegated users',
                        style: context.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email: ${state.temporaryOwnerEmail}',
                            style: context.textTheme.headline6,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Start date: ${state.delegationStartDate}',
                            style: context.textTheme.headline6,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'End date: ${state.delegationEndDate}',
                            style: context.textTheme.headline6,
                          ),
                          const SizedBox(height: 20),
                          MyElevatedButton(
                            text: 'Remove delegation',
                            color: Colors.red,
                            onPressed: state.removeTemporaryOwner,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _storyBox(BuildContext context) {
    return Container(
      padding: kPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: kBorderRadius,
      ),
      child: Text(
        '''This feature is designed to assign authority for another registered company user to '''
        '''have access to the ownership functions of the managers created geofences. '''
        '''This includes live NOTIFICATIONS of movements In and Out of each geofence, and access to the logbook data records.''',
        style: context.textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _assignGeofencesFunctions(
    BuildContext context,
    GeofenceDelegationNotifier state,
  ) {
    return Container(
      padding: kPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: kBorderRadius,
      ),
      child: Form(
        key: state.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assign geofences functions',
              style: context.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Assign ',
            //         style: context.textTheme.headline6,
            //       ),
            //       TextSpan(
            //         text: state.email ?? '',
            //         style: context.textTheme.headline6?.copyWith(
            //           color: Color.fromARGB(255, 243, 33, 86),
            //         ),
            //       ),
            //       TextSpan(
            //         text: ' to the geofences functions',
            //         style: context.textTheme.headline6,
            //       ),
            //     ],
            //   ),
            // ),

            // Text(
            //   'Assign  to the geofence \'My Geofence\' functions',
            //   style: context.textTheme.headline6,
            // ),
            const SizedBox(height: 20),

            EmailField(
              onChanged: state.setEmail,
              inputDecoration: const InputDecoration(
                labelText: 'Email',
                suffixIcon: Icon(Icons.email_outlined),
                filled: true,
              ),
            ),
            const SizedBox(height: 10),

            // MyDateField(label: 'Assign for a period of:'),
            MyDateField(
              label: 'Select Start Date',
              // filled decoration form field
              // generate decoration form field
              onChanged: state.setStartDate,
              date: state.state.startDate.toIso8601String(),

              decoration: const InputDecoration(
                labelText: 'Start Date',
                // border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.date_range),
                filled: true,
              ),
              // filled: true,

              // validator: (s) => Validator.date(DateTime.tryParse(s!)),
              validator: (s) => state.startDateValidator(),
            ),
            const SizedBox(height: 10),
            MyDateField(
              label: '',
              onChanged: state.setEndDate,
              date: state.state.endDate?.toIso8601String(),
              decoration: const InputDecoration(
                labelText: 'End Date',
                // border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.date_range),
                filled: true,
              ),
              validator: (s) => state.endDateValidator(s),
            ),
            const SizedBox(height: 10),

            MyElevatedButton(
              text: 'Assign',
              onPressed: state.delegateGeofence,
            ),

            // const SizedBox(height: 20),
            // Text(
            //   'The user has been successfully assigned to the geofence',
            //   style: context.textTheme.headline6,
            // ),
          ],
        ),
      ),
    );
  }
}
