import {CreateOfferDto} from "../common/dto/create_offer.dto";
import {UnlockedOfferStatus} from "../common/entity/unlocked_offer.entity";
import {OfferRepository} from "../repository/offer.repository";
import {UserRepository} from "../repository/user.repository";

export class OfferService {
  static async create(dto: CreateOfferDto) {
    await OfferRepository.create(dto.toJson());
  }

  static async unlock(userId: string, offerId: string) {
    const offer = await OfferRepository.getById(offerId);

    // Extract code
    const code = offer.codes[0];

    // Remove code from offer
    offer.codes.shift();

    // Create unlocked offer
    await OfferRepository.createUnlockOffer({
      userId: userId,
      offerId: offer.id,
      gem: offer.price,
      code: code,
      status: UnlockedOfferStatus.unlocked,
      createdAt: new Date(),
      validatedAt: null,
    });


    // Update offer codes
    await OfferRepository.updateCodes(offerId, offer.codes);

    // Decrease user gem
    await UserRepository.decreaseGem(userId, offer.price);
  }
}
