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
