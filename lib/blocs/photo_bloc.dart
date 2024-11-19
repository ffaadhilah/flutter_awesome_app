import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/photo_model.dart';
import '../services/pexels_service.dart';

abstract class PhotoEvent {}

class LoadPhotos extends PhotoEvent {}

class LoadMorePhotos extends PhotoEvent {}

abstract class PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<Photo> photos;
  PhotoLoaded(this.photos);
}

class PhotoError extends PhotoState {}

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PexelsService pexelsService;
  int _page = 1;

  PhotoBloc(this.pexelsService) : super(PhotoLoading()) {
    on<LoadPhotos>((event, emit) async {
      emit(PhotoLoading());
      try {
        final photos = await pexelsService.fetchPhotos(_page, 20);
        emit(PhotoLoaded(photos));
      } catch (_) {
        emit(PhotoError());
      }
    });

    on<LoadMorePhotos>((event, emit) async {
      if (state is PhotoLoaded) {
        final currentState = state as PhotoLoaded;
        _page++;
        try {
          final photos = await pexelsService.fetchPhotos(_page, 20);
          emit(PhotoLoaded([...currentState.photos, ...photos]));
        } catch (_) {
          emit(PhotoError());
        }
      }
    });
  }
}
