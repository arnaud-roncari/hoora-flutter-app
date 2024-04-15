import * as v1 from "firebase-functions/v1";
import * as admin from "firebase-admin";
import {UserEntity} from "./entity/user.entity";

admin.initializeApp();

export const createUser = v1.auth.user().onCreate( async (user) => {
  await admin.firestore().collection("user").add({
    userUid: user.uid,
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
