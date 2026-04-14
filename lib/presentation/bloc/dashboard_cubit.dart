import 'package:flutter_bloc/flutter_bloc.dart';

enum ChartMode { income, spend }

class DashboardCubit extends Cubit<ChartMode> {
  DashboardCubit() : super(ChartMode.spend);

  void toggle(ChartMode mode) => emit(mode);
}
