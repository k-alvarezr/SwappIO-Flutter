import 'package:flutter/material.dart';

import '../../viewModel/AppServicesViewModel.dart';
import '../ActivityView.dart';
import '../AddProductView.dart';
import 'AsyncStateView.dart';
import '../LoginView.dart';
import '../RegisterView.dart';
import '../CharityDetailView.dart';
import '../ChatDetailView.dart';
import '../ChatListView.dart';
import '../DonateView.dart';
import '../DropoffMapView.dart';
import '../HomeView.dart';
import '../InboxView.dart';
import '../ProductDetailView.dart';
import '../ProfileView.dart';
import '../SellerProfileView.dart';
import '../SellView.dart';
import '../ReportsDashboardView.dart';

class AppRoutesView {
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
  static const String reports = '/reports';

  static final services = AppServicesViewModel.instance;

  static String get initialRoute =>
      services.authRepository.isAuthenticated ? home : login;

  static Route<dynamic> _invalidArgumentsRoute(
    RouteSettings settings,
    String message,
  ) {
    return MaterialPageRoute<void>(
      builder: (_) => AsyncStateView(message: message),
      settings: settings,
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute<void>(
          builder: (_) => services.authRepository.isAuthenticated
              ? const HomeView()
              : const LoginView(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginView(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute<void>(
          builder: (_) => const RegisterView(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeView(),
          settings: settings,
        );
      case donate:
        return MaterialPageRoute<void>(
          builder: (_) => const DonateView(),
          settings: settings,
        );
      case sell:
        return MaterialPageRoute<void>(
          builder: (_) => const SellView(),
          settings: settings,
        );
      case inbox:
        return MaterialPageRoute<void>(
          builder: (_) => const InboxView(),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute<void>(
          builder: (_) => const ProfileView(),
          settings: settings,
        );
      case purchases:
        return MaterialPageRoute<void>(
          builder: (_) => const ActivityView(
            args: ActivityViewArgs(
              title: 'My Purchases',
              type: ActivityType.purchases,
            ),
          ),
          settings: settings,
        );
      case listings:
        return MaterialPageRoute<void>(
          builder: (_) => const ActivityView(
            args: ActivityViewArgs(
              title: 'My Listings',
              type: ActivityType.listings,
            ),
          ),
          settings: settings,
        );
      case favorites:
        return MaterialPageRoute<void>(
          builder: (_) => const ActivityView(
            args: ActivityViewArgs(
              title: 'Favorites',
              type: ActivityType.favorites,
            ),
          ),
          settings: settings,
        );
      case productDetail:
        final productId = settings.arguments;
        if (productId is! String || productId.isEmpty) {
          return _invalidArgumentsRoute(settings, 'No se recibio un producto valido.');
        }
        return MaterialPageRoute<void>(
          builder: (_) => ProductDetailView(productId: productId),
          settings: settings,
        );
      case sellerProfile:
        final sellerId = settings.arguments;
        if (sellerId is! String || sellerId.isEmpty) {
          return _invalidArgumentsRoute(settings, 'No se recibio un vendedor valido.');
        }
        return MaterialPageRoute<void>(
          builder: (_) => SellerProfileView(sellerId: sellerId),
          settings: settings,
        );
      case add:
        return MaterialPageRoute<void>(
          builder: (_) => const AddProductView(),
          settings: settings,
        );
      case charityDetail:
        final charityId = settings.arguments;
        if (charityId is! String || charityId.isEmpty) {
          return _invalidArgumentsRoute(settings, 'No se recibio una fundacion valida.');
        }
        return MaterialPageRoute<void>(
          builder: (_) => CharityDetailView(charityId: charityId),
          settings: settings,
        );
      case dropOffMap:
        return MaterialPageRoute<void>(
          builder: (_) => const DropoffMapView(),
          settings: settings,
        );
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsDashboardView());
      case chatList:
        return MaterialPageRoute<void>(
          builder: (_) => const ChatListView(),
          settings: settings,
        );
      case chatDetail:
        final chatId = settings.arguments;
        if (chatId is! String || chatId.isEmpty) {
          return _invalidArgumentsRoute(settings, 'No se recibio una conversacion valida.');
        }
        return MaterialPageRoute<void>(
          builder: (_) => ChatDetailView(chatId: chatId),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginView(),
          settings: settings,
        );
    }
  }
}


