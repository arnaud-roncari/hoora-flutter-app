import * as v1 from "firebase-functions/v1";
import * as v2 from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {UserEntity} from "./entity/user.entity";
import {CreateSpotsDto} from "./dto/create_spots.dto";

// / TODO: Upgrade body validation
admin.initializeApp();

export const createUser = v1.auth.user().onCreate( async (user) => {
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
  } as UserEntity);
});

export const createSpots = v2.https.onRequest(async (request, response) => {
  try {
    for (const spot of request.body) {
      const dto = CreateSpotsDto.fromJson(spot);
      await admin.firestore().collection("spot").add(dto.toJson());
    }

    response.json({status: "OK"});
  } catch (e) {
    response.json({status: "KO", error: e});
  }
});
