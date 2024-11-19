import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/photo_bloc.dart';
import '../widgets/photo_grid_item.dart';
import '../widgets/photo_list_item.dart';

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

  Future<void> _refreshPhotos() async {
    // Reload photos on refresh
    context.read<PhotoBloc>().add(LoadPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPhotos,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Awesome App'),
                background: Image.network(
                  'https://source.unsplash.com/random',
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () => setState(() {
                    _isGridView = !_isGridView;
                  }),
                ),
              ],
            ),
            BlocBuilder<PhotoBloc, PhotoState>(
              builder: (context, state) {
                if (state is PhotoLoading) {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is PhotoLoaded) {
                  final photos = state.photos;
                  return _isGridView
                      ? SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return PhotoGridItem(photo: photos[index]);
                            },
                            childCount: photos.length,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return PhotoListItem(photo: photos[index]);
                            },
                            childCount: photos.length,
                          ),
                        );
                } else {
                  return SliverFillRemaining(
                    child: Center(child: Text('Failed to load photos')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
