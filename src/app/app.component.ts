import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  name: string = '';
  email: string = '';
  goal: string = '';

  onSubmit() {
    // Simple form submit logic
    alert(`Thank you, ${this.name}! We have received your details:
           Email: ${this.email}
           Goal: ${this.goal}`);
  }
}
