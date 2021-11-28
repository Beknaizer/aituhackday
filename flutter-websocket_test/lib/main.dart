import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();


}





class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _controller = TextEditingController();

  final StompClient stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://192.168.0.103:8091/websocket-example',
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        // onConnect: onConnect,
      )
  );

  @override
  void initState() {
    // TODO: implement initState
    stompClient.activate();

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),

          ],

        ),

      ),


      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.

    );


  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      stompClient.send(
        destination: '/app/message',
        body: json.encode({'content': _controller.text}),
      );
    }
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

}


onConnect(StompFrame frame,StompClient stompClient) {
  stompClient.subscribe(
    destination: '/topic/user',
    callback: (frame) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(
          json.decode(frame.body));
      print(myMap);
    },
  );
}


