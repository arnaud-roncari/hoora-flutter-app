import * as admin from "firebase-admin";
import {CreateChallengeDto} from "../common/dto/create_challenge.dto";
import {ChallengeStatus, UnlockedChallengeEntity} from "../common/entity/unlocked_challenge.entity";
import {UserEntity} from "../common/entity/user.entity";
import {SpotValidatedEntity} from "../common/entity/spot_validated";
import {ChallengeEntity} from "../common/entity/challenge_entity";
import {TransactionRepository} from "../repository/transaction.repository";
import {TransactionType} from "../common/entity/transaction.entity";
import {ChallengeRepository} from "../repository/challenge_repository";
import { SpotRepository } from "../repository/spot.repository";
import { UserRepository } from "../repository/user.repository";
import { ProjectRepository } from "../repository/project.repository";

export class ChallengeService {
  static async create(dto: CreateChallengeDto) : Promise<void> {
    await admin.firestore().collection("challenge").doc(dto.id).set(dto.toJson());
  }

  static async createUnlocked(userId: string, challengeId: string) : Promise<void> {
    // Get challenge
    const snapshotChallenge = await admin.firestore().collection("challenge")
      .doc(challengeId)
      .get();
    const challenge = ChallengeEntity.fromSnapshot(snapshotChallenge);

    // Create unlocked challenge with challenge gems
    await admin.firestore().collection("unlockedChallenge").add({
      challengeId: challengeId,
      userId: userId,
      gem: challenge.gem,
      status: ChallengeStatus.unlocked,
    });

    //  Update the user
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    user.amountChallengeUnlocked += 1;
    await admin.firestore().collection("user").doc(user.id).update({
      amountChallengeUnlocked: user.amountChallengeUnlocked,
    });
  }

  static async claimUnlocked(userId: string, unlockedChallengeId: string) : Promise<void> {
    // Update the unlocked challenge status
    await admin.firestore().collection("unlockedChallenge").doc(unlockedChallengeId).update({
      status: ChallengeStatus.claimed,
    });

    // Get the unlocked challenge
    const unlockedChallengeSnapshot = await admin.firestore().collection("unlockedChallenge").doc(unlockedChallengeId).get();
    const unlockedChallenge = UnlockedChallengeEntity.fromSnapshot(unlockedChallengeSnapshot);

    // Get the unlocked challenge
    const challenge = await ChallengeRepository.getChallengeById(unlockedChallenge.challengeId);

    //  Update the user gem and experience
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    user.gem += unlockedChallenge.gem;
    user.experience += unlockedChallenge.gem;
    await admin.firestore().collection("user").doc(user.id).update({
      gem: user.gem,
      experience: user.experience,
    });

    // Create transaction
    await TransactionRepository.create({
      "type": TransactionType.challenge,
      "gem": unlockedChallenge.gem,
      "userId": user.userId,
      "name": challenge.name,
      "createdAt": new Date(),
    });
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
        case "2":
          ChallengeService._challenge2(userId);
          break;
          case "3":
            ChallengeService._challenge3(userId);
            break;
            case "4":
              ChallengeService._challenge4(userId);
              break;
              case "5":
                ChallengeService._challenge5(userId);
                break;
      }
    }
  }


 /**
  * 
  * @param userId 
  * @returns 
  */
  static async _challenge1(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_1");
      if (isUnlocked) {
        return;
      }

      // Get spots validated
      const spotsValidated = await SpotRepository.getSpotsValidated(userId);

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

  
  /**
   * 
   * @param userId 
   * @returns 
   */
  static async _challenge2(userId: string) : Promise<void> {
    try {
      const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_2");
      if (isUnlocked) {
        return;
      }

      let user = await UserRepository.getUser(userId);

      if (user.amountSpotValidated >= 25) {
        ChallengeService.createUnlocked(userId, "challenge_2");
      }
      
    } catch (e) {
      // Log error
    }
  }

  /**   
   * 
   * @param userId 
   * @returns 
   */
    static async _challenge3(userId: string) : Promise<void> {
      try {
        const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_3");
        if (isUnlocked) {
          return;
        }
  
        let user = await UserRepository.getUser(userId);
  
        if (user.amountSpotValidated >= 10) {
          ChallengeService.createUnlocked(userId, "challenge_3");
        }
        
      } catch (e) {
        // Log error
      }
    }

    /**
     * 
     * @param userId 
     * @returns 
     */
    static async _challenge4(userId: string) : Promise<void> {
      try {
        const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_4");
        if (isUnlocked) {
          return;
        }
  
        // Get spots validated
        const spotsValidated = await SpotRepository.getSpotsValidated(userId);
  
        for (const spotValidated of spotsValidated) {
          if (spotValidated.createdAt.getHours() >= 19) {
            ChallengeService.createUnlocked(userId, "challenge_4");
            break;
          }
        }
        
      } catch (e) {
        // Log error
      }
    }

        /**
     * 
     * @param userId 
     * @returns 
     */
        static async _challenge5(userId: string) : Promise<void> {
          try {
            const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_5");
            if (isUnlocked) {
              return;
            }
      
          // Fetch all users
          let users = await UserRepository.getAll();
          
          // Sort users based on experience
          users.sort( (a, b) => {
            return a.experience > b.experience ? -1 : 1;
          })
        
          // Takes 10 first users
          users = users.slice(0, 10)

          for (let user of users) {
            if (user.userId == userId) { 
            await ChallengeService.createUnlocked(userId, "challenge_5");
              break;
            }
          }
            
          } catch (e) {
            // Log error
          }
        }
  
        static async _challenge6(userId: string) : Promise<void> {
          try {
            const isUnlocked = await ChallengeRepository.isUnlocked(userId, "challenge_6");
            if (isUnlocked) {
              return;
            }
      
            // Fetch donations
            // let donations = ProjectRepository.get
            // Si > 1, on valide
        
       
            
          } catch (e) {
            // Log error
          }
        }
}
