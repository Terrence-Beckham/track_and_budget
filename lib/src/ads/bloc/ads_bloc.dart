import 'dart:async';

import 'package:ads_repo/ads_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:settings_repo/settings_repo.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc({
    required AdsRepo adsRepo,
  })  : _adsRepo = adsRepo,
        super(const AdsState()) {
    on<InterstitialAdRequestedEvent>(
      _InterstitialAdRequested,
    );
    on<InterstitialAdDisposed>(_InterstitialAdDisposed);
  }

  final AdsRepo _adsRepo;

  FutureOr<void> _InterstitialAdRequested(
    InterstitialAdRequestedEvent event,
    Emitter<AdsState> emit,
  ) async {
    if (state.didInterstitialAdLoad) return;
    final pattern = await _adsRepo.getInterstitialAd(
      onAdDismissedFullScreenContent: event.onAdDismissedFullScreenContent,
    );
    switch (pattern) {
      case (failure: null, value: final InterstitialAd ad):
        return emit(state.copyWith(interstitialAd: ad));
      case (failure: final RepoFailure<String> failure, value: null):
        addError(failure.error, failure.stackTrace);
    }
  }

  FutureOr<void> _InterstitialAdDisposed(
    InterstitialAdDisposed event,
    Emitter<AdsState> emit,
  ) {
    state.interstitialAd?.dispose();

    emit(state.copyWith( interstitialAd: null));
  }
}
