import 'package:prbal/utils/theme/theme_caching.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RadioCubit extends Cubit<String> {
  RadioCubit() : super(ThemeCaching.initialRadio());

  void changeValue(String radio) {
    emit(radio);
  }
}
