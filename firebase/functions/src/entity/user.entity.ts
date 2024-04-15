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
  language: string;
  gender: string;
  birthday: string;
  phoneNumber: string;

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
    language,
    gender,
    birthday,
    phoneNumber,
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
      language: string,
      gender: string,
      birthday: string,
      phoneNumber: string,
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
    this.language = language;
    this.gender = gender;
    this.birthday = birthday;
    this.phoneNumber = phoneNumber;
  }

  static fromJson(json: any): UserEntity | null {
    if (!json) {
      return null;
    }

    const user = new UserEntity({
      id: json.id,
      userId: json.userId,
      gem: json.gem,
      experience: json.experience,
      level: json.level,
      firstname: json.firstname,
      lastname: json.lastname,
      nickname: json.nickname,
      city: json.city,
      country: json.country,
      language: json.language,
      gender: json.gender,
      birthday: json.birthday,
      phoneNumber: json.phoneNumber,
    });
    return user;
  }

  static fromJsons(jsons: any[]): UserEntity[] {
    if (!jsons) {
      return [];
    }

    const users: UserEntity[] = [];
    for (const json of jsons) {
      const user = UserEntity.fromJson(json);
      if (user) {
        users.push(user);
      }
    }
    return users;
  }
}
