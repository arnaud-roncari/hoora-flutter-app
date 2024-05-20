import * as admin from "firebase-admin";
import {CreateChallengeDto} from "../common/dto/create_challenge.dto";
import {ChallengeStatus, UnlockedChallengeEntity} from "../common/entity/unlocked_challenge.entity";
import {UserEntity} from "../common/entity/user.entity";
import {SpotValidatedEntity} from "../common/entity/spot_validated";
import {ChallengeEntity} from "../common/entity/challenge_entity";

export class ChallengeService {
  static async create(dto: CreateChallengeDto) : Promise<void> {
    await admin.firestore().collection("challenge").doc(dto.id).set(dto.toJson());
  }

  static async createUnlocked(userId: string, challengeId: string) : Promise<void> {
    // Get challenge
    const snapshotChallenge = await admin.firestore().collection("challenge")
      .doc("challenge_1")
      .get();
    const challenge = ChallengeEntity.fromSnapshot(snapshotChallenge);

    // Create unlocked challenge with challenge gems
    await admin.firestore().collection("unlockedChallenge").add({
      challengeId: challengeId,
      userId: userId,
      gem: challenge.gem,
      status: ChallengeStatus.unlocked,
    });
  }

  static async claimUnlocked(userId: string, unlockedChallengeId: string) : Promise<void> {
    // Update the unlocked challenge status
    await admin.firestore().collection("unlockedChallenge").doc(unlockedChallengeId).update({
      status: ChallengeStatus.claimed,
    });

    // Get the challenge
    const unlockedChallengeSnapshot = await admin.firestore().collection("unlockedChallenge").doc(unlockedChallengeId).get();
    const unlockedChallenge = UnlockedChallengeEntity.fromSnapshot(unlockedChallengeSnapshot);

    //  Update the user gem and experience
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    user.gem += unlockedChallenge.gem;
    user.experience += unlockedChallenge.gem;
    await admin.firestore().collection("user").doc(user.id).update({gem: user.gem});

    // TODO Create history
  }

  /**
   * Return true if a user already unlocked the challenge
   */
  static async isUnlocked(userId: string, challengeId: string) : Promise<boolean> {
    const snapshot = await admin.firestore().collection("unlockedChallenge")
      .where("userId", "==", userId)
      .where("challengeId", "==", challengeId)
      .get();

    if (snapshot.docs.length > 0) {
      return true;
    }
    return false;
  }

  /**
   * Trigger challenges verification
   */
  static async trigger(userId:string, challengeIds: string[]) {
    for (const challengeId of challengeIds) {
      switch (challengeId) {
      case "1":
        ChallengeService._challenge1(userId);
        break;
      }
    }
  }


  static async _challenge1(userId: string) : Promise<void> {
    try {
      // Exit if challenge already unlocked
      const isUnlocked = await ChallengeService.isUnlocked(userId, "challenge_1");
      if (isUnlocked) {
        return;
      }

      // Get spots validated
      const snapshotSv = await admin.firestore().collection("spotValidation")
        .where("userId", "==", userId)
        .get();
      const spotsValidated = SpotValidatedEntity.fromSnapshots(snapshotSv.docs);

      for (const spotValidated of spotsValidated) {
        if (spotValidated.createdAt.getHours() < 11) {
          ChallengeService.createUnlocked(userId, "challenge_1");
          break;
        }
      }
    } catch (e) {
      // Log error
    }
  }
}
