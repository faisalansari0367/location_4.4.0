import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/envd/cubit/envd_cubit.dart';
import 'package:bioplus/ui/envd/cubit/graphql_client.dart';
import 'package:bioplus/ui/envd/view/envd_view.dart';
import 'package:bioplus/ui/pic/widgets/pic_card.dart';
import 'package:bioplus/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EnvdPage extends StatelessWidget {
  const EnvdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = EnvdCubit(context);
    return ChangeNotifierProvider.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('eNVDs'),
          elevation: 3,
        ),
        // body:  _listPics(context, model.picsStream),
        body: _handleStates(context, model),
      ),
    );
    // return GraphQLProvider(
    //   client: GraphQlClient().client,
    //   child: ChangeNotifierProvider(
    //     create: (context) => EnvdCubit(context),
    //     child: const EnvdView(),
    //   ),
    // );
  }

  Widget _listPics(BuildContext context, Stream<List<PicModel>> picsStream) {
    return StreamBuilder<List<PicModel>>(
      stream: picsStream,
      builder: (context, state) {
        if (state.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (state.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.data?.isEmpty ?? true) {
          return const Center(
            child: Text('No data'),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          padding: kPadding,
          itemCount: state.data?.length ?? 0,
          itemBuilder: (context, index) {
            final picModel = state.data![index];
            return PicCard(
              onTap: () async {
                final graphQl = GraphQlClient(
                  username: picModel.lpaUsername,
                  password: picModel.lpaPassword,
                );

                final isValidated = await graphQl.validateCreds(picModel);
                if (!isValidated) return;

                Get.to(
                  () => GraphQLProvider(
                    client: GraphQlClient(
                      username: picModel.lpaUsername,
                      password: picModel.lpaPassword,
                    ).client,
                    child: ChangeNotifierProvider(
                      create: (context) => EnvdCubit(context),
                      child: const EnvdView(),
                    ),
                  ),
                );
              },
              picModel: picModel,
            );
          },
        );
      },
    );
  }

  Widget _handleStates(BuildContext context, EnvdCubit model) {
    if (model.isVisitor) {
      return Padding(
        padding: kPadding,
        child: EmptyScreen(
          message: 'You are not able to view this page',
          subWidget: Padding(
            padding: kPadding,
            child: Text(
              'You need to upgrade to a Property subscription for this feature.',
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else {
      return _listPics(context, model.picsStream);
    }
  }
}
