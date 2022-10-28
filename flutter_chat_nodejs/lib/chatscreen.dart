import 'package:flutter/material.dart';
import 'package:flutter_chat_nodejs/controller/chat_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'model/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Color purple = const Color(0xFF6c5ce7);
  Color black = const Color(0xFF191919);
  TextEditingController msgInputController = TextEditingController();

  late IO.Socket socket;
  ChatController chatController = ChatController();

  @override
  void initState() {
    // TODO: implement initState
    socket = IO.io(
        'http://localhost:4000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection// optional
            .build());
    socket.connect();
    setUpSocketListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Obx(
              () => Container(
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  "Connect User ${chatController.connectedUser}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                  ),
                ),
              ),
            )),
            Expanded(
                flex: 9,
                child: Obx(
                  () => ListView.builder(
                      itemCount: chatController.chatMessages.length,
                      itemBuilder: (context, index) {
                        var currentItem = chatController.chatMessages[index];
                        return MessageItem(
                          sentByMe: currentItem.sentByMe == socket.id,
                          message: currentItem.message,
                        );
                      }),
                )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.red,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: purple,
                controller: msgInputController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: purple,
                      ),
                      //color: purple,
                      child: IconButton(
                        onPressed: () {
                          sendMessage(msgInputController.text);
                          msgInputController.text = "";
                        },
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                      ),
                    )),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) {
    var messageJson = {"message": text, "sentByMe": socket.id};
    socket.emit('message', messageJson);
    chatController.chatMessages.add(Message.fromJson(messageJson));
  }

  void setUpSocketListener() {
    socket.on('message-receive', (data) {
      print(data);
      chatController.chatMessages.add(Message.fromJson(data));
    });
    socket.on('connected-user', (data) {
      print(data);
      chatController.connectedUser.value = data;
    });
  }
}

class MessageItem extends StatelessWidget {
  MessageItem({Key? key, required this.sentByMe, required this.message})
      : super(key: key);
  final bool sentByMe;
  final String message;
  DateTime now = DateTime.now();
  //var dateString = format.format(DateTime.now());
//String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  // DateFormat dateFormat = DateFormat("HH:mm:ss");
  // String now = dateFormat.format(DateTime.now());
  // var now = new DateTime.now();
  // //var formatter = new DateFormat('HH:mm:ss');
  // String formatredTime = DateFormat('HH:mm:ss').format(now);
  @override
  Widget build(BuildContext context) {
    Color purple = const Color(0xFF6c5ce7);
    Color black = const Color(0xFF191919);
    Color white = Colors.white;
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: sentByMe ? purple : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                  color: (sentByMe ? white : purple).withOpacity(0.7),
                  fontSize: 24.0),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              DateFormat.j().format(DateTime.now()),
            ),
          ],
        ),
      ),
    );
  }
}
