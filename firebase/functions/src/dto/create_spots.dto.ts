import * as gcloud from "@google-cloud/firestore";
import {OpenHoursDto} from "./open_hours.dto";
import {ExceptionalOpenHoursDto} from "./exceptional_open_hours.dto";
import {LastCrowdReportDto} from "./last_crowd_report.dto";

export class CreateSpotsDto {
  name: string;
  imageCardPath: string;
  coordinates: gcloud.GeoPoint;
  areaId: string;
  playlistIds: string[];
  exceptionalOpenHours: ExceptionalOpenHoursDto[];
  openHours: OpenHoursDto[];
  gemsPerDays: Map<number, number>[];
  lastCrowdReport: LastCrowdReportDto | null;
  balancePremium: BalancePremiumDto | null;
  pulsePremium: PulsePremiumDto | null;
  rating: number;


  constructor({
    name,
    imageCardPath,
    coordinates,
    areaId,
    playlistIds,
    exceptionalOpenHours,
    openHours,
    gemsPerDays,
    lastCrowdReport,
    balancePremium,
    pulsePremium,
    rating,
  } : {
        name: string,
        imageCardPath: string,
        coordinates: gcloud.GeoPoint,
        areaId: string,
        playlistIds: string[],
        exceptionalOpenHours: ExceptionalOpenHoursDto[],
        openHours: OpenHoursDto[],
        gemsPerDays: Map<number, number>[],
        lastCrowdReport: LastCrowdReportDto | null,
        balancePremium: BalancePremiumDto | null,
        pulsePremium: PulsePremiumDto | null,
        rating: number,
       }) {
    this.name = name;
    this.imageCardPath = imageCardPath;
    this.coordinates = coordinates;
    this.areaId = areaId;
    this.playlistIds = playlistIds;
    this.exceptionalOpenHours = exceptionalOpenHours;
    this.openHours = openHours;
    this.gemsPerDays = gemsPerDays;
    this.lastCrowdReport = lastCrowdReport;
    this.balancePremium = balancePremium;
    this.pulsePremium = pulsePremium;
    this.rating = rating;
  }

  static fromJson(json: any): CreateSpotsDto {
    const dto = new CreateSpotsDto({
      name: json.name,
      imageCardPath: json.imageCardPath,
      coordinates: new gcloud.GeoPoint(json.coordinates[0],
        json.coordinates[1]),
      areaId: json.areaId,
      playlistIds: json.playlistIds,
      exceptionalOpenHours: ExceptionalOpenHoursDto.fromJsons(
        json.exceptionalOpenHours),
      openHours: OpenHoursDto.fromJsons(json.openHours),
      gemsPerDays: json.gemsPerDays,
      lastCrowdReport: LastCrowdReportDto.fromJson(json.lastCrowdReport),
      balancePremium: BalancePremiumDto.fromJson(json.balancePremium),
      pulsePremium: PulsePremiumDto.fromJson(json.pulsePremium),
      rating: json.rating,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): CreateSpotsDto[] {
    const list: CreateSpotsDto[] = [];
    for (const json of jsons) {
      const elem = CreateSpotsDto.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "name": this.name,
      "imageCardPath": this.imageCardPath,
      "coordinates": this.coordinates,
      "areaId": this.areaId,
      "playlistIds": this.playlistIds,
      "exceptionalOpenHours": ExceptionalOpenHoursDto.toJsons(
        this.exceptionalOpenHours),
      "openHours": OpenHoursDto.toJsons(this.openHours),
      "gemsPerDays": this.gemsPerDays,
      "lastCrowdReport": this.lastCrowdReport?.toJson() ?? null,
      "balancePremium": this.balancePremium?.toJson() ?? null,
      "pulsePremium": this.pulsePremium?.toJson() ?? null,
      "rating": this.rating,
    };
  }

  static toJsons(dtos : CreateSpotsDto[]) : object[] {
    const list: object[] = [];
    for (const dto of dtos) {
      const elem = dto.toJson();
      list.push(elem);
    }
    return list;
  }
}
