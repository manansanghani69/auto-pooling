import 'package:auto_pooling_driver/presentation/home/bloc/home_bloc.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_state.dart';
import 'package:auto_pooling_driver/presentation/home/widgets/home_app_bar_title.dart';
import 'package:auto_pooling_driver/presentation/home/widgets/home_dashboard_content.dart';
import 'package:auto_pooling_driver/presentation/home/widgets/home_error_state.dart';
import 'package:auto_pooling_driver/presentation/home/widgets/home_loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const HomeAppBarTitle()),
      body: const SafeArea(child: HomeStatusView()),
    );
  }
}

class HomeStatusView extends StatelessWidget {
  const HomeStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        switch (state.status) {
          case HomeStatus.initial:
          case HomeStatus.loading:
            return const HomeLoadingState();
          case HomeStatus.failure:
            return const HomeErrorState();
          case HomeStatus.loaded:
            return const HomeDashboardContent();
        }
      },
    );
  }
}
