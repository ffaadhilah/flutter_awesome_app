import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/photo_bloc.dart';
import '../widgets/photo_grid_item.dart';
import '../widgets/photo_list_item.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(LoadPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Awesome App'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() {
              _isGridView = !_isGridView;
            }),
          ),
        ],
      ),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PhotoLoaded) {
            final photos = state.photos;
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
                  context.read<PhotoBloc>().add(LoadMorePhotos());
                }
                return false;
              },
              child: _isGridView
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return PhotoGridItem(photo: photos[index]);
                      },
                    )
                  : ListView.builder(
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return PhotoListItem(photo: photos[index]);
                      },
                    ),
            );
          } else {
            return Center(child: Text('Failed to load photos'));
          }
        },
      ),
    );
  }
}
