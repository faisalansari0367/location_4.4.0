import 'package:bioplus/ui/envd/cubit/envd_cubit.dart';
import 'package:bioplus/ui/envd/cubit/graphql_client.dart';
import 'package:bioplus/ui/envd/view/envd_view.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EnvdPage extends StatelessWidget {
  const EnvdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQlClient().client,
      child: ChangeNotifierProvider(
        create: (context) => EnvdCubit(context),
        child: const EnvdView(),
      ),
    );
  }
}
