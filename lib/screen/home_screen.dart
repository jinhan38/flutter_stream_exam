import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // _transformerTest();

    // _defaultTest();

    // _errorTest();

    _broadCastStreamTest();


    return Scaffold(
      appBar: AppBar(title: Text("Stream 예제"),),
    );
  }



  ///broadCast stream test
  ///이 메소드에서는 listen와, sumStream 함수 둘다 호출하기 때문에 원래는 listen already error가 발생해야 한다.
  ///하지만 BroadcastStream으로 만들면 중복으로 리스너를 세팅할 수 있다.
  _broadCastStreamTest() async {
    var stream = countStream(5);
    var bcStream = stream.asBroadcastStream();
    bcStream.listen((event) => print("again : $event"));
    var sum = await sumStream(bcStream);
    print(sum);
  }

  ///transformer stream test
  ///sink : 입구
  ///stream : 출구
  _transformerTest() async {
    var transformer =
    StreamTransformer<int, String>.fromHandlers(handleData: (value, sink) {
      sink.add("value : $value");
    });

    var streamData = countStream(6);
    streamData
        .transform(transformer)
        .listen((event) => print("stream listener : $event"));
  }

  ///Default stream test
  _defaultTest() async {
    var streamData = countStream(5);
    streamData.listen((event) => print("stream listener : $event"));
    sumStream(streamData);
  }

  ///Error test
  _errorTest() async {
    var streamData = countStreamError(7);
    streamData.listen((event) => print("stream listener : $event"));
    sumStream(streamData);
  }


  ///Stream을 반환할 때는 async*를 사용한다
  Stream<int> countStreamError(int to) async* {
    for (int i = 0; i <= to; i++) {
      await Future.delayed(const Duration(seconds: 1));
      print("countStream i: $i");
      if (i == 5)
        throw Exception("Intentional Error");
      else
        yield i;
    }
  }

  Stream<int> countStream(int to) async* {
    for (int i = 0; i <= to; i++) {
      await Future.delayed(const Duration(seconds: 1));
      print("countStream i: $i");
      yield i;
    }
  }

  Future<int> sumStream(Stream<int> stream) async {
    var sum = 0;
    try {
      await for (var value in stream) {
        sum += value;
        print("sumStream sum : $sum");
      }
      return sum;
    } catch (e) {
      print(e);
      return -1;
    }
  }

}
