import 'package:flutter/material.dart';

class SearchVideos extends StatefulWidget {
  const SearchVideos({super.key});

  @override
  State<SearchVideos> createState() => _SearchVideosState();
}

class _SearchVideosState extends State<SearchVideos> {
  final searchController = TextEditingController();

  final List<bool> _selectedTypeVideo = [true, false];
  final List<String> genreList = ['Ação','Animação', 'Aventura', 'Comédia',
  'Drama', 'Ficção', 'Romance','Suspense', 
  'Terror', 'Fantasia', 'Musical', 'Reality',
  'Variedades', 'Documentário', 'Todos'];

  String genreSelected = 'Todos';

  void dropdownCallback (String? selectedValue){
    if (selectedValue is String){
      setState(() {
        genreSelected = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                prefixIconColor: Colors.white,
                  filled: true,
                  fillColor: Color.fromARGB(255, 75, 75, 75),
                  labelText: 'Pesquisar',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Row(
              children: [
                ToggleButtons(
                  renderBorder: false,
                  children:[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Filme', style: TextStyle(color: Colors.white),)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Series', style: TextStyle(color: Colors.white),)),
                  ],
                  isSelected: _selectedTypeVideo,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _selectedTypeVideo.length; i++){
                        _selectedTypeVideo[i] = i == index;
                      }
                    });
                  }),
                // DropdownButton(
                //   items: _generateDropdownItems(genreList), 
                //   value: genreSelected,
                //   onChanged: dropdownCallback)
              ],
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem> _generateDropdownItems(List<String> itemList){
    List<DropdownMenuItem> items = [];
    for (int i = 0; i<itemList.length; i++){
      items.add(DropdownMenuItem(child: Text(itemList[i]), value: itemList[i]));
    }
    return items;
  }
}
