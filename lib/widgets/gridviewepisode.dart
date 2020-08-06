import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class GridViewEp extends StatefulWidget {
  @override
  _GridViewEpState createState() => _GridViewEpState();
}

class _GridViewEpState extends State<GridViewEp> {
  ScrollController myScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<String> eps = new List<String>.generate(1000, (i) => "Episode $i");
    // return Container(
    //     color: Colors.white,
    //     child: Flexible(
    //       child: GridView.count(
    //         addAutomaticKeepAlives: true,
    //         cacheExtent: 99999,
    //         shrinkWrap: true,
    //         //padding: EdgeInsets.all(2.0),
    //         crossAxisCount: 4,
    //         mainAxisSpacing: 25,
    //         crossAxisSpacing: 5,
    //         childAspectRatio: 150 / 60,
    //         children: eps
    //             .map((a) => Container(
    //                   child: RaisedButton(
    //                       color: new Color(0xff001030).withOpacity(0.8),
    //                       child: Text(
    //                         a.toString(),
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           fontSize: 12,
    //                           color: new Color(0xffffffff),
    //                         ),
    //                       ),
    //                       onPressed: () {},
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(30.0),
    //                       )),
    //                 ))
    //             .toList(),
    //       ),
    //     ));
    return DefaultTabController(
      length: 2, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('Books'), // This is the title in the app bar.
                pinned: true,
                expandedHeight: 150.0,
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  // These are the widgets to put in each tab in the tab bar.
                  tabs: [
                    Text('tab1'),
                    Text('tab2'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: [
              SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  // This Builder is needed to provide a BuildContext that is
                  // "inside" the NestedScrollView, so that
                  // sliverOverlapAbsorberHandleFor() can find the
                  // NestedScrollView.
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      shrinkWrap: true,
                      // The "controller" and "primary" members should be left
                      // unset, so that the NestedScrollView can control this
                      // inner scroll view.
                      // If the "controller" property is set, then this scroll
                      // view will not be associated with the NestedScrollView.
                      // The PageStorageKey should be unique to this ScrollView;
                      // it allows the list to remember its scroll position when
                      // the tab view is not on the screen.
                      //key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber
                          // above.
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              DraggableScrollbar.arrows(
                                labelTextBuilder: (double offset) =>
                                    Text("${offset ~/ 70 + 1}"),
                                controller: myScrollController,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: myScrollController,
                                  itemCount: 500,
                                  itemExtent: 70.0,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print('${index + 1}');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Material(
                                          elevation: 4.0,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          color: Colors.purple[index % 9 * 100],
                                          child: Center(
                                            child: Text("Episode ${index + 1}"),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  // This Builder is needed to provide a BuildContext that is
                  // "inside" the NestedScrollView, so that
                  // sliverOverlapAbsorberHandleFor() can find the
                  // NestedScrollView.
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      shrinkWrap: true,
                      // The "controller" and "primary" members should be left
                      // unset, so that the NestedScrollView can control this
                      // inner scroll view.
                      // If the "controller" property is set, then this scroll
                      // view will not be associated with the NestedScrollView.
                      // The PageStorageKey should be unique to this ScrollView;
                      // it allows the list to remember its scroll position when
                      // the tab view is not on the screen.
                      //key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber
                          // above.
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              DraggableScrollbar.arrows(
                                labelTextBuilder: (double offset) =>
                                    Text("${offset ~/ 70 + 1}"),
                                controller: myScrollController,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: myScrollController,
                                  itemCount: 500,
                                  itemExtent: 70.0,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print('${index + 1}');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Material(
                                          elevation: 4.0,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          color: Colors.purple[index % 9 * 100],
                                          child: Center(
                                            child: Text("Episode ${index + 1}"),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ]),
      ),
    );
  }
}
