import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { catchError } from 'rxjs/operators';

import 'rxjs/add/operator/toPromise';

import { Student } from './student';

@Injectable()
export class StudentService {

  //protected studentUrl = 'http://am.dev.wso2.org:8280/studentcontest/v1.0/student/';  // URL to web API    http://am.dev.wso2.org:8280/studentcontest/v1.0/student/  //'localhost:8080/studentcontest/v1.0/student/'

  httpObs: Observable<any>;
  newStudent: Student;

  constructor(private http: HttpClient) { }

  getStudent(id: string) {
    this.httpObs = this.http.get('http://localhost:8080/student/' + id, {
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
    });
    this.httpObs.subscribe(
      (data) => {
        console.log(data);
      });

  }

  addStudent(id: string, student: Student) {
    this.httpObs = this.http.put('http://localhost:8080/student/' + id, student, {
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
      });

      this.httpObs.subscribe(
      (data) => {
        console.log(data);
      },
      (err: HttpErrorResponse) => {
        console.log("test");
        console.log(err);
      },
      () => {
        console.log('put gedaan');
      }
    );
  }
}
