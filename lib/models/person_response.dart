import './person.dart';

class PersonResponse {
  final List<Person> persons;
  final String error;

  const PersonResponse(this.persons, this.error);
  PersonResponse.fromJson(Map<String, dynamic> json)
      : persons = (json["results"] as List)
            .map((item) => Person.fromJson(item))
            .toList(),
        error = "";
  PersonResponse.withError(String errorValue)
      : persons = [],
        error = errorValue;
}
