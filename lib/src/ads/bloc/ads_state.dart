// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'ads_bloc.dart';

class AdsState extends Equatable {
  const AdsState({
    this.adsCounter,
    this.interstitialAd,
    
  });
  final int? adsCounter;
  final InterstitialAd? interstitialAd;

  bool get didInterstitialAdLoad => interstitialAd != null;

  @override
  List<Object?> get props => [
        adsCounter,
        interstitialAd,
      ];

  AdsState copyWith({
    int? adsCounter,
    InterstitialAd? interstitialAd,
  }) {
    return AdsState(
      adsCounter: adsCounter ?? this.adsCounter,
      interstitialAd: interstitialAd ?? this.interstitialAd,
    );
  }
}
