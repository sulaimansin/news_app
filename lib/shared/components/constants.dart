
import 'package:mm/modules/shope_app/login/login_screen.dart';
import 'package:mm/shared/network/local/cache_helper.dart';

import 'components.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token')!.then((value) {
    if (value) {
      navigateAndFinish(context, LoginScreen());
    }
  });
}

void printFullText(String? text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text!).forEach((element) {print(element.group(0));});

}

String token = '';