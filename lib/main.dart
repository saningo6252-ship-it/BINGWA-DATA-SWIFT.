import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const BingwaDataSwiftApp());
}

class BDSColors {
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color primaryGreen = Color(0xFF22A06B);
  static const Color lightGreenAccent = Color(0xFF4ADE80);
  static const Color softGreenBg = Color(0xFFEAF9F1);
  static const Color lightGreenBadgeBg = Color(0xFFD1FAE5);
  static const Color lightGreyPill = Color(0xFFEEEEEE);
  static const Color blackText = Color(0xFF111111);
  static const Color greyText = Color(0xFF666666);
  static const Color cardBorder = Color(0xFFDCEEE4);
  static const Color dangerRed = Color(0xFFB91C1C);
  static const Color amberBg = Color(0xFFFEF3C7);
  static const Color amberText = Color(0xFFB45309);
}

class OfferModel {
  final String id;
  final String network;
  final String name;
  final String priceLabel;
  final int? fixedPriceKes;
  final int? minKes;
  final int? maxKes;
  final String validity;
  final String category;
  final bool isVisible;

  const OfferModel({
    required this.id,
    required this.network,
    required this.name,
    required this.priceLabel,
    this.fixedPriceKes,
    this.minKes,
    this.maxKes,
    required this.validity,
    required this.category,
    this.isVisible = true,
  });

  bool get isFlexibleAmount => fixedPriceKes == null;

  OfferModel copyWith({
    String? id,
    String? network,
    String? name,
    String? priceLabel,
    int? fixedPriceKes,
    int? minKes,
    int? maxKes,
    String? validity,
    String? category,
    bool? isVisible,
  }) {
    return OfferModel(
      id: id ?? this.id,
      network: network ?? this.network,
      name: name ?? this.name,
      priceLabel: priceLabel ?? this.priceLabel,
      fixedPriceKes: fixedPriceKes ?? this.fixedPriceKes,
      minKes: minKes ?? this.minKes,
      maxKes: maxKes ?? this.maxKes,
      validity: validity ?? this.validity,
      category: category ?? this.category,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class AdItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const AdItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class OrderRecord {
  final String orderId;
  final String network;
  final String bundleName;
  final String recipientPhone;
  final String paymentPhone;
  final int amountKes;
  final String paymentRef;
  final String dateLabel;
  final String paymentStatus;
  final String deliveryStatus;

  const OrderRecord({
    required this.orderId,
    required this.network,
    required this.bundleName,
    required this.recipientPhone,
    required this.paymentPhone,
    required this.amountKes,
    required this.paymentRef,
    required this.dateLabel,
    required this.paymentStatus,
    required this.deliveryStatus,
  });
}

class Catalogue68 {
  static const String appName = 'BINGWA DATA SWIFT';
  static const String tagline = 'Bundles and airtime that keep you connected.';
  static const String whatsappPhone = '0794363801';
  static const String callPhone = '0794363801';
  static const String adminPhone = '0794363801';
  static const String adminAccessCode = '2026';
  static const String whatsappGroupUrl =
      'https://chat.whatsapp.com/DB9snd9pSXf9vVrTN3vhTR?s=cl&p=a&iam=2';
  static const String appDownloadBaseUrl = 'https://bingwadataswift.app/download';

  static const List<OfferModel> initialOffers = [
    OfferModel(id: 's_dc_1', network: 'SAFARICOM', name: '10MB+7SMS', priceLabel: 'KES 8', fixedPriceKes: 8, validity: '24Hrs', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_2', network: 'SAFARICOM', name: '250MB', priceLabel: 'KES 20', fixedPriceKes: 20, validity: '24Hrs', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_3', network: 'SAFARICOM', name: '1GB', priceLabel: 'KES 21', fixedPriceKes: 21, validity: '1Hr', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_4', network: 'SAFARICOM', name: '1GB', priceLabel: 'KES 19', fixedPriceKes: 19, validity: '1Hr', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_5', network: 'SAFARICOM', name: '450MB', priceLabel: 'KES 32', fixedPriceKes: 32, validity: 'Till Midnight', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_6', network: 'SAFARICOM', name: '1.5GB', priceLabel: 'KES 53', fixedPriceKes: 53, validity: '3Hrs', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_7', network: 'SAFARICOM', name: '750MB+50SMS', priceLabel: 'KES 54', fixedPriceKes: 54, validity: '24Hrs', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_8', network: 'SAFARICOM', name: '1GB', priceLabel: 'KES 55', fixedPriceKes: 55, validity: 'Till Midnight', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_9', network: 'SAFARICOM', name: '400MB', priceLabel: 'KES 56', fixedPriceKes: 56, validity: '7Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_10', network: 'SAFARICOM', name: '400MB', priceLabel: 'KES 49', fixedPriceKes: 49, validity: '7Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_11', network: 'SAFARICOM', name: '900MB', priceLabel: 'KES 58', fixedPriceKes: 58, validity: 'Till Midnight', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_12', network: 'SAFARICOM', name: '1GB', priceLabel: 'KES 60', fixedPriceKes: 60, validity: 'Till Midnight', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_13', network: 'SAFARICOM', name: '1.25GB', priceLabel: 'KES 78', fixedPriceKes: 78, validity: 'Till Midnight', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_14', network: 'SAFARICOM', name: '1.5GB+40SMS+WhatsApp', priceLabel: 'KES 106', fixedPriceKes: 106, validity: '24Hrs', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_15', network: 'SAFARICOM', name: '2GB', priceLabel: 'KES 110', fixedPriceKes: 110, validity: '24Hrs', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_16', network: 'SAFARICOM', name: '2.5GB', priceLabel: 'KES 99', fixedPriceKes: 99, validity: '24Hrs', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_17', network: 'SAFARICOM', name: '2.5GB', priceLabel: 'KES 250', fixedPriceKes: 250, validity: '30Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_18', network: 'SAFARICOM', name: '5GB', priceLabel: 'KES 255', fixedPriceKes: 255, validity: '3Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_19', network: 'SAFARICOM', name: '2.5GB', priceLabel: 'KES 256', fixedPriceKes: 256, validity: '30Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_20', network: 'SAFARICOM', name: '4GB+220Mins+50SMS', priceLabel: 'KES 505', fixedPriceKes: 505, validity: '7Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_21', network: 'SAFARICOM', name: '11GB+Free YouTube', priceLabel: 'KES 509', fixedPriceKes: 509, validity: '7Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_22', network: 'SAFARICOM', name: '21GB', priceLabel: 'KES 1006', fixedPriceKes: 1006, validity: '30Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_23', network: 'SAFARICOM', name: '21GB', priceLabel: 'KES 1020', fixedPriceKes: 1020, validity: '30Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_dc_24', network: 'SAFARICOM', name: '150GB', priceLabel: 'KES 5012', fixedPriceKes: 5012, validity: '30Days', category: 'DATA/COMBO'),
    OfferModel(id: 's_m_1', network: 'SAFARICOM', name: '45Mins', priceLabel: 'KES 23', fixedPriceKes: 23, validity: '3Hrs', category: 'MINUTES'),
    OfferModel(id: 's_m_2', network: 'SAFARICOM', name: '45Mins', priceLabel: 'KES 22', fixedPriceKes: 22, validity: '3Hrs', category: 'MINUTES'),
    OfferModel(id: 's_m_3', network: 'SAFARICOM', name: '500Flex', priceLabel: 'KES 34', fixedPriceKes: 34, validity: '2Hrs', category: 'MINUTES'),
    OfferModel(id: 's_m_4', network: 'SAFARICOM', name: '60Mins', priceLabel: 'KES 51', fixedPriceKes: 51, validity: 'Till Midnight', category: 'MINUTES'),
    OfferModel(id: 's_m_5', network: 'SAFARICOM', name: '350Flex', priceLabel: 'KES 65', fixedPriceKes: 65, validity: 'Till Midnight', category: 'MINUTES'),
    OfferModel(id: 's_m_6', network: 'SAFARICOM', name: '1000Flex', priceLabel: 'KES 107', fixedPriceKes: 107, validity: 'Till Midnight', category: 'MINUTES'),
    OfferModel(id: 's_m_7', network: 'SAFARICOM', name: '250Mins', priceLabel: 'KES 249', fixedPriceKes: 249, validity: '7Days', category: 'MINUTES'),
    OfferModel(id: 's_m_8', network: 'SAFARICOM', name: '300Mins', priceLabel: 'KES 506', fixedPriceKes: 506, validity: '30Days', category: 'MINUTES'),
    OfferModel(id: 's_m_9', network: 'SAFARICOM', name: '1000Mins', priceLabel: 'KES 1017', fixedPriceKes: 1017, validity: '30Days', category: 'MINUTES'),
    OfferModel(id: 's_m_10', network: 'SAFARICOM', name: '1250Mins', priceLabel: 'KES 1019', fixedPriceKes: 1019, validity: '30Days', category: 'MINUTES'),
    OfferModel(id: 's_m_11', network: 'SAFARICOM', name: '1250Mins', priceLabel: 'KES 1010', fixedPriceKes: 1010, validity: '30Days', category: 'MINUTES'),
    OfferModel(id: 's_s_1', network: 'SAFARICOM', name: '20SMS', priceLabel: 'KES 5', fixedPriceKes: 5, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 's_s_2', network: 'SAFARICOM', name: '200SMS', priceLabel: 'KES 10', fixedPriceKes: 10, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 's_s_3', network: 'SAFARICOM', name: '200SMS', priceLabel: 'KES 12', fixedPriceKes: 12, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 's_s_4', network: 'SAFARICOM', name: 'Unlimited SMS', priceLabel: 'KES 28', fixedPriceKes: 28, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 's_s_5', network: 'SAFARICOM', name: '1000SMS', priceLabel: 'KES 30', fixedPriceKes: 30, validity: '7Days', category: 'SMS'),
    OfferModel(id: 's_s_6', network: 'SAFARICOM', name: '1000SMS', priceLabel: 'KES 33', fixedPriceKes: 33, validity: '7Days', category: 'SMS'),
    OfferModel(id: 's_s_7', network: 'SAFARICOM', name: 'Unlimited SMS', priceLabel: 'KES 64', fixedPriceKes: 64, validity: '7Days', category: 'SMS'),
    OfferModel(id: 's_s_8', network: 'SAFARICOM', name: '1500SMS', priceLabel: 'KES 103', fixedPriceKes: 103, validity: '30Days', category: 'SMS'),
    OfferModel(id: 's_s_9', network: 'SAFARICOM', name: '3500SMS', priceLabel: 'KES 209', fixedPriceKes: 209, validity: '30Days', category: 'SMS'),
    OfferModel(id: 's_ne_1', network: 'SAFARICOM', name: 'No Expiry Airtime', priceLabel: 'KES 1-499', fixedPriceKes: null, minKes: 1, maxKes: 499, validity: 'No Expiry', category: 'NO EXPIRY'),
    OfferModel(id: 's_ne_2', network: 'SAFARICOM', name: 'No Expiry Data', priceLabel: 'KES 1-499', fixedPriceKes: null, minKes: 1, maxKes: 499, validity: 'No Expiry', category: 'NO EXPIRY'),
    OfferModel(id: 'a_1', network: 'AIRTEL', name: '40SMS', priceLabel: 'KES 6', fixedPriceKes: 6, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 'a_2', network: 'AIRTEL', name: '1200 On-Net SMS', priceLabel: 'KES 13', fixedPriceKes: 13, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 'a_3', network: 'AIRTEL', name: '250SMS', priceLabel: 'KES 15', fixedPriceKes: 15, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 'a_4', network: 'AIRTEL', name: '500SMS', priceLabel: 'KES 24', fixedPriceKes: 24, validity: '24Hrs', category: 'SMS'),
    OfferModel(id: 'a_5', network: 'AIRTEL', name: '50Mins', priceLabel: 'KES 27', fixedPriceKes: 27, validity: '2Days', category: 'MINUTES'),
    OfferModel(id: 'a_6', network: 'AIRTEL', name: '350 Airtel Mins', priceLabel: 'KES 61', fixedPriceKes: 61, validity: '7Days', category: 'MINUTES'),
    OfferModel(id: 'a_7', network: 'AIRTEL', name: '1500 Airtel Mins', priceLabel: 'KES 160', fixedPriceKes: 160, validity: '30Days', category: 'MINUTES'),
    OfferModel(id: 'a_8', network: 'AIRTEL', name: '3GB', priceLabel: 'KES 261', fixedPriceKes: 261, validity: '30Days', category: 'DATA'),
    OfferModel(id: 'a_9', network: 'AIRTEL', name: '12GB', priceLabel: 'KES 510', fixedPriceKes: 510, validity: '7Days', category: 'DATA'),
    OfferModel(id: 'a_10', network: 'AIRTEL', name: '8GB', priceLabel: 'KES 511', fixedPriceKes: 511, validity: '30Days', category: 'DATA'),
    OfferModel(id: 'a_11', network: 'AIRTEL', name: '25GB', priceLabel: 'KES 1015', fixedPriceKes: 1015, validity: '30Days', category: 'DATA'),
    OfferModel(id: 'a_12', network: 'AIRTEL', name: '55GB', priceLabel: 'KES 2017', fixedPriceKes: 2017, validity: '30Days', category: 'DATA'),
    OfferModel(id: 'a_13', network: 'AIRTEL', name: '55GB', priceLabel: 'KES 6020', fixedPriceKes: 6020, validity: '90Days', category: 'DATA'),
    OfferModel(id: 't_1', network: 'TELKOM', name: 'Madaraka Life 1GB+100 Onnet Mins', priceLabel: 'KES 63', fixedPriceKes: 63, validity: '30Days', category: 'COMBO'),
    OfferModel(id: 't_2', network: 'TELKOM', name: 'Mambo 199 6GB+200 Telkom Mins', priceLabel: 'KES 204', fixedPriceKes: 204, validity: '30Days', category: 'COMBO'),
    OfferModel(id: 'f_1', network: 'FAIBA', name: '500MB', priceLabel: 'KES 26', fixedPriceKes: 26, validity: '24Hrs', category: 'DATA'),
    OfferModel(id: 'f_2', network: 'FAIBA', name: '1.5GB', priceLabel: 'KES 59', fixedPriceKes: 59, validity: '24Hrs', category: 'DATA'),
    OfferModel(id: 'f_3', network: 'FAIBA', name: '3GB', priceLabel: 'KES 109', fixedPriceKes: 109, validity: '3Days', category: 'DATA'),
    OfferModel(id: 'f_4', network: 'FAIBA', name: '10GB', priceLabel: 'KES 311', fixedPriceKes: 311, validity: '7Days', category: 'DATA'),
    OfferModel(id: 'f_5', network: 'FAIBA', name: '15GB', priceLabel: 'KES 520', fixedPriceKes: 520, validity: '30Days', category: 'DATA'),
    OfferModel(id: 'f_6', network: 'FAIBA', name: '40GB', priceLabel: 'KES 1014', fixedPriceKes: 1014, validity: '30Days', category: 'DATA'),
    OfferModel(id: 'f_7', network: 'FAIBA', name: '120GB', priceLabel: 'KES 2020', fixedPriceKes: 2020, validity: '30Days', category: 'DATA'),
  ];
}

String _normalizePhone(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('254') && digits.length == 12) {
    return '0${digits.substring(3)}';
  }
  return digits;
}

bool _checkIsAdmin(String phone, String pin) {
  return _normalizePhone(phone) == _normalizePhone(Catalogue68.adminPhone) &&
      pin.trim() == Catalogue68.adminAccessCode;
}

Future<String?> pickImageFromGallery(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) {
      return null;
    }
    return picked.path;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open gallery on this device.')),
      );
    }
    return null;
  }
}

Widget buildAvatarWidget({
  required String? imagePath,
  required double radius,
  Color bgColor = BDSColors.softGreenBg,
  Color iconColor = BDSColors.primaryGreen,
}) {
  if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      backgroundImage: FileImage(File(imagePath)),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: bgColor,
    child: Icon(Icons.person, color: iconColor, size: radius),
  );
}

Future<void> openWhatsAppDirect(BuildContext context) async {
  final digits = Catalogue68.whatsappPhone.replaceAll(RegExp(r'\D'), '');
  final international = digits.startsWith('0') ? '254${digits.substring(1)}' : digits;
  final uri = Uri.parse('https://wa.me/$international');
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open WhatsApp on this device.')),
    );
  }
}

Future<void> openCallDirect(BuildContext context) async {
  final uri = Uri(scheme: 'tel', path: Catalogue68.callPhone);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open phone dialer on this device.')),
    );
  }
}

Future<void> openWhatsAppGroupDirect(BuildContext context) async {
  final uri = Uri.parse(Catalogue68.whatsappGroupUrl);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open WhatsApp group link.')),
    );
  }
}

class BingwaDataSwiftApp extends StatefulWidget {
  const BingwaDataSwiftApp({super.key});

  @override
  State<BingwaDataSwiftApp> createState() => _BingwaDataSwiftAppState();
}

class _BingwaDataSwiftAppState extends State<BingwaDataSwiftApp> {
  bool _showSplash = true;
  bool _isAuthenticated = false;
  bool _isAdmin = false;
  String _userName = 'Bingwa User';
  String _userPhone = '07XXXXXXXX';
  String _userPin = '1234';
  String? _profilePhotoPath;
  bool _storeOpen = true;

  List<OfferModel> _offers = List<OfferModel>.from(Catalogue68.initialOffers);
  List<AdItem> _ads = [
    const AdItem(
      id: 'ad_1',
      title: 'Fast Data & Minutes Across Networks',
      subtitle: 'Instant M-Pesa STK Push checkout with clear bundle details.',
      icon: Icons.bolt,
    ),
    const AdItem(
      id: 'ad_2',
      title: 'Safaricom, Airtel, Telkom & Faiba',
      subtitle: 'Select your network and confirm your recipient number easily.',
      icon: Icons.wifi_tethering,
    ),
  ];
  final List<OrderRecord> _orders = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  void _onLoginSuccess({
    String? name,
    String? phone,
    String? pin,
    String? profilePhotoPath,
  }) {
    final resolvedPhone = (phone != null && phone.trim().isNotEmpty)
        ? phone.trim()
        : _userPhone;
    final resolvedPin = (pin != null && pin.length == 4)
        ? pin
        : _userPin;

    setState(() {
      if (name != null && name.trim().isNotEmpty) {
        _userName = name.trim();
      }
      _userPhone = resolvedPhone;
      _userPin = resolvedPin;
      if (profilePhotoPath != null && profilePhotoPath.isNotEmpty) {
        _profilePhotoPath = profilePhotoPath;
      }
      _isAdmin = _checkIsAdmin(resolvedPhone, resolvedPin);
      _isAuthenticated = true;
    });
  }

  void _onLogout() {
    setState(() {
      _isAuthenticated = false;
      _isAdmin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Catalogue68.appName,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: BDSColors.pureWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BDSColors.primaryGreen,
          primary: BDSColors.primaryGreen,
          surface: BDSColors.pureWhite,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: BDSColors.primaryGreen,
            foregroundColor: BDSColors.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.normal, color: BDSColors.blackText),
          bodyMedium: TextStyle(fontWeight: FontWeight.normal, color: BDSColors.blackText),
          titleMedium: TextStyle(fontWeight: FontWeight.w500, color: BDSColors.blackText),
        ),
      ),
      home: _showSplash
          ? const SplashScreen()
          : !_isAuthenticated
              ? AuthScreen(onSuccess: _onLoginSuccess)
              : MainShellScreen(
                  userName: _userName,
                  userPhone: _userPhone,
                  profilePhotoPath: _profilePhotoPath,
                  isAdmin: _isAdmin,
                  storeOpen: _storeOpen,
                  offers: _offers,
                  ads: _ads,
                  orders: _orders,
                  onLogout: _onLogout,
                  onUpdatePin: (newPin) {
                    setState(() {
                      _userPin = newPin;
                      _isAdmin = _checkIsAdmin(_userPhone, newPin);
                    });
                  },
                  onUpdateProfilePhoto: (path) => setState(() => _profilePhotoPath = path),
                  onToggleStore: (open) => setState(() => _storeOpen = open),
                  onAddOffer: (offer) => setState(() => _offers.insert(0, offer)),
                  onEditOffer: (updated) {
                    setState(() {
                      final idx = _offers.indexWhere((o) => o.id == updated.id);
                      if (idx != -1) _offers[idx] = updated;
                    });
                  },
                  onDeleteOffer: (id) {
                    setState(() => _offers.removeWhere((o) => o.id == id));
                  },
                  onAddAd: (ad) => setState(() => _ads.add(ad)),
                  onRemoveAd: (index) => setState(() => _ads.removeAt(index)),
                  onRecordStkAttempt: (order) => setState(() => _orders.insert(0, order)),
                  onClearOrders: () => setState(() => _orders.clear()),
                ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: BDSColors.softGreenBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: BDSColors.lightGreenAccent, width: 1.5),
                ),
                child: const Icon(
                  Icons.bolt,
                  size: 52,
                  color: BDSColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                Catalogue68.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: BDSColors.blackText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                Catalogue68.tagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: BDSColors.greyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  final void Function({
    String? name,
    String? phone,
    String? pin,
    String? profilePhotoPath,
  }) onSuccess;

  const AuthScreen({
    super.key,
    required this.onSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = true;
  bool _forgotPinMode = false;
  bool _otpSent = false;
  String? _selectedPhotoPath;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  String _error = '';

  Future<void> _uploadProfilePicture() async {
    final path = await pickImageFromGallery(context);
    if (path != null && mounted) {
      setState(() => _selectedPhotoPath = path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture selected from gallery.')),
      );
    }
  }

  void _sendOtp() {
    if (_phoneCtrl.text.trim().length < 9) {
      setState(() => _error = 'Please enter a valid phone number first.');
      return;
    }
    setState(() {
      _otpSent = true;
      _error = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent to your phone number.')),
    );
  }

  void _submit() {
    final phone = _phoneCtrl.text.trim();
    final pin = _pinCtrl.text.trim();

    if (_forgotPinMode) {
      if (phone.length < 9 || _otpCtrl.text.trim().length < 4 || pin.length != 4) {
        setState(() => _error = 'Enter phone number, OTP, and a new 4-digit PIN.');
        return;
      }
      widget.onSuccess(
        phone: phone,
        pin: pin,
        profilePhotoPath: _selectedPhotoPath,
      );
      return;
    }

    if (_isLoginMode) {
      if (phone.length < 9 || pin.length != 4) {
        setState(() => _error = 'Enter your phone number and 4-digit PIN.');
        return;
      }
      widget.onSuccess(
        phone: phone,
        pin: pin,
        profilePhotoPath: _selectedPhotoPath,
      );
    } else {
      if (_nameCtrl.text.trim().isEmpty ||
          phone.length < 9 ||
          _otpCtrl.text.trim().length < 4 ||
          pin.length != 4) {
        setState(() => _error = 'Complete name, phone number, OTP, and 4-digit PIN.');
        return;
      }
      widget.onSuccess(
        name: _nameCtrl.text.trim(),
        phone: phone,
        pin: pin,
        profilePhotoPath: _selectedPhotoPath,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = _forgotPinMode
        ? 'Reset PIN with OTP'
        : (_isLoginMode ? 'Welcome Back' : 'Create Account');

    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    Catalogue68.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _isLoginMode = true;
                            _forgotPinMode = false;
                            _error = '';
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isLoginMode && !_forgotPinMode
                                  ? BDSColors.primaryGreen
                                  : BDSColors.lightGreyPill,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: _isLoginMode && !_forgotPinMode
                                      ? BDSColors.pureWhite
                                      : BDSColors.blackText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _isLoginMode = false;
                            _forgotPinMode = false;
                            _error = '';
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isLoginMode && !_forgotPinMode
                                  ? BDSColors.primaryGreen
                                  : BDSColors.lightGreyPill,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: !_isLoginMode && !_forgotPinMode
                                      ? BDSColors.pureWhite
                                      : BDSColors.blackText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _uploadProfilePicture,
                    child: Column(
                      children: [
                        buildAvatarWidget(
                          imagePath: _selectedPhotoPath,
                          radius: 38,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedPhotoPath == null
                              ? 'Upload Profile Picture'
                              : 'Change Profile Picture',
                          style: const TextStyle(
                            color: BDSColors.primaryGreen,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    titleText,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 14),
                  if (!_isLoginMode && !_forgotPinMode) ...[
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter full name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '07XXXXXXXX',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      if (!_isLoginMode || _forgotPinMode) ...[
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _sendOtp,
                          child: Text(_otpSent ? 'Resend OTP' : 'Send OTP'),
                        ),
                      ],
                    ],
                  ),
                  if (!_isLoginMode || _forgotPinMode) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'OTP Code',
                        hintText: 'Enter OTP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pinCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: '4-Digit PIN',
                      hintText: '****',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_error.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BDSColors.dangerRed),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        _forgotPinMode
                            ? 'Save New PIN'
                            : (_isLoginMode ? 'Login' : 'Register'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      _forgotPinMode = !_forgotPinMode;
                      _error = '';
                    }),
                    child: Text(
                      _forgotPinMode ? 'Back to Login' : 'Forgot PIN with OTP?',
                      style: const TextStyle(color: BDSColors.primaryGreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String? profilePhotoPath;
  final bool isAdmin;
  final bool storeOpen;
  final List<OfferModel> offers;
  final List<AdItem> ads;
  final List<OrderRecord> orders;
  final VoidCallback onLogout;
  final ValueChanged<String> onUpdatePin;
  final ValueChanged<String> onUpdateProfilePhoto;
  final ValueChanged<bool> onToggleStore;
  final ValueChanged<OfferModel> onAddOffer;
  final ValueChanged<OfferModel> onEditOffer;
  final ValueChanged<String> onDeleteOffer;
  final ValueChanged<AdItem> onAddAd;
  final ValueChanged<int> onRemoveAd;
  final ValueChanged<OrderRecord> onRecordStkAttempt;
  final VoidCallback onClearOrders;

  const MainShellScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.profilePhotoPath,
    required this.isAdmin,
    required this.storeOpen,
    required this.offers,
    required this.ads,
    required this.orders,
    required this.onLogout,
    required this.onUpdatePin,
    required this.onUpdateProfilePhoto,
    required this.onToggleStore,
    required this.onAddOffer,
    required this.onEditOffer,
    required this.onDeleteOffer,
    required this.onAddAd,
    required this.onRemoveAd,
    required this.onRecordStkAttempt,
    required this.onClearOrders,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _navIndex = 0;

  void _openNetwork(String network) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NetworkOffersScreen(
          network: network,
          offers: widget.offers,
          storeOpen: widget.storeOpen,
          onRecordStkAttempt: widget.onRecordStkAttempt,
        ),
      ),
    );
  }

  void _openAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountScreen(
          userName: widget.userName,
          userPhone: widget.userPhone,
          profilePhotoPath: widget.profilePhotoPath,
          isAdmin: widget.isAdmin,
          onUpdatePin: widget.onUpdatePin,
          onUpdateProfilePhoto: widget.onUpdateProfilePhoto,
          onLogout: widget.onLogout,
          onOpenAdmin: widget.isAdmin
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminDashboardScreen(
                        storeOpen: widget.storeOpen,
                        offers: widget.offers,
                        ads: widget.ads,
                        orders: widget.orders,
                        onToggleStore: widget.onToggleStore,
                        onAddOffer: widget.onAddOffer,
                        onEditOffer: widget.onEditOffer,
                        onDeleteOffer: widget.onDeleteOffer,
                        onAddAd: widget.onAddAd,
                        onRemoveAd: widget.onRemoveAd,
                      ),
                    ),
                  );
                }
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTabScreen(
        userName: widget.userName,
        profilePhotoPath: widget.profilePhotoPath,
        storeOpen: widget.storeOpen,
        ads: widget.ads,
        onProfileTap: _openAccount,
        onNetworkTap: _openNetwork,
      ),
      const ReferTabScreen(),
      HistoryTabScreen(
        orders: widget.orders,
        onClearOrders: widget.onClearOrders,
      ),
      const SupportTabScreen(),
    ];

    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      body: pages[_navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: BDSColors.pureWhite,
        selectedItemColor: BDSColors.primaryGreen,
        unselectedItemColor: BDSColors.blackText,
        onTap: (idx) => setState(() => _navIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.link), label: 'Refer'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Support'),
        ],
      ),
    );
  }
}

class HomeTabScreen extends StatelessWidget {
  final String userName;
  final String? profilePhotoPath;
  final bool storeOpen;
  final List<AdItem> ads;
  final VoidCallback onProfileTap;
  final ValueChanged<String> onNetworkTap;

  const HomeTabScreen({
    super.key,
    required this.userName,
    required this.profilePhotoPath,
    required this.storeOpen,
    required this.ads,
    required this.onProfileTap,
    required this.onNetworkTap,
  });

  Widget _buildCompanyLogo(String company) {
    switch (company) {
      case 'SAFARICOM':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: BDSColors.lightGreenBadgeBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cell_tower, size: 16, color: BDSColors.primaryGreen),
              SizedBox(width: 5),
              Text('Safaricom', style: TextStyle(color: BDSColors.primaryGreen, fontSize: 12)),
            ],
          ),
        );
      case 'AIRTEL':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFDECEC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.signal_cellular_alt, size: 16, color: BDSColors.dangerRed),
              SizedBox(width: 5),
              Text('Airtel', style: TextStyle(color: BDSColors.dangerRed, fontSize: 12)),
            ],
          ),
        );
      case 'TELKOM':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.network_cell, size: 16, color: Color(0xFF1D4ED8)),
              SizedBox(width: 5),
              Text('Telkom', style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 12)),
            ],
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: BDSColors.amberBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.router, size: 16, color: BDSColors.amberText),
              SizedBox(width: 5),
              Text('Faiba', style: TextStyle(color: BDSColors.amberText, fontSize: 12)),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    const companies = ['SAFARICOM', 'AIRTEL', 'TELKOM', 'FAIBA'];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: BDSColors.softGreenBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bolt, color: BDSColors.primaryGreen),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    Catalogue68.appName,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: onProfileTap,
                  child: buildAvatarWidget(
                    imagePath: profilePhotoPath,
                    radius: 20,
                    bgColor: BDSColors.primaryGreen,
                    iconColor: BDSColors.pureWhite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              Catalogue68.tagline,
              style: TextStyle(fontSize: 14, color: BDSColors.greyText),
            ),
            if (!storeOpen) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BDSColors.amberBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Store Closed: Browse only. No orders right now.',
                  style: TextStyle(color: BDSColors.amberText, fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ads.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, idx) {
                  final ad = ads[idx];
                  return Container(
                    width: 280,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: BDSColors.softGreenBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: BDSColors.lightGreenAccent),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: BDSColors.pureWhite,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(ad.icon, size: 30, color: BDSColors.primaryGreen),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad.title,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ad.subtitle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: BDSColors.greyText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: companies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.35,
              ),
              itemBuilder: (context, index) {
                final company = companies[index];
                return GestureDetector(
                  onTap: () => onNetworkTap(company),
                  child: Container(
                    decoration: BoxDecoration(
                      color: BDSColors.pureWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: BDSColors.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCompanyLogo(company),
                        const SizedBox(height: 10),
                        Text(
                          company,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkOffersScreen extends StatelessWidget {
  final String network;
  final List<OfferModel> offers;
  final bool storeOpen;
  final ValueChanged<OrderRecord> onRecordStkAttempt;

  const NetworkOffersScreen({
    super.key,
    required this.network,
    required this.offers,
    required this.storeOpen,
    required this.onRecordStkAttempt,
  });

  @override
  Widget build(BuildContext context) {
    final visibleOffers =
        offers.where((o) => o.network == network && o.isVisible).toList();

    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        title: Text(network),
      ),
      body: Column(
        children: [
          if (!storeOpen)
            Container(
              width: double.infinity,
              color: BDSColors.amberBg,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Store Closed: Browse only',
                style: TextStyle(color: BDSColors.amberText),
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: visibleOffers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = visibleOffers[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: BDSColors.pureWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BDSColors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: BDSColors.softGreenBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.card_giftcard, color: BDSColors.primaryGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(
                              '${item.priceLabel}  •  ${item.validity}',
                              style: const TextStyle(fontSize: 13, color: BDSColors.greyText),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: storeOpen
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BuyConfirmScreen(
                                      offer: item,
                                      storeOpen: storeOpen,
                                      onRecordStkAttempt: onRecordStkAttempt,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: BDSColors.pureWhite,
                          foregroundColor: BDSColors.primaryGreen,
                          side: const BorderSide(color: BDSColors.primaryGreen, width: 1.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Buy'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BuyConfirmScreen extends StatefulWidget {
  final OfferModel offer;
  final bool storeOpen;
  final ValueChanged<OrderRecord> onRecordStkAttempt;

  const BuyConfirmScreen({
    super.key,
    required this.offer,
    required this.storeOpen,
    required this.onRecordStkAttempt,
  });

  @override
  State<BuyConfirmScreen> createState() => _BuyConfirmScreenState();
}

class _BuyConfirmScreenState extends State<BuyConfirmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientCtrl = TextEditingController();
  final _paymentCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _statusMsg = '';

  @override
  void initState() {
    super.initState();
    if (!widget.offer.isFlexibleAmount && widget.offer.fixedPriceKes != null) {
      _amountCtrl.text = widget.offer.fixedPriceKes.toString();
    }
  }

  String? _validatePhone(String? v) {
    final clean = (v ?? '').replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^(?:\+254|254|0)(?:7\d{8}|1\d{8})$').hasMatch(clean)) {
      return 'Enter a valid phone number (e.g. 07XXXXXXXX)';
    }
    return null;
  }

  String? _validateAmount(String? v) {
    final amt = int.tryParse((v ?? '').trim());
    if (amt == null) return 'Enter a valid amount';
    if (widget.offer.isFlexibleAmount) {
      final minVal = widget.offer.minKes ?? 1;
      final maxVal = widget.offer.maxKes ?? 499;
      if (amt < minVal || amt > maxVal) {
        return 'Amount must be between KES $minVal and KES $maxVal';
      }
    } else if (amt != widget.offer.fixedPriceKes) {
      return 'Amount must be KES ${widget.offer.fixedPriceKes}';
    }
    return null;
  }

  void _confirmAndPay() {
    if (!widget.storeOpen) {
      setState(() => _statusMsg = 'Store is currently closed. Orders are disabled.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final amount = int.parse(_amountCtrl.text.trim());
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    widget.onRecordStkAttempt(
      OrderRecord(
        orderId: orderId,
        network: widget.offer.network,
        bundleName: widget.offer.name,
        recipientPhone: _recipientCtrl.text.trim(),
        paymentPhone: _paymentCtrl.text.trim(),
        amountKes: amount,
        paymentRef: 'Awaiting Daraja Callback',
        dateLabel: 'Just now',
        paymentStatus: 'Pending Callback Verification',
        deliveryStatus: 'Waiting Provider Confirmation',
      ),
    );

    setState(() {
      _statusMsg =
          'STK Push request logged ($orderId). Connect the Daraja backend to verify callback before confirming delivery.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        title: const Text('Buy / Confirm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BDSColors.pureWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: BDSColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Network: ${widget.offer.network}'),
                    const SizedBox(height: 6),
                    Text('Bundle: ${widget.offer.name}'),
                    const SizedBox(height: 6),
                    Text(
                      'Price: ${widget.offer.priceLabel} (${widget.offer.validity})',
                      style: const TextStyle(color: BDSColors.primaryGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _recipientCtrl,
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
                decoration: const InputDecoration(
                  labelText: 'Recipient Phone Number',
                  hintText: '07XXXXXXXX',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _paymentCtrl,
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
                decoration: const InputDecoration(
                  labelText: 'M-Pesa STK Push Phone Number',
                  hintText: '07XXXXXXXX',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                readOnly: !widget.offer.isFlexibleAmount,
                keyboardType: TextInputType.number,
                validator: _validateAmount,
                decoration: const InputDecoration(
                  labelText: 'Amount (KES)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _confirmAndPay,
                  child: const Text('Confirm & Pay'),
                ),
              ),
              if (_statusMsg.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: BDSColors.amberBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusMsg,
                    style: const TextStyle(color: BDSColors.amberText),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ReferTabScreen extends StatefulWidget {
  const ReferTabScreen({super.key});

  @override
  State<ReferTabScreen> createState() => _ReferTabScreenState();
}

class _ReferTabScreenState extends State<ReferTabScreen> {
  String _generatedLink = '${Catalogue68.appDownloadBaseUrl}?ref=app';

  void _generateAppDownloadLink() {
    final token = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    setState(() {
      _generatedLink = '${Catalogue68.appDownloadBaseUrl}?share=$token';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App download link generated.')),
    );
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: _generatedLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App download link copied.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        title: const Text('Refer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Share the App Download Link',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: BDSColors.primaryGreen),
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate a download link for Bingwa Data Swift and share it with friends so they can download the app.',
            style: TextStyle(color: BDSColors.greyText),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BDSColors.softGreenBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BDSColors.lightGreenAccent),
            ),
            child: SelectableText(
              _generatedLink,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _generateAppDownloadLink,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate Download Link'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: _copyLink,
              icon: const Icon(Icons.copy, color: BDSColors.primaryGreen),
              label: const Text('Copy Download Link', style: TextStyle(color: BDSColors.primaryGreen)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: BDSColors.primaryGreen),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('How It Works', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const Text('1. Tap Generate Download Link to create a fresh app download link.'),
          const SizedBox(height: 6),
          const Text('2. Tap Copy Download Link and paste it in your chats.'),
          const SizedBox(height: 6),
          const Text('3. Friends open the link directly to download Bingwa Data Swift.'),
        ],
      ),
    );
  }
}

class HistoryTabScreen extends StatelessWidget {
  final List<OrderRecord> orders;
  final VoidCallback onClearOrders;

  const HistoryTabScreen({
    super.key,
    required this.orders,
    required this.onClearOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        title: const Text('History'),
        actions: [
          if (orders.isNotEmpty)
            TextButton(
              onPressed: onClearOrders,
              child: const Text('Clear', style: TextStyle(color: BDSColors.dangerRed)),
            ),
        ],
      ),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.receipt_long, size: 48, color: BDSColors.greyText),
                    SizedBox(height: 12),
                    Text('No orders recorded yet.', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 6),
                    Text(
                      'Your M-Pesa STK Push order history, payment status, and delivery status will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: BDSColors.greyText),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final o = orders[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: BDSColors.pureWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BDSColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${o.orderId}'),
                      const SizedBox(height: 4),
                      Text('Network: ${o.network} | Bundle: ${o.bundleName}'),
                      const SizedBox(height: 4),
                      Text('Recipient: ${o.recipientPhone} | Payment Phone: ${o.paymentPhone}'),
                      const SizedBox(height: 4),
                      Text('Amount: KES ${o.amountKes} | Date: ${o.dateLabel}'),
                      const SizedBox(height: 4),
                      Text('Payment Ref: ${o.paymentRef}'),
                      const SizedBox(height: 4),
                      Text('Payment Status: ${o.paymentStatus}', style: const TextStyle(color: BDSColors.amberText)),
                      const SizedBox(height: 4),
                      Text('Delivery Status: ${o.deliveryStatus}', style: const TextStyle(color: BDSColors.greyText)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class SupportTabScreen extends StatelessWidget {
  const SupportTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        title: const Text('Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Customer Support',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: BDSColors.primaryGreen),
          ),
          const SizedBox(height: 6),
          const Text(
            'Need help with an order or bundle request? Reach out directly using the buttons below.',
            style: TextStyle(color: BDSColors.greyText),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => openWhatsAppDirect(context),
              icon: const Icon(Icons.chat),
              label: const Text('WhatsApp'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => openCallDirect(context),
              icon: const Icon(Icons.call, color: BDSColors.primaryGreen),
              label: const Text('Call', style: TextStyle(color: BDSColors.primaryGreen)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: BDSColors.primaryGreen, width: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => openWhatsAppGroupDirect(context),
              icon: const Icon(Icons.groups),
              label: const Text('Join Bingwa Data Swift WhatsApp Group'),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Helpful Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BDSColors.pureWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BDSColors.cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Direct M-Pesa STK Push', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(
                  'Payments are initiated via M-Pesa STK Push and verified through server callback confirmation.',
                  style: TextStyle(color: BDSColors.greyText, fontSize: 13),
                ),
                SizedBox(height: 12),
                Text('Recipient Number Check', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(
                  'Confirm the recipient phone number carefully before approving your M-Pesa STK Push prompt.',
                  style: TextStyle(color: BDSColors.greyText, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String? profilePhotoPath;
  final bool isAdmin;
  final ValueChanged<String> onUpdatePin;
  final ValueChanged<String> onUpdateProfilePhoto;
  final VoidCallback onLogout;
  final VoidCallback? onOpenAdmin;

  const AccountScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.profilePhotoPath,
    required this.isAdmin,
    required this.onUpdatePin,
    required this.onUpdateProfilePhoto,
    required this.onLogout,
    required this.onOpenAdmin,
  });

  void _showLegalSheet(BuildContext context, String title, String body) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BDSColors.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              Text(body, style: const TextStyle(color: BDSColors.greyText, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              buildAvatarWidget(
                imagePath: profilePhotoPath,
                radius: 30,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $userName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('Phone: $userPhone', style: const TextStyle(color: BDSColors.greyText)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  final pickedPath = await pickImageFromGallery(context);
                  if (pickedPath != null && context.mounted) {
                    onUpdateProfilePhoto(pickedPath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile picture updated from gallery.')),
                    );
                  }
                },
                child: const Text('Change Photo', style: TextStyle(color: BDSColors.primaryGreen)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Change 4-Digit PIN', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: pinCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New PIN',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (pinCtrl.text.trim().length == 4) {
                    onUpdatePin(pinCtrl.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PIN updated successfully.')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
          const Divider(height: 28),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Policy Privacy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalSheet(
              context,
              'Policy Privacy',
              'Bingwa Data Swift uses only the information required to manage your account and process bundle requests. Payment credentials and API secrets are stored exclusively on the backend server and never inside the mobile app.',
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Terms and Conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalSheet(
              context,
              'Terms and Conditions',
              'Orders are initiated through M-Pesa STK Push. Check the recipient phone number, bundle details, and validity period before confirming payment. Fulfillment depends on payment callback verification and network processing.',
            ),
          ),
          if (isAdmin && onOpenAdmin != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                onOpenAdmin!();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: BDSColors.primaryGreen, width: 1.4),
              ),
              child: const Text('Admin Dashboard', style: TextStyle(color: BDSColors.primaryGreen)),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BDSColors.dangerRed,
                foregroundColor: BDSColors.pureWhite,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: BDSColors.pureWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  final bool storeOpen;
  final List<OfferModel> offers;
  final List<AdItem> ads;
  final List<OrderRecord> orders;
  final ValueChanged<bool> onToggleStore;
  final ValueChanged<OfferModel> onAddOffer;
  final ValueChanged<OfferModel> onEditOffer;
  final ValueChanged<String> onDeleteOffer;
  final ValueChanged<AdItem> onAddAd;
  final ValueChanged<int> onRemoveAd;

  const AdminDashboardScreen({
    super.key,
    required this.storeOpen,
    required this.offers,
    required this.ads,
    required this.orders,
    required this.onToggleStore,
    required this.onAddOffer,
    required this.onEditOffer,
    required this.onDeleteOffer,
    required this.onAddAd,
    required this.onRemoveAd,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedNet = 'SAFARICOM';
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _validityCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController(text: 'DATA');
  final _adTitleCtrl = TextEditingController();
  final _adSubtitleCtrl = TextEditingController();

  void _addNewOffer() {
    final name = _nameCtrl.text.trim();
    final priceNum = int.tryParse(_priceCtrl.text.trim());
    final validity = _validityCtrl.text.trim();
    if (name.isEmpty || priceNum == null || validity.isEmpty) return;

    widget.onAddOffer(
      OfferModel(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        network: _selectedNet,
        name: name,
        priceLabel: 'KES $priceNum',
        fixedPriceKes: priceNum,
        validity: validity,
        category: _categoryCtrl.text.trim().isEmpty
            ? 'DATA'
            : _categoryCtrl.text.trim().toUpperCase(),
      ),
    );
    _nameCtrl.clear();
    _priceCtrl.clear();
    _validityCtrl.clear();
    setState(() {});
  }

  void _confirmDelete(OfferModel offer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Offer Permanently?'),
        content: Text('${offer.network} - ${offer.name} (${offer.priceLabel})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onDeleteOffer(offer.id);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Delete', style: TextStyle(color: BDSColors.dangerRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        title: const Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Total Offers: ${widget.offers.length} | Logged Orders: ${widget.orders.length}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(widget.storeOpen ? 'Store Status: Open' : 'Store Status: Closed'),
            value: widget.storeOpen,
            activeTrackColor: BDSColors.primaryGreen,
            onChanged: (val) {
              widget.onToggleStore(val);
              setState(() {});
            },
          ),
          const Divider(height: 24),
          const Text('Manage Ads', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _adTitleCtrl,
            decoration: const InputDecoration(labelText: 'Ad Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _adSubtitleCtrl,
            decoration: const InputDecoration(labelText: 'Ad Subtitle', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (_adTitleCtrl.text.trim().isNotEmpty) {
                widget.onAddAd(
                  AdItem(
                    id: 'ad_${DateTime.now().millisecondsSinceEpoch}',
                    title: _adTitleCtrl.text.trim(),
                    subtitle: _adSubtitleCtrl.text.trim().isEmpty
                        ? 'Bingwa Data Swift promotion'
                        : _adSubtitleCtrl.text.trim(),
                    icon: Icons.campaign,
                  ),
                );
                _adTitleCtrl.clear();
                _adSubtitleCtrl.clear();
                setState(() {});
              }
            },
            child: const Text('Add Ad'),
          ),
          ...List.generate(
            widget.ads.length,
            (i) => ListTile(
              title: Text(widget.ads[i].title),
              subtitle: Text(widget.ads[i].subtitle),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: BDSColors.dangerRed),
                onPressed: () {
                  widget.onRemoveAd(i);
                  setState(() {});
                },
              ),
            ),
          ),
          const Divider(height: 24),
          const Text('Add New Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedNet,
            items: const ['SAFARICOM', 'AIRTEL', 'TELKOM', 'FAIBA']
                .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                .toList(),
            onChanged: (v) => setState(() => _selectedNet = v ?? 'SAFARICOM'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Offer Name (e.g. 2GB)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price in KES (e.g. 110)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _validityCtrl,
            decoration: const InputDecoration(labelText: 'Validity (e.g. 24Hrs)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addNewOffer,
            child: const Text('Add Offer'),
          ),
          const Divider(height: 24),
          const Text('Manage Offers (Hide / Show / Delete)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          ...widget.offers.map(
            (offer) => ListTile(
              title: Text('${offer.network} | ${offer.name} (${offer.priceLabel})', style: const TextStyle(fontSize: 13)),
              subtitle: Text(
                offer.isVisible ? 'Visible' : 'Hidden',
                style: TextStyle(color: offer.isVisible ? BDSColors.primaryGreen : BDSColors.greyText),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(offer.isVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      widget.onEditOffer(offer.copyWith(isVisible: !offer.isVisible));
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: BDSColors.dangerRed),
                    onPressed: () => _confirmDelete(offer),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
