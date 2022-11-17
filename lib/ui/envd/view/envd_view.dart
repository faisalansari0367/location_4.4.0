import 'dart:io';

import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/envd/view/envd_list_item.dart';
import 'package:background_location/widgets/dialogs/error.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../cubit/graphql_query_strings.dart';
import '../models/envd_model.dart';

class EnvdView extends StatefulWidget {
  const EnvdView({Key? key}) : super(key: key);

  @override
  State<EnvdView> createState() => _EnvdViewState();
}

class _EnvdViewState extends State<EnvdView> {
  var list = <Items>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('eNVDs'),
        elevation: 3,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/export.png',
              width: 30,
            ),
            onPressed: () {
              generateEnvdCSV();
              // context.read<GraphQLClient>().cache.reset();
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(GraphQlQueryStrings.envdQuery),
        ),
        builder: _builder,
      ),
    );
  }

  Widget _builder(QueryResult<Object?> result, {FetchMore<Object?>? fetchMore, Refetch<Object?>? refetch}) {
    if (result.hasException) {
      return SingleChildScrollView(
        child: Padding(
          padding: kPadding,
          child: ErrorDialog(
            message: result.exception.toString(),
            showCloseButton: false,
            onTap: () {},
          ),
        ),
      );
    }
    print(result.exception);

    if (result.isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    if (result.isNotLoading) {
      print(result.data);
    }
    // var list = <Items>[];
    if (result.data != null) {
      try {
        final consignments = Consignments.fromJson(result.data!['consignments']);
        list = consignments.items ?? [];
      } catch (e) {
        print(e);
      }
    }

    return ListView.separated(
      padding: kPadding,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: list.length,
      itemBuilder: (context, index) => EnvdListItem(items: list[index]),
    );
  }

  Future<void> generateEnvdCSV() async {
    final headers = [
      'Consignment',
      'Created',
      'From PIC',
      'To PIC',
      'Species',
      'Breed',
      'Quantity',
      'Accreditations',
      'Transporter',
      'Status'
    ];
    final newHeaders = headers.map((e) => e.toUpperCase()).toList();
    final rows = list
        .map(
          (item) => [
            item.number ?? '',
            item.createdAt(),
            item.fromPIC,
            item.toPIC,
            item.species ?? '',
            '',
            item.getQuantity(),
            item.getAccredentials(),
            item.transporter,
            item.status ?? '',
          ],
        )
        .toList();
    rows.insert(0, newHeaders);
    final data = await ListToCsvConverter().convert(rows);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/envd_csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(data);

    await Share.shareFiles([(file.path)]);
    // exportCSV.myCSV(newHeaders, rows);
  }
}
