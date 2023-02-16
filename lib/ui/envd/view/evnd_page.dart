import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/envd/cubit/envd_cubit.dart';
import 'package:bioplus/ui/pic/widgets/pic_card.dart';
import 'package:bioplus/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnvdPage extends StatefulWidget {
  const EnvdPage({super.key});

  @override
  State<EnvdPage> createState() => _EnvdPageState();
}

class _EnvdPageState extends State<EnvdPage> {
  late EnvdCubit cubit;
  @override
  void initState() {
    cubit = EnvdCubit(context);
    cubit.api.getPics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('eNVDs'),
          elevation: 3,
        ),
        body: _handleStates(context, cubit),
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

        return _buildPIc(state);
      },
    );
  }

  ListView _buildPIc(AsyncSnapshot<List<PicModel>> state) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      padding: kPadding,
      itemCount: state.data?.length ?? 0,
      itemBuilder: (context, index) {
        final picModel = state.data![index];
        return PicCard(
          picModel: picModel,
          onTap: () async {
            final model = EnvdCubit(context);
            model.onPicSelect(picModel);
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
