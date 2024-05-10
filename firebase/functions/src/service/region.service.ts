import {CreateRegionDto} from "../common/dto/create_region.dto";
import {CityEntity} from "../common/entity/city.entity";
import {RegionEntity} from "../common/entity/region.entity";
import {SpotEntity} from "../common/entity/spot.entity";
import * as admin from "firebase-admin";

export class RegionService {
  static async create(dto: CreateRegionDto) {
    await admin.firestore().collection("region").add(dto.toJson());
  }

  static async increaseSpotQuantity( spot : SpotEntity) {
    // Retrieve region
    const regionId = spot.regionId;
    const regionSnapshot = await admin.firestore().collection("region").doc(regionId).get();
    const region = RegionEntity.fromSnapshot(regionSnapshot);

    // Increment the right region spot quantity
    const cities = region.cities;
    for (const city of cities) {
      if (city.id === spot.cityId) {
        city.spotQuantity += 1;
        break;
      }
    }

    // Update spot quantity
    await admin.firestore().collection("region").doc(regionId).update({
      cities: CityEntity.toJsons(cities),
    });
  }

  static async decreaseSpotQuantity( spot : SpotEntity) {
    // Retrieve region
    const regionId = spot.regionId;
    const regionSnapshot = await admin.firestore().collection("region").doc(regionId).get();
    const region = RegionEntity.fromSnapshot(regionSnapshot);

    // Decrease the right region spot quantity
    const cities = region.cities;
    for (const city of cities) {
      if (city.id === spot.cityId) {
        city.spotQuantity -= 1;
        break;
      }
    }

    // Update spot quantity
    await admin.firestore().collection("region").doc(regionId).update({
      cities: CityEntity.toJsons(cities),
    });
  }
}
