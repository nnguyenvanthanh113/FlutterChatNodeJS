import 'package:flutter_chat_nodejs/model/message.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var chatMessages = <Message>[].obs;
  var connectedUser = 0.obs;
}
