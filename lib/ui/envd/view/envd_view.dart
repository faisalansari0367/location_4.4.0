import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/envd/models/envd_model.dart';
import 'package:background_location/ui/envd/view/envd_list_item.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../cubit/graphql_query_strings.dart';

class EnvdView extends StatelessWidget {
  const EnvdView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('eNVDs'),
      ),
      // backgroundColor: Colors.grey.shade100,
      // body: Consumer<EnvdCubit>(
      //   builder: (context, cubit, child) {
      //     if (cubit.baseState.isLoading) {
      //       return const Center(
      //         child: CircularProgressIndicator.adaptive(),
      //       );
      //     }
      //     // return cubit.state.when(
      //     //   loading: () => const Center(child: CircularProgressIndicator()),
      //     //   data: (data) => _buildBody(data),
      //     //   error: (error) => Center(child: Text(error)),
      //     // );
      //     return ListView.separated(
      //       padding: kPadding,
      //       separatorBuilder: (context, index) => const SizedBox(height: 10),
      //       itemCount: cubit.items.length,
      //       itemBuilder: (context, index) {
      //         return EnvdListItem(items: cubit.items.elementAt(index));
      //       },
      //     );
      //   },
      // ),

      body: Query(
        options: QueryOptions(
          document: gql(GraphQlQueryStrings.envdQuery),
          // this is the query string you just created
          // pollInterval: const Duration(seconds: 10),
        ),
        builder: _builder,
      ),
    );
  }

  Widget _builder(QueryResult<Object?> result, {FetchMore<Object?>? fetchMore, Refetch<Object?>? refetch}) {
    if (result.hasException) {
      return SingleChildScrollView(
        child: Text(result.exception.toString()),
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
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return EnvdListItem(items: list.elementAt(index));
      },
    );
  }
}