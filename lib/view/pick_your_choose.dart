import 'package:chaplin_new_version/controler/setting.dart';
import 'package:chaplin_new_version/controler/story_api.dart';
import 'package:chaplin_new_version/controler/wordpress_connector.dart';
import 'package:chaplin_new_version/helper/app_localization.dart';
import 'package:chaplin_new_version/helper/my_app.dart';
import 'package:chaplin_new_version/model/global.dart';
import 'package:chaplin_new_version/model/product.dart';
import 'package:chaplin_new_version/model/story.dart';
import 'package:chaplin_new_version/view/billing.dart';
import 'package:chaplin_new_version/view/dashboard.dart';
import 'package:chaplin_new_version/view/favorite.dart';
import 'package:chaplin_new_version/view/music.dart';
import 'package:chaplin_new_version/view/my_story_view.dart';
import 'package:chaplin_new_version/view/photo_picker.dart';
import 'package:chaplin_new_version/view/qr_scanner.dart';
import 'package:chaplin_new_version/view/shipping.dart';
import 'package:chaplin_new_version/view/sign_in.dart';
import 'package:chaplin_new_version/view/story_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/story_view.dart';

class PickChoose extends StatefulWidget {

  List<Story> stories;
  Story? my_story;

  PickChoose(this.stories,this.my_story){
    Global.stories=this.stories;
  }

  @override
  _PickChooseState createState() => _PickChooseState(this.stories,this.my_story);
}

class _PickChooseState extends State<PickChoose> {

  var loading = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List<Product> products=<Product>[];
  int selected_category = 0;

  final ImagePicker _picker = ImagePicker();
  List<Story> stories;
  Story? my_story;
  bool pick=false;

  _PickChooseState(this.stories,this.my_story);

  get_search(String query){
    setState(() {
      loading=true;
      WordPressConnecter.get_products_search(query).then((value){
        products=value;
        selected_category=-1;
        loading=false;
      }).catchError((){
        loading=false;
      });
    });
  }
  _calc_total(){
    setState(() {
      Global.total=Global.get_total();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/sidebar_cover.png"),
                    fit: BoxFit.cover
                )
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          AppSetting.set_verificated(false);
                          AppSetting.save("non", "non");
                          AppSetting.set_timer("non");
                          Global.customer=null;
                          Global.customer_id=-1;
                          Navigator.pushNamedAndRemoveUntil(context, "signIn", (r) => false);
                        },
                        child: Padding(padding: EdgeInsets.only(top: 15,left: 15,right: 15),
                          child: Global.customer==null?Center():Text(App_Localization.of(context)!.translate("logout"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.3,
                          height: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(App_Localization.of(context)!.translate("charlie_chaplin"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 4,
                          width: 40,
                          color: Colors.black87,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(Global.customer==null){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Sign_In()),
                              );
                            }else{
                              setState(() {
                                // print(Global.customer!.id!);
                                StoryApi.get_stories(Global.customer_id).then((value) {
                                  StoryApi.get_my_story(Global.customer_id).then((my_story){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PhotoPicker(value,my_story)),
                                    );
                                  });

                                });
                              });

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Profile()),
                              // );
                            }

                          },
                          child: Padding(padding: EdgeInsets.only(left: 15,right: 15),
                            child: Text(App_Localization.of(context)!.translate("profile"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Container(
                          height: 4,
                          width: 40,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //
                  //       GestureDetector(
                  //         onTap: (){
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => const MyPoints()),
                  //           );
                  //         },
                  //         child: Padding(padding: EdgeInsets.only(left: 15,right: 15),
                  //           child: Text("MY POINTS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //
                  //       GestureDetector(
                  //         onTap: (){
                  //           if(Global.customer!=null){
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(builder: (context) => Billing(0)),
                  //             );
                  //           }else{
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(builder: (context) => Sign_In()),
                  //             );
                  //             // _scaffoldkey.currentState!.showSnackBar(must_login_snackBar);
                  //           }
                  //         },
                  //         child: Padding(padding: EdgeInsets.only(left: 15,right: 15),
                  //           child: Text("MY BILL",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Favorite()),
                            );
                          },
                          child: Padding(padding: EdgeInsets.only(left: 15,right: 15),
                            child: Text(App_Localization.of(context)!.translate("favorite"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(Global.customer!=null){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Shipping(0)),
                              );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Billing(0)),
                              );
                              // _scaffoldkey.currentState!.showSnackBar(must_login_snackBar);
                            }
                          },
                          child: Padding(padding: EdgeInsets.only(left: 15,right: 15),
                            child: Text(App_Localization.of(context)!.translate("my_address"),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: (){
                          //todo nav to instgram
                        }, icon: const ImageIcon(
                          AssetImage("assets/social-media/insta.png"),
                          size: 40,
                        )),
                        IconButton(onPressed: (){
                          //todo nav to twitter
                        }, icon: const ImageIcon(
                          AssetImage("assets/social-media/twitter.png"),
                          size: 40,
                        )),
                        IconButton(onPressed: (){
                          //todo nav to facebook
                        }, icon: const ImageIcon(
                          AssetImage("assets/social-media/facebook.png"),
                          size: 40,
                        )),
                        IconButton(onPressed: (){
                          //todo nav to youtube
                        }, icon: const ImageIcon(
                          AssetImage("assets/social-media/youtube.png",),
                          size: 25,
                        )),

                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                        GestureDetector(
                          child: Text(App_Localization.of(context)!.translate("privace_policy"),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                          onTap: (){
                            // Todo : nav
                          },
                        ),
                        Text("."),
                        GestureDetector(
                          child: Text(App_Localization.of(context)!.translate("term_of_sale"),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                          onTap: (){
                            // Todo : nav
                          },
                        ),
                        Text("."),
                        GestureDetector(
                          child: Text(App_Localization.of(context)!.translate("term_of_use"),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                          onTap: (){
                            // Todo : nav
                          },
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                        GestureDetector(
                          child: Text(App_Localization.of(context)!.translate("return_policy"),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                          onTap: (){
                            // Todo : nav
                          },
                        ),
                        Text("."),
                        GestureDetector(
                          child: Text(App_Localization.of(context)!.translate("warranty_policy"),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                          onTap: (){
                            // Todo : nav
                          },
                        ),



                        SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(App_Localization.of(context)!.translate("version"),style: TextStyle(fontSize: 10,color: Colors.grey),),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(App_Localization.of(context)!.translate("rights"),style: TextStyle(fontSize: 8,color: Colors.black,),),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    width: MediaQuery.of(context).size.width*0.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/black_logo.png",),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      key: _scaffoldkey,
      backgroundColor: Color(0xff231F20),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  pick=false;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height*0.27,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25))
                                ),
                                child:  Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 5,bottom: 5),
                                      child: SvgPicture.asset("assets/pick_page/logo.svg",height: 40,)
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _scaffoldkey.currentState!.openDrawer();
                                          },
                                          icon: SvgPicture.asset(
                                              "assets/details.svg",
                                              color: Color(0xff272525),
                                              semanticsLabel: 'details'
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width>=400?MediaQuery.of(context).size.width * 0.7:MediaQuery.of(context).size.width * 0.5,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Color(0xff272525),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextField(
                                              onSubmitted: (q){
                                                get_search(q);
                                              },
                                              cursorColor: Colors.white,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.search, size: 18, color: Colors.white.withOpacity(0.5),),
                                                prefixIconConstraints: BoxConstraints(
                                                  minHeight: 0,
                                                  minWidth: 0,
                                                ),
                                                hintText: App_Localization.of(context)!.translate("find_your_favorite_dish"),
                                                hintStyle: TextStyle(
                                                  color: Colors.white.withOpacity(0.5),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Global.get_cart(context).then((value) {
                                              _calc_total();
                                            });
                                          },
                                          /**/
                                          icon: Icon(
                                            Icons.shopping_cart,
                                            color: Color(0xff272525),
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              /*
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.09,
                                  child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: Global.stories.length+1,
                                        itemBuilder: (context,index){
                                          return index==0?
                                          my_story==null?Padding(
                                            padding: const EdgeInsets.only(left: 5,right: 5),
                                            child: GestureDetector(
                                              onTap: (){
                                                //showAlertDialog(context);
                                                //  setState(() {
                                                //    pick=true;
                                                //  });
                                                if(Global.customer_id==-1){
                                                  App.err_msg(context, App_Localization.of(context)!.translate("login_first"));
                                                }else{
                                                  //showAlertDialog(context);
                                                  setState(() {
                                                    pick=true;
                                                  });
                                                }
                                              },
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 600),
                                                width: !pick ? MediaQuery.of(context).size.height*0.08 : MediaQuery.of(context).size.height*0.075,
                                                height: MediaQuery.of(context).size.height*0.08,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff231F20),
                                                  border: Border.all(color: Colors.white,width: 2),
                                                ),
                                                child: AnimatedSwitcher(
                                                    duration: Duration(milliseconds: 600),
                                                    child: !pick ? Icon(Icons.add,size: 40,color: Colors.white,) : Text('')
                                                ),
                                              ),
                                            ),
                                          ):Padding(
                                            padding: const EdgeInsets.only(left: 5,right: 5),
                                            child: GestureDetector(
                                              onTap: (){
                                                //get_images(my_story.id,index-1);
                                                get_images_my_story();
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.height*0.08,
                                                height: MediaQuery.of(context).size.height*0.08,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.white,width: 3),
                                                    image: my_story!.image.endsWith("mp4")?DecorationImage(
                                                        image:AssetImage("assets/chapo.png"),
                                                        fit: BoxFit.cover
                                                    ):DecorationImage(
                                                        image:NetworkImage(StoryApi.media_url+my_story!.image),
                                                        fit: BoxFit.cover
                                                    )
                                                ),
                                              ),
                                            ),
                                          )
                                              : Padding(
                                            padding: const EdgeInsets.only(left: 5,right: 5),
                                            child: GestureDetector(
                                              onTap: (){
                                                get_images(Global.stories[index-1].id,index-1);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.height*0.08+9,
                                                height: MediaQuery.of(context).size.height*0.08+9,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient:Global.stories[index-1].readed==0? LinearGradient(
                                                    colors: [
                                                      Colors.orange,
                                                      Colors.pinkAccent,
                                                    ],
                                                  ): LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                  // borderRadius: BorderRadius.circular(35),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.height*0.08+3,
                                                    height: MediaQuery.of(context).size.height*0.08+3,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(3),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.height*0.08,
                                                        height: MediaQuery.of(context).size.height*0.08,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,

                                                            image: Global.stories[index-1].image.endsWith("mp4")?DecorationImage(
                                                                image:AssetImage("assets/chapo.png"),
                                                                fit: BoxFit.cover
                                                            ):DecorationImage(
                                                                image:NetworkImage(StoryApi.media_url+Global.stories[index-1].image),
                                                                fit: BoxFit.cover
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                               */
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.09,
                                  child: Padding(padding: EdgeInsets.only(left: 20,right: 20),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: Global.stories.length+1,
                                        itemBuilder: (context,index){
                                          return index==0?
                                          my_story==null?Padding(
                                            padding: const EdgeInsets.only(left: 5,right: 5),
                                            child:
                                                /** my add button*/
                                            GestureDetector(
                                              onTap: (){
                                                //showAlertDialog(context);
                                                //  setState(() {
                                                //    pick=true;
                                                //  });
                                                if(Global.customer_id==-1){
                                                  App.err_msg(context, App_Localization.of(context)!.translate("login_first"));
                                                }else{
                                                  //showAlertDialog(context);
                                                  setState(() {
                                                    pick=true;
                                                  });
                                                }
                                              },
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 600),
                                                width: !pick ? MediaQuery.of(context).size.height*0.08 : MediaQuery.of(context).size.height*0.075,
                                                height: MediaQuery.of(context).size.height*0.08,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff231F20),
                                                  border: Border.all(color: Colors.white,width: 2),
                                                ),
                                                child: AnimatedSwitcher(
                                                    duration: Duration(milliseconds: 600),
                                                    child: !pick ? Icon(Icons.add,size: 40,color: Colors.white,) : Text('')
                                                ),
                                              ),
                                            ),
                                          )
                                          :Padding(
                                            padding: const EdgeInsets.only(left: 5,right: 5),
                                            child: GestureDetector(
                                              onTap: (){
                                                //get_images(my_story.id,index-1);
                                                get_images_my_story();
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.height*0.08,
                                                height: MediaQuery.of(context).size.height*0.08,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.white,width: 3),
                                                    image: my_story!.image.endsWith("mp4")?DecorationImage(
                                                        image:AssetImage("assets/chapo.png"),
                                                        fit: BoxFit.cover
                                                    ):DecorationImage(
                                                        image:NetworkImage(StoryApi.media_url+my_story!.image),
                                                        fit: BoxFit.cover
                                                    )
                                                ),
                                              ),
                                            ),
                                          )
                                              : Padding(
                                            padding: const EdgeInsets.only(left: 5,right: 5),
                                            child: GestureDetector(
                                              onTap: (){
                                                get_images(Global.stories[index-1].id,index-1);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.height*0.08+9,
                                                height: MediaQuery.of(context).size.height*0.08+9,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient:Global.stories[index-1].readed==0? LinearGradient(
                                                    colors: [
                                                      Colors.orange,
                                                      Colors.pinkAccent,
                                                    ],
                                                  ): LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                  // borderRadius: BorderRadius.circular(35),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.height*0.08+3,
                                                    height: MediaQuery.of(context).size.height*0.08+3,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(3),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.height*0.08,
                                                        height: MediaQuery.of(context).size.height*0.08,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,

                                                            image: Global.stories[index-1].image.endsWith("mp4")?DecorationImage(
                                                                image:AssetImage("assets/chapo.png"),
                                                                fit: BoxFit.cover
                                                            ):DecorationImage(
                                                                image:NetworkImage(StoryApi.media_url+Global.stories[index-1].image),
                                                                fit: BoxFit.cover
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                          height: MediaQuery.of(context).size.height *0.07,
                          child: Center(child: Text("We are in your service",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),))
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => const DashBoard()),);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/pick_page/m.png"),
                                fit: BoxFit.cover
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset("assets/pick_page/menu.svg",width: 60,),
                              Container(
                                width: MediaQuery.of(context).size.width*0.95-120,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Menu",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Great food within minutes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            Global.option = 0;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QRScanner()),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const MusicView()),
                          // );
                          //Navigator.push(context,  MaterialPageRoute(builder: (context) => const DashBoard()),);
                        },
                        child: Container(
                          height:120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/pick_page/2.png"),
                                fit: BoxFit.cover
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset("assets/pick_page/music.svg",width: 60,),
                              Container(
                                width: MediaQuery.of(context).size.width*0.95-120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Music",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Life is a song, let's enjoy together some good music",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          //Navigator.push(context,  MaterialPageRoute(builder: (context) => const DashBoard()),);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoPicker(stories, my_story)),
                          );
                        },
                        child: Container(
                          height:120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/pick_page/3.png"),
                                fit: BoxFit.cover
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset("assets/pick_page/story.svg",width: 60,),
                              Container(
                                width: MediaQuery.of(context).size.width*0.95-120,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Chaplin friends ",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Capture and share your special moments with us! ",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          //Navigator.push(context,  MaterialPageRoute(builder: (context) => const DashBoard()),);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QRScanner()),
                          );
                        },
                        child: Container(
                          height:120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/pick_page/4.png"),
                                fit: BoxFit.cover
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset("assets/pick_page/car.svg",width: 60,),
                              Container(
                                width: MediaQuery.of(context).size.width*0.95-120,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Valet",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text("Ready to go? Request your car now",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Positioned(child: loading?Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ):Center()),

            Positioned(
                left: 22,
                top: MediaQuery.of(context).size.height*0.25-MediaQuery.of(context).size.height*0.04,
                child: Padding(
                padding: const EdgeInsets.only(left: 5,right: 5),
                   child: GestureDetector(
                    onTap: (){
                      setState(() {
                        pick=false;
                      });

                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                     curve: Curves.easeInOut,
                  width: MediaQuery.of(context).size.height*0.068,
                  height: pick?160:0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(MediaQuery.of(context).size.height*0.04),
                        topLeft: Radius.circular(5),
                        topRight : Radius.circular(5),
                        bottomLeft: Radius.circular(MediaQuery.of(context).size.height*0.04),
                      ),
                      color: Color(0xff231F20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white.withOpacity(0),
                            blurRadius: 0.1,
                            spreadRadius: 0.1,
                            offset: Offset(0,1)
                        )
                      ]
                  ),
                  child:SingleChildScrollView(
                    child: Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                              _picker.pickMultiImage().then((value) async{
                                pick_image(value!);
                              });
                            }, icon: Icon(Icons.photo,size: 35,color: Colors.white,),),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: (){
                                List<XFile> value=<XFile>[];
                                _picker.pickVideo(source: ImageSource.gallery).then((file) {
                                  value.add(file!);
                                  pick_image(value);
                                });
                              }, icon: Icon(Icons.video_call_outlined,size: 38,color: Colors.white,)),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: (){
                                List<XFile> value=<XFile>[];
                                _picker.pickImage(source: ImageSource.camera).then((file) {
                                  value.add(file!);
                                  pick_image(value);
                                });
                              }, icon: Icon(Icons.camera_alt,size: 33,color: Colors.white,)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Please pick"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              _picker.pickMultiImage().then((value) async{
                pick_image(value!);
              });
            }, icon: Icon(Icons.photo,size: 50,),),
          IconButton(
              padding: EdgeInsets.all(0),
              onPressed: (){
                List<XFile> value=<XFile>[];
                _picker.pickVideo(source: ImageSource.gallery).then((file) {
                  value.add(file!);
                  pick_image(value);
                });
              }, icon: Icon(Icons.video_call_outlined,size: 50)),
          IconButton(
              padding: EdgeInsets.all(0),
              onPressed: (){
                List<XFile> value=<XFile>[];
                _picker.pickImage(source: ImageSource.camera).then((file) {
                  value.add(file!);
                  pick_image(value);
                });
              }, icon: Icon(Icons.camera_alt,size: 50)),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  pick_image(List<XFile> value)async{

    Navigator.pop(context);
    setState(() {
      // images!.add(value!);
      loading = true;

    });
    for(int i=0;i<value.length;i++){
      await StoryApi.add_story(Global.customer_id, value[i].path);
    }

    StoryApi.get_my_story(Global.customer_id).then((value) {

      setState(() {
        my_story=value;
      });
      print(my_story!.image);
    });
    setState(() {
      loading=false;
    });

    // Navigator.pop(context);

    //Navigator.pop(context);


    // Navigator.pop(context);
  }

  // pick_image()async{
  //     _picker.pickMultiImage().then((value) async{
  //       setState(() {
  //         // images!.add(value!);
  //         loading = true;
  //
  //       });
  //       for(int i=0;i<value!.length;i++){
  //         print(Global.customer_id!=-1);
  //         await StoryApi.add_story(Global.customer_id, value[i].path);
  //         print('****');
  //       }
  //       setState(() {
  //         StoryApi.get_stories(Global.customer_id).then((value) {
  //           stories=value;
  //           Global.stories=value;
  //         });
  //         loading=false;
  //
  //       });
  //
  //
  //   });
  // }
  get_images(int id,int index){
    setState(() {
      loading=true;
    });
    List<StoryItem> storyItems=<StoryItem>[];
    final controller = StoryController();
    StoryApi.get_images(id).then((value) {
      for(int i=0;i<value.length;i++){
        if(value[i].link.endsWith("mp4")){
          print('******************************');
          print(StoryApi.media_url+value[i].link);
          storyItems.add(StoryItem.pageVideo(StoryApi.media_url+value[i].link,controller: controller));
        }else{
          storyItems.add(StoryItem.pageImage(url: StoryApi.media_url+value[i].link,controller: controller));
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Story_View(storyItems,controller,Global.stories,index)),
      ).then((value){
        setState(() {
          loading=false;
          Global.stories;
        });
      });
    });
  }
  get_images_my_story(){
    setState(() {
      loading=true;
    });
    List<StoryItem> storyItems=<StoryItem>[];
    final controller = StoryController();
    StoryApi.get_images(my_story!.id).then((value) {
      for(int i=0;i<value.length;i++){
        if(value[i].link.endsWith("mp4")){
          print('******************************');
          print(StoryApi.media_url+value[i].link);
          storyItems.add(StoryItem.pageVideo(StoryApi.media_url+value[i].link,controller: controller));
        }else{
          storyItems.add(StoryItem.pageImage(url: StoryApi.media_url+value[i].link,controller: controller));
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyStory_View(storyItems,controller,value)),
      ).then((value){
        StoryApi.get_my_story(Global.customer_id).then((value) {
          setState(() {
            loading=false;
            my_story=value;
          });
        });

      });
    });
  }

}

