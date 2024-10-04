part of 'ads_bloc.dart';

@immutable
abstract class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object> get props => [];
}

class InterstitialAdRequestedEvent extends AdsEvent {
  const InterstitialAdRequestedEvent({
    required this.onAdDismissedFullScreenContent,
  });

  final VoidCallback onAdDismissedFullScreenContent;

  @override
  List<Object> get props => [onAdDismissedFullScreenContent];
}

class InterstitialAdDisposed extends AdsEvent {}

class InterstitialReadyToRequest extends AdsEvent {
  const InterstitialReadyToRequest({
    required this.onAdDismissedFullScreenContent,
  });

  final VoidCallback onAdDismissedFullScreenContent;
  @override
  List<Object> get props => [onAdDismissedFullScreenContent];
}

