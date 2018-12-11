void main(){
    var a = f();
    print(a.runtimeType);
}


Future f() async {
    return Future.value(Future.value('Test'));
}