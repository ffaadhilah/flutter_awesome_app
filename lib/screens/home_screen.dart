import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_app/blocs/photo_bloc.dart';
import '../widgets/photo_grid_item.dart';
import '../widgets/photo_list_item.dart';
import '../widgets/offline_ui.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../widgets/shimmer_placeholders.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOffline = false;
  bool _isGridView = true;
  bool _hasLoadedInitialData = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    context.read<PhotoBloc>().add(LoadPhotos());
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  Future<void> _refreshPhotos() async {
    await _checkConnectivity();
    if (!_isOffline) {
      context.read<PhotoBloc>().add(LoadPhotos());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isOffline
            ? OfflineUI(onRetry: () async {
                await _checkConnectivity();
                if (!_isOffline) {
                  context.read<PhotoBloc>().add(LoadPhotos());
                }
              })
            : RefreshIndicator(
                onRefresh: _refreshPhotos,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                        expandedHeight: 200.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                            titlePadding:
                                EdgeInsets.only(left: 16.0, bottom: 16.0),
                            title: Text('Awesome App',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            background: Image.network(
                                'https://picsum.photos/200/300',
                                fit: BoxFit.cover)),
                        actions: [
                          IconButton(
                              icon: Icon(_isGridView
                                  ? Icons.view_list
                                  : Icons.grid_view),
                              onPressed: () => setState(() {
                                    _isGridView = !_isGridView;
                                  }),
                              iconSize: 35)
                        ]),
                    BlocBuilder<PhotoBloc, PhotoState>(
                      builder: (context, state) {
                        if (state is PhotoLoading) {
                          if (!_hasLoadedInitialData) {
                            return SliverFillRemaining(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                          return _isGridView
                              ? ShimmerGridPlaceholder()
                              : ShimmerListPlaceholder();
                        } else if (state is PhotoLoaded) {
                          _hasLoadedInitialData = true;
                          final photos = state.photos;

                          return _isGridView
                              ? SliverPadding(
                                  padding:
                                      EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                  sliver: SliverGrid(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8),
                                      delegate: SliverChildBuilderDelegate(
                                          (context, index) => PhotoGridItem(
                                              photo: photos[index]),
                                          childCount: photos.length)))
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) =>
                                          PhotoListItem(photo: photos[index]),
                                      childCount: photos.length));
                        } else if (state is PhotoError) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                        'Failed to load photos. Please try again.'),
                                    ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<PhotoBloc>()
                                              .add(LoadPhotos());
                                        },
                                        child: Text('Retry'))
                                  ]),
                            ),
                          );
                        } else {
                          return SliverFillRemaining(
                              child:
                                  Center(child: Text('No photos available')));
                        }
                      },
                    )
                  ],
                )));
  }
}
