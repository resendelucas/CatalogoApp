import 'package:flutter/material.dart';
import 'videoCard.dart';
import 'videosTeste.dart';

class SearchVideos extends StatefulWidget {
  const SearchVideos({super.key});

  @override
  State<SearchVideos> createState() => _SearchVideosState();
}

class _SearchVideosState extends State<SearchVideos> {
  final searchController = TextEditingController();

  final List<bool> _selectedTypeVideo = [true, false];
  final List<String> genreList = [ 'Todos', 'Ação','Animação', 'Aventura', 'Comédia',
  'Drama', 'Ficção', 'Romance','Suspense', 
  'Terror', 'Fantasia', 'Musical', 'Reality',
  'Variedades', 'Documentário'];

  String genreSelected = 'Todos';


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
                  fillColor: Colors.transparent,
                  
                  labelText: 'Pesquisar',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    
                    borderSide: BorderSide(
                      color: Colors.black
                    ),
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ToggleButtons(
                  renderBorder: false,
                  children:[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Filmes', style: TextStyle(color: Colors.white),)),
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
                DecoratedBox(
                  
                  decoration: BoxDecoration(
                    color:  Colors.transparent,
                    border: Border.all(color: Colors.black38, width: 2),
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color.fromARGB(0, 0, 0, 60),
                        blurRadius: 5
                      )
                    ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    
                    child: DropdownButton(
                      icon: Icon(Icons.arrow_circle_down_rounded),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.transparent,
                      menuMaxHeight: 250,
                      underline: Container(),
                      style: TextStyle(color: Colors.white),
                      items: _generateDropdownItems(genreList), 
                      value: genreSelected,
                      onChanged: (dynamic value){
                        if (value is String){
                          setState(() {
                            genreSelected = value;
                          });
                        }
                      }),
                  ),
                )
              ],
            ),
          ),
          Flexible(
            child: gridVideosBuilder(videolistTest),
            )
        ],
      ),
    );
  }

  List<DropdownMenuItem> _generateDropdownItems(List<String> itemList){
    List<DropdownMenuItem> items = [];
    for (int i = 0; i<itemList.length; i++){
      items.add(DropdownMenuItem(
        child: Text(itemList[i]), value: itemList[i]));
    }
    return items;
  }

  Widget gridVideosBuilder(List<Video> videolist){
    return GridView.builder(
      itemCount: videolist.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // mainAxisSpacing: 16,
        // crossAxisSpacing: 16
      ), 
      itemBuilder:(context, index) {
        // return VideoCard(video: videolist[index]);
      },);
  }
}
