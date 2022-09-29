import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/layout/news_app/cubit/cubit.dart';
import 'package:mm/layout/news_app/cubit/states.dart';
import 'package:mm/shared/components/components.dart';

class SearchScreen extends StatelessWidget {

   var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context, state){},
      builder: (context,state){
        var list =NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                    controller: searchController,
                    textInputType: TextInputType.text,
                    validate: (value){
                      if(value!.isEmpty){
                        return 'Search must not be empty';
                      }
                      return null;
                    },
                    label: 'Search',
                    prefixIcon: Icons.search,
                    onChange: (value){
                      NewsCubit.get(context).getSearch(value);
                    }
                ),
              ),
              Expanded(child: articileBuilder(list, context,NewsCubit.get(context).search.length, isSearch: true))
            ],
          ),
        );
      },
    );
  }
}
