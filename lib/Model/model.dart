import 'package:flutter/material.dart';

class Course {
  int id;
  String courseName;
  String courseDesc;
  String courseImgURL;
  int courseCategory;
  bool favourite;
  double progress;

  Course({
    @required this.id,
    @required this.courseName,
    @required this.courseDesc,
    @required this.courseImgURL,
    @required this.courseCategory,
    @required this.favourite,
    @required this.progress,
  });
}

class Category {
  int id;
  String name;
  String desc;
  int totalCourse;
  List<Course> courses;

  Category({
    this.id,
    this.name,
    this.desc,
    this.totalCourse,
    this.courses,
  });
}

class Topic {
  String id;
  String name;
  String desc;
  String available;
  List<Module> modules;

  Topic({
    @required this.id,
    @required this.name,
    @required this.desc,
    @required this.available,
    @required this.modules,
  });
}

class User {
  String id;
  String name;
  String username;
  String email;
  String imgUrl;
  String position;
  String type;
  String department;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
    @required this.email,
    @required this.imgUrl,
    @required this.position,
    @required this.type,
    @required this.department,
  });
}

class Person {
  String token;
  String id;
  String name;
  String username;
  String email;
  String imgUrl;
  String position;
  String type;
  String department;

  Person({
    this.token,
    this.id,
    this.name,
    this.username,
    this.email,
    this.imgUrl,
    this.position,
    this.type,
    this.department,
  });

  factory Person.fromMap(Map<String, dynamic> json) => new Person(
        token: json["token"],
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        imgUrl: json["imgUrl"],
        position: json["position"],
        type: json["type"],
        department: json["department"],
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "imgUrl": imgUrl,
        "position": position,
        "type": type,
        "department": department,
      };
}

class Event {
  String id;
  String eventName;
  String courseName;
  String time;
  String day;
  String month;
  String year;
  String desc;
  String location;

  Event({
    @required this.id,
    @required this.eventName,
    @required this.courseName,
    @required this.time,
    @required this.day,
    @required this.month,
    @required this.year,
    @required this.location,
    @required this.desc,
  });
}

class Module {
  String id;
  String instance;
  String moduleType;
  String name;
  String url;
  int completeStatus;
  int completeTime;
  String available;
  int timelimit;
  int maxattempts;
  int usercurrentattempts;

  Module({
    @required this.id,
    @required this.instance,
    @required this.moduleType,
    @required this.name,
    @required this.url,
    @required this.completeStatus,
    @required this.completeTime,
    @required this.available,
    this.timelimit,
    this.maxattempts,
    this.usercurrentattempts,
  });
}

class Quiz {
  String id;
  String qzQuestion;
  String qzType;
  bool checkunanswer;
  List<String> qzChoices;
  List<bool> answers;

  Quiz({
    this.id,
    this.qzQuestion,
    this.qzType,
    this.checkunanswer,
    this.qzChoices,
    this.answers,
  });
}

class QuizAnswer {
  String id;
  String slot;
  String slotValue;
  String sequencecheck;
  String sequencecheckValue;
  String answer;
  String ansValue;

  QuizAnswer({
    this.id,
    this.slot,
    this.slotValue,
    this.sequencecheck,
    this.sequencecheckValue,
    this.answer,
    this.ansValue,
  });
}

class QuizResult {
  List<String> chose;
  String correctAnswer;
  String question;
  String status;
  String choseAnswer;

  QuizResult({
    this.chose,
    this.correctAnswer,
    this.question,
    this.status,
    this.choseAnswer,
  });
}

class Lesson {
  int id;
  String title;
  String content;
  int nextPage;
  int previousPage;

  Lesson({
    this.id,
    this.title,
    this.content,
    this.nextPage,
    this.previousPage,
  });
}

class GradeByCategory {
  String categoryname;
  String coursename;
  int courseid;
  String mark;
  String gradeCategoryImg;

  GradeByCategory({
    this.categoryname,
    this.coursename,
    this.courseid,
    this.mark,
    this.gradeCategoryImg,
  });
}

class DetailGrades {
  String itemname;
  String grade;
  String grademax;
  String percentage;

  DetailGrades({
    this.itemname,
    this.grade,
    this.grademax,
    this.percentage,
  });
}

class QuizAdditionalDetail {
  int quizid;
  int courseid;
  int moduleid;
  String name;
  int timelimit;
  int maxattempts;
  int usercurrentattempts;

  QuizAdditionalDetail({
    this.quizid,
    this.courseid,
    this.moduleid,
    this.name,
    this.timelimit,
    this.maxattempts,
    this.usercurrentattempts,
  });
}
