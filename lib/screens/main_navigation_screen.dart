import 'package:flutter/material.dart';
import 'book/book_list_screen.dart';
import 'book/book_form_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final GlobalKey<BookFormScreenState> _formKey = GlobalKey();

  List<Widget> get _screens => [
    const BookListScreen(),
    BookFormScreen(key: _formKey, onBookAdded: _onBookAdded),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBookAdded() {
    // Switch to Books tab after adding a book
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      // floatingActionButton: _currentIndex == 0
      //     ? FloatingActionButton.extended(
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 1;
      //           });
      //         },
      //         icon: const Icon(Icons.add),
      //         label: const Text('Tambah Buku'),
      //         backgroundColor: const Color(0xFFCFAB8D),
      //         foregroundColor: Colors.white,
      //         elevation: 4,
      //       )
      //     : null,
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Buku'),
              backgroundColor: const Color(0xFFCFAB8D),
              foregroundColor: Colors.white,
              elevation: 4,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFCFAB8D),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              activeIcon: Icon(Icons.book, size: 28),
              label: 'Buku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle, size: 28),
              label: 'Tambah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
