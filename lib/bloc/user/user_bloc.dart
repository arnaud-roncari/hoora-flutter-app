import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/company_model.dart';
import 'package:hoora/model/offer_model.dart';
import 'package:hoora/model/unlocked_offer_model.dart';
import 'package:hoora/model/user_model.dart';
import 'package:hoora/repository/company_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/offer_repository.dart';
import 'package:hoora/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final OfferRepository offerRepository;
  final CompanyRepository companyRepository;
  final CrashRepository crashRepository;

  late User user;
  late String email;
  late List<Offer> unlockedOffers;

  UserBloc({
    required this.companyRepository,
    required this.userRepository,
    required this.offerRepository,
    required this.crashRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<AddGem>(addGem);
    on<RemoveGem>(removeGem);
    on<SetNickname>(setNickname);
    on<UpdateProfile>(updateProfile);
    on<AddUnlockedOffer>(addUnlockedOffer);
    on<ActivateUnlockedOffer>(activateUnlockedOffer);
  }

  void initialize(Init event, Emitter<UserState> emit) async {
    try {
      emit(InitLoading());

      email = userRepository.getEmail();
      List futures = await Future.wait([
        userRepository.getUser(),
        offerRepository.getUnlockedOffers(),
        offerRepository.getAllOffers(),
        companyRepository.getAllCompanies(),
      ]);
      user = futures[0];

      List<UnlockedOffer> unlockedOffers = futures[1];
      List<Offer> offers = futures[2];
      List<Company> companies = futures[3];

      this.unlockedOffers = [];
      for (Offer offer in offers) {
        /// Link company to offer
        for (Company company in companies) {
          if (offer.companyId == company.id) {
            offer.company = company;
            break;
          }
        }

        /// Link unlocked offer to offer
        for (UnlockedOffer unlockedOffer in unlockedOffers) {
          if (unlockedOffer.offerId == offer.id) {
            offer.unlockedOffer = unlockedOffer;
            this.unlockedOffers.add(offer);
            break;
          }
        }
      }

      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void addGem(AddGem event, Emitter<UserState> emit) {
    user.gem += event.gem;
    emit(GemsUpdate(gems: user.gem));
  }

  void removeGem(RemoveGem event, Emitter<UserState> emit) {
    user.gem -= event.gem;
    emit(GemsUpdate(gems: user.gem));
  }

  void addUnlockedOffer(AddUnlockedOffer event, Emitter<UserState> emit) {
    unlockedOffers.insert(0, event.offer);
    emit(UnlockedOffersUpdate(offers: unlockedOffers));
  }

  void setNickname(SetNickname event, Emitter<UserState> emit) async {
    try {
      emit(SetNicknameLoading());
      await userRepository.setNickname(event.nickname);
      emit(SetNicknameSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SetNicknameFailed(exception: alertException));
    }
  }

  void updateProfile(UpdateProfile event, Emitter<UserState> emit) async {
    try {
      emit(UpdateProfileLoading());
      await userRepository.updateProfile(
        documentId: user.id,
        nickname: event.nickname,
        firstname: event.firstname,
        lastname: event.lastname,
        city: event.city,
        country: event.country,
        birthday: event.birthday,
        gender: event.gender,
      );
      user.nickname = event.nickname;
      user.firstname = event.firstname;
      user.lastname = event.lastname;
      user.city = event.city;
      user.country = event.country;
      user.birthday = event.birthday;
      user.gender = event.gender;
      emit(UpdateProfileSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateProfileFailed(exception: alertException));
    }
  }

  void activateUnlockedOffer(ActivateUnlockedOffer event, Emitter<UserState> emit) async {
    try {
      emit(ActivateUnlockedOfferLoading());

      await offerRepository.activateUnlockedOffer(event.offer.unlockedOffer!.id);

      for (Offer unlockedOffer in unlockedOffers) {
        if (event.offer.id == unlockedOffer.id) {
          unlockedOffer.unlockedOffer!.status = UnlockedOfferStatus.activated;
          break;
        }
      }

      emit(ActivateUnlockedOfferSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ActivateUnlockedOfferFailed(exception: alertException));
    }
  }
}
