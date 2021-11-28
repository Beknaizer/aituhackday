import 'dart:async';
import 'dart:convert';
import 'dart:io';s

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

final StompClient stompClient = StompClient(
    config: StompConfig.SockJS(
      url: 'http://192.168.0.103:8091/websocket-example',
      onConnect: onConnect,
      beforeConnect: () async {
        print('waiting to connect...');
        await Future.delayed(Duration(milliseconds: 200));
        print('connecting...');
      },
      onWebSocketError: (dynamic error) => print(error.toString()),
    )
);

void onConnect(StompFrame frame) {
  onConnectCallback(frame);
  stompClient.subscribe(
    destination: '/topic/user',
    callback: (frame) {
      // List<dynamic>? result = json.decode(frame.body!);
      Map<String, dynamic> myMap = Map<String, dynamic>.from(json.decode(frame.body!));
      print(myMap);
    },
  );

    // String? message = stdin.readLineSync();
    // stompClient.send(
    //         destination: '/app/message',
    //         body: json.encode({'content': message}),
    //       );

  Timer.periodic(Duration(seconds: 10), (_) {
    stompClient.send(
      destination: '/app/message',
      body: json.encode({'content': "message from dart client side"}),
    );

  });
}

void main(){
stompClient.activate();
}


void onConnectCallback(StompFrame connectFrame) {
  // client is connected and ready
  print("client connected!");
}