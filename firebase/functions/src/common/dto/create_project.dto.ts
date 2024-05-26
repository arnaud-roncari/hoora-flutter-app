
export class CreateProjectDto {
  organizationId: string;
  imagePath: string;
  title: string;
  subtitle: string;
  organizationDescription: string;
  description: string;
  condition: string;
  from: Date;
  to: Date | null;
  collected: number;
  goal: number;
  smallDonation: number;
  mediumDonation: number;
  bigDonation: number;

  constructor({organizationId, imagePath, title, subtitle, organizationDescription, description, condition, from, to, collected, goal, smallDonation, mediumDonation, bigDonation} : {
    organizationId: string;
    imagePath: string;
    title: string;
    subtitle: string;
    organizationDescription: string;
    description: string;
    condition: string;
    from: Date;
    to: Date | null;
    collected: number;
    goal: number;
    smallDonation: number;
    mediumDonation: number;
    bigDonation: number;
      }) {
    this.organizationId = organizationId;
    this.imagePath = imagePath;
    this.title = title;
    this.subtitle = subtitle;
    this.organizationDescription = organizationDescription;
    this.description = description;
    this.condition = condition;
    this.from = from;
    this.to = to;
    this.collected = collected;
    this.goal = goal;
    this.smallDonation = smallDonation;
    this.mediumDonation = mediumDonation;
    this.bigDonation = bigDonation;
  }

  static fromJson(json: any): CreateProjectDto {
    const dto = new CreateProjectDto({
      organizationId: json.organizationId,
      imagePath: json.imagePath,
      title: json.title,
      subtitle: json.subtitle,
      organizationDescription: json.organizationDescription,
      description: json.description,
      condition: json.condition,
      collected: json.collected,
      goal: json.goal,
      smallDonation: json.smallDonation,
      mediumDonation: json.mediumDonation,
      bigDonation: json.bigDonation,
      from: new Date(json.from),
      to: json.to === null ? null : new Date(json.to),

    });
    return dto;
  }

  toJson() : object {
    return {
      "organizationId": this.organizationId,
      "imagePath": this.imagePath,
      "title": this.title,
      "subtitle": this.subtitle,
      "organizationDescription": this.organizationDescription,
      "description": this.description,
      "condition": this.condition,
      "collected": this.collected,
      "goal": this.goal,
      "smallDonation": this.smallDonation,
      "mediumDonation": this.mediumDonation,
      "bigDonation": this.bigDonation,
      "from": this.from,
      "to": this.to,
    };
  }
}
