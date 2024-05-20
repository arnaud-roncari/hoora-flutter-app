import * as admin from "firebase-admin";
import {UserEntity} from "../common/entity/user.entity";

export class UserRepository {
  static async updateLevel(userId: string, newLevel: number) : Promise<void> {
    // Fetch user
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    // Update level
    await admin.firestore().collection("user").doc(user.id).update({level: newLevel});
  }

  static async updateAmountCrowdReportCreated(userId: string) : Promise<void> {
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    await admin.firestore().collection("user").doc(user.id).update({amountCrowdReportCreated: user.amountCrowdReportCreated + 1});
  }

  static async updateAmountChallengeUnlocked(userId: string) : Promise<void> {
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    await admin.firestore().collection("user").doc(user.id).update({amountChallengeUnlocked: user.amountChallengeUnlocked + 1});
  }

  static async updateAmountSpotValidated(userId: string) : Promise<void> {
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    await admin.firestore().collection("user").doc(user.id).update({amountSpotValidated: user.amountSpotValidated + 1});
  }

  static async updateAmountOfferUnlocked(userId: string) : Promise<void> {
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    await admin.firestore().collection("user").doc(user.id).update({amountOfferUnlocked: user.amountOfferUnlocked + 1});
  }

  static async decreaseGem(userId: string, gem: number): Promise<void> {
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    await admin.firestore().collection("user").doc(user.id).update({gem: user.gem - gem});
  }
}
