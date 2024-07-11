import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itt632_nashcafe/Admin%20Directory/Category/addCategory.dart';
import 'package:itt632_nashcafe/Admin%20Directory/Category/editCategory.dart';
import 'package:itt632_nashcafe/Admin%20Directory/Product/addProduct.dart';
import 'package:itt632_nashcafe/Admin%20Directory/Product/menuList.dart';
import 'package:itt632_nashcafe/Admin%20Directory/Rating/ratingList.dart';
import 'package:itt632_nashcafe/Customer%20Directory/Maps/map.dart';
import 'package:itt632_nashcafe/Customer%20Directory/Menu/addtocart.dart';
import 'package:itt632_nashcafe/Customer%20Directory/Order/orderhistory.dart';
import 'package:itt632_nashcafe/Customer%20Directory/Profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Customer Directory/customer_home.dart';
import 'Admin Directory/admin_home.dart';
import 'Authentication/register.dart';
import 'Authentication/login.dart';
import 'Configuration/networkConfig.dart';
import 'Splash Screen/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isAdmin = prefs.getString('role') == 'admin';

  String initialRoute = isLoggedIn ? (isAdmin ? '/admin-home' : '/customer-home') : '/splashscreen';
  Stripe.publishableKey = 'pk_test_51OUK7WEr0NpAF3HwF5mQWoOcFypOGkz2dvG32tWJOzXxCV6Sp3Qeb0l2Zz9osPFbEqYiW2UyrQWqvCjanjEmobw400waSPtJwN';

  // await dotenv.load(fileName: "assets/.env");

  runApp(MyApp(initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp(this.initialRoute, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor primarySwatchWhite = MaterialColor(
      0xFFFFFFFF, // 0xFFFFFFFF is white, you can adjust shades as needed
      <int, Color>{
        50: Color(0xFFFAFAFA), // Very light shade
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFE0E0E0),
        400: Color(0xFFBDBDBD),
        500: Colors.white, // Normal white
        600: Color(0xFF757575),
        700: Color(0xFF616161),
        800: Color(0xFF424242),
        900: Color(0xFF212121), // Very dark shade
      },
    );
    return MaterialApp(
      title: 'Nash Cafe Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatchWhite,

        ),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      initialRoute: initialRoute,
      routes: {
    //Authentication Route
        '/splashscreen': (context) => HomePage(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginPage(),

    //Admin Route
        '/admin-home': (context) => AdminHomePage(),
        '/admin-rating-list' : (context) => AdminRatingListPage(),
        '/admin-product-list' : (context) => AdminMenuList(),
        '/admin-create-product' : (context) => CreateProductPage(),
        '/admin-create-category' : (context) => AddCategoryPage(),
        // '/admin-edit-category' : (context) => EditCategoryPage(),

    //Customer Route
        '/customer-home': (context) => CustomerHomePage(),
        '/map': (context) => MapScreen(),
        '/order-history': (context) => OrdersHistoryPage(),
        '/profile': (context) => MyProfilePage(),
        // 'cart': (context) => CartPage(),

        // '/menu': (context) => MenuPage(), // Remove static route definition for MenuPage
      },
    );
  }
}
