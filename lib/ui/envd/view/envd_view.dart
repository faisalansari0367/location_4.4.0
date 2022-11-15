import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/envd/view/envd_list_item.dart';
import 'package:background_location/widgets/dialogs/error.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../cubit/graphql_query_strings.dart';
import '../models/envd_model.dart';

class EnvdView extends StatelessWidget {
  const EnvdView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('eNVDs'),
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
    var list = <Items>[];
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
}
