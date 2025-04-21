class Task {
  int?id ;
  String title;
  String desc ;
  String?day ;
  String?time ;
  int?isCompleted;

  Task( this.title, this.desc,[this.id,this.isCompleted]){
    String y = DateTime.now().toString().substring(0,4);
    String d = DateTime.now().toString().substring(8,10);
    String m = DateTime.now().toString().substring(5,7);
    day='$d/$m/$y';
    time = DateTime.now().toString().substring(11,16);
    isCompleted=0;
  }

  Map<String,dynamic> toMap () => {
    'id' : id,
    'title' : title,
    'desc' : desc,
    'day' : day,
    'time' : time,
    'isCompleted' : isCompleted
  };
}



//
// void main (){
//   Task task1 = Task(title: "hallo", desc: "omar");
//
//   print("${task1.title} : ${task1.desc} : ${task1.day} : ${task1.time}");
// }