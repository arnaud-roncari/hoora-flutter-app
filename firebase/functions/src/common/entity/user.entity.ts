import {DocumentData} from "firebase-admin/firestore";

export class UserEntity {
  id: string;
  userId: string;
  gem: number;
  experience: number;
  level: number;
  firstname: string;
  lastname: string;
  nickname: string;
  city: string;
  country: string;
  gender: string | null;
  birthday: Date | null;
  amountSpotValidated: number;
  amountCrowdReportCreated: number;
  amountChallengeUnlocked: number;
  amountOfferUnlocked: number;
  amountDonation: number;
  createdAt: Date;


  constructor({id,
    userId,
    gem,
    experience,
    level,
    firstname,
    lastname,
    nickname,
    city,
    country,
    gender,
    birthday,
    amountSpotValidated,
    amountCrowdReportCreated,
    amountChallengeUnlocked,
    amountOfferUnlocked,
    amountDonation,
    createdAt,
  } : {
      id: string,
      userId: string,
      gem: number,
      experience: number,
      level: number,
      firstname: string,
      lastname: string,
      nickname: string,
      city: string,
      country: string,
      gender: string | null,
      birthday: Date | null,
      amountSpotValidated: number,
      amountCrowdReportCreated: number,
      amountChallengeUnlocked: number,
      amountOfferUnlocked: number,
      amountDonation: number,
    createdAt: Date,

     }) {
    this.id = id;
    this.userId = userId;
    this.gem = gem;
    this.experience = experience;
    this.level = level;
    this.firstname = firstname;
    this.lastname = lastname;
    this.nickname = nickname;
    this.city = city;
    this.country = country;
    this.gender = gender;
    this.birthday = birthday;
    this.amountSpotValidated = amountSpotValidated;
    this.amountCrowdReportCreated = amountCrowdReportCreated;
    this.amountChallengeUnlocked = amountChallengeUnlocked;
    this.amountOfferUnlocked = amountOfferUnlocked;
    this.amountDonation = amountDonation;
    this.createdAt = createdAt;
  }


  static fromSnapshot(snapshot: DocumentData): UserEntity {
    const json = snapshot.data();
    const user = new UserEntity({
      id: snapshot.id,
      userId: json.userId,
      gem: json.gem,
      experience: json.experience,
      level: json.level,
      firstname: json.firstname,
      lastname: json.lastname,
      nickname: json.nickname,
      city: json.city,
      country: json.country,
      gender: json.gender,
      birthday: json.birthday === null ? null : json.birthday.toDate(),
      amountSpotValidated: json.amountSpotValidated,
      amountCrowdReportCreated: json.amountCrowdReportCreated,
      amountChallengeUnlocked: json.amountChallengeUnlocked,
      amountOfferUnlocked: json.amountOfferUnlocked,
      amountDonation: json.amountDonation,
      createdAt: json.createdAt,

    });
    return user;
  }
}
