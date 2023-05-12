import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mottu_marvel/tools/dimension_extension.dart';
import 'package:mottu_marvel/widgets/list_tile_comic.dart';

import '../model/character.dart';
import '../model/comics.dart';
import '../repository/character_repo.dart';
import '../repository/comics_repo.dart';
import '../widgets/character_search_delegate.dart';
import '../widgets/list_tile_character.dart';

class ListScreen extends StatefulWidget {
  ListScreen({this.characterList, this.comicList});

  late final Future<List<Character>>? characterList;
  late final Future<List<Comics>>? comicList;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

late double heigth;
late double width;
bool loaded = false;
bool loading = false;
late String searchQuery = '';
FocusNode _focusNode = FocusNode();

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    heigth = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 36),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12, top: 24),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 28),
                    height: 24,
                    width: width * 0.7,
                    child: TextField(
                      focusNode: _focusNode,
                      onChanged: (text) {
                        setState(() {
                          searchQuery = text;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 4),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black26,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 12, top: 24),
                    child: InkWell(
                        onTap: () => _focusNode.requestFocus(),
                        child: const Icon(
                          Icons.search,
                          size: 28,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.hg,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: widget.characterList != null ? Text(
                'Character List',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ) : Text(
                'Comics List',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ) ,
            ),
            16.hg,
            Expanded(
              child: widget.characterList != null ? FutureBuilder<List<Character>>(
                  future: widget.characterList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final characters = snapshot.data;
                      final filteredCharacters = searchQuery == ''
                          ? characters!
                          : characters!.where((character) => character.name!.toLowerCase().contains(searchQuery.toLowerCase())).toList();
                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: filteredCharacters.length,
                        //characters!.length,
                        itemBuilder: (context, index) {
                          //final character = characters[index];
                          final character = filteredCharacters[index];
                          return ListTileCharacter(character);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: heigth * 0.4,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              Text("${snapshot.error}"),
                              16.hg,
                              ElevatedButton(
                                onPressed: loading == false
                                    ? () async {
                                        setState(() {
                                          loaded = false;
                                          loading = true;
                                        });
                                        widget.characterList =
                                            CharacterRepo().fetchCharacters();
                                        setState(() {
                                          loading = false;
                                          loaded = true;
                                        });
                                      }
                                    : null,
                                child: loading == false
                                    ? Text(
                                        'Tente novamente',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )
                                    : CircularProgressIndicator(),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red)),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }) : FutureBuilder<List<Comics>>(
                  future: widget.comicList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final comics = snapshot.data;
                      final filteredComics = searchQuery == ''
                          ? comics!
                          : comics!
                          .where((comics) => comics.title!
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                          .toList();
                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: filteredComics.length,
                        itemBuilder: (context, index) {
                          final comic = filteredComics[index];
                          return ListTileComic(comic: comic, seeAll: true,);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: heigth * 0.3,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              Text("${snapshot.error}"),
                              16.hg,
                              ElevatedButton(
                                onPressed: loading == false
                                    ? () async {
                                  setState(() {
                                    loaded = false;
                                    loading = true;
                                  });
                                  widget.comicList = ComicsRepo().fetchComics();
                                  setState(() {
                                    loading = false;
                                    loaded = true;
                                  });
                                }
                                    : null,
                                child: loading == false
                                    ? Text(
                                  'Tente novamente',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                                    : CircularProgressIndicator(),
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
