import * as admin from "firebase-admin";

export class CompanyRepository {
  static async create(json : any) : Promise<void> {
    await admin.firestore().collection("company").add(json);
  }
}
