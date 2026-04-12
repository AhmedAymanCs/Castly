import 'package:castly/features/live_stream/logic/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  LiveStreamCubit() : super(const LiveStreamState());
}
