import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/layout/news_app/cubit/states.dart';


import '../../../modules/news_app/business/business_screen.dart';
import '../../../modules/news_app/science/science_screen.dart';
import '../../../modules/news_app/sports/sport_screen.dart';
import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialStates());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const BusinessScreen(),
    const SportScreen(),
    const ScienceScreen(),
  ];

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'science',
    ),

  ];

  void changeBottomNavBar(int index){
    if(index == 1){
      getSports();
    }
    if(index == 2){
      getScience();
    }
    currentIndex = index;
    emit(NewsBottomNavState());
  }


  List<dynamic> business=[];
  List<dynamic> sports=[];
  List<dynamic> science=[];

  void getBusiness(){
    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'my',
          'category':'business',
          'apiKey':'bedb4c7c51884db3bde895a65be8d677'
        }
    ).then((value) {
      business = value.data['articles'];
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  void getSports(){
    emit(NewsGetSportsLoadingState());
    if(sports.isEmpty){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'my',
            'category':'sports',
            'apiKey':'bedb4c7c51884db3bde895a65be8d677'
          }
      ).then((value) {
        sports = value.data['articles'];
        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessState());
    }
  }

  void getScience(){
    emit(NewsGetScienceLoadingState());

    if(science.isEmpty){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'my',
            'category':'science',
            'apiKey':'bedb4c7c51884db3bde895a65be8d677'
          }
      ).then((value) {
        science = value.data['articles'];
        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }else{
      emit(NewsGetScienceSuccessState());
    }


  }
  List<dynamic> search=[];

  void getSearch(String value){
    emit(NewsGetSearchLoadingState());

     search = [];

    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'q':value,
          'apiKey':'9fe5d51a6afc447a820464d789d3e80c'
        }
    ).then((value) {
      search = value.data['articles'];
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }


}
