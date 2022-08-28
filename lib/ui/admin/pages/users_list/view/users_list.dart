import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/theme/color_constants.dart';
import 'package:background_location/ui/admin/pages/users_list/view/roles_sheet.dart';
import 'package:background_location/widgets/expanded_tile.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

import '../../../../../widgets/bottom_sheet/bottom_sheet_service.dart';
import '../../../../../widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import '../../../../../widgets/text_fields/text_formatters/CapitalizeFirstLetter.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class UsersView extends StatelessWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();
    return Scaffold(
      appBar: MyAppBar(title: Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                Gap(2.h),
                BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    return MyTextField(
                      onTap: () => BottomSheetService.showSheet(
                        child: RolesSheet(
                          title: 'Please select a role',
                          options: state.roles,
                          onChanged: cubit.setCurrentRole,
                        ),
                      ),
                      enabled: true,
                      inputFormatters: [CapitalizeAllInputFormatter()],
                      hintText: 'Select Role',
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      controller: TextEditingController(text: state.selectRole),
                      focusNode: AlwaysDisabledFocusNode(),
                      readOnly: false,
                    );
                  },
                ),
                Gap(10.h),
                MyTextField(
                  hintText: 'Search',
                  filled: true,
                  fillColor: kPrimaryColor.withOpacity(0.01),
                  prefixIcon: Icon(Icons.search),
                  onChanged: cubit.onSearch,
                  autovalidateMode: AutovalidateMode.disabled,
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
                                    selected: e == state.filter,
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
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
          // _userTile(context),
        ],
      ),
    );
  }

  Container _userTile(BuildContext context, UserData user) {
    return Container(
      // decoration: MyDecoration.decoration(),
      child: ExpandedTile(
        title: Text(
          user.firstName! + ' ' + user.lastName!,
          style: context.textTheme.subtitle2?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(user.role ?? ''),
        trailing: SizedBox.shrink(),
        children: [
          Divider(),
          Row(
            children: [
              // Text('Email')
              Icon(
                Icons.mail_outline,
                color: Colors.blueGrey,
              ),
              Gap(10.w),
              Text(user.email ?? ''),
            ],
          ),
          Divider(),

          Row(
            children: [
              // Text('Email')
              Icon(
                Icons.phone,
                color: Colors.blueGrey,
              ),
              Gap(10.w),
              Text('${user.countryCode} ${user.phoneNumber}'),
            ],
          ),
          Divider(),
          Row(
            children: [
              // Text('Email')
              Text('PIC:'),
              Gap(10.w),
              Text(
                user.pic ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Divider(),

          // Text
          Row(
            children: [
              Text(
                'Status ',
                style: context.textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Text(
              //   user.status!.name.capitalize!,
              //   style: context.textTheme.subtitle1?.copyWith(
              //     fontWeight: FontWeight.w500,
              //     color: user.status!.color,
              //   ),
              // ),
              Spacer(),
              _StatusWidget(user: user),
              // _statusWidget(user, context.read<UsersCubit>().state.status[user.id!], context),
              // ...UserStatus.values
              //     .map((e) => UserStatusWidget(
              //           margin: EdgeInsets.symmetric(horizontal: 10),
              //           status: e,
              //         ))
              //     .toList()
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
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.white,
            )
          ],
        ),
      ),
      options: UserStatus.values,
      onSelected: (s) => setState(() => selected = s),
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
      child: child,
      onSelected: onSelected,
      padding: EdgeInsets.zero,
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
