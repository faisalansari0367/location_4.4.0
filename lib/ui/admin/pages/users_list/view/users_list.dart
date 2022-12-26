import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/services/notifications/intent_service.dart';
import 'package:bioplus/theme/color_constants.dart';
import 'package:bioplus/ui/admin/pages/users_list/view/roles_sheet.dart';
import 'package:bioplus/widgets/dialogs/delete_dialog.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/expanded_tile.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

import '../../../../../widgets/bottom_sheet/bottom_sheet_service.dart';
import '../../../../../widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import '../../../../../widgets/text_fields/text_formatters/input_formatters.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class UsersView extends StatelessWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();
    return Scaffold(
      appBar: const MyAppBar(title: Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              children: [
                Gap(2.h),
                BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    return MyTextField(
                      onTap: () => BottomSheetService.showSheet(
                        child: RolesSheet(
                          title: 'Please select a role',
                          options: state.roles.map((e) => e.role).toList(),
                          onChanged: cubit.setCurrentRole,
                        ),
                      ),
                      inputFormatters: [CapitalizeAllInputFormatter()],
                      hintText: 'Select Role',
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      controller: TextEditingController(text: state.selectRole),
                      focusNode: AlwaysDisabledFocusNode(),
                    );
                  },
                ),
                Gap(10.h),
                BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    return MyTextField(
                      hintText: 'Search',
                      filled: true,
                      fillColor: kPrimaryColor.withOpacity(0.01),
                      prefixIcon: const Icon(Icons.search),
                      controller: cubit.state.controller,
                      autovalidateMode: AutovalidateMode.disabled,
                    );
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: BlocBuilder<UsersCubit, UsersState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Text(
                            'Search by',
                            style: TextStyle(
                              fontSize: 15.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          ...['First Name', 'Last Name', 'Property Name', 'Town', 'Pic']
                              .map(
                                (e) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: InputChip(
                                    selected: e == (state.filter ?? ''),
                                    backgroundColor: Colors.grey.shade200,
                                    selectedColor: context.theme.primaryColor.withOpacity(0.2),
                                    // elevation: 5,
                                    onPressed: () => cubit.setFilter(e),
                                    label: Text(e.replaceAll('_', ' ').capitalize!),
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // MyListView(),
          BlocBuilder<UsersCubit, UsersState>(
            builder: (_context, state) {
              return Expanded(
                child: InfiniteList(
                  onFetchData: () {},
                  separatorBuilder: (context) => Container(
                    height: 3.h,
                    color: Colors.grey.shade200,
                  ),
                  emptyBuilder: (context) => SizedBox(
                    width: 100.width,
                    height: 100.h,
                    child: Center(
                      child: Text(
                        'No Results Found',
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  isLoading: state.isLoading,
                  itemCount: state.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = state.users.elementAt(index);
                    return _userTile(context, item);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container _userTile(BuildContext context, UserData user) {
    return Container(
      child: ExpandedTile(
        title: Text(
          '${user.firstName!} ${user.lastName!}',
          style: context.textTheme.subtitle2?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(user.role ?? ''),
        trailing: const SizedBox.shrink(),
        children: [
          const Divider(),
          Row(
            children: [
              Icon(
                Icons.mail_outline,
                color: context.theme.primaryColor,
              ),
              Gap(10.w),
              InkWell(
                onTap: () => IntentService.emailIntent(user.email),
                child: Text(
                  user.email ?? '',
                  style: TextStyle(
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),

          Row(
            children: [
              // Text('Email')
              Icon(
                Icons.phone,
                // color: Colors.blueGrey,
                color: context.theme.primaryColor,
              ),
              Gap(10.w),
              InkWell(
                onTap: () => IntentService.dialIntent('${user.phoneNumber}'),
                child: Text(
                  '${user.countryCode} ${user.phoneNumber}',
                  style: TextStyle(
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              // Text('Email')
              const Text('PIC:'),
              Gap(10.w),
              Text(
                user.pic ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text('Delete User'),
              const Spacer(),
              IconButton(
                onPressed: () {
                  DialogService.showDialog(
                    child: DeleteDialog(
                      msg: 'Are you sure you want to delete this user?',
                      onConfirm: () => context.read<UsersCubit>().deleteUser(user.id!),
                      onCancel: Get.back,
                    ),
                  );
                },
                icon: Icon(Icons.delete_forever),
                color: Colors.red,
              ),
            ],
          ),

          // Text
          Row(
            children: [
              Text(
                'Status ',
                style: context.textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _StatusWidget(user: user),
            ],
          )
        ],
      ),
    );
  }
}

class _StatusWidget extends StatefulWidget {
  final UserData user;
  const _StatusWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<_StatusWidget> createState() => __StatusWidgetState();
}

class __StatusWidgetState extends State<_StatusWidget> {
  UserStatus selected = UserStatus.active;

  @override
  void initState() {
    selected = widget.user.status!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenu(
      options: UserStatus.values,
      onSelected: (s) async {
        final api = context.read<Api>();
        // final userData = api.getUserData();
        widget.user.status = s;

        final result = await api.updateStatus(userData: widget.user);
        result.when(
          success: (data) {
            final cubit = context.read<UsersCubit>();
            cubit.fetchUsers();
            setState(() => selected = s);
          },
          failure: (error) {
            DialogService.failure(error: error);
          },
        );
        // api.updateMe(user: api.user);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: MyDecoration.inputBorderRadius,
          color: selected.color,
        ),
        child: Row(
          children: [
            Text(
              selected.name.capitalize!,
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

// Widget _statusWidget(UserData user, UserStatus? status, BuildContext context) {
//   return PopupMenu(
//     child: Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.transparent),
//         borderRadius: MyDecoration.inputBorderRadius,
//         color: user.status!.color,
//       ),
//       child: Row(
//         children: [
//           Text(
//             'Active',
//             style: TextStyle(color: Colors.white),
//           ),
//           Icon(
//             Icons.keyboard_arrow_down_outlined,
//             color: Colors.white,
//           )
//         ],
//       ),
//     ),
//     options: UserStatus.values,
//     onSelected: (s) => setState(() => selected = s),
//     // onSelected: (s) => context.read<UsersCubit>().setStatus(s, user.id!),
//   );
// }

class PopupMenu<T> extends StatelessWidget {
  final List<UserStatus> options;
  final Widget? child;
  final Function(UserStatus)? onSelected;
  const PopupMenu({
    Key? key,
    this.options = const [],
    this.child,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<UserStatus>(
      itemBuilder: itemBuilder,
      shape: MyDecoration.dialogShape,
      onSelected: onSelected,
      padding: EdgeInsets.zero,
      child: child,
    );
  }

  List<PopupMenuEntry<UserStatus>> itemBuilder(BuildContext context) {
    return options
        .map(
          (e) => PopupMenuItem(
            value: e,
            child: Text(e.name.capitalize!),
          ),
        )
        .toList();
  }
}

// enum UserStatus { active, inactive, delete }

// extension UserStatusExt on UserStatus {
//   Color get color {
//     switch (this) {
//       case UserStatus.active:
//         return Colors.teal;

//       case UserStatus.inactive:
//         return Colors.grey;
//       case UserStatus.delete:
//         return Colors.red;
//     }
//   }
// }

class UserStatusWidget extends StatelessWidget {
  final UserStatus status;
  final EdgeInsets? margin;
  const UserStatusWidget({Key? key, this.status = UserStatus.inactive, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      margin: margin,
      decoration: MyDecoration.decoration(
        isCircle: true,
        shadow: false,
        color: status.color,
      ),
    );
  }
}
