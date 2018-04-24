import { Component, OnInit } from '@angular/core';
import { Student } from './../student';
import { StudentService } from './../student.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { RadioControlValueAccessor } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-signup-form',
  templateUrl: './signup-form.component.html',
  styleUrls: ['./signup-form.component.css']
})

export class SignupFormComponent implements OnInit {

  constructor(private studentService: StudentService, private fb: FormBuilder) { }

  private student: Student;
  private signupForm: FormGroup;

  ngOnInit() {
    const emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    const mobilePhoneRegex = /^((\+|00)32\s?|0)4(60|[789]\d)(\s?\d{2}){3}$/;

    this.signupForm = this.fb.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      privateEmail: ['', [Validators.required, Validators.pattern(emailRegex)]],
      schoolEmail: ['', [Validators.required, Validators.pattern(emailRegex)]],
      mobilePhone: ['', [Validators.required, Validators.pattern(mobilePhoneRegex)]],
      question: ['', Validators.required],
      tieBreaker: ['', [Validators.required, Validators.min(0)]],
      terms: ['', Validators.requiredTrue]
    })
  }


  get firstName() { return this.signupForm.get('firstName'); }

  get lastName() { return this.signupForm.get('lastName'); }

  get privateEmail() { return this.signupForm.get('privateEmail'); }

  get schoolEmail() { return this.signupForm.get('schoolEmail'); }

  get mobilePhone() { return this.signupForm.get('mobilePhone'); }

  get question() { return this.signupForm.get('question'); }

  get tieBreaker() { return this.signupForm.get('tieBreaker'); }

  get terms() { return this.signupForm.get('terms'); }


  public onFormSubmit() {
    if (this.signupForm.valid) {
      this.student = this.signupForm.value;
      /* Temporary, sets object id */
      this.student.id = "1";
      /* Any API call logic via services goes here */
      //	this.studentService.getStudent("3");
      this.studentService.addStudent(this.student.id, this.student);

    }
  }
}
