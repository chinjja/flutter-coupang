import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/home/cubit/home_cubit.dart';
import 'package:coupang/home/view/home_view.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(context.read<CommerceRepository>()),
      child: const HomeView(),
    );
  }
}
