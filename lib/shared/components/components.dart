import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mm/layout/news_app/cubit/cubit.dart';
import 'package:mm/layout/shope_app/cubit/cubit.dart';
import 'package:mm/shared/cubit/cubit.dart';
import 'package:mm/shared/style/colors.dart';

import '../../modules/news_app/web_view/web_view_secreen.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 5.0,
  required VoidCallback function, // we can replace it with Function()
  required String buttonText,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? buttonText.toUpperCase() : buttonText,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType textInputType,
  Function(String newValue)? onSubmit,
  Function(String newValue)? onChange,
  Function()? onTap,
  required final String? Function(String?)? validate,
  bool obscureText = false,
  required String label,
  required IconData? prefixIcon,
  IconData? suffixIcon,
  Function()? suffixPress,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: textInputType,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      onChanged: onChange,
      validator: validate,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null ? IconButton(onPressed: suffixPress, icon: Icon(suffixIcon),)
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text('${model['time']}'),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateData(status: 'archive', id: model['id']);
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.red,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );

Widget myDivider() {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
    child: Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
  );
}

Widget buildAtricaleItems(articale, context) {
  return InkWell(
    onTap: () {
      navigateTo(context, WebViewScreen(articale['url']));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    image: NetworkImage('${articale['urlToImage']}'),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: SizedBox(
              height: 120.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${articale['title']}',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${articale['publishedAt']}',
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget articileBuilder(list, context, length, {isSearch = false}) =>
    ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              buildAtricaleItems(list[index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: length),
      fallback: (context) => isSearch
          ? Container()
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );

void showToast({
  required String message,
  required ToastState state,

})=> Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor:chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastState {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastState state){

  Color color;
  switch(state){
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProducts(model,context, {bool isOldPrice =true}) {
   return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model!.image!),
              width: 120,
              height: 120,
            ),
            if(model!.discount !=0 && isOldPrice)
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                color: Colors.red,
              )
          ],
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model!.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    model!.price!.toString(),
                    style: TextStyle(fontSize: 12, color: defaulteColor),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  if (model!.discount != 0 && isOldPrice)
                    Text(model!.oldPrice!.toString(),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: ShopeCubit.get(context).favorites![model!.id]! ? defaulteColor : Colors.grey,
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.white,
                      ),
                      radius: 15,
                    ),
                    onPressed: () {
                      ShopeCubit.get(context).changeFavorites(model!.id!);
                    },
                  )
                ],
              )
            ],
          ),
        )
      ]),
    ),
  );
}