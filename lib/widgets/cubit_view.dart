import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitView<T> extends StatefulWidget {
  final Cubit<T> cubit;
  final Widget child;
  const CubitView({super.key,required this.cubit, required this.child});

  @override
  State<CubitView> createState() => _CubitViewState();
}

class _CubitViewState extends State<CubitView> {
  
  
  @override
  void dispose() {
    widget.cubit.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.cubit,
      child: widget.child,
    );
  }
}