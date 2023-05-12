import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CharacterSearchDelegate extends SearchDelegate<String> {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  CharacterSearchDelegate({
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  List<Widget> buildActions(BuildContext context) => [];

  @override
  Widget buildLeading(BuildContext context) => BackButton();

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) => TextField(
    autofocus: true,
    onChanged: onSearchChanged,
    decoration: InputDecoration(
      hintText: 'Search characters...',
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.grey),
    ),
  );
}