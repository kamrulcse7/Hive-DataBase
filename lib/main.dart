import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("myList");
  // var box = await Hive.openBox("myList");
  // box.put("name", "kamrul");
  // var name = box.get("name");
  // print(name);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _textController = TextEditingController();
  TextEditingController _updateTextController = TextEditingController();
  late Box myBox;

  @override
  void initState() {
    myBox = Hive.box("myList");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive DataBase',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            controller: _textController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Name"),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            var text = _textController.text;
                            myBox.add(text);
                            _textController.clear();
                          },
                          child: Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(12.0)),
                              color: Colors.green,
                            ),
                            child: Text(
                              "ADD",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box("myList").listenable(),
                    builder: (context, box, Widget) {
                      return ListView.builder(
                        itemCount: myBox.keys.toList().length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.green[100],
                            child: ListTile(
                              title: Text(myBox.getAt(index)),
                              trailing: Container(
                                width: 100.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Update Note'),
                                                content: TextFormField(
                                                  controller:
                                                      _updateTextController,
                                                  autofocus: true,
                                                  enableSuggestions: true,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        myBox.getAt(index),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.green),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      myBox.putAt(
                                                          index,
                                                          _updateTextController
                                                              .text);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Update"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // setState(() {
                                        //   myBox.deleteAt(index);
                                        // });
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.green[50],
                                              title: Text('Confimation Delete'),
                                              content: Text('Are you sure?'),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    MaterialButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(true);
                                                        setState(() {
                                                          myBox.deleteAt(index);
                                                        });
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      color: Colors.red,
                                                    ),
                                                    MaterialButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                              // trailing: Container(
                              //   child: Row(
                              //     children: [
                              //       IconButton(
                              //           onPressed: () {}, icon: Icon(Icons.edit))
                              //     ],
                              //   ),
                              // ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
