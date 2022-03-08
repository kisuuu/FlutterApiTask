import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

String? stringResponse;
Map? mapResponse;
Map? dataResponse;
List? listResponse;

class _DashboardState extends State<Dashboard> {
  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if (response.statusCode == 200) {
      setState(() {
        // stringResponse = response.body;
        mapResponse = jsonDecode(response.body);
        listResponse = mapResponse!['data'];
      });
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text(
          'Dashboard',
        ),
        backgroundColor: Colors.deepPurpleAccent.shade700,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: Column(children: [
              // borderSide: BorderSide(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Image.network(
                  listResponse![index]['avatar'],
                ),
              ),
              Text(listResponse![index]['email'].toString()),
              const SizedBox(
                height: 3.0,
              ),
              Text(listResponse![index]['first_name'].toString()),
              const SizedBox(
                height: 3.0,
              ),
              Text(listResponse![index]['last_name'].toString()),
              const SizedBox(
                height: 5.0,
              ),
            ]),
          );
        },
        itemCount: listResponse == null ? 0 : listResponse!.length,
      ),
    );
  }
}
