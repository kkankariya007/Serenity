import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/ContactTile.dart';

class GridList extends StatefulWidget {
  GridList({Key? key, required this.uid}) : super(key: key);
  String uid;
  @override
  State<GridList> createState() => _GridListState();
}

class _GridListState extends State<GridList> {
  Stream<List<Doctor>>? _listDoctor;
  List<Doctor> _doctorListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    var yes = snapshot.docs.map((doc) {
      return Doctor(
        id: doc.id,
        name: doc.data()['name'] ?? '',
        city: doc.data()['city'] ?? '',
        img: doc.data()['img'] ?? '',
        isBooked: doc.data()['isBooked'] ?? false,
        job: doc.data()['job'] ?? '',
        rate: doc.data()['rate'].toString() ?? '',
        requesterId: doc.data()['requesterId'] ?? '',
      );
    }).toList();
    return yes;
  }

  Stream<List<Doctor>> getDoctorData() {
    return FirebaseFirestore.instance
        .collection('doctor')
        .snapshots()
        .map(_doctorListFromSnapshot);
  }

  @override
  void initState() {
    super.initState();
    _listDoctor = getDoctorData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              StreamBuilder<List<Doctor>>(
                  stream: _listDoctor,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    var data = snapshot.data;
                    if (data == null) return Center(child: Text("No data"));

                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      //   crossAxisSpacing: 20,
                      //   mainAxisSpacing: 100,
                      //   childAspectRatio: 1.3,
                      // ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 50,
                        childAspectRatio: 1 / 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return Contact(
                          uid: widget.uid,
                          docID: data[index].id ?? "",
                          name: data[index].name,
                          profession: data[index].job,
                          city: data[index].city,
                          rating: data[index].rate,
                        );
                      },
                      itemCount: (data.isNotEmpty) ? data.length : 0,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class Doctor {
  String? id;
  String? city;
  String? img;
  bool? isBooked;
  String? job;
  String? name;
  String? rate;
  String? requesterId;
  Doctor(
      {this.id,
      this.city,
      this.img,
      this.isBooked,
      this.job,
      this.name,
      this.rate,
      this.requesterId});
}
