// import 'dart:developer';
// import 'dart:io';

// import 'package:google_mobile_ads/google_mobile_ads.dart';

// // ignore: avoid_classes_with_only_static_members
// class AdService {
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return 
//       //? TEST
//       // 'ca-app-pub-3940256099942544/6300978111';
//       'ca-app-pub-8617418968381981/4637456929';
//     } else if (Platform.isIOS) {
//       return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }

//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>';
//     } else if (Platform.isIOS) {
//       return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }

//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return 
//       //? TEST
//       // 'ca-app-pub-3940256099942544/5224354917';
//       'ca-app-pub-8617418968381981/3482489059';
//     } else if (Platform.isIOS) {
//       return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }

//   static void initialize() {
//     MobileAds.instance.initialize();
//   }

//   static late BannerAd bannerAd;
//   static late RewardedAd rewardedAd;
//   static bool isRewardedAdReady = false;

//   static void loadRewardedAd() {
//     RewardedAd.load(
//       adUnitId: AdService.rewardedAdUnitId,
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           rewardedAd = ad;
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               loadRewardedAd();
//             },
//           );
//           isRewardedAdReady = true;
//         },
//         onAdFailedToLoad: (err) {
//           log('Failed to load a rewarded ad: ${err.message}');
//           isRewardedAdReady = false;
//         },
//       ),
//     );
//   }

//   static BannerAd createBannerAd() {
//     return BannerAd(
//         adUnitId: AdService.bannerAdUnitId,
//         listener: BannerAdListener(
//             onAdLoaded: (_) {
//               log('Banner Ad loaded');
//             },
//             onAdFailedToLoad: (ad, err) {
//               log('Failed to load a banner ad: ${err.message}');
//               ad.dispose();
//             }),
//         request: const AdRequest(),
//         size: AdSize.fullBanner);
//   }
// }
