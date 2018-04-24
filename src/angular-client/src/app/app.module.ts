import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { RouterModule, Routes, CanActivate } from '@angular/router';
//import { AuthGuardService as AuthGuard } from './authguard.service';
import { StudentService } from './student.service';
import { OAuthModule } from 'angular-oauth2-oidc';
import { HttpClientModule } from '@angular/common/http';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';
import { SignupFormComponent } from './signup-form/signup-form.component';
import { HomeComponent } from './home/home.component';
import { AboutComponent } from './about/about.component';
import { TermsComponent } from './terms/terms.component';

const appRoutes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'signupform', component: SignupFormComponent /*, canActivate: [AuthGuard]*/ },
  { path: 'about', component: AboutComponent },
  { path: 'terms', component: TermsComponent },

  // otherwise redirect to home
  { path: '**', redirectTo: '' }
  //{ path: '**', component: PageNotFoundComponent }
];


@NgModule({
  declarations: [
    AppComponent,
    SignupFormComponent,
    HomeComponent,
    AboutComponent,
    TermsComponent
  ],
  imports: [
    RouterModule.forRoot(appRoutes, { enableTracing: true }),
    HttpModule,
    OAuthModule.forRoot(),
    HttpClientModule,
    BrowserModule,
    ReactiveFormsModule
  ],
  providers: [/*AuthGuard,*/ StudentService],
  bootstrap: [AppComponent]
})

export class AppModule { }
