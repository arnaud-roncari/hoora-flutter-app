import {UserRepository} from "../repository/user.repository";

export class UserService {
  static async updateLevel(userId: string, newLevel: number) : Promise<void> {
    await UserRepository.updateLevel(userId, newLevel);
  }

  static async updateAmountCrowdReportCreated(userId: string) : Promise<void> {
    await UserRepository.updateAmountCrowdReportCreated(userId);
  }

  static async updateAmountChallengeUnlocked(userId: string) : Promise<void> {
    await UserRepository.updateAmountChallengeUnlocked(userId);
  }

  static async updateAmountSpotValidated(userId: string) : Promise<void> {
    await UserRepository.updateAmountSpotValidated(userId);
  }

  static async updateAmountOfferUnlocked(userId: string) : Promise<void> {
    await UserRepository.updateAmountOfferUnlocked(userId);
  }
}
