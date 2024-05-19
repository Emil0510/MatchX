import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';
import '../pages/sign_in_sign_up/login_signup.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {


  int _currentIndex = 0;
  late List<String> onboardText;
  var isBackBtnVisible = false;
  var buttonText = "Irəli";
  final CarouselController _carouselController = CarouselController();



  final List<Widget> _pages = [
    Align(
      alignment: Alignment.center,
      child: Image.asset("assets/image1.png"),
      ),
    Align(
      alignment: Alignment.center,
      child: Image.asset("assets/image2.png"),
    ),
    Align(
      alignment: Alignment.center,
      child: Image.asset("assets/image3.png"),
    ),
    Align(
      alignment: Alignment.center,
      child: Image.asset("assets/image4.png"),
    ),
    Align(
      alignment: Alignment.center,
      child: Image.asset("assets/image5.png"),
    ),
  ];

  void onBackPressed(){
    setState(() {
      if(_currentIndex!=0){
        _carouselController.previousPage();
        buttonText = "Irəli";
        _currentIndex--;
        if(_currentIndex==0){
          isBackBtnVisible = false;
        }
      }
    });
  }

  void onNextPressed(){
    setState(() {
      if(_currentIndex<4){
        _carouselController.nextPage();
        _currentIndex++;
        isBackBtnVisible = true;
        if(_currentIndex==4){
          buttonText = "Tamamla";
        }
      }else if(_currentIndex == 4){
        finishOnboarding();
      }
    });
  }

  void finishOnboarding() async{
    var sharedPreferences = locator.get<SharedPreferences>();
    await sharedPreferences.setBool(shouldShowOnboardKey, false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInSignUp(),
      ),
          (e) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    onboardText = [
      "Öz komandanı qur!",
      "Komandana uyğun rəqib tap!",
      "Turnirlərə qoşul ve mükafatlan!",
      "Qalib ol sıralamaya gir!",
      "Yeni məkanlar tanı!"
    ];
  }

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CarouselSlider(
                  carouselController: _carouselController,
                  items: _pages,
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        if(index == 0){
                          isBackBtnVisible = false;
                        }else if(index == 1){
                          isBackBtnVisible = true;
                        }else if(index == 2){
                          isBackBtnVisible = true;
                        }else if(index == 3){
                          isBackBtnVisible = true;
                        }else if(index == 4){
                          isBackBtnVisible = true;
                          buttonText = "Tamamla";
                        }
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(onboardText[_currentIndex],textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: height/40, fontStyle: FontStyle.normal, decoration: TextDecoration.none,  fontFamily: 'NotoSans'),),
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _pages.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key ? const Color(goldColor) : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: height/10,
            left: width/20,
            right: width/20,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Visibility(
                  visible: isBackBtnVisible,
                  child: Container(
                    height: 45,
                    width: width / 3 - width/20,
                    decoration: const BoxDecoration(
                      color: Color(blackColor),// Background color of the container
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38, // Shadow color
                          offset: Offset(0, 4), // Offset of the shadow (x, y)
                          blurRadius: 6, // Spread of the shadow
                          spreadRadius: 0, // Expansion of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(goldColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),),
                      onPressed: onBackPressed,
                      child: const Center(
                        child: Text(
                          "Geri",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Color(blackColor),// Background color of the container
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38, // Shadow color
                          offset: Offset(0, 4), // Offset of the shadow (x, y)
                          blurRadius: 6, // Spread of the shadow
                          spreadRadius: 0, // Expansion of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(goldColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),),
                      onPressed: onNextPressed,
                      child:  Center(
                        child: Text(
                          buttonText,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
