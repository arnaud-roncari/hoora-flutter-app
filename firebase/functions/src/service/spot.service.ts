import * as admin from "firebase-admin";
import {CreateSpotDto} from "../common/dto/create_spot.dto";
import {SpotEntity} from "../common/entity/spot.entity";
import {UserEntity} from "../common/entity/user.entity";

export class SpotService {
  static trafficPoints : number[][] = [
    [5, 10, 15, 20],
    [10, 15, 20, 25],
    [15, 20, 25, 30],
    [20, 25, 30, 35],
    [25, 30, 35, 40],
  ];

  static _getTrafficPoint(density: number, popularTime : number, average: number) : number {
    const difference: number = average - popularTime;

    if (difference <= 0) {
      return 0;
    }

    if (difference <= 10) {
      return this.trafficPoints[density - 1][0];
    }

    if (difference <= 20) {
      return this.trafficPoints[density - 1][1];
    }
    if (difference <= 30) {
      return this.trafficPoints[density - 1][2];
    }
    return this.trafficPoints[density - 1][3];
  }

  static _generateTrafficPoints(dto: CreateSpotDto): object[] {
    const popularTimes: Map<string, number>[] = dto.popularTimes;

    // Actual density
    const density = dto.density[new Date().getMonth()];

    // Set average
    let average = 0;
    let total = 0;
    for (const popularTime of popularTimes) {
      for (const [_, value] of Object.entries(popularTime)) {
        if (value > 0) {
          total += 1;
          average += value;
        }
      }
    }
    average = average / total;

    // Generate gemPerDays
    const trafficPoints: Map<string, number>[] = [];

    for (const popularTime of popularTimes) {
      const gpd = new Map<string, number>();

      for (const [key, value] of Object.entries(popularTime)) {
        gpd.set(key, this._getTrafficPoint(density, value, average));
      }

      trafficPoints.push(gpd);
    }


    return trafficPoints.map((e) => Object.fromEntries(e));
  }

  static async create(dto: CreateSpotDto) {
    // Generate gems per day
    const trafficPoints = this._generateTrafficPoints(dto);

    await admin.firestore().collection("spot").add({
      "trafficPoints": trafficPoints,
      ...dto.toJson(),
    });
  }

  static async validate(userId: string, spotId: string) {
    //  Retrieve the gems that the user will earn, from the spot
    const spotDoc = await admin.firestore().collection("spot").doc(spotId).get();
    const spot = SpotEntity.fromSnapshot(spotDoc);
    const gems = spot.getGemsNow();

    //  Create a new validation document
    await admin.firestore().collection("spotValidation").add({
      userId: userId,
      spotId: spotId,
      gems: gems,
      createdAt: new Date(Date.now()),
    });

    //  Update the user gem and experience
    const snapshot = await admin.firestore().collection("user").where("userId", "==", userId).get();
    const user = UserEntity.fromSnapshot(snapshot.docs[0]);
    user.gem += gems;
    user.experience += gems;
    await admin.firestore().collection("user").doc(user.id).update({gem: user.gem});
  }
}
