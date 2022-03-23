import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel(
      {required this.imageAssetPath, required this.title, required this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel slide1 = new SliderModel(
      title: "Welcome",
      desc: "Welcome to Foodica, your personal helper for tracking allergies.",
      imageAssetPath: "assets/start-1.png");
  slides.add(slide1);
  SliderModel slide2 = new SliderModel(
      title: "What does the app do?",
      desc:
          "Foodica helps you keep track of the types of food you eat and decides for you what you can or can't eat. All the foods you add to the app will be kept in the History tab.",
      imageAssetPath: "assets/start-2.png");
  slides.add(slide2);
  SliderModel slide3 = new SliderModel(
      title: "Tips",
      desc:
          "Need help with what foods you can or can't consume? Depending on the allergy you specified, the app will give you tips to let you live a better life.",
      imageAssetPath: "assets/start-3.png");

  slides.add(slide3);

  return slides;
}
