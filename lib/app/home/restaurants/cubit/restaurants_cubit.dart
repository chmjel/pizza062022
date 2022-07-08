import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  RestaurantsCubit()
      : super(
          const RestaurantsState(
              documents: [], errorMessage: '', isLoading: false),
        );

  StreamSubscription? _streamSubscripction;

  Future<void> start() async {
    emit(
      const RestaurantsState(documents: [], errorMessage: '', isLoading: true),
    );
    _streamSubscripction = FirebaseFirestore.instance
        .collection('restaurants')
        .orderBy('rating', descending: true)
        .snapshots()
        .listen((data) {
      emit(
        RestaurantsState(
            documents: data.docs, errorMessage: '', isLoading: false),
      );
    })
      ..onError((error) {
        emit(RestaurantsState(
            documents: [], errorMessage: error.toString(), isLoading: false));
      });
  }

  @override
  Future<void> close() {
    _streamSubscripction?.cancel();
    return super.close();
  }
}
