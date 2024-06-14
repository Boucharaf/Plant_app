import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'notification_service.dart';
import 'package:plantapp/plant.dart';
import 'package:plantapp/aquatiques.dart' as aquatiques;
import 'package:plantapp/aromatiques.dart' as aromatiques;
import 'package:plantapp/culinaires.dart' as culinaires;
import 'package:plantapp/medicinales.dart' as medicinales;
import 'package:plantapp/ornementales.dart' as ornementales;
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'parametres.dart';
import 'propos.dart';

List<Plant> plants = [
  ...aquatiques.plants,
  ...aromatiques.plants,
  ...culinaires.plants,
  ...medicinales.plants,
  ...ornementales.plants,
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  notificationService.init().then((_) {
    notificationService.scheduleDailyNotification(
      0,
      'Learn about a new plant!',
      'Today\'s plant: Aloe Vera. Aloe Vera is a succulent plant species of the genus Aloe.',
    );
  });
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: MyApp1(),
    ),
  );
}

class MyApp1 extends StatelessWidget {
  final String name;
  final String firstName;

  MyApp1({this.name = '', this.firstName = ''});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            brightness:
                settings.isDayNight ? Brightness.dark : Brightness.light,
          ),
          home: HomePage(name: ' ${name}', firstName: '${firstName}'),
        );
      },
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => {FlutterExitApp.exitApp()},
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String name;
  final String firstName;

  HomePage({this.name = '', this.firstName = ''});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myCurrentIndex = 0;
  String selectedFilter = 'All';
  List<Plant> favorites = [];
  String searchQuery = '';

  void _addFavorite(Plant plant) {
    setState(() {
      favorites.add(plant);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${plant.name} a été ajouté aux favoris')),
    );
  }

  List<Plant> filteredPlants = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    plants.sort((a, b) => a.name.compareTo(b.name));
    filteredPlants = plants;
  }

  void _filterPlants(String letter) {
    final int index =
        filteredPlants.indexWhere((plant) => plant.name.startsWith(letter));
    if (index != -1) {
      _scrollController
          .jumpTo(index * 56.0); // Adjust 56.0 based on your ListTile height
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        List<Plant> filteredPlants = selectedFilter == 'All'
            ? plants
            : plants
                .where((plant) => plant.category == selectedFilter)
                .toList();

        if (searchQuery.isNotEmpty) {
          filteredPlants = filteredPlants
              .where((plant) =>
                  plant.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
        }

        String welcomeMessage =
            settings.selectedLanguage == 'Français' ? 'Bienvenue' : 'Welcome';
        if (widget.name.isNotEmpty || widget.firstName.isNotEmpty) {
          welcomeMessage += ' ${widget.name} ${widget.firstName}'.trim();
        }

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) {
              return;
            }
            final bool shouldPop =
                await ExitConfirmationDialog.show(context) ?? false;
            if (context.mounted && shouldPop) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFF569C3B),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    welcomeMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            drawer: Drawer(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 160,
                          child: DrawerHeader(
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Text(
                              settings.selectedLanguage == 'Français'
                                  ? 'Liste de toutes les plantes'
                                  : 'List of all plants',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            children: filteredPlants
                                .map((plant) => ListTile(
                                      title: Text(plant.name),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlantDetailsPage(
                                                        plant: plant)));
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    color: settings.isDayNight
                        ? Color(0xFF151515)
                        : Color(0xFFE8E0F0),
                    child: ListView(
                      children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                          .split('')
                          .map((letter) => GestureDetector(
                                onTap: () {
                                  _filterPlants(letter);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    letter,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            body: IndexedStack(
              index: myCurrentIndex,
              children: [
                // Page d'accueil
                Container(
                  color: settings.isDayNight
                      ? Color(0xFF151515)
                      : Color(0xFFE8F2E7),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: settings.selectedLanguage == 'Français'
                              ? 'Recherche'
                              : 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: settings.isDayNight
                              ? Color(0xFF303030)
                              : Color(0xFFFEF8FF),
                        ),
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterButton(
                              text: settings.selectedLanguage == 'Français'
                                  ? 'Toutes'
                                  : 'All',
                              selected: selectedFilter == 'All',
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'All';
                                });
                              },
                            ),
                            FilterButton(
                              text: settings.selectedLanguage == 'Français'
                                  ? 'Plantes aquatiques'
                                  : 'Aquatic plants',
                              selected: selectedFilter == 'Plantes aquatiques',
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Plantes aquatiques';
                                });
                              },
                            ),
                            FilterButton(
                              text: settings.selectedLanguage == 'Français'
                                  ? 'Plantes médicinales'
                                  : 'Medicinal plants',
                              selected: selectedFilter == 'Plantes médicinales',
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Plantes médicinales';
                                });
                              },
                            ),
                            FilterButton(
                              text: settings.selectedLanguage == 'Français'
                                  ? 'Plantes culinaires'
                                  : 'Culinary plants',
                              selected: selectedFilter == 'Plantes culinaires',
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Plantes culinaires';
                                });
                              },
                            ),
                            FilterButton(
                              text: settings.selectedLanguage == 'Français'
                                  ? 'Plantes aromatiques'
                                  : 'Aromatic plants',
                              selected: selectedFilter == 'Plantes aromatiques',
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Plantes aromatiques';
                                });
                              },
                            ),
                            FilterButton(
                              text: settings.selectedLanguage == 'Français'
                                  ? 'Plantes ornementales'
                                  : 'Ornamental plants',
                              selected:
                                  selectedFilter == 'Plantes ornementales',
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Plantes ornementales';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredPlants.length,
                          itemBuilder: (context, index) {
                            Plant plant = filteredPlants[index];
                            bool isFavorite = favorites.contains(plant);

                            return PlantCard(
                              imageUrl: plant.image,
                              name: plant.name,
                              isFavorite: isFavorite,
                              onFavoriteToggle: () {
                                setState(() {
                                  if (isFavorite) {
                                    favorites.remove(plant);
                                  } else {
                                    _addFavorite(plant);
                                  }
                                });
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlantDetailsPage(plant: plant),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                // Page des favoris
                FavoritesPage(favorites: favorites),
                // Page des paramètres
                SettingsPage(),
                // Page à propos
                AboutPage(),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  color: Color(0xFF569C3B),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Color(0xFF569C3B),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white70,
                    currentIndex: myCurrentIndex,
                    onTap: (index) {
                      setState(() {
                        myCurrentIndex = index;
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: settings.selectedLanguage == 'Français'
                              ? 'Accueil'
                              : 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.favorite),
                          label: settings.selectedLanguage == 'Français'
                              ? 'Favoris'
                              : 'Favorites'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: settings.selectedLanguage == 'Français'
                              ? 'Paramètres'
                              : 'Settings'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.info),
                          label: settings.selectedLanguage == 'Français'
                              ? 'Conditions et Termes d\'utilisation'
                              : 'Terms and Conditions'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<Plant> favorites;

  FavoritesPage({required this.favorites});

  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          settings.selectedLanguage == 'Français' ? 'Favoris' : 'Favorites',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF569C3B),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text(
                settings.selectedLanguage == 'Français'
                    ? 'Pas de plantes favoris'
                    : 'No favorite plants',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                Plant plant = favorites[index];

                return PlantCard(
                  imageUrl: plant.image,
                  name: plant.name,
                  isFavorite: true,
                  onFavoriteToggle: () {
                    // Favorite toggle not needed in favorites page
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailsPage(plant: plant),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class PlantDetailsPage extends StatelessWidget {
  final Plant plant;
  final String plantDetails =
      'Détails about the plant... Contact: example@example.com';

  PlantDetailsPage({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, settings, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(plant.name),
          backgroundColor: Color(0xFF569C3B),
          actions: [
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: plant.description));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text copied to clipboard')),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                _shareContent(context);
              },
            ),
          ],
        ),
        body: Container(
          color: settings.isDayNight ? Color(0xFF151515) : Color(0xFFE8F2E7),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(plant.image),
                SizedBox(height: 20),
                Text(
                  plant.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  plant.description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _shareContent(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    Share.share(
      plantDetails,
      subject: 'Check out this plant detail',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  FilterButton({
    required this.text,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.green : Color(0xFFFEF8FF),
          foregroundColor: selected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  PlantCard({
    required this.imageUrl,
    required this.name,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ExitConfirmationDialog {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => {FlutterExitApp.exitApp()},
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
