import * as v1 from "firebase-functions/v1";
import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {CreateSpotDto} from "./common/dto/create_spot.dto";
import {SpotService} from "./service/spot.service";
import {verifyIdToken} from "./common/verify_id_token";
import {CrowdReportService} from "./service/crowd_report.service";
import {CreateCrowdReportDto} from "./common/dto/create_crowd_report.dto";
import {RegionService} from "./service/region.service";
import {SpotEntity} from "./common/entity/spot.entity";
import {CreatePlaylistDto} from "./common/dto/create_playlist.dto";
import {PlaylistService} from "./service/playlist.service";
import {CreateRegionDto} from "./common/dto/create_region.dto";
import {CreateChallengeDto} from "./common/dto/create_challenge.dto";
import {ChallengeService} from "./service/challenge_service";
import {CreateUnlockedChallengeDto} from "./common/dto/create_unlocked_challenge.dto";
import {ClaimUnlockedChallengeDto} from "./common/dto/claim_unlocked_challenge.dto";
import {UserEntity} from "./common/entity/user.entity";
import {UserService} from "./service/user.service";
import {CrowdReportEntity} from "./common/entity/crowd_report.entity";
import {SpotValidatedEntity} from "./common/entity/spot_validated";
import {UnlockedChallengeEntity} from "./common/entity/unlocked_challenge.entity";
import {CreateCompanyDto} from "./common/dto/create_company.dto";
import {CompanyService} from "./service/company.service";
import {CreateOfferDto} from "./common/dto/create_offer.dto";
import {OfferService} from "./service/offer.service";
import {UnlockOfferDto} from "./common/dto/unlock_offer.dto";
import {UnlockedOfferEntity} from "./common/entity/unlocked_offer.entity";

// TODO: Upgrade body validation
// TODO: Catch crashes
admin.initializeApp();

/**
 * Create user document, with default values
 */
export const onUserCreated = v1.auth.user().onCreate(async (user) => {
  await admin.firestore().collection("user").add({
    userId: user.uid,
    gem: 15,
    experience: 15,
    level: 1,
    firstname: "",
    lastname: "",
    nickname: "",
    city: "",
    country: "",
    gender: null,
    birthday: null,
    amountSpotValidated: 0,
    amountCrowdReportCreated: 0,
    amountChallengeUnlocked: 0,
    amountOfferUnlocked: 0,
    amountDonation: 0,
    createdAt: new Date(),
  });
});

/**
 * Update level
 */
exports.onUserUpdated = v2.firestore.onDocumentUpdated("user/{docId}", async (event) => {
  const user = UserEntity.fromSnapshot(event.data!.after);
  if (user.level === 1 && user.experience > 800) {
    await UserService.updateLevel(user.userId, 2);
  } else if ( user.level === 2 && user.experience > 2000) {
    await UserService.updateLevel(user.userId, 3);
  }
  // / TODO : Trigger challenges.
});


/**
 * Update User stats
 */
exports.onCrowdReportCreated = v2.firestore.onDocumentCreated("crowdReport/{docId}", async (event) => {
  const crowdReport = CrowdReportEntity.fromSnapshot(event.data!);
  await UserService.updateAmountCrowdReportCreated(crowdReport.userId);
});

/**
 * Update User stats
 */
exports.onSpotValidated = v2.firestore.onDocumentCreated("spotValidation/{docId}", async (event) => {
  const spotValidated = SpotValidatedEntity.fromSnapshot(event.data!);
  await UserService.updateAmountSpotValidated(spotValidated.userId);
});

/**
 * Update User stats
 */
exports.onChallengeUnlocked = v2.firestore.onDocumentCreated("unlockedChallenge/{docId}", async (event) => {
  const unlockedChallenge = UnlockedChallengeEntity.fromSnapshot(event.data!);
  await UserService.updateAmountChallengeUnlocked(unlockedChallenge.userId);
});

/**
 * Update User stats
 */
exports.onOfferUnlocked = v2.firestore.onDocumentCreated("unlockedOffer/{docId}", async (event) => {
  const unlockedOffer = UnlockedOfferEntity.fromSnapshot(event.data!);
  await UserService.updateAmountOfferUnlocked(unlockedOffer.userId);
});


/**
 * Increase spotQuantity
 */
exports.incrementSpotQuantity = v2.firestore.onDocumentCreated("spot/{docId}", async (event) => {
  const snapshot = event.data;
  if (snapshot == null) {
    return;
  }
  const spot = SpotEntity.fromSnapshot(snapshot);
  await RegionService.increaseSpotQuantity(spot);
});

/**
 * Decrease spotQuantity
 */
exports.decreaseSpotQuantity = v2.firestore.onDocumentDeleted("spot/{docId}", async (event) => {
  const snapshot = event.data;
  if (snapshot == null) {
    return;
  }

  const spot = SpotEntity.fromSnapshot(snapshot);
  await RegionService.decreaseSpotQuantity(spot);
}
);

/**
 * Create spots
 */
export const createSpots = v2.https.onRequest(async (request, response ) => {
  try {
    for (const spot of request.body) {
      const dto = CreateSpotDto.fromJson(spot);
      await SpotService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create playlists
 */
export const createPlaylists = v2.https.onRequest(async (request, response ) => {
  try {
    for (const playlist of request.body) {
      const dto = CreatePlaylistDto.fromJson(playlist);
      await PlaylistService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create regions
 */
export const createRegions = v2.https.onRequest(async (request, response ) => {
  try {
    for (const region of request.body) {
      const dto = CreateRegionDto.fromJson(region);
      await RegionService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Validate spot
 */
export const validateSpot = v2.https.onRequest(async (request, response) => {
  try {
    // Extract parameters
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const spotId : string = request.body.spotId;

    await SpotService.validate(userId, spotId);

    // TODO: Implement history

    response.json({status: "OK"});

    ChallengeService.trigger(userId, ["1"]);
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create crowd report
 * Replace last crowd report of attached spot
 */
export const createCrowdReport = v2.https.onRequest(async ( request, response) => {
  try {
    // Extract parameters
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const dto = CreateCrowdReportDto.fromJson(request.body);

    await CrowdReportService.create(dto, userId);

    // TODO: Implement history

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Unlocked offer
 */
export const unlockOffer = v2.https.onRequest(async ( request, response) => {
  try {
    // Extract parameters
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const dto = UnlockOfferDto.fromJson(request.body);

    await OfferService.unlock( userId, dto.offerId);

    // TODO: Implement history

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create challenges
 */
export const createChallenges = v2.https.onRequest(async (request, response ) => {
  try {
    for (const challenge of request.body) {
      const dto = CreateChallengeDto.fromJson(challenge);
      await ChallengeService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});

/**
 * Create companies
 */
export const createCompanies = v2.https.onRequest(async (request, response ) => {
  try {
    for (const company of request.body) {
      const dto = CreateCompanyDto.fromJson(company);
      await CompanyService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});


/**
 * Create offers
 */
export const createOffers = v2.https.onRequest(async (request, response ) => {
  try {
    for (const offer of request.body) {
      const dto = CreateOfferDto.fromJson(offer);
      await OfferService.create(dto);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});


/**
 * Create unlocked challenges
 */
export const createUnlockedChallenges = v2.https.onRequest(async (request, response ) => {
  try {
    for (const challenge of request.body) {
      const dto = CreateUnlockedChallengeDto.fromJson(challenge);
      await ChallengeService.createUnlocked( dto.userId, dto.challengeId);
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});


/**
 * Claim unlocked challenges
 */
export const claimUnlockedChallenge = v2.https.onRequest(async (request, response ) => {
  try {
    const decodedIdToken = await verifyIdToken(request);
    const userId = decodedIdToken.uid;
    const dto = ClaimUnlockedChallengeDto.fromJson(request.body);
    await ChallengeService.claimUnlocked(userId, dto.unlockedChallengeId);

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});
