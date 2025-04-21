import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../sql_management/model.dart';
import 'main_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _performSearch() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;

    final results = await sqlHelper.search(keyword);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Tasks'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                      borderRadius:BorderRadius.circular(15)
                  ),
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onChanged: (_) => _performSearch(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(child: Text('No results'))
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final task = _searchResults[index];
                  return  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(),
                    ),
                    width: double.infinity,
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title'],
                                  style: TextStyle(fontSize: 20,decoration: task['isCompleted']==1?TextDecoration.lineThrough:TextDecoration.none),
                                ),
                                Container(
                                  height: 45,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      task['desc'],
                                      style: TextStyle(fontSize: 15,decoration: task['isCompleted']==1?TextDecoration.lineThrough:TextDecoration.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(task['time']),
                            Text(task['day']),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                sqlHelper.deleteTask(
                                  task['id'],
                                );
                                setState(() {});
                              },
                              icon: Icon(Icons.delete_forever),
                            ),
                            IconButton(
                              onPressed: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (_) {
                                    TextEditingController
                                    titleController =
                                    TextEditingController(
                                      text:
                                      task['title'],
                                    );
                                    TextEditingController descController =
                                    TextEditingController(
                                      text:
                                      task['desc'],
                                    );
                                    return CupertinoAlertDialog(
                                      title: Text('Edit Task'),
                                      content: Material(
                                        color: Colors.transparent,
                                        child: Column(
                                          spacing: 5,
                                          children: [
                                            SizedBox(
                                              height: 60,
                                              child: TextFormField(
                                                controller:
                                                titleController,
                                                decoration:
                                                InputDecoration(
                                                  hintText: 'title',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              child: TextFormField(
                                                controller:
                                                descController,
                                                decoration:
                                                InputDecoration(
                                                  hintText:
                                                  'description',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: Text('Edit'),
                                          onPressed: () {
                                            sqlHelper
                                                .updateTask(
                                              Task(
                                                titleController.text,
                                                descController.text,
                                                task['id'],
                                              ),
                                            )
                                                .whenComplete(() {
                                              setState(() {});
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




//
// import 'package:flutter/material.dart';
//
// import 'main_screen.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreanState();
// }
//
// class _SearchScreanState extends State<SearchScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Search..."),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius:BorderRadius.circular(15)
//                   ),
//                   hintText: "Search...",
//                 ),
//                 onChanged: (val){
//                   sqlHelper.search(val);
//                   setState(() {
//
//                   });
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
