// import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart';
//
// class ListBloc {
//
//   static ListBloc _listBloc;
//
//   factory ListBloc(){
//     if(_listBloc == null)
//       _listBloc = new ListBloc._();
//
//     return _listBloc;
//   }
//
//   PublishSubject<int> _positionItem;
//
//   ListBloc._(){
//     _positionItem = new PublishSubject<int>();
//   }
//
//   Observable<int> get listenAnimation => _positionItem.stream;
//
//   void startAnimation(int limit, Duration duration) async {
//     for(var i = -1; i<limit; i++){
//       await new Future.delayed(duration, (){
//         _updatePosition(i);
//       });
//     }
//   }
//
//   void _updatePosition(int position){
//     _positionItem.add(position);
//   }
//
//   dispose(){
//     _listBloc = null;
//     _positionItem.close();
//   }
//
// }
//
// class ListViewEffect extends StatefulWidget {
//   final Duration duration;
//   final List<Widget> children;
//
//   ListViewEffect({Key key, this.duration, this.children}) : super(key:key);
//   _ListViewEffect createState() => new _ListViewEffect();
// }
//
// class _ListViewEffect extends State<ListViewEffect> {
//
//   ListBloc _listBloc;
//
//   initState(){
//     _listBloc = new ListBloc();
//     super.initState();
//   }
//
//   Widget build(BuildContext context) {
//
//     _listBloc.startAnimation(widget.children.length, widget.duration);
//
//     return new Scaffold(body: new Container(child:
//     new Container(height: MediaQuery.of(context).size.height, child:
//     new ListView.builder(scrollDirection: Axis.vertical, itemCount: widget.children.length, itemBuilder: (context, position){
//       return new ItemEffect(child: widget.children[position], duration: widget.duration, position: position);
//     })
//     )
//     ));
//   }
//
//   @override
//   void dispose() {
//     _listBloc.dispose();
//     super.dispose();
//   }
// }
//
// class ItemEffect extends StatefulWidget{
//   final int position;
//   final Widget child;
//   final Duration duration;
//   ItemEffect({this.position, this.child, this.duration});
//   _ItemEffect createState() => new _ItemEffect();
// }
//
// class _ItemEffect extends State<ItemEffect> with TickerProviderStateMixin {
//   AnimationController _controller;
//   Animation<Offset> _offsetFloat;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     );
//
//     _offsetFloat = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero)
//         .animate(_controller);
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return new StreamBuilder(stream: new ListBloc().listenAnimation, initialData: -1, builder: (context, AsyncSnapshot<int> snapshot){
//       if(snapshot.data >= widget.position && snapshot.data > -1) _controller.forward();
//       return SlideTransition(position: _offsetFloat, child:
//       widget.child
//       );
//     });
//   }
//
// }