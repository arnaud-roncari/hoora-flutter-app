import * as v1 from "firebase-functions/v1"; 
import * as admin from "firebase-admin"; 
import { UserEntity } from "./entity/user.entity";

admin.initializeApp();

export const createUser = v1.auth.user().onCreate( async user => {
    let userEntity : UserEntity = new UserEntity({ 
        uid: user.uid,
        userUid: user.uid,
        gems: 15,
    });

    await admin.firestore().collection("user").add({
        userUid: userEntity.userUid,
        gems: userEntity.gems,
    } as UserEntity);
});
