import 'package:background_location/ui/envd/cubit/envd_cubit.dart';
import 'package:background_location/ui/envd/cubit/graphql_client.dart';
import 'package:background_location/ui/envd/view/envd_view.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EnvdPage extends StatelessWidget {
  const EnvdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQlClient().client,
      child: ChangeNotifierProvider(
        create: (context) => EnvdCubit(context),
        child: EnvdView(),
      ),
    );
  }
}
