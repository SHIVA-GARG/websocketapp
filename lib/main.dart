// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
// import 'dart:html';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WebSockets Learning",
      theme: ThemeData(primarySwatch: Colors.pink),
      home: MyHomePage(
          channel: new IOWebSocketChannel.connect("wss://echo.websocket.org"),
          ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
   final WebSocketChannel channel;
  MyHomePage({ @required this.channel});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket Test App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Form(
              child: new TextFormField(
                decoration: InputDecoration(labelText: "send any message"),
                controller: editingController,
              ),
            ),
            new StreamBuilder(
              stream: widget.channel.stream,
              builder: (context,snapsots){
                return new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(snapsots.hasData?'$snapsots.data':''),
                );
              },

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: _sendMessage,
      ),
    );
  }
  void _sendMessage(){
    if(editingController.text.isNotEmpty){
      widget.channel.sink.add(editingController.text);
    }

  }
  @override
  void dispose(){
    widget.channel.sink.close();
    super.dispose();
  }
}
