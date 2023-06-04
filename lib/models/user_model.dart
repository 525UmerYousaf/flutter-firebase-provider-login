// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final int point;
  final String rank;
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.point,
    required this.rank,
  });

  //  Below is my factory constructor to read user docuemnt from Firestore
  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;
    return User(
      id: userDoc.id,
      name: userData!['name'],
      email: userData['email'],
      profileImage: userData['profileImage'],
      point: userData['point'],
      rank: userData['rank'],
    );
  }

  //  Reason for defining below one is when first time app
  //  starts then app is not connected to server so user-related
  //  information data becomes null, similarly when user log-out
  //  user related information must be cleared causing it to null.
  //  With nullability issue kept in mind & also app's data structure
  //  is also known in advance, it's intended to use non-null user
  //  who doesn't have to worry about overlapping.
  factory User.initialUser() {
    return const User(
      id: '',
      name: '',
      email: '',
      profileImage: '',
      point: -1,
      rank: '',
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      profileImage,
      point,
      rank,
    ];
  }

  @override
  bool get stringify => true;
}
