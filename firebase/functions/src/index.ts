import * as v1 from "firebase-functions/v1";
import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {CreateSpotDto} from "./common/dto/create_spot.dto";
import {SpotService} from "./service/spot.service";
import {verifyIdToken} from "./common/verify_id_token";
import {CrowdReport} from "./service/crowd_report.service";
import {CreateCrowdReportDto} from "./common/dto/create_crowd_report.dto";
import {RegionService} from "./service/region.service";
import {SpotEntity} from "./common/entity/spot.entity";
import {CreatePlaylistDto} from "./common/dto/create_playlist.dto";
import {PlaylistService} from "./service/playlist.service";
import {CreateRegionDto} from "./common/dto/create_region.dto";

// TODO: Upgrade body validation
// TODO: Catch crashes
admin.initializeApp();

/**
 * Create user document, with default values
 */
export const createUser = v1.auth.user().onCreate(async (user) => {
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
    language: "",
    gender: "",
    birthday: "",
    phoneNumber: "",
  });
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

    await CrowdReport.create(dto, userId);

    // TODO: Implement history

    response.json({status: "OK"});
  } catch (e) {
    console.log(e);
    response.json({status: "KO", error: e});
  }
});
