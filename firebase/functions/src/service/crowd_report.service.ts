import {CreateCrowdReportDto} from "../common/dto/create_crowd_report.dto";
import * as admin from "firebase-admin";
import {SpotEntity} from "../common/entity/spot.entity";
import {LastCrowdReportEntity} from "../common/entity/last_crowd_report.entity";
import {UserEntity} from "../common/entity/user.entity";

export class CrowdReportService {
  static async create(dto: CreateCrowdReportDto, userId: string) {
    // Create crowd report document
    await admin.firestore().collection("crowdReport").add({
      userId: userId,
      spotId: dto.spotId,
      intensity: dto.intensity,
      duration: dto.duration,
      createdAt: new Date(),
    });

    // Get the spot
    const spotDoc = await admin.firestore().collection("spot").doc(dto.spotId).get();
    const spot = SpotEntity.fromSnapshot(spotDoc);

    // Update the last crowd report
    spot.lastCrowdReport = new LastCrowdReportEntity({
      createdAt: new Date(),
      duration: dto.duration,
      intensity: dto.intensity,
      userId: userId,
    });

    await admin.firestore().collection("spot").doc(dto.spotId).update({lastCrowdReport: spot.lastCrowdReport.toJson()});

    //  Update the user gems
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    user.gem += 5;
    await admin.firestore().collection("user").doc(user.id).update({gem: user.gem});
  }
}
