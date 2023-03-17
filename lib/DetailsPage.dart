import 'package:flutter/material.dart';
import 'package:loginapifunc/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DetailsPage extends StatefulWidget {
  final Map<String,dynamic> data;
  const DetailsPage({super.key,required this.data});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back,color: Colors.black,),
            ),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              InkWell(
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Locally stored data got cleared")));
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  if(mounted){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LoginPage()));
                  }
                },
                child: Row(
                  children: [
                    const Text("Logout",style: TextStyle(color: Colors.red),),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.settings,color: Colors.red,)),
                  ],
                ),
              )
            ],
          ),
          body: Center(
            child: Card(
              elevation: 5.0,
              shape:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white)
        ),
              child: Container(
                height: 320,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("First Name: ${widget.data['first_name']}"),
                    Text("Last Name: ${widget.data['last_name']}"),
                    Text("id: ${widget.data['id']}"),
                    Text("Role Users Id: ${widget.data['role_users_id']}"),
                    Text("Company Id: ${widget.data['company_id']}"),
                    Text("Department Id: ${widget.data['department_id']}"),
                    Text("Email: ${widget.data['email']}"),
                    Text("Contact: ${widget.data['contact_no']}"),
                    Text("DOB: ${widget.data['date_of_birth']}"),
                    Text("Gender: ${widget.data['gender']}"),
                    Text("Image: ${widget.data['profile_photo']}"),
                    Text("Address: ${widget.data['address']}"),
                    Text("City: ${widget.data['city']}"),
                    Text("State: ${widget.data['state']}"),
                    Text("Designation: ${widget.data['designation_name']}"),
                    Text("Company: ${widget.data['company_name']}"),
                    Text("Department Name: ${widget.data['department_name']}"),
                  ],
                ),
              ),
            ),
          )
        ));
  }
}
