import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/layout/news_app/cubit/cubit.dart';
import 'package:mm/layout/news_app/cubit/states.dart';

import 'package:mm/shared/components/components.dart';
import 'package:mm/shared/cubit/cubit.dart';
import 'package:mm/shared/network/remote/dio_helper.dart';

import '../../modules/news_app/search/search.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit , NewsStates>(
        listener: (context, state){},
        builder: (context, state){
          var cubit = NewsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('News app'),
              actions: [
              IconButton(onPressed: (){
                navigateTo(context, SearchScreen());
              }, icon:const Icon(Icons.search)),
                IconButton(onPressed: (){
                  AppCubit.get(context).changeMode();
                },
                  icon: const Icon(Icons.brightness_4_outlined),)
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              items: cubit.bottomItems,
              onTap: (index){
                cubit.changeBottomNavBar(index);
              },
            ),
          );
        },
    );
  }
}
