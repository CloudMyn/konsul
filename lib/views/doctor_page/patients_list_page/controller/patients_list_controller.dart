import 'package:get/get.dart';
import 'package:konsul/models/rekam_medis.dart';
import 'package:konsul/models/user.dart';
import 'package:konsul/services/network_handler.dart';

class PatientsListController extends GetxController {
  Future<List<RekamMedis>> getDoctorPatients(
      User user, String status, String apiToken) async {
    return await NetworkHandler.getDoctorPatients(
      user.id,
      apiToken,
      status: status,
    );
  }
}
