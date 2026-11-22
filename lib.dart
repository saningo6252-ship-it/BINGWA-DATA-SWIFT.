enum NetworkType {
  safaricom,
  airtel,
  telkom,
  faiba;

  String get displayName {
    switch (this) {
      case NetworkType.safaricom:
        return 'SAFARICOM';
      case NetworkType.airtel:
        return 'AIRTEL';
      case NetworkType.telkom:
        return 'TELKOM';
      case NetworkType.faiba:
        return 'FAIBA';
    }
  }

  String get apiKey => name.toUpperCase();

  static NetworkType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'SAFARICOM':
        return NetworkType.safaricom;
      case 'AIRTEL':
        return NetworkType.airtel;
      case 'TELKOM':
        return NetworkType.telkom;
      case 'FAIBA':
        return NetworkType.faiba;
      default:
        return NetworkType.safaricom;
    }
  }
}

enum BundleCategory {
  all,
  data,
  sms,
  minutes,
  combo,
  noExpiry;

  String get label {
    switch (this) {
      case BundleCategory.all:
        return 'ALL';
      case BundleCategory.data:
        return 'DATA';
      case BundleCategory.sms:
        return 'SMS';
      case BundleCategory.minutes:
        return 'MINUTES';
      case BundleCategory.combo:
        return 'COMBO';
      case BundleCategory.noExpiry:
        return 'NO EXPIRY';
    }
  }

  static BundleCategory fromString(String value) {
    final normalized = value.toUpperCase().replaceAll(' ', '_');
    switch (normalized) {
      case 'ALL':
        return BundleCategory.all;
      case 'DATA':
        return BundleCategory.data;
      case 'SMS':
        return BundleCategory.sms;
      case 'MINUTES':
        return BundleCategory.minutes;
      case 'COMBO':
        return BundleCategory.combo;
      case 'NO_EXPIRY':
      case 'NOEXPIRY':
        return BundleCategory.noExpiry;
      default:
        return BundleCategory.all;
    }
  }
}

class BundleOffer {
  final String id;
  final NetworkType network;
  final BundleCategory category;
  final String name;
  final int? priceKes;
  final int? minCustomAmount;
  final int? maxCustomAmount;
  final String validity;
  final bool isPopular;
  final bool isActive;
  final String? providerProductCode;

  const BundleOffer({
    required this.id,
    required this.network,
    required this.category,
    required this.name,
    this.priceKes,
    this.minCustomAmount,
    this.maxCustomAmount,
    required this.validity,
    this.isPopular = false,
    this.isActive = true,
    this.providerProductCode,
  });

  bool get isCustomAmount => priceKes == null;

  String get priceDisplay {
    if (priceKes != null) {
      return 'KES ${_formatWithCommas(priceKes!)}';
    }
    if (minCustomAmount != null && maxCustomAmount != null) {
      return 'Customer chooses KES $minCustomAmount–$maxCustomAmount';
    }
    return 'Custom Amount';
  }

  static String _formatWithCommas(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  BundleOffer copyWith({
    String? id,
    NetworkType? network,
    BundleCategory? category,
    String? name,
    int? priceKes,
    int? minCustomAmount,
    int? maxCustomAmount,
    String? validity,
    bool? isPopular,
    bool? isActive,
    String? providerProductCode,
  }) {
    return BundleOffer(
      id: id ?? this.id,
      network: network ?? this.network,
      category: category ?? this.category,
      name: name ?? this.name,
      priceKes: priceKes ?? this.priceKes,
      minCustomAmount: minCustomAmount ?? this.minCustomAmount,
      maxCustomAmount: maxCustomAmount ?? this.maxCustomAmount,
      validity: validity ?? this.validity,
      isPopular: isPopular ?? this.isPopular,
      isActive: isActive ?? this.isActive,
      providerProductCode: providerProductCode ?? this.providerProductCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'network': network.apiKey,
      'category': category.name.toUpperCase(),
      'name': name,
      'priceKes': priceKes,
      'minCustomAmount': minCustomAmount,
      'maxCustomAmount': maxCustomAmount,
      'validity': validity,
      'isPopular': isPopular,
      'isActive': isActive,
      'providerProductCode': providerProductCode,
    };
  }

  factory BundleOffer.fromJson(Map<String, dynamic> json) {
    return BundleOffer(
      id: json['id'] as String,
      network: NetworkType.fromString(json['network'] as String),
      category: BundleCategory.fromString(json['category'] as String),
      name: json['name'] as String,
      priceKes: json['priceKes'] as int?,
      minCustomAmount: json['minCustomAmount'] as int?,
      maxCustomAmount: json['maxCustomAmount'] as int?,
      validity: json['validity'] as String,
      isPopular: (json['isPopular'] as bool?) ?? false,
      isActive: (json['isActive'] as bool?) ?? true,
      providerProductCode: json['providerProductCode'] as String?,
    );
  }
}

class OfficialCatalogueSeed {
  static const List<BundleOffer> offers = [
    // A. SAFARICOM
    BundleOffer(
      id: 'saf_combo_10mb_7sms_8',
      network: NetworkType.safaricom,
      category: BundleCategory.combo,
      name: '10MB + 7 SMS',
      priceKes: 8,
      validity: '24 Hrs / Daily',
      isPopular: true,
    ),
    BundleOffer(
      id: 'saf_data_250mb_20',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '250MB',
      priceKes: 20,
      validity: '24 Hrs / Daily',
    ),
    BundleOffer(
      id: 'saf_data_1gb_21',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '1GB',
      priceKes: 21,
      validity: '1 Hr / Hourly',
      isPopular: true,
    ),
    BundleOffer(
      id: 'saf_data_450mb_32',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '450MB',
      priceKes: 32,
      validity: 'Till Midnight / Daily',
    ),
    BundleOffer(
      id: 'saf_data_1_5gb_53',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '1.5GB',
      priceKes: 53,
      validity: '3 Hrs / Hourly',
    ),
    BundleOffer(
      id: 'saf_combo_750mb_50sms_54',
      network: NetworkType.safaricom,
      category: BundleCategory.combo,
      name: '750MB + 50 SMS',
      priceKes: 54,
      validity: '24 Hrs / Daily',
    ),
    BundleOffer(
      id: 'saf_data_800mb_55',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '800MB',
      priceKes: 55,
      validity: 'Till Midnight / Daily',
    ),
    BundleOffer(
      id: 'saf_data_400mb_56',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '400MB',
      priceKes: 56,
      validity: '7 Days / Weekly',
    ),
    BundleOffer(
      id: 'saf_data_900mb_58',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '900MB',
      priceKes: 58,
      validity: 'Till Midnight / Daily',
    ),
    BundleOffer(
      id: 'saf_data_1gb_60',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '1GB',
      priceKes: 60,
      validity: 'Till Midnight / Daily',
      isPopular: true,
    ),
    BundleOffer(
      id: 'saf_data_1_25gb_78',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '1.25GB',
      priceKes: 78,
      validity: 'Till Midnight / Daily',
    ),
    BundleOffer(
      id: 'saf_combo_1_5gb_40sms_wa_106',
      network: NetworkType.safaricom,
      category: BundleCategory.combo,
      name: '1.5GB + 40 SMS + WhatsApp',
      priceKes: 106,
      validity: '24 Hrs / Daily',
    ),
    BundleOffer(
      id: 'saf_data_1_1gb_yt_110',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '1.1GB + Free YouTube',
      priceKes: 110,
      validity: '7 Days / Weekly',
    ),
    BundleOffer(
      id: 'saf_data_5gb_255',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '5GB',
      priceKes: 255,
      validity: '3 Days',
      isPopular: true,
    ),
    BundleOffer(
      id: 'saf_data_2_5gb_256',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '2.5GB',
      priceKes: 256,
      validity: '30 Days / Monthly',
    ),
    BundleOffer(
      id: 'saf_combo_4gb_220mins_50sms_505',
      network: NetworkType.safaricom,
      category: BundleCategory.combo,
      name: '4GB + 220 Mins + 50 SMS',
      priceKes: 505,
      validity: '7 Days / Weekly',
    ),
    BundleOffer(
      id: 'saf_data_11gb_yt_509',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '11GB + Free YouTube',
      priceKes: 509,
      validity: '7 Days / Weekly',
    ),
    BundleOffer(
      id: 'saf_data_21gb_1006',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '21GB',
      priceKes: 1006,
      validity: '30 Days / Monthly',
    ),
    BundleOffer(
      id: 'saf_data_150gb_5012',
      network: NetworkType.safaricom,
      category: BundleCategory.data,
      name: '150GB',
      priceKes: 5012,
      validity: '30 Days / Monthly',
