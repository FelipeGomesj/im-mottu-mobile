import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mottu_marvel/screens/list_screen.dart';
import 'package:mottu_marvel/tools/dimension_extension.dart';
import 'package:mottu_marvel/widgets/list_tile_character.dart';
import '../model/character.dart';
import '../model/comics.dart';
import '../repository/comics_repo.dart';
import '../widgets/custom_padding.dart';
import '../widgets/list_tile_comic.dart';
import 'package:mottu_marvel/repository/character_repo.dart';
class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late Future<List<Character>> futureCharacters;
  late Future<List<Comics>> futureComics;

  bool loaded = false;
  bool loading = false;
  final characterRepo = CharacterRepo();
  final comicsRepo = ComicsRepo();
  @override
  void initState() {
    super.initState();
    if(loaded == false){
      setState(() {
        loading = true;
      });
      futureCharacters = characterRepo.fetchCharacters();
      futureComics = comicsRepo.fetchComics();
      setState(() {
        loading = false;
        loaded = true;
      });
    }
  }
  late double heigth;
  late double width;

  @override
  Widget build(BuildContext context) {
    heigth = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kToolbarHeight.hg,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      child: Text("UN"),
                    ),
                    20.wd,
                     const Text('User name', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    ),
                  ],
                ),
              ],
            ),
            30.hg,
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Characters', style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,),
                ),
                 GestureDetector(
                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListScreen(
                     characterList: futureCharacters,
                   ))),
                   child: Text('See all', style: TextStyle(
                     color: Colors.grey,
                     fontWeight: FontWeight.w500,
                     fontSize: 18,
                   ),
                   ),
                 )
              ],
            ),
            8.hg,
            FutureBuilder<List<Character>>(
                future: futureCharacters,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    final characters = snapshot.data;
                    return  Container(
                      height: heigth * 0.35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10, //characters!.length,
                        itemBuilder: (context, index){
                          final character = characters![index];
                          return ListTileCharacter(character);
                        },

                      ),
                    );
                  }else if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            Text("${snapshot.error}"),
                            16.hg,
                            ElevatedButton(onPressed: loading == false ?  () async{
                              setState(()  {
                                loaded = false;
                                loading = true;
                              });
                              futureCharacters = characterRepo.fetchCharacters();
                              setState(() {
                                loading = false;
                                loaded = true;
                              });
                            } : null, child: loading == false ? Text('Tente novamente', style: TextStyle(color: Colors.white, fontSize: 16),) : CircularProgressIndicator(), style: ButtonStyle(
                                backgroundColor:  MaterialStateProperty.all<Color>(Colors.red)
                            ),)
                          ],
                        ),
                      ),
                    );
                  }else{
                    return const Center(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                      ),
                    ),);
                  }
                }
            ),
            30.hg,
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Comics', style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListScreen(comicList: futureComics,))),
                  child: Text('See all', style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  ),
                ),
              ],
            ),
            8.hg,
            FutureBuilder<List<Comics>>(
                future: futureComics,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    final comics = snapshot.data;
                    return  Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: comics!.length,

                        itemBuilder: (context, index){
                          final comic = comics[index];
                          return ListTileComic(comic: comic, seeAll: false,);
                        },

                      ),
                    );
                  }else if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                          Text("${snapshot.error}"),
                            16.hg,
                            ElevatedButton(onPressed: loading == false ?  () async{
                              setState(()  {
                                loaded = false;
                                loading = true;
                              });
                              futureComics = comicsRepo.fetchComics();
                              setState(() {
                                loading = false;
                                loaded = true;
                              });

                            } : null, child: loading == false ? Text('Tente novamente', style: TextStyle(color: Colors.white, fontSize: 16),) : CircularProgressIndicator(), style: ButtonStyle(
                              backgroundColor:  MaterialStateProperty.all<Color>(Colors.red)
                            ),)
                          ],
                        ),
                      ),
                    );
                  }else{
                    return const Center(
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(
                        ),
                      ),);
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
