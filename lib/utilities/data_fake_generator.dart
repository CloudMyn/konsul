import 'package:faker/faker.dart';

class DataFakeGenerator {
  static List<String> genLoginData() {
    Faker fake = Faker();

    String email = fake.internet.email();
    String pass = fake.internet.password(length: 20);

    return [email, pass];
  }
}
