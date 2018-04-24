export class Student {
    id: string;
    firstName: string;
    lastName: string;
    privateEmail: string;
    schoolEmail: string;
    mobilePhone: string;
    question: string;
    tieBreaker: number;

   constructor(values: Object = {}) {
      //Constructor initialization
      Object.assign(this, values);
  }
}
