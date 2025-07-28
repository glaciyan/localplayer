import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static void showError(final String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
  }
}
