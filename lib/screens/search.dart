import 'dart:math';

import 'package:cuo_cutter/screens/category_details.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode focus = FocusNode();
  Future<List<String>> searchCatFuture;
  List<String> _categories = [];
  @override
  void initState() {
    searchCatFuture = Storage.instance.fetchSearchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: FutureBuilder<List<String>>(
            future: searchCatFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.7),
                    strokeWidth: 6,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  _categories = snapshot.data;
                }

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 30,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          "Search",
                          style: h4.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: TextFormField(
                          focusNode: focus,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                            labelText: "Store name ",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          onTap: () {
                            showSearch(context: context, delegate: Search());
                            focus.unfocus(
                                disposition: UnfocusDisposition.scope);
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 30,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          child: Text(
                            "Top categories",
                            style: body1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          // crossAxisCount: 2,
                          maxCrossAxisExtent: 300,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                          childAspectRatio: 3 / 1.7,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.maybeOf(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return CategoryPage(
                                      categoryName: _categories[index]);
                                }));
                              },
                              child: Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: colorList[Random()
                                              .nextInt(colorList.length - 1)]),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.black26,
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      left: 7,
                                      child: Container(
                                        child: Row(children: [
                                          Text(
                                            _categories[index],
                                            style: body1.copyWith(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: _categories.length,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }
}

class Search extends SearchDelegate {
  Search()
      : super(
          searchFieldLabel: "",
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      child: BackButton(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("Adewoyin");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("david Adewoyin");
  }
}
