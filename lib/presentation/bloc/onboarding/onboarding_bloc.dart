import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  
  @override
  List<Object?> get props => [];
}

class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;
  
  const OnboardingPageChanged(this.pageIndex);
  
  @override
  List<Object?> get props => [pageIndex];
}

class OnboardingCompleted extends OnboardingEvent {}

// States
abstract class OnboardingState extends Equatable {
  const OnboardingState();
  
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  final int currentPage;
  
  const OnboardingInitial({this.currentPage = 0});
  
  @override
  List<Object?> get props => [currentPage];
}

class OnboardingComplete extends OnboardingState {}

// Bloc
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompleted>(_onCompleted);
  }
  
  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingInitial(currentPage: event.pageIndex));
  }
  
  void _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingComplete());
  }
}

