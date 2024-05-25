import 'package:enjoy_television/common/drawer/drawer_widget.dart';
import 'package:enjoy_television/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/tv_app_bar.dart';
import '../../models/data_model.dart';

class UpdatesScreen extends ConsumerWidget {
  const UpdatesScreen({super.key});
  final bool threeItems = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataModelNotifierProvider('mob_updates.php'));
    return Scaffold(
        appBar: const TVAppBar(),
        drawer: const DrawerWidget(),
        body: data.when(
          data: (data) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: threeItems ? 3 : 2,
                childAspectRatio: threeItems ? 0.55 : 0.75,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => context.goNamed('play-video', queryParameters: {
                    'pageTitle': 'Updates',
                    'title': data[index].title,
                    'pageUrl': data[index].pagePath,
                    'videoUrl': data[index].videoUrl,
                    'date': data[index].date ?? '',
                    'phpPath': 'path',
                    'imageUrl': data[index].imageUrl,
                    'isFavorite': 'true',
                  }),
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        Hero(
                          tag: data[index].videoUrl,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data[index].imageUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: threeItems ? 2 : 6),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(data[index].title,
                                    style: threeItems
                                        ? Theme.of(context).textTheme.titleSmall
                                        : Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: threeItems ? 2 : 8),
                                child: Text(
                                    (data[index].category)?.toUpperCase() ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.blue,
                                          fontSize: threeItems ? 10 : null,
                                        )),
                              ),
                              SizedBox(height: threeItems ? 4 : 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(data[index].date ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.greyColor
                                          .copyWith(
                                            fontSize: threeItems ? 9 : null,
                                          )),
                                  SizedBox(width: threeItems ? 7 : 10),
                                ],
                              ),
                              SizedBox(height: threeItems ? 22 : 28),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            alignment: Alignment.center,
                            height: threeItems ? 18 : 25,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Text('Newly Added',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: threeItems ? 10 : null)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(error.toString())),
        ));
  }
}
