/***
 * IMPORTANT: If you make changes to this file, you must run this command
 * without the outer most quotes
 * from the Terminal from the this projects root directory.
 * command = 'flutter pub run build_runner build'
 */

import 'package:json_annotation/json_annotation.dart';
part 'TestCollectionObject.g.dart';

@JsonSerializable(explicitToJson: true)
class TestCollectionObject {// extends Object{
  @JsonKey(name: "_id")//, fromJson: _stringToBigInt, toJson: _stringFromBigInt)
  String id;
  String firstName;
  String lastName;
  String ttime;

  //Constructor.
  //I do not include the first name in the constructor because I want MongoDB to handle the
  //auto generation of the primary key.
  TestCollectionObject(this.firstName, this.lastName, this.ttime);

  factory TestCollectionObject.fromJson(Map<String, dynamic> json) => _$TestCollectionObjectFromJson(json);
  Map<String, dynamic> toJson() => _$TestCollectionObjectToJson(this);
  //static BigInt _stringToBigInt(String number) => number == null ? null : BigInt.parse(number);
  //static String _stringFromBigInt(BigInt number) =>  number?.toString();

  //Getters and setters.
  String getId() {
    return id;
  }
  String getFirstName() {
    return firstName;
  }
  String getLastName() {
    return lastName;
  }
  String getTTime() {
    return ttime;
  }
  void setId(id) {
    this.id = id;
  }
  void setFirstName(firstName) {
    this.firstName = firstName;
  }
  void setLastName(lastName) {
    this.lastName = lastName;
  }
  void setTTime(ttime) {
    this.ttime = ttime;
  }
}