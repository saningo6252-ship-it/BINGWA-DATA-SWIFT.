import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mpesa_service.dart';

const String kSupabaseUrl = 'https://fjorzgowpirsfohozlhd.supabase.co';
const String kSupabasePublishableKey =
    'sb_publishable_cNCrYuy6BDDTYC2j4gYSYw_P6cnWVVK';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Supabase.initialize(
    url: kSupabaseUrl,
    anonKey: kSupabasePublishableKey,
  );

  runApp(const BingwaDataSwiftApp());
}

SupabaseClient get supabase => Supabase.instance.client;

class BDSColors {
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color primaryGreen = Color(0xFF22A06B);
  static const Color splashGreen = Color(0xFF1B7A3E);
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

class DataPageColors {
  static const Color pageBg = Color(0xFFF3F6F4);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE3EAE5);
  static const Color buyButtonGreen = Color(0xFF1B7A3E);
  static const Color buyTextWhite = Color(0xFFFFFFFF);
  static const Color badgeGreenBg = Color(0xFFD1FAE5);
  static const Color badgeGreenText = Color(0xFF15803D);
  static const Color badgeAmberBg = Color(0xFFFEF3C7);
  static const Color badgeAmberText = Color(0xFFB45309);
  static const Color titleBlack = Color(0xFF111111);
  static const Color subtitleGrey = Color(0xFF4B5563);
  static const Color priceBlack = Color(0xFF111111);
  static const Color unavailableBorder = Color(0xFFD1D5DB);
  static const Color unavailableText = Color(0xFF9CA3AF);
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'network': network,
        'name': name,
        'price_label': priceLabel,
        'fixed_price_kes': fixedPriceKes,
        'min_kes': minKes,
        'max_kes': maxKes,
        'validity': validity,
        'category': category,
        'is_visible': isVisible,
      };

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as String? ?? 'offer_${DateTime.now().millisecondsSinceEpoch}',
        network: json['network'] as String? ?? 'SAFARICOM',
        name: json['name'] as String? ?? 'Offer',
        priceLabel: (json['price_label'] ?? json['priceLabel']) as String? ?? 'KES 10',
        fixedPriceKes: ((json['fixed_price_kes'] ?? json['fixedPriceKes']) as num?)?.toInt(),
        minKes: ((json['min_kes'] ?? json['minKes']) as num?)?.toInt(),
        maxKes: ((json['max_kes'] ?? json['maxKes']) as num?)?.toInt(),
        validity: json['validity'] as String? ?? '24Hrs',
        category: json['category'] as String? ?? 'DATA',
        isVisible: (json['is_visible'] ?? json['isVisible']) as bool? ?? true,
      );
}

class AdItem {
  final String id;
  final String title;
  final String subtitle;
  final int iconCodePoint;
  final String mediaType; // 'ad' | 'image' | 'video'
  final String? mediaPath;

  const AdItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.iconCodePoint = 0xe0e8,
    this.mediaType = 'ad',
    this.mediaPath,
  });

  IconData get icon {
    if (mediaType == 'video') return Icons.play_circle_fill;
    if (mediaType == 'image') return Icons.image;
    if (iconCodePoint == 0xe6e7) return Icons.wifi_tethering;
    if (iconCodePoint == 0xe126) return Icons.campaign;
    return Icons.bolt;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'icon_code_point': iconCodePoint,
        'media_type': mediaType,
        'media_path': mediaPath,
      };

  factory AdItem.fromJson(Map<String, dynamic> json) => AdItem(
        id: json['id'] as String? ?? 'ad_${DateTime.now().millisecondsSinceEpoch}',
        title: json['title'] as String? ?? 'Promotion',
        subtitle: json['subtitle'] as String? ?? '',
        iconCodePoint: ((json['icon_code_point'] ?? json['iconCodePoint']) as num?)?.toInt() ?? 0xe0e8,
        mediaType: (json['media_type'] ?? json['mediaType']) as String? ?? 'ad',
        mediaPath: (json['media_path'] ?? json['mediaPath']) as String?,
      );
}

class OrderRecord {
  final String orderId;
  final String network;
  final String bundleName;
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
    required this.paymentPhone,
    required this.amountKes,
    required this.paymentRef,
    required this.dateLabel,
    required this.paymentStatus,
    required this.deliveryStatus,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'network': network,
        'bundleName': bundleName,
        'paymentPhone': paymentPhone,
        'amountKes': amountKes,
        'paymentRef': paymentRef,
        'dateLabel': dateLabel,
        'paymentStatus': paymentStatus,
        'deliveryStatus': deliveryStatus,
      };

  factory OrderRecord.fromJson(Map<String, dynamic> json) => OrderRecord(
        orderId: json['orderId'] as String? ?? 'ORD-000',
        network: json['network'] as String? ?? 'SAFARICOM',
        bundleName: json['bundleName'] as String? ?? 'Bundle',
        paymentPhone: json['paymentPhone'] as String? ?? '',
        amountKes: (json['amountKes'] as num?)?.toInt() ?? 0,
        paymentRef: json['paymentRef'] as String? ?? '',
        dateLabel: json['dateLabel'] as String? ?? '',
        paymentStatus: json['paymentStatus'] as String? ?? '',
        deliveryStatus: json['deliveryStatus'] as String? ?? '',
      );
}

class Catalogue68 {
  static const String appName = 'BINGWA DATA SWIFT';
  static const String displayBrandName = 'Bingwa Data Swift';
  static const String brandSubline = 'Fast · Reliable · Affordable';
  static const String tagline = 'Bundles and airtime that keep you connected.';
  static const String whatsappPhone = '0794363801';
  static const String callPhone = '0794363801';
  static const String adminEmail = 'Saningo6252@gmail.com';
  static const String adminAccessCode = '3690';
  static const String whatsappGroupUrl =
      'https://chat.whatsapp.com/DB9snd9pSXf9vVrTN3vhTR?s=cl&p=a&iam=2';
  static const String appDownloadBaseUrl = 'https://bingwadataswift.app/download';

  static const String safaricomLogoAsset = 'assets/logos/safaricom.png';
  static const String airtelLogoAsset = 'assets/logos/airtel.png';
  static const String telkomLogoAsset = 'assets/logos/telkom.png';
  static const String faibaLogoAsset = 'assets/logos/faiba.png';

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

class LegalContent {
  static const String privacyPolicy = '''
1. Information We Collect & Use
Bingwa Data Swift collects only the details needed to provide bundle ordering, account access, and customer support—such as your name, email address, phone number, M-Pesa STK Push payment number, and order history entries.

2. Profile Photos & Device Permissions
• Photo Gallery: Accessed only when you choose to upload or change your profile picture or admin promo media.
• Phone & External Links: Used only when you initiate a support call, open WhatsApp, or share a download link.
• Security Credentials: API secrets and payment keys are never embedded inside the app; payment processing relies on secure backend verification.

3. Data Storage & Retention
Order logs and account details shown in the app are kept for session and transaction tracking. You can clear order history from the History screen or clear app storage from your Android device settings.

4. Third-Party Services & Updates
When you open WhatsApp, phone calls, or external links, those services operate under their own privacy policies. We may update this Privacy Policy periodically as the app evolves.
''';

  static const String termsAndConditions = '''
1. Acceptance of Terms
By accessing or using Bingwa Data Swift, you agree to these Terms and Conditions and all applicable laws and telecommunications rules in Kenya.

2. Offers, Pricing & Validity
Bundle options, prices in KES, categories, and validity periods (such as 1Hr, 24Hrs, 7Days, 30Days, or No Expiry) are subject to availability, promotional windows, and carrier terms. The admin may add, hide, edit, or remove offers and promotions as needed.

3. Payments & M-Pesa STK Push Accuracy
Orders are initiated via M-Pesa STK Push and are subject to payment callback confirmation and network processing. Always verify your M-Pesa STK Push phone number and amount before confirming payment.

4. Acceptable Use
You agree not to misuse the app, attempt unauthorized access to admin controls, submit false or fraudulent requests, interfere with app operation, or copy/distribute app assets unlawfully.

5. Store Availability & Limitation of Liability
The store may temporarily pause orders during maintenance or when closed. To the fullest extent permitted by law, Bingwa Data Swift is provided on an "as available" basis and is not liable for indirect losses, carrier downtime, network congestion, or user-entered errors.
''';
}

class RemoteSyncService {
  static const String supabaseUrl = kSupabaseUrl;
  static const String supabaseAnonKey = kSupabasePublishableKey;

  static bool get isConfigured =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  static Future<List<OfferModel>?> fetchRemoteOffers() async {
    if (!isConfigured) return null;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/offers?select=*&order=created_at.desc',
      );
      final client = HttpClient();
      final req = await client.getUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      client.close();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final list = jsonDecode(body) as List<dynamic>;
        return list
            .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> syncOffersToRemote(List<OfferModel> offers) async {
    if (!isConfigured) return false;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/offers?on_conflict=id',
      );
      final client = HttpClient();
      final req = await client.postUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      req.headers.set('Content-Type', 'application/json');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.write(jsonEncode(offers.map((o) => o.toJson()).toList()));
      final res = await req.close();
      await res.drain<void>();
      client.close();
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteOfferFromRemote(String offerId) async {
    if (!isConfigured) return false;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/offers?id=eq.${Uri.encodeComponent(offerId)}',
      );
      final client = HttpClient();
      final req = await client.deleteUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      final res = await req.close();
      await res.drain<void>();
      client.close();
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  static Future<List<AdItem>?> fetchRemoteAds() async {
    if (!isConfigured) return null;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/ads?select=*',
      );
      final client = HttpClient();
      final req = await client.getUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      client.close();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final list = jsonDecode(body) as List<dynamic>;
        return list
            .map((e) => AdItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> syncAdsToRemote(List<AdItem> ads) async {
    if (!isConfigured) return false;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/ads?on_conflict=id',
      );
      final client = HttpClient();
      final req = await client.postUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      req.headers.set('Content-Type', 'application/json');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.write(jsonEncode(ads.map((a) => a.toJson()).toList()));
      final res = await req.close();
      await res.drain<void>();
      client.close();
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteAdFromRemote(String adId) async {
    if (!isConfigured) return false;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/ads?id=eq.${Uri.encodeComponent(adId)}',
      );
      final client = HttpClient();
      final req = await client.deleteUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      final res = await req.close();
      await res.drain<void>();
      client.close();
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  static Future<bool?> fetchRemoteStoreOpen() async {
    if (!isConfigured) return null;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/store_settings?id=eq.main&select=store_open',
      );
      final client = HttpClient();
      final req = await client.getUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      client.close();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final list = jsonDecode(body) as List<dynamic>;
        if (list.isNotEmpty) {
          return (list.first as Map<String, dynamic>)['store_open'] as bool?;
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> syncStoreOpenToRemote(bool open) async {
    if (!isConfigured) return false;
    try {
      final uri = Uri.parse(
        '${supabaseUrl.trim()}/rest/v1/store_settings?on_conflict=id',
      );
      final client = HttpClient();
      final req = await client.postUrl(uri);
      req.headers.set('apikey', supabaseAnonKey.trim());
      req.headers.set('Authorization', 'Bearer ${supabaseAnonKey.trim()}');
      req.headers.set('Content-Type', 'application/json');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.write(jsonEncode([
        {
          'id': 'main',
          'store_open': open,
          'updated_at': DateTime.now().toIso8601String(),
        }
      ]));
      final res = await req.close();
      await res.drain<void>();
      client.close();
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}

bool _checkIsAdmin({String? email, required String pin}) {
  final cleanEmail = (email ?? '').trim().toLowerCase();
  final cleanPin = pin.trim();
  return cleanEmail == Catalogue68.adminEmail.toLowerCase() &&
      cleanPin == Catalogue68.adminAccessCode;
}

Future<String?> pickImageFromGallery(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return null;
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

Future<String?> pickVideoFromGallery(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked == null) return null;
    return picked.path;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open video gallery on this device.')),
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
  static const String _kOffersKey = 'bds_saved_offers_v1';
  static const String _kAdsKey = 'bds_saved_ads_v1';
  static const String _kOrdersKey = 'bds_saved_orders_v1';
  static const String _kStoreOpenKey = 'bds_store_open_v1';
  static const String _kProfilePhotoKey = 'bds_profile_photo_v1';

  static const String _kHasAccountKey = 'bds_has_account_v1';
  static const String _kSavedEmailKey = 'bds_saved_email_v1';
  static const String _kSavedPhoneKey = 'bds_saved_phone_v1';
  static const String _kSavedPinKey = 'bds_saved_pin_v1';
  static const String _kSavedNameKey = 'bds_saved_name_v1';

  bool _showSplash = true;
  bool _isAuthenticated = false;
  bool _hasAccount = false;
  bool _forceRegisterScreen = false;
  bool _isAdmin = false;

  String _userName = 'Bingwa User';
  String _userEmail = '';
  String _userPhone = '07XXXXXXXX';
  String _userPin = '';
  String? _profilePhotoPath;
  bool _storeOpen = true;

  List<OfferModel> _offers = List<OfferModel>.from(Catalogue68.initialOffers);
  List<AdItem> _ads = [
    const AdItem(
      id: 'ad_1',
      title: 'Fast Data & Minutes A...',
      subtitle: 'Instant M-Pesa STK Push checkout with clear bundle details.',
      iconCodePoint: 0xe0e8,
      mediaType: 'ad',
    ),
    const AdItem(
      id: 'ad_2',
      title: 'Safaricom, Airtel, Telkom & Faiba',
      subtitle: 'Select your network and confirm your payment number easily.',
      iconCodePoint: 0xe6e7,
      mediaType: 'ad',
    ),
  ];
  List<OrderRecord> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  Future<void> _loadPersistedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOffersJson = prefs.getString(_kOffersKey);
      final savedAdsJson = prefs.getString(_kAdsKey);
      final savedOrdersJson = prefs.getString(_kOrdersKey);
      final savedStoreOpen = prefs.getBool(_kStoreOpenKey);
      final savedPhoto = prefs.getString(_kProfilePhotoKey);
      final savedHasAccount = prefs.getBool(_kHasAccountKey) ?? false;
      final savedEmail = prefs.getString(_kSavedEmailKey) ?? '';
      final savedPhone = prefs.getString(_kSavedPhoneKey) ?? '07XXXXXXXX';
      final savedPin = prefs.getString(_kSavedPinKey) ?? '';
      final savedName = prefs.getString(_kSavedNameKey) ?? '';

      if (!mounted) return;
      setState(() {
        _hasAccount = savedHasAccount && savedEmail.isNotEmpty && savedPin.isNotEmpty;
        _userEmail = savedEmail;
        _userPhone = savedPhone;
        _userPin = savedPin;
        if (savedName.isNotEmpty) {
          _userName = savedName;
        }
        if (savedOffersJson != null && savedOffersJson.isNotEmpty) {
          final decoded = jsonDecode(savedOffersJson) as List<dynamic>;
          _offers = decoded
              .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        if (savedAdsJson != null && savedAdsJson.isNotEmpty) {
          final decoded = jsonDecode(savedAdsJson) as List<dynamic>;
          _ads = decoded
              .map((e) => AdItem.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        if (savedOrdersJson != null && savedOrdersJson.isNotEmpty) {
          final decoded = jsonDecode(savedOrdersJson) as List<dynamic>;
          _orders = decoded
              .map((e) => OrderRecord.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        if (savedStoreOpen != null) {
          _storeOpen = savedStoreOpen;
        }
        if (savedPhoto != null && savedPhoto.isNotEmpty) {
          _profilePhotoPath = savedPhoto;
        }
        _isAdmin = _checkIsAdmin(
          email: _userEmail,
          pin: _userPin,
        );
      });

      final remoteOffers = await RemoteSyncService.fetchRemoteOffers();
      final remoteAds = await RemoteSyncService.fetchRemoteAds();
      final remoteStoreOpen = await RemoteSyncService.fetchRemoteStoreOpen();
      if (!mounted) return;

      if (remoteOffers != null && remoteOffers.isNotEmpty) {
        setState(() => _offers = remoteOffers);
        await _saveOffers(syncRemote: false);
      }
      if (remoteAds != null && remoteAds.isNotEmpty) {
        setState(() => _ads = remoteAds);
        await _saveAds(syncRemote: false);
      }
      if (remoteStoreOpen != null) {
        setState(() => _storeOpen = remoteStoreOpen);
        await _saveStoreOpen(remoteStoreOpen, syncRemote: false);
      }
    } catch (_) {}
  }

  Future<void> _saveAccountCredentials({
    required String email,
    required String pin,
    String? phone,
    String? name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasAccountKey, true);
    await prefs.setString(_kSavedEmailKey, email);
    await prefs.setString(_kSavedPinKey, pin);
    if (phone != null && phone.trim().isNotEmpty) {
      await prefs.setString(_kSavedPhoneKey, phone.trim());
    }
    if (name != null && name.trim().isNotEmpty) {
      await prefs.setString(_kSavedNameKey, name.trim());
    }
  }

  Future<void> _saveOffers({bool syncRemote = true}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kOffersKey,
      jsonEncode(_offers.map((o) => o.toJson()).toList()),
    );
    if (syncRemote) {
      await RemoteSyncService.syncOffersToRemote(_offers);
    }
  }

  Future<void> _saveAds({bool syncRemote = true}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kAdsKey,
      jsonEncode(_ads.map((a) => a.toJson()).toList()),
    );
    if (syncRemote) {
      await RemoteSyncService.syncAdsToRemote(_ads);
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kOrdersKey,
      jsonEncode(_orders.map((o) => o.toJson()).toList()),
    );
  }

  Future<void> _saveStoreOpen(bool open, {bool syncRemote = true}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kStoreOpenKey, open);
    if (syncRemote) {
      await RemoteSyncService.syncStoreOpenToRemote(open);
    }
  }

  Future<void> _saveProfilePhoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfilePhotoKey, path);
  }

  void _onAccountRegistered({
    required String email,
    required String pin,
    String? phone,
    String? name,
    String? profilePhotoPath,
  }) {
    final cleanEmail = email.trim();
    final cleanPin = pin.trim();
    final resolvedName = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : (cleanEmail.contains('@') ? cleanEmail.split('@').first : _userName);
    final resolvedPhone = (phone != null && phone.trim().isNotEmpty)
        ? phone.trim()
        : _userPhone;

    setState(() {
      _userName = resolvedName;
      _userEmail = cleanEmail;
      _userPhone = resolvedPhone;
      _userPin = cleanPin;
      _hasAccount = true;
      _forceRegisterScreen = false;
      if (profilePhotoPath != null && profilePhotoPath.isNotEmpty) {
        _profilePhotoPath = profilePhotoPath;
        _saveProfilePhoto(profilePhotoPath);
      }
      _isAdmin = _checkIsAdmin(
        email: cleanEmail,
        pin: cleanPin,
      );
      _isAuthenticated = true;
    });

    _saveAccountCredentials(
      email: cleanEmail,
      pin: cleanPin,
      phone: resolvedPhone,
      name: resolvedName,
    );
  }

  void _onPinLoginSuccess(String pin) {
    final cleanPin = pin.trim();
    setState(() {
      _userPin = cleanPin;
      _forceRegisterScreen = false;
      _isAdmin = _checkIsAdmin(
        email: _userEmail,
        pin: cleanPin,
      );
      _isAuthenticated = true;
    });
  }

  void _onPinResetSuccess(String newPin) {
    final cleanPin = newPin.trim();
    setState(() {
      _userPin = cleanPin;
      _forceRegisterScreen = false;
      _isAdmin = _checkIsAdmin(
        email: _userEmail,
        pin: cleanPin,
      );
      _isAuthenticated = true;
    });
    if (_userEmail.isNotEmpty) {
      _saveAccountCredentials(
        email: _userEmail,
        pin: cleanPin,
        phone: _userPhone,
        name: _userName,
      );
    }
  }

  Future<void> _onLogout() async {
    try {
      await supabase.auth.signOut();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _isAuthenticated = false;
      _forceRegisterScreen = false;
      _isAdmin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeEntryScreen;
    if (!_hasAccount || _forceRegisterScreen) {
      activeEntryScreen = RegistrationPage(
        initialEmail: _userEmail,
        onRegistered: _onAccountRegistered,
        onGoToLogin: _hasAccount
            ? () => setState(() => _forceRegisterScreen = false)
            : null,
      );
    } else {
      activeEntryScreen = PinOnlyLoginPage(
        savedEmail: _userEmail,
        expectedPin: _userPin,
        onLoginSuccess: _onPinLoginSuccess,
        onResetPinSuccess: _onPinResetSuccess,
        onRegisterAccountTap: () => setState(() => _forceRegisterScreen = true),
      );
    }

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
              ? activeEntryScreen
              : MainShellScreen(
                  userName: _userName,
                  userPhone: _userPhone,
                  userEmail: _userEmail,
                  profilePhotoPath: _profilePhotoPath,
                  isAdmin: _isAdmin,
                  storeOpen: _storeOpen,
                  offers: _offers,
                  ads: _ads,
                  orders: _orders,
                  onLogout: _onLogout,
                  onUpdatePin: (newPin) {
                    final cleanPin = newPin.trim();
                    setState(() {
                      _userPin = cleanPin;
                      _isAdmin = _checkIsAdmin(
                        email: _userEmail,
                        pin: cleanPin,
                      );
                    });
                    if (_userEmail.isNotEmpty) {
                      _saveAccountCredentials(
                        email: _userEmail,
                        pin: cleanPin,
                        phone: _userPhone,
                        name: _userName,
                      );
                    }
                  },
                  onUpdateProfilePhoto: (path) {
                    setState(() => _profilePhotoPath = path);
                    _saveProfilePhoto(path);
                  },
                  onToggleStore: (open) {
                    setState(() => _storeOpen = open);
                    _saveStoreOpen(open);
                  },
                  onAddOffer: (offer) {
                    setState(() => _offers.insert(0, offer));
                    _saveOffers();
                  },
                  onEditOffer: (updated) {
                    setState(() {
                      final idx = _offers.indexWhere((o) => o.id == updated.id);
                      if (idx != -1) _offers[idx] = updated;
                    });
                    _saveOffers();
                  },
                  onDeleteOffer: (id) {
                    setState(() => _offers.removeWhere((o) => o.id == id));
                    _saveOffers(syncRemote: false);
                    RemoteSyncService.deleteOfferFromRemote(id);
                  },
                  onResetDefaultOffers: () {
                    setState(() {
                      _offers = List<OfferModel>.from(Catalogue68.initialOffers);
                    });
                    _saveOffers();
                  },
                  onAddAd: (ad) {
                    setState(() => _ads.add(ad));
                    _saveAds();
                  },
                  onRemoveAd: (index) {
                    final removedId = _ads[index].id;
                    setState(() => _ads.removeAt(index));
                    _saveAds(syncRemote: false);
                    RemoteSyncService.deleteAdFromRemote(removedId);
                  },
                  onRecordStkAttempt: (order) {
                    setState(() => _orders.insert(0, order));
                    _saveOrders();
                  },
                  onClearOrders: () {
                    setState(() => _orders.clear());
                    _saveOrders();
                  },
                ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.splashGreen,
      body: Stack(
        children: [
          Positioned(
            top: -70,
            right: -50,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: BDSColors.pureWhite,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Welcome to ${Catalogue68.appName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: BDSColors.pureWhite,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    Catalogue68.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFD1FAE5),
                    ),
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

class RegistrationPage extends StatefulWidget {
  final String initialEmail;
  final void Function({
    required String email,
    required String pin,
    String? phone,
    String? name,
    String? profilePhotoPath,
  }) onRegistered;
  final VoidCallback? onGoToLogin;

  const RegistrationPage({
    super.key,
    this.initialEmail = '',
    required this.onRegistered,
    this.onGoToLogin,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  bool _sendingOtp = false;
  bool _verifying = false;
  bool _otpSent = false;
  String? _selectedPhotoPath;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _pinCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _uploadProfilePicture() async {
    final path = await pickImageFromGallery(context);
    if (path != null && mounted) {
      setState(() => _selectedPhotoPath = path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture selected from gallery.')),
      );
    }
  }

  Future<void> _sendEmailOtpOrLink() async {
    if (_sendingOtp) return;
    final email = _emailCtrl.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _error = 'Please enter a valid email address first.');
      return;
    }

    setState(() {
      _sendingOtp = true;
      _error = '';
    });

    try {
      await supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
      );
      if (!mounted) return;
      setState(() {
        _sendingOtp = false;
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to $email. Check inbox or spam.')),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _sendingOtp = false;
        _error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sendingOtp = false;
        _error = 'Failed to send OTP: $e';
      });
    }
  }

  Future<void> _registerAccount() async {
    if (_verifying) return;
    final email = _emailCtrl.text.trim();
    final pin = _pinCtrl.text.trim();
    final otp = _otpCtrl.text.trim();

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }
    if (pin.length != 4) {
      setState(() => _error = 'Please create a 4-digit PIN.');
      return;
    }
    if (!_otpSent) {
      setState(() => _error = 'Tap Send OTP first and enter the code sent to your email.');
      return;
    }
    if (otp.length < 4) {
      setState(() => _error = 'Please enter the OTP code sent to your email.');
      return;
    }

    setState(() {
      _verifying = true;
      _error = '';
    });

    try {
      await supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );
      if (!mounted) return;
      setState(() => _verifying = false);
      widget.onRegistered(
        email: email,
        pin: pin,
        phone: _phoneCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        profilePhotoPath: _selectedPhotoPath,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _verifying = false;
        _error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _verifying = false;
        _error = 'OTP verification failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 18),
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
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Verify your email with OTP / confirmation link and set your PIN.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: BDSColors.greyText),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full Name (Optional)',
                      hintText: 'Enter full name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'name@example.com',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _sendingOtp ? null : _sendEmailOtpOrLink,
                        child: Text(
                          _sendingOtp
                              ? 'Sending...'
                              : (_otpSent ? 'Resend OTP' : 'Send OTP'),
                        ),
                      ),
                    ],
                  ),
                  if (_otpSent) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Email OTP Code',
                        hintText: 'Enter OTP from email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      hintText: '07XXXXXXXX',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pinCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: 'Create 4-Digit PIN',
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
                      onPressed: _verifying ? null : _registerAccount,
                      child: Text(
                        _verifying ? 'Verifying...' : 'Register & Confirm Email',
                      ),
                    ),
                  ),
                  if (widget.onGoToLogin != null) ...[
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: widget.onGoToLogin,
                      child: const Text(
                        'Already have an account? Login with PIN',
                        style: TextStyle(color: BDSColors.primaryGreen),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PinOnlyLoginPage extends StatefulWidget {
  final String savedEmail;
  final String expectedPin;
  final ValueChanged<String> onLoginSuccess;
  final ValueChanged<String> onResetPinSuccess;
  final VoidCallback onRegisterAccountTap;

  const PinOnlyLoginPage({
    super.key,
    required this.savedEmail,
    required this.expectedPin,
    required this.onLoginSuccess,
    required this.onResetPinSuccess,
    required this.onRegisterAccountTap,
  });

  @override
  State<PinOnlyLoginPage> createState() => _PinOnlyLoginPageState();
}

class _PinOnlyLoginPageState extends State<PinOnlyLoginPage> {
  final _pinCtrl = TextEditingController();
  final _resetOtpCtrl = TextEditingController();
  final _newPinCtrl = TextEditingController();

  bool _forgotPinMode = false;
  bool _sendingReset = false;
  bool _verifyingReset = false;
  bool _resetLinkSent = false;
  String _error = '';

  @override
  void dispose() {
    _pinCtrl.dispose();
    _resetOtpCtrl.dispose();
    _newPinCtrl.dispose();
    super.dispose();
  }

  void _loginWithPinOnly() {
    final enteredPin = _pinCtrl.text.trim();
    if (enteredPin.length != 4) {
      setState(() => _error = 'Enter your 4-digit PIN.');
      return;
    }
    if (enteredPin != widget.expectedPin) {
      setState(
        () => _error =
            'Incorrect PIN. Access denied — try again or use Forgot PIN to send a new one to your email.',
      );
      return;
    }
    setState(() => _error = '');
    widget.onLoginSuccess(enteredPin);
  }

  Future<void> _sendForgotPinEmail() async {
    if (_sendingReset) return;
    final targetEmail = widget.savedEmail.trim();
    if (targetEmail.isEmpty || !targetEmail.contains('@')) {
      setState(() => _error = 'No registered email found. Register an account first.');
      return;
    }

    setState(() {
      _sendingReset = true;
      _error = '';
    });

    try {
      await supabase.auth.signInWithOtp(
        email: targetEmail,
        shouldCreateUser: false,
      );
      if (!mounted) return;
      setState(() {
        _sendingReset = false;
        _resetLinkSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to $targetEmail.')),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _sendingReset = false;
        _error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sendingReset = false;
        _error = 'Failed to send reset OTP: $e';
      });
    }
  }

  Future<void> _confirmNewPin() async {
    if (_verifyingReset) return;
    final otp = _resetOtpCtrl.text.trim();
    final newPin = _newPinCtrl.text.trim();
    final targetEmail = widget.savedEmail.trim();

    if (!_resetLinkSent) {
      setState(() => _error = 'Send the reset link/OTP to your email first.');
      return;
    }
    if (otp.length < 4) {
      setState(() => _error = 'Enter the OTP code sent to your email.');
      return;
    }
    if (newPin.length != 4) {
      setState(() => _error = 'Enter a new 4-digit PIN.');
      return;
    }

    setState(() {
      _verifyingReset = true;
      _error = '';
    });

    try {
      await supabase.auth.verifyOTP(
        email: targetEmail,
        token: otp,
        type: OtpType.email,
      );
      if (!mounted) return;
      setState(() => _verifyingReset = false);
      widget.onResetPinSuccess(newPin);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _verifyingReset = false;
        _error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _verifyingReset = false;
        _error = 'Failed to verify OTP: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            Catalogue68.appName,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _forgotPinMode ? 'Forgot PIN' : 'Welcome Back',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _forgotPinMode
                                ? 'We send a new PIN reset link & OTP to your registered email.'
                                : 'Enter your PIN to login directly.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, color: BDSColors.greyText),
                          ),
                          const SizedBox(height: 22),
                          if (!_forgotPinMode) ...[
                            TextField(
                              controller: _pinCtrl,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              maxLength: 4,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                labelText: 'Enter PIN',
                                hintText: '****',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ] else ...[
                            ElevatedButton.icon(
                              onPressed: _sendingReset ? null : _sendForgotPinEmail,
                              icon: const Icon(Icons.mark_email_read),
                              label: Text(
                                _sendingReset
                                    ? 'Sending...'
                                    : (_resetLinkSent
                                        ? 'Resend Email Link & OTP'
                                        : 'Send New PIN Link & OTP to Email'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _resetOtpCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Email OTP Code',
                                hintText: 'Enter OTP from email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _newPinCtrl,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              maxLength: 4,
                              decoration: const InputDecoration(
                                labelText: 'New 4-Digit PIN',
                                hintText: '****',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                          if (_error.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _error,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: BDSColors.dangerRed),
                            ),
                          ],
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _forgotPinMode
                                  ? (_verifyingReset ? null : _confirmNewPin)
                                  : _loginWithPinOnly,
                              child: Text(
                                _forgotPinMode
                                    ? (_verifyingReset
                                        ? 'Verifying...'
                                        : 'Set New PIN & Login')
                                    : 'Login',
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
                              _forgotPinMode ? 'Back to PIN Login' : 'Forgot PIN?',
                              style: const TextStyle(color: BDSColors.primaryGreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: widget.onRegisterAccountTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BDSColors.primaryGreen,
                    side: const BorderSide(color: BDSColors.primaryGreen, width: 1.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Register Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String userEmail;
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
  final VoidCallback onResetDefaultOffers;
  final ValueChanged<AdItem> onAddAd;
  final ValueChanged<int> onRemoveAd;
  final ValueChanged<OrderRecord> onRecordStkAttempt;
  final VoidCallback onClearOrders;

  const MainShellScreen({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
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
    required this.onResetDefaultOffers,
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
          userEmail: widget.userEmail,
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
                        adminEmail: widget.userEmail,
                        storeOpen: widget.storeOpen,
                        offers: widget.offers,
                        ads: widget.ads,
                        orders: widget.orders,
                        onToggleStore: widget.onToggleStore,
                        onAddOffer: widget.onAddOffer,
                        onEditOffer: widget.onEditOffer,
                        onDeleteOffer: widget.onDeleteOffer,
                        onResetDefaultOffers: widget.onResetDefaultOffers,
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
        onJumpToSupport: () => setState(() => _navIndex = 3),
      ),
      ReferTabScreen(
        onBackHome: () => setState(() => _navIndex = 0),
      ),
      HistoryTabScreen(
        orders: widget.orders,
        onClearOrders: widget.onClearOrders,
      ),
      SupportTabScreen(
        onBackHome: () => setState(() => _navIndex = 0),
      ),
    ];

    return Scaffold(
      backgroundColor: BDSColors.pureWhite,
      body: pages[_navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0B0E11),
        selectedItemColor: BDSColors.lightGreenAccent,
        unselectedItemColor: BDSColors.pureWhite,
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
  final VoidCallback onJumpToSupport;

  const HomeTabScreen({
    super.key,
    required this.userName,
    required this.profilePhotoPath,
    required this.storeOpen,
    required this.ads,
    required this.onProfileTap,
    required this.onNetworkTap,
    required this.onJumpToSupport,
  });

  Widget _buildPromoBanner(BuildContext context) {
    final primaryAd = ads.isNotEmpty
        ? ads.first
        : const AdItem(
            id: 'ad_default',
            title: 'Fast Data & Minutes A...',
            subtitle: 'Instant M-Pesa STK Push checkout with clear bundle details.',
            iconCodePoint: 0xe0e8,
            mediaType: 'ad',
          );

    final hasImage = primaryAd.mediaType == 'image' &&
        primaryAd.mediaPath != null &&
        primaryAd.mediaPath!.isNotEmpty &&
        File(primaryAd.mediaPath!).existsSync();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF9F1), Color(0xFF86EFAC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: BDSColors.pureWhite,
              shape: BoxShape.circle,
              border: Border.all(color: BDSColors.primaryGreen, width: 1.5),
            ),
            child: hasImage
                ? ClipOval(
                    child: Image.file(
                      File(primaryAd.mediaPath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    primaryAd.mediaType == 'video'
                        ? Icons.play_circle_fill
                        : Icons.bolt,
                    color: const Color(0xFF16A34A),
                    size: 30,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryAd.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: BDSColors.blackText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  primaryAd.subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF14532D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'STK',
                  style: TextStyle(
                    color: BDSColors.pureWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Push',
                  style: TextStyle(
                    color: BDSColors.pureWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Icon(Icons.check_circle, color: BDSColors.lightGreenAccent, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkLogoHeader({
    required String assetPath,
    required String fallbackText,
    required Color accentColor,
    required IconData fallbackIcon,
  }) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(fallbackIcon, color: accentColor, size: 22),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      fallbackText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.signal_cellular_alt, color: accentColor, size: 16),
        ],
      ),
    );
  }

  Widget _buildNetworkCard({
    required String company,
    required String assetPath,
    required String fallbackText,
    required Color accentColor,
    required IconData fallbackIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: BDSColors.pureWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNetworkLogoHeader(
              assetPath: assetPath,
              fallbackText: fallbackText,
              accentColor: accentColor,
              fallbackIcon: fallbackIcon,
            ),
            Column(
              children: [
                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: BDSColors.blackText,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Data · Airtime · Bundles',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: BDSColors.greyText,
                  ),
                ),
              ],
            ),
            Container(
              width: 106,
              height: 32,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Open',
                    style: TextStyle(
                      color: BDSColors.pureWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: BDSColors.pureWhite, size: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: BDSColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF16A34A), width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'BDS',
                      style: TextStyle(
                        color: Color(0xFF15803D),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Catalogue68.displayBrandName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: BDSColors.blackText,
                        ),
                      ),
                      Text(
                        Catalogue68.brandSubline,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onProfileTap,
                  child: buildAvatarWidget(
                    imagePath: profilePhotoPath,
                    radius: 21,
                    bgColor: const Color(0xFF111827),
                    iconColor: BDSColors.pureWhite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: BDSColors.blackText,
                  ),
                ),
                SizedBox(width: 6),
                Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              Catalogue68.tagline,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF374151),
              ),
            ),
            if (!storeOpen) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
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
            const SizedBox(height: 14),
            _buildPromoBanner(context),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
              children: [
                _buildNetworkCard(
                  company: 'SAFARICOM',
                  assetPath: Catalogue68.safaricomLogoAsset,
                  fallbackText: 'Safaricom',
                  accentColor: const Color(0xFF16A34A),
                  fallbackIcon: Icons.cell_tower,
                  onTap: () => onNetworkTap('SAFARICOM'),
                ),
                _buildNetworkCard(
                  company: 'AIRTEL',
                  assetPath: Catalogue68.airtelLogoAsset,
                  fallbackText: 'airtel',
                  accentColor: const Color(0xFFDC2626),
                  fallbackIcon: Icons.signal_cellular_alt,
                  onTap: () => onNetworkTap('AIRTEL'),
                ),
                _buildNetworkCard(
                  company: 'TELKOM',
                  assetPath: Catalogue68.telkomLogoAsset,
                  fallbackText: 'Telkom',
                  accentColor: const Color(0xFF0284C7),
                  fallbackIcon: Icons.network_cell,
                  onTap: () => onNetworkTap('TELKOM'),
                ),
                _buildNetworkCard(
                  company: 'FAIBA',
                  assetPath: Catalogue68.faibaLogoAsset,
                  fallbackText: 'Faiba',
                  accentColor: const Color(0xFFF59E0B),
                  fallbackIcon: Icons.router,
                  onTap: () => onNetworkTap('FAIBA'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.verified_user, color: Color(0xFF16A34A), size: 20),
                  const Expanded(
                    child: Text(
                      'Secure · Instant · Always Connected',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onJumpToSupport,
                    child: const Icon(Icons.headset_mic, color: Color(0xFF111827), size: 20),
                  ),
                ],
              ),
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

  String _formatKshPrice(OfferModel item) {
    if (item.fixedPriceKes != null) {
      return 'Ksh ${item.fixedPriceKes}';
    }
    if (item.priceLabel.toLowerCase().startsWith('kes ')) {
      return 'Ksh ${item.priceLabel.substring(4)}';
    }
    return item.priceLabel;
  }

  String _badgeLabel(OfferModel item, int index) {
    final lowerVal = item.validity.toLowerCase();
    if (lowerVal.contains('11pm') || lowerVal.contains('midnight')) {
      return 'Available 11PM – 7PM';
    }
    if (lowerVal.contains('1hr')) {
      return '1 hour · Patamore';
    }
    if (lowerVal.contains('7days') || lowerVal.contains('30days')) {
      return 'Once a day';
    }
    return index.isEven ? 'Many times' : 'Once a day';
  }

  bool _isAmberBadge(String badgeText) {
    final lower = badgeText.toLowerCase();
    return lower.contains('once a day') || lower.contains('available');
  }

  bool _isOfferAvailable(OfferModel item) {
    if (!storeOpen) return false;
    final lowerVal = item.validity.toLowerCase();
    if (lowerVal.contains('unavailable')) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final visibleOffers =
        offers.where((o) => o.network == network && o.isVisible).toList();

    return Scaffold(
      backgroundColor: DataPageColors.pageBg,
      appBar: AppBar(
        backgroundColor: BDSColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFDCFCE7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF15803D)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Catalogue68.displayBrandName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: DataPageColors.titleBlack,
              ),
            ),
            Text(
              Catalogue68.brandSubline,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Color(0xFF15803D),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Badge(
              label: Text('${visibleOffers.length}'),
              backgroundColor: const Color(0xFFEF4444),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(Icons.shopping_cart, color: Color(0xFF15803D), size: 20),
              ),
            ),
          ),
        ],
      ),
      body: visibleOffers.isEmpty
          ? const Center(
              child: Text(
                'No active offers available for this network.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: DataPageColors.subtitleGrey,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 76),
              itemCount: visibleOffers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 215,
              ),
              itemBuilder: (context, index) {
                final item = visibleOffers[index];
                final badgeText = _badgeLabel(item, index);
                final isAmber = _isAmberBadge(badgeText);
                final available = _isOfferAvailable(item);
                final priceText = _formatKshPrice(item);

                return Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: DataPageColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: DataPageColors.cardBorder,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isAmber
                              ? DataPageColors.badgeAmberBg
                              : DataPageColors.badgeGreenBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isAmber
                                ? DataPageColors.badgeAmberText
                                : DataPageColors.badgeGreenText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: DataPageColors.titleBlack,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.validity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: DataPageColors.subtitleGrey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        priceText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: DataPageColors.priceBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: available
                            ? ElevatedButton.icon(
                                onPressed: () {
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
                                },
                                icon: const Icon(Icons.shopping_cart, size: 16),
                                label: const Text(
                                  'Buy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: DataPageColors.buyTextWhite,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: DataPageColors.buyButtonGreen,
                                  foregroundColor: DataPageColors.buyTextWhite,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            : OutlinedButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.access_time, size: 15),
                                label: const Text(
                                  'Unavailable now',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: DataPageColors.unavailableText,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: DataPageColors.cardBg,
                                  disabledForegroundColor:
                                      DataPageColors.unavailableText,
                                  side: const BorderSide(
                                    color: DataPageColors.unavailableBorder,
                                    width: 1,
                                  ),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openWhatsAppDirect(context),
        backgroundColor: const Color(0xFF15803D),
        foregroundColor: BDSColors.pureWhite,
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text(
          'Chat',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
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
  final _paymentCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  bool _isSending = false;
  String _statusMsg = '';

  @override
  void initState() {
    super.initState();
    if (!widget.offer.isFlexibleAmount && widget.offer.fixedPriceKes != null) {
      _amountCtrl.text = widget.offer.fixedPriceKes.toString();
    }
  }

  @override
  void dispose() {
    _paymentCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
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

  Future<void> _confirmAndPay() async {
    if (_isSending) return;
    if (!widget.storeOpen) {
      setState(() => _statusMsg = 'Store is currently closed. Orders are disabled.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final amount = int.parse(_amountCtrl.text.trim());
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final paymentPhone = _paymentCtrl.text.trim();

    setState(() {
      _isSending = true;
      _statusMsg = 'Sending M-Pesa STK Push prompt...';
    });

    try {
      final response = await MpesaService.sendStkPush(
        phone: paymentPhone,
        amount: amount,
        orderId: orderId,
      );

      final stkMap = response['stk'] is Map ? response['stk'] as Map : <dynamic, dynamic>{};
      final checkoutId = stkMap['CheckoutRequestID']?.toString() ?? 'Awaiting Daraja Callback';
      final customerMsg = stkMap['CustomerMessage']?.toString() ??
          'STK Push sent. Enter your M-Pesa PIN on your phone.';

      widget.onRecordStkAttempt(
        OrderRecord(
          orderId: orderId,
          network: widget.offer.network,
          bundleName: widget.offer.name,
          paymentPhone: paymentPhone,
          amountKes: amount,
          paymentRef: checkoutId,
          dateLabel: 'Just now',
          paymentStatus: 'STK Prompt Sent - Awaiting Callback',
          deliveryStatus: 'Waiting Payment Confirmation',
        ),
      );

      if (!mounted) return;
      setState(() {
        _isSending = false;
        _statusMsg = '$customerMsg ($orderId)';
      });
    } catch (e) {
      widget.onRecordStkAttempt(
        OrderRecord(
          orderId: orderId,
          network: widget.offer.network,
          bundleName: widget.offer.name,
          paymentPhone: paymentPhone,
          amountKes: amount,
          paymentRef: 'STK Request Failed',
          dateLabel: 'Just now',
          paymentStatus: 'Failed to Initiate STK Push',
          deliveryStatus: 'Not Sent',
        ),
      );

      if (!mounted) return;
      setState(() {
        _isSending = false;
        _statusMsg = 'Error: ${e.toString().replaceFirst('Exception: ', '')}';
      });
    }
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
                  onPressed: _isSending ? null : _confirmAndPay,
                  child: Text(_isSending ? 'Sending STK Push...' : 'Confirm & Pay'),
                ),
              ),
              if (_statusMsg.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: BDSColors.softGreenBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusMsg,
                    style: const TextStyle(color: BDSColors.blackText),
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
  final VoidCallback? onBackHome;

  const ReferTabScreen({super.key, this.onBackHome});

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

  Widget _stepRow(String numText, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: const Color(0xFF16A34A),
          child: Text(
            numText,
            style: const TextStyle(
              color: BDSColors.pureWhite,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBackHome,
                    child: const Icon(Icons.arrow_back, color: BDSColors.pureWhite),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Refer',
                      style: TextStyle(
                        color: BDSColors.pureWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _copyLink,
                    child: const Icon(Icons.share, color: BDSColors.pureWhite),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: BDSColors.pureWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.group,
                                size: 44,
                                color: Color(0xFF15803D),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 3,
                              height: 112,
                              color: const Color(0xFF86EFAC),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Share the App',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: BDSColors.blackText,
                                    ),
                                  ),
                                  Text(
                                    'Download Link',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Generate a download link for Bingwa Data Swift and share it with friends so they can download the app.',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.link, color: Color(0xFF15803D)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SelectableText(
                                  _generatedLink,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: BDSColors.blackText,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _copyLink,
                                child: const Icon(Icons.copy, color: Color(0xFF15803D), size: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _generateAppDownloadLink,
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              'Generate Download Link',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF15803D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _copyLink,
                            icon: const Icon(Icons.copy, color: Color(0xFF15803D)),
                            label: const Text(
                              'Copy Download Link',
                              style: TextStyle(
                                color: Color(0xFF15803D),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF15803D), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.lightbulb, color: Color(0xFF16A34A), size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'How It Works',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _stepRow('1', 'Tap Generate Download Link to create a fresh app download link.'),
                              const SizedBox(height: 8),
                              _stepRow('2', 'Tap Copy Download Link and paste it in your chats.'),
                              const SizedBox(height: 8),
                              _stepRow('3', 'Friends open the link directly to download Bingwa Data Swift.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                      Text('STK Push Phone: ${o.paymentPhone}'),
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
  final VoidCallback? onBackHome;

  const SupportTabScreen({super.key, this.onBackHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBackHome,
                    child: const Icon(Icons.arrow_back, color: BDSColors.pureWhite),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Support',
                      style: TextStyle(
                        color: BDSColors.pureWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(Icons.headset_mic, color: BDSColors.pureWhite),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: BDSColors.pureWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Support',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: BDSColors.blackText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Need help with an order or bundle request? Reach out directly using the buttons below.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF374151)),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => openWhatsAppDirect(context),
                            icon: const Icon(Icons.chat),
                            label: const Text(
                              'WhatsApp',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF15803D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () => openCallDirect(context),
                            icon: const Icon(Icons.call, color: Color(0xFF15803D)),
                            label: const Text(
                              'Call',
                              style: TextStyle(
                                color: Color(0xFF15803D),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF15803D), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
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
                            label: const Expanded(
                              child: Text(
                                'Join Bingwa Data Swift WhatsApp Group',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF15803D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Row(
                          children: [
                            Icon(Icons.info, color: Color(0xFF15803D), size: 20),
                            SizedBox(width: 6),
                            Text(
                              'Helpful Information',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: BDSColors.blackText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.bolt, color: Color(0xFF16A34A), size: 28),
                              SizedBox(width: 8),
                              VerticalDivider(width: 12, thickness: 2, color: Color(0xFF16A34A)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Direct M-Pesa STK Push',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: BDSColors.blackText,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Payments are initiated via M-Pesa STK Push and verified through server callback confirmation.',
                                      style: TextStyle(color: Color(0xFF374151), fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.verified_user, color: Color(0xFF16A34A), size: 28),
                              SizedBox(width: 8),
                              VerticalDivider(width: 12, thickness: 2, color: Color(0xFF16A34A)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'STK Push Number Check',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: BDSColors.blackText,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Confirm your M-Pesa STK Push phone number carefully before approving your PIN prompt.',
                                      style: TextStyle(color: Color(0xFF374151), fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String userEmail;
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
    required this.userEmail,
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
      isScrollControlled: true,
      backgroundColor: BDSColors.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.78,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const Divider(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    body,
                    style: const TextStyle(color: BDSColors.greyText, height: 1.55),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
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
                    Text(
                      userEmail.isNotEmpty ? 'Email: $userEmail' : 'Phone: $userPhone',
                      style: const TextStyle(color: BDSColors.greyText),
                    ),
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
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalSheet(
              context,
              'Privacy Policy',
              LegalContent.privacyPolicy,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Terms and Conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLegalSheet(
              context,
              'Terms and Conditions',
              LegalContent.termsAndConditions,
            ),
          ),
          if (isAdmin && onOpenAdmin != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onOpenAdmin!();
              },
              icon: const Icon(Icons.admin_panel_settings, color: BDSColors.primaryGreen),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: BDSColors.primaryGreen, width: 1.4),
              ),
              label: const Text('Admin Dashboard', style: TextStyle(color: BDSColors.primaryGreen)),
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
  final String adminEmail;
  final bool storeOpen;
  final List<OfferModel> offers;
  final List<AdItem> ads;
  final List<OrderRecord> orders;
  final ValueChanged<bool> onToggleStore;
  final ValueChanged<OfferModel> onAddOffer;
  final ValueChanged<OfferModel> onEditOffer;
  final ValueChanged<String> onDeleteOffer;
  final VoidCallback onResetDefaultOffers;
  final ValueChanged<AdItem> onAddAd;
  final ValueChanged<int> onRemoveAd;

  const AdminDashboardScreen({
    super.key,
    required this.adminEmail,
    required this.storeOpen,
    required this.offers,
    required this.ads,
    required this.orders,
    required this.onToggleStore,
    required this.onAddOffer,
    required this.onEditOffer,
    required this.onDeleteOffer,
    required this.onResetDefaultOffers,
    required this.onAddAd,
    required this.onRemoveAd,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedNet = 'SAFARICOM';
  String _filterNet = 'ALL';
  String _selectedMediaType = 'ad';
  String? _selectedMediaPath;

  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _validityCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController(text: 'DATA');
  final _adTitleCtrl = TextEditingController();
  final _adSubtitleCtrl = TextEditingController();

  Future<void> _pickPromoMedia() async {
    if (_selectedMediaType == 'image') {
      final path = await pickImageFromGallery(context);
      if (path != null && mounted) {
        setState(() => _selectedMediaPath = path);
      }
    } else if (_selectedMediaType == 'video') {
      final path = await pickVideoFromGallery(context);
      if (path != null && mounted) {
        setState(() => _selectedMediaPath = path);
      }
    }
  }

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New offer added and synced.')),
    );
  }

  void _showEditOfferDialog(OfferModel offer) {
    final editNameCtrl = TextEditingController(text: offer.name);
    final editPriceCtrl = TextEditingController(
      text: offer.fixedPriceKes?.toString() ?? '',
    );
    final editValidityCtrl = TextEditingController(text: offer.validity);
    final editCategoryCtrl = TextEditingController(text: offer.category);
    String editNetwork = offer.network;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Edit Offer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: editNetwork,
                  items: const ['SAFARICOM', 'AIRTEL', 'TELKOM', 'FAIBA']
                      .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => editNetwork = v ?? offer.network),
                  decoration: const InputDecoration(labelText: 'Network'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: editNameCtrl,
                  decoration: const InputDecoration(labelText: 'Bundle Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: editPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Fixed Price (KES)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: editValidityCtrl,
                  decoration: const InputDecoration(labelText: 'Validity'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: editCategoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editNameCtrl.text.trim();
                final newValidity = editValidityCtrl.text.trim();
                final newPrice = int.tryParse(editPriceCtrl.text.trim());
                if (newName.isEmpty || newValidity.isEmpty) return;

                final updated = offer.copyWith(
                  network: editNetwork,
                  name: newName,
                  priceLabel: newPrice != null ? 'KES $newPrice' : offer.priceLabel,
                  fixedPriceKes: newPrice ?? offer.fixedPriceKes,
                  validity: newValidity,
                  category: editCategoryCtrl.text.trim().isEmpty
                      ? offer.category
                      : editCategoryCtrl.text.trim().toUpperCase(),
                );
                widget.onEditOffer(updated);
                Navigator.pop(ctx);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Offer updated and synced.')),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
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
    final authorized = _checkIsAdmin(
      email: widget.adminEmail,
      pin: Catalogue68.adminAccessCode,
    );
    if (!authorized) {
      return const Scaffold(
        body: Center(child: Text('Unauthorized access.')),
      );
    }

    final filteredOffers = _filterNet == 'ALL'
        ? widget.offers
        : widget.offers.where((o) => o.network == _filterNet).toList();

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
          const SizedBox(height: 4),
          Text(
            RemoteSyncService.isConfigured
                ? 'Global Broadcast Sync: Active (updates reach all installed apps)'
                : 'Global Broadcast Sync: Local cache active (configure RemoteSyncService URL/Key for remote push)',
            style: const TextStyle(fontSize: 12, color: BDSColors.greyText),
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
          const Text(
            'Manage Promo Ads, Pictures & Videos (Visible to All Users)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedMediaType,
            items: const [
              DropdownMenuItem(value: 'ad', child: Text('Ad / Text Promo')),
              DropdownMenuItem(value: 'image', child: Text('Picture / Image')),
              DropdownMenuItem(value: 'video', child: Text('Video')),
            ],
            onChanged: (v) => setState(() {
              _selectedMediaType = v ?? 'ad';
              _selectedMediaPath = null;
            }),
            decoration: const InputDecoration(
              labelText: 'Promo Media Type',
              border: OutlineInputBorder(),
            ),
          ),
          if (_selectedMediaType == 'image' || _selectedMediaType == 'video') ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickPromoMedia,
              icon: Icon(
                _selectedMediaType == 'video' ? Icons.video_library : Icons.photo_library,
                color: BDSColors.primaryGreen,
              ),
              label: Text(
                _selectedMediaPath == null
                    ? 'Pick ${_selectedMediaType == 'video' ? 'Video' : 'Picture'} from Gallery'
                    : 'Selected: ${_selectedMediaPath!.split('/').last}',
                style: const TextStyle(color: BDSColors.primaryGreen),
              ),
            ),
          ],
          const SizedBox(height: 8),
          TextField(
            controller: _adTitleCtrl,
            decoration: const InputDecoration(labelText: 'Ad / Promo Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _adSubtitleCtrl,
            decoration: const InputDecoration(labelText: 'Ad / Promo Subtitle', border: OutlineInputBorder()),
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
                    iconCodePoint: 0xe126,
                    mediaType: _selectedMediaType,
                    mediaPath: _selectedMediaPath,
                  ),
                );
                _adTitleCtrl.clear();
                _adSubtitleCtrl.clear();
                setState(() => _selectedMediaPath = null);
              }
            },
            child: const Text('Publish Promo to Users'),
          ),
          ...List.generate(
            widget.ads.length,
            (i) => ListTile(
              leading: Icon(widget.ads[i].icon, color: BDSColors.primaryGreen),
              title: Text(widget.ads[i].title),
              subtitle: Text('${widget.ads[i].mediaType.toUpperCase()} • ${widget.ads[i].subtitle}'),
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
          const SizedBox(height: 8),
          TextField(
            controller: _categoryCtrl,
            decoration: const InputDecoration(labelText: 'Category (e.g. DATA, MINUTES, SMS)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addNewOffer,
            child: const Text('Add Offer'),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Manage Offers (Edit / Hide / Delete)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onResetDefaultOffers();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restored default 68 offers.')),
                  );
                },
                child: const Text('Reset 68', style: TextStyle(color: BDSColors.primaryGreen)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['ALL', 'SAFARICOM', 'AIRTEL', 'TELKOM', 'FAIBA'].map((net) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(net),
                    selected: _filterNet == net,
                    onSelected: (_) => setState(() => _filterNet = net),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          ...filteredOffers.map(
            (offer) => ListTile(
              title: Text(
                '${offer.network} | ${offer.name} (${offer.priceLabel})',
                style: const TextStyle(fontSize: 13),
              ),
              subtitle: Text(
                '${offer.validity} • ${offer.isVisible ? 'Visible' : 'Hidden'}',
                style: TextStyle(color: offer.isVisible ? BDSColors.primaryGreen : BDSColors.greyText),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: BDSColors.primaryGreen),
                    onPressed: () => _showEditOfferDialog(offer),
                  ),
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
