import 'package:flutter/material.dart';

import '../core/services/app_services.dart';
import '../features/activity/activity_screen.dart';
import '../features/add_product/add_product_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/charity/charity_detail_screen.dart';
import '../features/chat/chat_detail_screen.dart';
import '../features/chat/chat_list_screen.dart';
import '../features/donate/donate_screen.dart';
import '../features/dropoff/dropoff_map_screen.dart';
import '../features/home/home_screen.dart';
import '../features/inbox/inbox_screen.dart';
import '../features/product/product_detail_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/seller/seller_profile_screen.dart';
import '../features/sell/sell_screen.dart';

class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String donate = '/donate';
  static const String sell = '/sell';
  static const String inbox = '/inbox';
  static const String profile = '/profile';
  static const String purchases = '/purchases';
  static const String listings = '/listings';
  static const String favorites = '/favorites';
  static const String productDetail = '/product-detail';
  static const String sellerProfile = '/seller-profile';
  static const String add = '/add';
  static const String charityDetail = '/charity-detail';
  static const String dropOffMap = '/drop-off-map';
  static const String chatList = '/chat-list';
  static const String chatDetail = '/chat-detail';

  static final services = AppServices.instance;

  static String get initialRoute =>
      services.authRepository.isAuthenticated ? home : login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute<void>(
          builder: (_) => services.authRepository.isAuthenticated
              ? const HomeScreen()
              : const LoginScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute<void>(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case donate:
        return MaterialPageRoute<void>(
          builder: (_) => const DonateScreen(),
          settings: settings,
        );
      case sell:
        return MaterialPageRoute<void>(
          builder: (_) => const SellScreen(),
          settings: settings,
        );
      case inbox:
        return MaterialPageRoute<void>(
          builder: (_) => const InboxScreen(),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute<void>(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      case purchases:
        return MaterialPageRoute<void>(
          builder: (_) => const ActivityScreen(
            args: ActivityScreenArgs(
              title: 'My Purchases',
              type: ActivityType.purchases,
            ),
          ),
          settings: settings,
        );
      case listings:
        return MaterialPageRoute<void>(
          builder: (_) => const ActivityScreen(
            args: ActivityScreenArgs(
              title: 'My Listings',
              type: ActivityType.listings,
            ),
          ),
          settings: settings,
        );
      case favorites:
        return MaterialPageRoute<void>(
          builder: (_) => const ActivityScreen(
            args: ActivityScreenArgs(
              title: 'Favorites',
              type: ActivityType.favorites,
            ),
          ),
          settings: settings,
        );
      case productDetail:
        final productId = settings.arguments as String;
        return MaterialPageRoute<void>(
          builder: (_) => ProductDetailScreen(productId: productId),
          settings: settings,
        );
      case sellerProfile:
        final sellerId = settings.arguments as String;
        return MaterialPageRoute<void>(
          builder: (_) => SellerProfileScreen(sellerId: sellerId),
          settings: settings,
        );
      case add:
        return MaterialPageRoute<void>(
          builder: (_) => const AddProductScreen(),
          settings: settings,
        );
      case charityDetail:
        final charityId = settings.arguments as String;
        return MaterialPageRoute<void>(
          builder: (_) => CharityDetailScreen(charityId: charityId),
          settings: settings,
        );
      case dropOffMap:
        return MaterialPageRoute<void>(
          builder: (_) => const DropOffMapScreen(),
          settings: settings,
        );
      case chatList:
        return MaterialPageRoute<void>(
          builder: (_) => const ChatListScreen(),
          settings: settings,
        );
      case chatDetail:
        final chatId = settings.arguments as String;
        return MaterialPageRoute<void>(
          builder: (_) => ChatDetailScreen(chatId: chatId),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}
