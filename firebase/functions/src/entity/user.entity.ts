export class UserEntity {
    uid: string;
    userUid: string;
    gems: number;
  
    constructor({uid, userUid, gems} : { uid: string ,userUid: string, gems: number}) {
        this.uid = uid;
        this.userUid = userUid;
        this.gems = gems;
      }

      static fromJson(json: any): UserEntity | null {
        if (!json) {
          return null;
        }
    
        const user = new UserEntity({
          uid: json.uid,
          userUid: json.userUid,
          gems: json.gems,
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