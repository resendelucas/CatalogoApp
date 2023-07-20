import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DatabaseHelper.dart';
import 'videoCard.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final nameController = TextEditingController();
  final thumbnailController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final releaseController = TextEditingController();

  String selectedAge = 'Livre';

  final List<bool> _typeSelected = [true, false];
  final List<String> _typeOptions = ['Filme', 'Série'];
  final List<String> _ageOptions = ['Livre', '10', '12', '14', '16', '18'];
  final List<bool> _ageSelected = [true, false, false, false, false, false];
  final List<bool> _genreSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  final List<String> genreList = [
    'Ação',
    'Animação',
    'Aventura',
    'Comédia',
    'Crime',
    'Documentário',
    'Drama',
    'Esportes',
    'Fantasia',
    'Ficção',
    'Guerra',
    'Mistério',
    'Musical',
    'Policial',
    'Reality',
    'Romance',
    'Sobrevivência',
    'Suspense',
    'Terror',
    'Variedades'
  ];

  final List<String> _selectedGenres = [];

  void changeGenreList(index) {
    if (_genreSelected[index] == false) {
      _genreSelected[index] = true;
    } else {
      _genreSelected[index] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                left: 10,
                right: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Nome do vídeo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: thumbnailController,
                      decoration: InputDecoration(
                          labelText: 'Url da imagem',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                        readOnly: true,
                        controller: releaseController,
                        decoration: InputDecoration(
                            labelText: 'Data de Lançamento',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2024));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/y').format(pickedDate);

                            setState(() {
                              releaseController.text = formattedDate;
                            });
                          } else {
                            print("Data não selecionada");
                          }
                        }),
                    SizedBox(height: 20),
                    TextField(
                      controller: durationController,
                      decoration: InputDecoration(
                          labelText: 'Duração',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    _generateTypeSelectableList(),
                    SizedBox(height: 20),
                    _generateGenreSelectableList(),
                    SizedBox(height: 20),
                    _generateAgeSelectableList(),
                    SizedBox(height: 20),
                    TextField(
                      controller: descriptionController,
                      maxLines: 6,
                      minLines: 1,
                      decoration: InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < _genreSelected.length; i++) {
                                if (_genreSelected[i])
                                  _selectedGenres.add(genreList[i]);
                              }
                              print(_selectedGenres);
                              for (int i = 0; i < _ageSelected.length; i++) {
                                if (_ageSelected[i])
                                  selectedAge = _ageOptions[i];
                              }
                            });
                            DatabaseHelper().saveVideoDb(
                                nameController.text,
                                descriptionController.text,
                                _typeSelected[0] ? 0 : 1,
                                selectedAge,
                                int.parse(durationController.text),
                                thumbnailController.text,
                                releaseController.text,
                                _selectedGenres);

                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Salvar',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ]),
            )));
  }

  Widget _generateGenreSelectableList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: genreList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                changeGenreList(index);
              });
            },
            child: Container(
              height: 10,
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color:
                      _genreSelected[index] ? Colors.blue[100] : Colors.white),
              child: Text(genreList[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _generateAgeSelectableList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _ageOptions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < _ageSelected.length; i++) {
                  _ageSelected[i] = i == index;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color: _ageSelected[index] ? Colors.blue[100] : Colors.white),
              child: Text(_ageOptions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _generateTypeSelectableList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _typeOptions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < _typeSelected.length; i++) {
                  _typeSelected[i] = i == index;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color:
                      _typeSelected[index] ? Colors.blue[100] : Colors.white),
              child: Text(_typeOptions[index]),
            ),
          );
        },
      ),
    );
  }
}

class EditVideoScreen extends StatefulWidget {
  const EditVideoScreen({super.key, required this.video});

  final VideoDb video;

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  final nameController = TextEditingController();
  final thumbnailController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final releaseController = TextEditingController();

  String selectedAge = '';

  final List<bool> _typeSelected = [true, false];
  final List<String> _typeOptions = ['Filme', 'Série'];
  final List<String> _ageOptions = ['Livre', '10', '12', '14', '16', '18'];
  final List<bool> _ageSelected = [false, false, false, false, false, false];
  final List<bool> _genreSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  final List<String> genreList = [
    'Ação',
    'Animação',
    'Aventura',
    'Comédia',
    'Crime',
    'Documentário',
    'Drama',
    'Esportes',
    'Fantasia',
    'Ficção',
    'Guerra',
    'Mistério',
    'Musical',
    'Policial',
    'Reality',
    'Romance',
    'Sobrevivência',
    'Suspense',
    'Terror',
    'Variedades'
  ];


  // List<String> generos = [];

  final List<String> _selectedGenres = [];

  void changeGenreList(index) {
    if (_genreSelected[index] == false) {
      _genreSelected[index] = true;
    } else {
      _genreSelected[index] = false;
    }
  }

  @override
  void initState() {
    nameController.text = widget.video.name;
    descriptionController.text = widget.video.description;
    thumbnailController.text = widget.video.thumbnailImageId;
    durationController.text = widget.video.durationMinutes.toString();
    releaseController.text = widget.video.releaseDate;

    if (widget.video.type == 0) {
      _typeSelected[0] = true;
      _typeSelected[1] = false;
    } else if (widget.video.type == 1) {
      _typeSelected[1] = true;
      _typeSelected[0] = false;
    }

    // _getListGenres();
    // print(generos.length);
    for (int i = 0; i < widget.video.genres.length; i++) {
      for (int j = 0; j < genreList.length; j++){
        if (widget.video.genres[i] == genreList[j]){
          _genreSelected[j] = true;
        }
      }
    }
    print(_genreSelected);

    for (int i = 0; i < _ageOptions.length; i++){
      if(widget.video.ageRestriction == _ageOptions[i]){
        _ageSelected[i] = true;
        break;
      }
    }


    super.initState();
  }

  // void _getListGenres() async {
  //   generos =  await DatabaseHelper().genresByVideo(widget.video.name);
  // }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                left: 10,
                right: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Nome do vídeo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: thumbnailController,
                      decoration: InputDecoration(
                          labelText: 'Url da imagem',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                        readOnly: true,
                        controller: releaseController,
                        decoration: InputDecoration(
                            labelText: 'Data de Lançamento',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2024));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/y').format(pickedDate);

                            setState(() {
                              releaseController.text = formattedDate;
                            });
                          } else {
                            print("Data não selecionada");
                          }
                        }),
                    SizedBox(height: 20),
                    TextField(
                      controller: durationController,
                      decoration: InputDecoration(
                          labelText: 'Duração',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    _generateTypeSelectableList(),
                    SizedBox(height: 20),
                    _generateGenreSelectableList(),
                    SizedBox(height: 20),
                    _generateAgeSelectableList(),
                    SizedBox(height: 20),
                    TextField(
                      controller: descriptionController,
                      maxLines: 6,
                      minLines: 1,
                      decoration: InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < _genreSelected.length; i++) {
                                if (_genreSelected[i])
                                  _selectedGenres.add(genreList[i]);
                              }
                              print(_selectedGenres);
                              for (int i = 0; i < _ageSelected.length; i++) {
                                if (_ageSelected[i])
                                  selectedAge = _ageOptions[i];
                              }

                            });
                            DatabaseHelper().modifyVideo(
                              widget.video.id,
                                nameController.text,
                                descriptionController.text,
                                _typeSelected[0] ? 0 : 1,
                                selectedAge,
                                int.parse(durationController.text),
                                thumbnailController.text,
                                releaseController.text,
                                );

                            VideoDb video = VideoDb(
                              widget.video.id,
                                nameController.text,
                                descriptionController.text,
                                _typeSelected[0] ? 0 : 1,
                                selectedAge,
                                int.parse(durationController.text),
                                thumbnailController.text,
                                releaseController.text,
                                _selectedGenres
                                );
                            Navigator.pop(context, video);
                          },
                          child: const Text(
                            'Salvar',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ]),
            )));
  }

  Widget _generateGenreSelectableList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: genreList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                changeGenreList(index);
              });
            },
            child: Container(
              height: 10,
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color:
                      _genreSelected[index] ? Colors.blue[100] : Colors.white),
              child: Text(genreList[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _generateAgeSelectableList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _ageOptions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < _ageSelected.length; i++) {
                  _ageSelected[i] = i == index;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color: _ageSelected[index] ? Colors.blue[100] : Colors.white),
              child: Text(_ageOptions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _generateTypeSelectableList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _typeOptions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < _typeSelected.length; i++) {
                  _typeSelected[i] = i == index;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color:
                      _typeSelected[index] ? Colors.blue[100] : Colors.white),
              child: Text(_typeOptions[index]),
            ),
          );
        },
      ),
    );
  }
}
