import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/django/api_service.dart';
import '../../util/keyword.dart';
import '../../../util/location.dart';
import '../../bloc/authentication_bloc.dart';
import '../../bloc/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _Home();
}

class _Home extends State<SearchPage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController keywordController = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> data = [];

  List<Map<String, dynamic>> selectedActivities = [];
  List<String> locations = [];
  List<String> keywords = [];

  @override
  void initState() {
    super.initState();
    // Fetch selected activities
    _fetchSelectedActivities();
  }

  Future<void> _fetchSelectedActivities() async {
    try {
      // Fetch the list of chosen activities from the API
      List<Map<String, dynamic>> activities = await apiService.getChosenList();

      setState(() {
        selectedActivities = activities;
      });
    } catch (e) {
      print("Error fetching selected activities: $e");
    }
  }

  String _selectedItem = '';
  String _searchQuery = '';

  void deleteLocation(int index) {
    setState(() {
      locations.removeAt(index);
    });
  }

  void addKeyword() {
    String keyword = keywordController.text;
    if (keyword.isNotEmpty) {
      setState(() {
        keywords = [keyword];
      });
    }
  }

  void deleteKeyword(int index) {
    setState(() {
      keywords.removeAt(index);
    });
  }

// Update addActivity function
  void addActivity(Map<String, dynamic> activity) async {
    // Check for duplication using the ID (assuming 'id' is the key for the unique identifier)
    if (!selectedActivities
        .any((selected) => selected['id'] == activity['id'])) {
      final chosenId = await apiService.addChosenActivity({
        'activity': activity['id'],
      });
      if (chosenId == '') {
        return;
      }

      setState(() {
        selectedActivities.add({
          'id': activity['id'],
          'location': activity['location'],
          'description': activity['description'],
          'chosenId': chosenId,
        });
      });
    } else {
      // Optionally show a message that the activity is already added
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Activity "${activity['description']}" is already added!')),
      );
    }
  }

  void deleteActivity(int index) async {
    final chosenId = selectedActivities[index]['chosenId'];
    setState(() {
      selectedActivities.removeAt(index);
    });
    await apiService.deleteChosenActivity(chosenId); // Call the delete function
  }

  void clearActivities() {
    setState(() {
      selectedActivities.clear();
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('MA Traveling Suggestion',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Your Selected Activities',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...selectedActivities.map((activity) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity['id'].toString() +
                              ' ' +
                              activity['location'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteActivity(
                              selectedActivities.indexOf(activity)),
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (value) {
                        setState(() {
                          _searchQuery =
                              value; // Update the search query on each change
                        });

                        controller.openView();
                      },
                      onSubmitted: (String value) {
                        setState(() {
                          _searchQuery = value;
                          _selectedItem =
                              value; // Treat the submitted text as selected
                        });
                        print(_searchQuery);
                        // controller.closeView(value);
                      },
                      leading: const Icon(Icons.search),
                      // trailing: <Widget>[
                      //   Tooltip(
                      //     message: 'Change brightness mode',
                      //     child: IconButton(
                      //       isSelected: isDark,
                      //       onPressed: () {
                      //         setState(() {
                      //           isDark = !isDark;
                      //         });r
                      //       },
                      //       icon: const Icon(Icons.wb_sunny_outlined),
                      //       selectedIcon:
                      //           const Icon(Icons.brightness_2_outlined),
                      //     ),
                      //   )
                      // ],
                    );
                  }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    final suggestions = [
                      'New York',
                      'Amherst',
                      'Boston',
                      'Chicago',
                      'Los Angeles',
                      'San Francisco',
                      'Seattle',
                      'Washington D.C.'
                    ];
                    return List<ListTile>.generate(8, (int index) {
                      return ListTile(
                        title: Text(suggestions[index]),
                        onTap: () {
                          setState(() {
                            _selectedItem = suggestions[
                                index]; // Update state when an item is selected
                          });
                          controller.closeView(suggestions[index]);
                        },
                      );
                    });
                  }),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: keywords.length,
                      itemBuilder: (context, index) {
                        return Keyword(
                          keyword: keywords[index],
                          deleteFunction: () => deleteKeyword(index),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: keywordController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                labelText: "Keyword",
                                hintText: "Enter a keyword for your holiday.",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addKeyword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Add Keywords',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        String keys = keywords.join(',');
                        List<List<String>> matchingPairs = pairs.where((pair) {
                          return keys.contains(pair[0]) ||
                              keys.contains(pair[1]);
                        }).toList();
                        print(matchingPairs);
                        try {
                          List<dynamic> fetchData = await apiService.getData(
                            queryParameters: {
                              'location': _searchQuery,
                              'category': matchingPairs[0][0],
                              'keywords': keys,
                            },
                          );
                          setState(() {
                            data = fetchData;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['category'].toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      item['description'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Location: ${item['location']}',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _launchURL(item['source_link']),
                                          child: const Text(
                                            'Visit Source',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Add button to the Card
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Call the function to add the item to the cart
                                          addActivity(item);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Add'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
              child: CircularProgressIndicator()); // Handle other states
        },
      ),
    );
  }
}

List<String> keywords = ['hotel', 'restaurant', 'entertainments'];
List<List<String>> pairs = [
  ['hotel', 'Hotel'],
  ['restaurant', 'Restaurant'],
  ['entertainments', 'Entertainment']
];
