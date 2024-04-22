export class LastCrowdReportDto {
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

  static fromJson(json: any | null): LastCrowdReportDto | null {
    if (json == null) {
      return null;
    }

    const dto = new LastCrowdReportDto({
      createdAt: new Date(json.createdAt),
      userId: json.userId,
      hour: json.hour,
      minute: json.minute,
      intensity: json.intensity,
    });
    return dto;
  }

  static fromJsons(jsons: any[]): LastCrowdReportDto[] {
    const list: LastCrowdReportDto[] = [];
    for (const json of jsons) {
      const elem = LastCrowdReportDto.fromJson(json);
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

  static toJsons(reports : LastCrowdReportDto[]) : object[] {
    const list: object[] = [];
    for (const report of reports) {
      const elem = report.toJson();
      list.push(elem);
    }
    return list;
  }
}
