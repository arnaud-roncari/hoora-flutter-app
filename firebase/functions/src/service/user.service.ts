import {UserRepository} from "../repository/user.repository";

export class UserService {
  static async setLevel(documentId: string, newLevel: number) : Promise<void> {
    await UserRepository.setLevel(documentId, newLevel);
  }
}
