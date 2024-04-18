// import * as admin from "firebase-admin";
import * as gcloud from "@google-cloud/firestore";

export class PulsePremiumDto {
  from: Date;
  to: Date;
  gem: number;

  constructor({from, to, gem} : {
    from: Date,
    to: Date,
    gem: number,
  }) {
    this.from = from;
    this.to = to;
    this.gem = gem;
  }

  static fromJson(json: any): PulsePremiumDto | null {
    if (json == null) {
      return null;
    }

    const dto = new PulsePremiumDto({
      from: new Date(json.from),
      to: new Date(json.to),
      gem: json.gem,
    });
    return dto;
  }

  toJson() : object {
    return {
      "from": this.from,
      "to": this.to,
      "gem": this.gem,
    };
  }
}

export class BalancePremiumDto {
  from: Date;
  to: Date;
  gem: number;

  constructor({from, to, gem} : {
    from: Date,
    to: Date,
    gem: number,
  }) {
    this.from = from;
    this.to = to;
    this.gem = gem;
  }

  static fromJson(json: any): BalancePremiumDto | null {
    if (json == null) {
      return null;
    }

    const dto = new BalancePremiumDto({
      from: new Date(json.from),
      to: new Date(json.to),
      gem: json.gem,
    });
    return dto;
  }

  toJson() : object {
    return {
      "from": this.from,
      "to": this.to,
      "gem": this.gem,
    };
  }
}

export class CrowdReportDto {
  createdAt: Date;
  userId: string;
  hour: number;
  minute: number;
  intensity: number;

  constructor({createdAt, userId, hour, minute, intensity} : {
        createdAt: Date,
        userId: string,
        hour: number,
        minute: number,
        intensity: number,

    }) {
    this.createdAt = createdAt;
    this.userId = userId;
    this.hour = hour;
    this.minute = minute;
    this.intensity = intensity;
  }

  static fromJson(json: any): CrowdReportDto {
    const dto = new CrowdReportDto({
      createdAt: new Date(json.createdAt),
      userId: json.userId,
      hour: json.hour,
      minute: json.minute,
      intensity: json.intensity,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): CrowdReportDto[] {
    const list: CrowdReportDto[] = [];
    for (const json of jsons) {
      const elem = CrowdReportDto.fromJson(json);
      if (elem) {
        list.push(elem);
      }
    }
    return list;
  }

  toJson() : object {
    return {
      "createdAt": this.createdAt,
      "userId": this.userId,
      "hour": this.hour,
      "minute": this.minute,
      "intensity": this.intensity,
    };
  }

  static toJsons(reports : CrowdReportDto[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}

export class CreateSpotsDto {
  name: string;
  imageCardPath: string;
  coordinates: gcloud.GeoPoint;
  cityId: string;
  categoryIds: string[];
  exceptionalOpenHours: Map<Date, Map<number, boolean>>;
  openHours: Map<number, boolean>[];
  gemsPerDays: Map<number, number>[];
  crowdReports: CrowdReportDto[];
  balancePremium: BalancePremiumDto | null;
  pulsePremium: PulsePremiumDto | null;
  rating: number;


  constructor({
    name,
    imageCardPath,
    coordinates,
    cityId,
    categoryIds,
    exceptionalOpenHours,
    openHours,
    gemsPerDays,
    crowdReports,
    balancePremium,
    pulsePremium,
    rating,
  } : {
        name: string,
        imageCardPath: string,
        coordinates: gcloud.GeoPoint,
        cityId: string,
        categoryIds: string[],
        exceptionalOpenHours: Map<Date, Map<number, boolean>>,
        openHours: Map<number, boolean>[],
        gemsPerDays: Map<number, number>[],
        crowdReports: CrowdReportDto[],
        balancePremium: BalancePremiumDto | null,
        pulsePremium: PulsePremiumDto | null,
        rating: number,
       }) {
    this.name = name;
    this.imageCardPath = imageCardPath;
    this.coordinates = coordinates;
    this.cityId = cityId;
    this.categoryIds = categoryIds;
    this.exceptionalOpenHours = exceptionalOpenHours;
    this.openHours = openHours;
    this.gemsPerDays = gemsPerDays;
    this.crowdReports = crowdReports;
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
      cityId: json.cityId,
      categoryIds: json.categoryIds,
      exceptionalOpenHours: json.exceptionalOpenHours,
      openHours: json.openHours,
      gemsPerDays: json.gemsPerDays,
      crowdReports: CrowdReportDto.fromJsons(json.crowdReports),
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
      "cityId": this.cityId,
      "categoryIds": this.categoryIds,
      "exceptionalOpenHours": this.exceptionalOpenHours,
      "openHours": this.openHours,
      "gemsPerDays": this.gemsPerDays,
      "crowdReports": CrowdReportDto.toJsons(this.crowdReports),
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
