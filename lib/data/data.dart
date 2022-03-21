import 'package:flutter/material.dart';


class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath,this.title,this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("Welcome to Foodica, your personal helper for tracking allergies.");
  sliderModel.setTitle("Welcome");
  sliderModel.setImageAssetPath("assets/start-1.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Foodica helps you keep track of the types of food you eat and decides for you what you can or can't eat. All the foods you add to the app will be kept in the History tab.");
  sliderModel.setTitle("What does the app do?");
  sliderModel.setImageAssetPath("assets/start-2.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("Need help with what foods you can or can't consume? Depending on the allergy you specified, the app will give you tips to let you live a better life.");
  sliderModel.setTitle("Tips");
  sliderModel.setImageAssetPath("assets/card1bg.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}