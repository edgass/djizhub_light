
import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<FetchGoalsController>(FetchGoalsController());
    Get.put<CreateGoalController>(CreateGoalController());
    Get.put<DepositController>(DepositController());
    Get.put<SecurityController>(SecurityController());




  }

}